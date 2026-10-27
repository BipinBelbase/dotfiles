#!/usr/bin/env python3
"""Read yabai's Dock payload handshake. Never inject, restart, or switch Spaces."""

import getpass
import socket
import struct
import subprocess
import sys


def main():
    path = f"/tmp/yabai-sa_{getpass.getuser()}.socket"
    try:
        with socket.socket(socket.AF_UNIX) as connection:
            connection.settimeout(2)
            connection.connect(path)
            connection.sendall(b"\x01\x00\x01")  # length=1, handshake opcode=1
            reply = bytearray()
            while len(reply) < 4096:
                chunk = connection.recv(4096 - len(reply))
                if not chunk:
                    break
                reply.extend(chunk)
                end = reply.find(0)
                if end >= 0 and len(reply) >= end + 5:
                    break
        version, separator, data = bytes(reply).partition(b"\0")
        if not separator or len(data) < 4:
            raise ValueError("incomplete payload handshake")
        capabilities = struct.unpack("<I", data[:4])[0]
        os_version = subprocess.check_output(
            ["/usr/bin/sw_vers", "-productVersion"], text=True
        ).strip()
        # This local macOS 27 patch resolves focus/create/destroy/animation.
        # Removed DPPM/move-Space and unused front-window hooks are not required.
        required = 0x4D if os_version.split(".")[0] == "27" else 0x7F
        print(f"Dock payload: {version.decode('ascii')}; capabilities 0x{capabilities:02X}; "
              f"required on macOS {os_version}: 0x{required:02X}")
        if capabilities & required != required:
            print("Dock payload: missing capabilities; inspect local patch and Dock signatures. "
                  "A responsive socket does not establish compatibility.")
            return 1
        print("Dock payload: required capabilities present; actual Space switching still needs a live test.")
        return 0
    except (OSError, ValueError, UnicodeError, subprocess.SubprocessError) as error:
        print(f"Dock payload: unavailable ({error}); not proof of hotkey or Space-switch health.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
