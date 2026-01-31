#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up Node.js environment..."

if ! command_exists fish; then
    log_error "Fish shell is required for nvm.fish. Please run 55-fish.sh first."
    exit 1
fi

if ! fish -c "type -q nvm" 2>/dev/null; then
    log_error "nvm.fish is not installed. Please ensure fisher has installed it."
    exit 1
fi

log_info "Installing latest LTS version of Node.js..."
fish -c "nvm install lts && nvm use lts --default"

NODE_VERSION=$(fish -c "node --version" 2>/dev/null || echo "not found")
NPM_VERSION=$(fish -c "npm --version" 2>/dev/null || echo "not found")

log_info "Node.js version: $NODE_VERSION"
log_info "npm version: $NPM_VERSION"

log_info "Node.js environment setup complete!"
