"""Preserve startup semantics without accessing Docker, AWS or a real checkout."""

import os
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class ServerStartupTests(unittest.TestCase):
    def run_start(self, branch="production", fail="", registered=False, conditional=False):
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
            command = ["bash", str(ROOT / "bin/start-server"), "ecisite", branch]
            if conditional:
                command = [
                    "bash", "-c",
                    'source "$1"; if _eci_prepare_server_images ecisite production; '
                    'then exit 0; else exit $?; fi',
                    "test", str(ROOT / "src/bash/server-startup.sh"),
                ]
            result = subprocess.run(
                command,
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
            calls = log.read_text().splitlines() if log.exists() else []
            return result, calls, (home / "deployments").exists()

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

    def test_conditional_preparation_propagates_failure(self):
        for command in (
            "sudo chmod 666 /var/run/docker.sock",
            "docker system prune -af",
            "aws ecr get-login-password --region us-east-2",
        ):
            with self.subTest(command=command):
                result, calls, _ = self.run_start(fail=command, conditional=True)
                self.assertEqual(result.returncode, 47, result.stderr)
                self.assertFalse(any(call.startswith("docker pull") for call in calls))

    def test_invalid_branch_has_no_external_side_effects(self):
        for branch in ("-", "--help", "-production"):
            with self.subTest(branch=branch):
                result, calls, reports_exist = self.run_start(branch)
                self.assertEqual(result.returncode, 2, result.stderr)
                self.assertEqual(calls, [])
                self.assertFalse(reports_exist)
