#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up dotfiles with GNU stow..."

if ! command_exists stow; then
    log_info "Installing GNU stow..."
    sudo apt install -y stow
fi

cd "${SCRIPT_DIR}"

stow --restow --adopt --target="${HOME}" *
