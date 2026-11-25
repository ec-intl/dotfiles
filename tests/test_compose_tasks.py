"""Exercise the company Compose interface without changing a user's shell."""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class ComposeTasks(unittest.TestCase):
    """Repository tasks preserve profile fallback, arguments and exit status."""

    def test_dispatch_in_supported_shells(self):
        source = (ROOT / "src/bash/functions").read_text()
        functions = source.split("# Docker compose functions", 1)[1].split(
            "# Run functions", 1
        )[0]
        for shell in ("bash", "zsh"):
            if not shutil.which(shell):
                continue
            with self.subTest(shell=shell), tempfile.TemporaryDirectory() as folder:
                root = Path(folder)
                (root / "functions").write_text(functions)
                binary = root / "docker"
                binary.write_text(
                    '#!/bin/sh\nprintf "%s\\n" "$@" > "$TASK_LOG"\nexit "${TASK_STATUS:-0}"\n'
                )
                binary.chmod(0o755)
                log = root / "args"
                env = dict(
                    os.environ,
                    PATH=folder + os.pathsep + os.environ["PATH"],
                    TASK_LOG=str(log),
                )

                def run(command, status=0):
                    result = subprocess.run(
                        [shell, "-c", ". ./functions; " + command],
                        cwd=folder,
                        env=env,
                        text=True,
                        capture_output=True,
                        check=False,
                    )
                    self.assertEqual(result.returncode, status, result.stderr)
                    return log.read_text().splitlines() if log.exists() else []

                self.assertEqual(
                    run("dcpu production"), ["compose", "--profile", "production", "up"]
                )
                self.assertEqual(
                    run("dcpub ci-testing"),
                    ["compose", "--profile", "ci-testing", "up", "--build"],
                )
                (root / ".eci").mkdir()
                (root / ".eci/compose-tasks").write_text("preview\n")
                handler = root / ".eci/compose-task"
                handler.write_text(binary.read_text())
                handler.chmod(0o755)
                for helper, operation in [
                    ("dcpu", "up"),
                    ("dcpub", "up-build"),
                    ("dcpd", "down"),
                    ("dcpb", "build"),
                    ("dcpud", "up-detached"),
                ]:
                    self.assertEqual(run(helper + " preview"), [operation, "preview"])
                env["TASK_STATUS"] = "47"
                run("dcpu preview", 47)
                run("dcpu production", 47)
                del env["TASK_STATUS"]
                for invalid in ("", "--help", "../preview", "'preview;echo bad'"):
                    log.unlink(missing_ok=True)
                    self.assertEqual(run("dcpu " + invalid, 2), [])
                handler.chmod(0o644)
                run("dcpu preview", 2)
