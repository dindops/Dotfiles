#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/scripts/.local/lib/utils.sh"

log_info "Setting up Fish shell..."

# Ensure fish is installed
if ! command_exists fish; then
    log_info "Installing Fish shell..."
    sudo apt install -y fish
else
    log_info "Fish shell already installed"
fi

FISH_BIN=$(which fish)

# Change default shell to fish if not already
if [ "$SHELL" != "$FISH_BIN" ]; then
    log_info "Changing default shell to fish..."
    chsh -s "$FISH_BIN"
    log_info "Default shell changed to fish (will take effect on next login)"
else
    log_info "Fish is already the default shell"
fi

log_info "Installing/updating fisher plugins..."
fish -c "fisher update" 2>&1 || log_warn "Fisher update failed (might be first run)"

log_info "Fish shell setup complete!"
