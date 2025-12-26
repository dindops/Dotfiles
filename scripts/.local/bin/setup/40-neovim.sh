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

CURRENT_COMMIT=$(git rev-parse HEAD | cut -c1-10)
REMOTE_COMMIT=$(git rev-parse @{u} | cut -c1-10)

INSTALLED_COMMIT=""
if command_exists nvim; then
    INSTALLED_COMMIT=$(nvim --version 2>/dev/null | head -1 | grep -oE 'g[0-9a-f]+' | head -1 | cut -c2- || echo "")
fi

if ! command_exists nvim; then
    STATE="no_nvim"
elif [ -z "$INSTALLED_COMMIT" ]; then
    STATE="unknown_version"
elif [ "$INSTALLED_COMMIT" != "$CURRENT_COMMIT" ]; then
    STATE="commit_mismatch"
elif [ "$CURRENT_COMMIT" != "$REMOTE_COMMIT" ]; then
    STATE="behind_remote"
else
    STATE="up_to_date"
fi

case "$STATE" in
    no_nvim)
        NEEDS_BUILD=true
        BUILD_REASON="Neovim not installed"
        ;;
    unknown_version)
        NEEDS_BUILD=true
        BUILD_REASON="Cannot determine installed version"
        ;;
    commit_mismatch)
        NEEDS_BUILD=true
        BUILD_REASON="Installed version ($INSTALLED_COMMIT) doesn't match current commit ($CURRENT_COMMIT)"
        ;;
    behind_remote)
        NEEDS_BUILD=true
        BUILD_REASON="Current commit ($CURRENT_COMMIT) is behind remote ($REMOTE_COMMIT)"
        ;;
    up_to_date)
        NEEDS_BUILD=false
        BUILD_REASON=""
        ;;
esac

if [ "$NEEDS_BUILD" = true ]; then
    log_info "$BUILD_REASON"
    log_info "Building Neovim from source..."
    git pull
    make clean
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install

    log_info "Cleaning up build artifacts..."
    make clean
    make distclean

    if command_exists nvim; then
        NEW_COMMIT=$(nvim --version 2>/dev/null | head -1 | grep -oE 'g[0-9a-f]+' | head -1 | cut -c2- || echo "unknown")
        log_info "Neovim installed successfully (commit: $NEW_COMMIT)"
    else
        log_error "Neovim installation may have failed"
    fi
else
    log_info "Neovim is up to date (commit: $INSTALLED_COMMIT)"
fi
