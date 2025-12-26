#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up Go environment..."

# Install goenv if directory doesn't exist
if [ ! -d "$HOME/.goenv" ]; then
    log_info "Installing goenv..."
    git clone https://github.com/syndbg/goenv.git ~/.goenv
else
    log_info "goenv already installed"
fi

# Update goenv
cd ~/.goenv && git pull && cd -

# Set up goenv environment
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
export GOENV_PATH_ORDER=front  # Prioritize goenv versions over system Go
eval "$(goenv init -)"

LATEST_GO=$(goenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
if ! goenv versions | grep -q "$LATEST_GO"; then
    log_info "Installing Go $LATEST_GO..."
    goenv install "$LATEST_GO"
    goenv global "$LATEST_GO"
else
    log_info "Go $LATEST_GO already installed"
fi

eval "$(goenv init -)"
goenv global "$LATEST_GO"

GO_VERSION=$(go version 2>/dev/null || echo "not found")
log_info "Active Go version: $GO_VERSION"

GO_PACKAGES_FILE="${SCRIPT_DIR}/share/go.packages.list"
if [ -f "$GO_PACKAGES_FILE" ]; then
    log_info "Installing Go packages from go.packages.list..."
    while IFS= read -r package || [ -n "$package" ]; do
        [[ "$package" =~ ^#.*$ ]] && continue
        [[ -z "$package" ]] && continue
        package_name=$(echo "$package" | xargs)
        log_info "Installing $package_name..."
        go install "$package_name" || log_warn "Failed to install $package_name"
    done < "$GO_PACKAGES_FILE"
fi

log_info "Go environment setup complete!"
