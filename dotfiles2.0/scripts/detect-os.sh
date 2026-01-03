#!/usr/bin/env sh
#
# detect-os.sh -- detect the current operating system and print a short name.
#
# The script echoes one of the following identifiers:
#   macos    for Darwin based systems (macOS)
#   arch     for Arch Linux and derivatives
#   ubuntu   for Ubuntu/Debian based systems
#   fedora   for Fedora, CentOS or RHEL systems
#   windows  for Windows/WSL environments
#
# This script is intentionally simple and uses only POSIX sh constructs.

set -e

uname_out="$(uname -s)"
case "${uname_out}" in
    Darwin*)   echo "macos" ;;
    Linux*)
        # Look for distro specific release files
        if [ -f /etc/arch-release ]; then
            echo "arch"
        elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
            echo "fedora"
        else
            # default to Ubuntu for Debian based systems
            echo "ubuntu"
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "windows" ;;
    *)
        # Unknown system: assume Ubuntu for portability
        echo "ubuntu" ;;
esac