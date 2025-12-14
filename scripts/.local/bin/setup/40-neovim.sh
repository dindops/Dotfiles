#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up Neovim..."

NVIM_DIR="${HOME}/git/neovim"

if [ ! -d "$NVIM_DIR" ]; then
    log_info "Cloning Neovim repository..."
    mkdir -p "$(dirname "$NVIM_DIR")"
    git clone https://github.com/neovim/neovim.git "$NVIM_DIR"
fi

cd "$NVIM_DIR"
git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if ! command_exists nvim || [ "$LOCAL" != "$REMOTE" ]; then
    if ! command_exists nvim; then
        log_info "Neovim not installed, building from source..."
    else
        log_info "Updating and building Neovim..."
    fi
    git pull
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install

    log_info "Cleaning up build artifacts..."
    make clean
else
    log_info "Neovim is up to date"
fi
