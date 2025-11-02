#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/scripts/.local/lib/utils.sh"

log_info "Setting up dotfiles with GNU stow..."

if ! command_exists stow; then
    log_info "Installing GNU stow..."
    sudo apt install -y stow
fi

cd "${SCRIPT_DIR}"

for package in */; do
    package=${package%/}  # Remove trailing slash
    log_info "Stowing $package..."
    stow --restow --adopt --target="${HOME}" "$package" || log_warn "Failed to stow $package"
done

log_info "Restoring original dotfiles from git..."
git restore . 2>/dev/null || log_warn "Could not restore from git (might not be in a git repo)"

log_info "Dotfiles stowed successfully!"
