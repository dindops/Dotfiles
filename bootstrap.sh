#!/usr/bin/env bash
set -euo pipefail

echo "=== Bootstrapping system ==="

sudo apt update
sudo apt install -y git stow curl wget build-essential

DOTFILES_DIR="${HOME}/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/dindops/dotfiles.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Run the main setup
./setup.sh

echo "=== Bootstrap complete ==="
