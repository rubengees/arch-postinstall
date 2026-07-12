#!/usr/bin/env bash
set -euo pipefail

# Install fish shell if not already installed
if ! command -v fish >/dev/null 2>&1
then
    sudo pacman -S --noconfirm fish
fi

/usr/bin/env fish install.fish