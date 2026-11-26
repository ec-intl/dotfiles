"""Preserve startup semantics without accessing Docker, AWS or a real checkout."""

import os
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class ServerStartupTests(unittest.TestCase):
    def run_start(self, branch="production", fail="", registered=False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            home = root / "home"
            repo = home / "ecisite"
            repo.mkdir(parents=True)
            binary = root / "bin"
            binary.mkdir()
            log = root / "calls"
            for name in ("sudo", "docker", "aws", "git"):
                path = binary / name
                path.write_text(
                    "#!/bin/bash\n"
                    f'echo "{name} $*" >> "$CALL_LOG"\n'
                    f'if [[ "{name} $*" == "$FAIL_COMMAND" ]]; then exit 47; fi\n'
                    f'if [[ "{name}" == aws ]]; then echo test-token; fi\n'
                    f'if [[ "{name} $1" == "docker login" ]]; then cat >/dev/null; fi\n'
                    "exit 0\n"
                )
                path.chmod(0o755)
            if registered:
                (repo / ".eci").mkdir()
                (repo / ".eci/compose-tasks").write_text("production\n")
                handler = repo / ".eci/compose-task"
                handler.write_text(
                    '#!/bin/bash\necho "task $* $ECI_SERVER_IMAGES_READY" >> "$CALL_LOG"\n'
                )
                handler.chmod(0o755)
            result = subprocess.run(
                ["bash", str(ROOT / "bin/start-server"), "ecisite", branch],
                env=dict(
                    os.environ,
                    HOME=str(home),
                    PATH=str(binary) + os.pathsep + os.environ["PATH"],
                    CALL_LOG=str(log),
                    FAIL_COMMAND=fail,
                    AWSECR="registry.example",
                    AWS_REGION="us-east-2",
                ),
                capture_output=True,
                text=True,
                check=False,
            )
            return result, log.read_text().splitlines(), (home / "deployments").exists()

    def test_production_retains_prune_pulls_checkout_and_detached_start(self):
        result, calls, reports_exist = self.run_start()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            calls[:2],
            ["sudo chmod 666 /var/run/docker.sock", "docker system prune -af"],
        )
        self.assertEqual(
            [call for call in calls if call.startswith("docker pull")],
            [
                "docker pull registry.example/ecisite:production",
                "docker pull registry.example/ecisite:dante-proxy",
                "docker pull registry.example/ecisite:squid-proxy",
            ],
        )
        self.assertEqual(
            calls[-3:],
            [
                "git checkout production",
                "git pull",
                "docker compose --profile production up -d",
            ],
        )
        self.assertFalse(reports_exist)

    def test_staging_still_pulls_and_runs_foreground(self):
        result, calls, _ = self.run_start("staging")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("docker pull registry.example/ecisite:staging", calls)
        self.assertEqual(calls[-1], "docker compose --profile staging up")

    def test_registered_task_receives_preparation_marker(self):
        result, calls, _ = self.run_start(registered=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(calls[-1], "task up-detached production ecisite:production")
        self.assertEqual(calls.count("docker system prune -af"), 1)

    def test_failures_stop_startup_and_retain_reports(self):
        for command in (
            "docker system prune -af",
            "aws ecr get-login-password --region us-east-2",
            "docker pull registry.example/ecisite:production",
            "git pull",
            "docker compose --profile production up -d",
        ):
            with self.subTest(command=command):
                result, calls, reports_exist = self.run_start(fail=command)
                self.assertEqual(result.returncode, 47, result.stderr)
                self.assertNotIn("successfully", result.stdout)
                self.assertTrue(reports_exist)
                if not command.startswith("docker compose"):
                    self.assertFalse(any(" compose " in call for call in calls))
