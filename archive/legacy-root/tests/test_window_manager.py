"""Run with python3 tests/test_window_manager.py; no live macOS changes."""
from pathlib import Path
import os
import re
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class Shortcuts(unittest.TestCase):
    def test_number_keys_use_only_yabai(self):
        config = (ROOT / 'skhd/skhdrc').read_text()
        for digit, space in [(str(i), i) for i in range(1, 10)] + [('0', 10)]:
            command = re.search(r'^cmd - ' + digit + r' : (.+)$', config, re.M)[1]
            self.assertEqual(command, f'/opt/homebrew/bin/yabai -m space --focus {space}')

    def test_follow_requires_successful_move(self):
        config = (ROOT / 'skhd/skhdrc').read_text()
        for digit, space in [(str(i), i) for i in range(1, 10)] + [('0', 10)]:
            command = re.search(r'^cmd \+ ctrl - ' + digit + r' : (.+)$', config, re.M)[1]
            for move_status in (0, 1, 42):
                with self.subTest(digit=digit, status=move_status), tempfile.TemporaryDirectory() as d:
                    p = Path(d)
                    fake = p / 'yabai'
                    fake.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$CALLS"\n'
                                    'if [ "$2" = window ]; then exit "$MOVE_STATUS"; fi\n')
                    fake.chmod(0o755)
                    # Substitute only the executable; preserve the production shell logic.
                    r = subprocess.run(['/bin/sh', '-c', command.replace('/opt/homebrew/bin/yabai', str(fake))],
                                       env={**os.environ, 'CALLS': str(p / 'calls'), 'MOVE_STATUS': str(move_status)})
                    calls = (p / 'calls').read_text().splitlines()
                    expected = [f'-m window --space {space}']
                    if move_status == 0:
                        expected.append(f'-m space --focus {space}')
                    self.assertEqual(calls, expected)
                    self.assertEqual(r.returncode, move_status)


class Report(unittest.TestCase):
    def run_report(self, labels, socket_status=0, logs=False):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d)
            def executable(name, body):
                f = p / name
                f.write_text('#!/bin/sh\nset -eu\n' + body)
                f.chmod(0o755)
                return str(f)
            yabai = executable('yabai', 'case "$1" in\n --version) echo yabai-test;;\n'
                               ' -m) exit "$SOCKET_STATUS";;\n *) echo UNEXPECTED >&2; exit 99;;\nesac\n')
            skhd = executable('skhd', '[ "$1" = --version ] || exit 99\necho skhd-test\n')
            executable('launchctl', '[ "$1" = print ] || { echo MUTATION >&2; exit 99; }\n'
                       'case "$LABELS:$2" in\n both:*|current:*/com.asmvik.*|legacy:*/com.koekeishiya.*) echo "state = running";;\n *) exit 1;;\nesac\n')
            executable('sw_vers', 'echo ProductVersion: test\n')
            executable('csrutil', '[ "$1" = status ] || exit 99\necho SIP-test\n')
            executable('defaults', '[ "$1" = read ] || { echo MUTATION >&2; exit 99; }\nexit 1\n')
            executable('sudo', 'echo MUTATION >&2\nexit 99\n')
            source = (ROOT / 'yabai/wm-doctor.sh').read_text()
            source = source.replace('YABAI=/opt/homebrew/bin/yabai', f'YABAI="{yabai}"')
            source = source.replace('SKHD=/opt/homebrew/bin/skhd', f'SKHD="{skhd}"')
            for name in ('yabai', 'skhd'):
                source = source.replace(f'{name.upper()}_ERR="/tmp/{name}_${{USER_NAME}}.err.log"',
                                        f'{name.upper()}_ERR="{p}/{name}.log"')
            if logs:
                (p / 'yabai.log').write_text('sample old error\n')
            script = p / 'doctor.sh'
            script.write_text(source)
            r = subprocess.run(['/bin/sh', str(script), 'report'], text=True, capture_output=True,
                               env={**os.environ, 'PATH': str(p) + ':' + os.environ['PATH'],
                                    'LABELS': labels, 'SOCKET_STATUS': str(socket_status)})
            output = r.stdout + r.stderr
            self.assertEqual(r.returncode, 0, output)
            self.assertNotIn('MUTATION', output)
            self.assertNotIn('UNEXPECTED', output)
            self.assertIn('Report only:', output)
            self.assertIn('ProductVersion: test', output)
            return output

    def test_current_and_legacy_labels(self):
        for labels in ('current', 'legacy', 'none'):
            with self.subTest(labels=labels):
                self.assertNotIn('Multiple yabai', self.run_report(labels))

    def test_duplicate_labels(self):
        output = self.run_report('both')
        self.assertIn('Multiple yabai service labels', output)
        self.assertIn('Multiple skhd service labels', output)

    def test_socket_failure_and_old_logs(self):
        output = self.run_report('current', socket_status=1, logs=True)
        self.assertIn('socket: FAILED', output)
        self.assertIn('sample old error', output)
        self.assertIn('may include old failures', output)

    def test_missing_logs(self):
        self.assertIn('No log file.', self.run_report('none'))


if __name__ == '__main__':
    unittest.main()
