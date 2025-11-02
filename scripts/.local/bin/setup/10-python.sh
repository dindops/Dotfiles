#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up Python environment..."

# Install pyenv if not present
if ! command_exists pyenv; then
    log_info "Installing pyenv..."
    curl https://pyenv.run | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
else
    log_info "pyenv already installed"
fi

LATEST_PYTHON=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
if ! pyenv versions | grep -q "$LATEST_PYTHON"; then
    log_info "Installing Python $LATEST_PYTHON..."
    pyenv install "$LATEST_PYTHON"
    pyenv global "$LATEST_PYTHON"
else
    log_info "Python $LATEST_PYTHON already installed"
fi

eval "$(pyenv init -)"
for pkg in pipx virtualenv; do
    if ! pip list | grep -q "^$pkg "; then
        log_info "Installing $pkg..."
        pip install --user "$pkg"
    fi
done

export PATH="$HOME/.local/bin:$PATH"

PIPX_PACKAGES_FILE="${SCRIPT_DIR}/share/python.packages.list"
if [ -f "$PIPX_PACKAGES_FILE" ]; then
    log_info "Installing/upgrading pipx packages from python.packages.list..."
    while IFS= read -r package || [ -n "$package" ]; do
        [[ "$package" =~ ^#.*$ ]] && continue
        [[ -z "$package" ]] && continue
        package_name=$(echo "$package" | cut -d'=' -f1 | cut -d'[' -f1 | xargs)
        if pipx list | grep -q "package $package_name"; then
            log_info "Upgrading $package_name..."
            pipx upgrade "$package_name" || log_warn "Failed to upgrade $package_name"
        else
            log_info "Installing $package_name..."
            pipx install "$package" || log_warn "Failed to install $package"
        fi
    done < "$PIPX_PACKAGES_FILE"
fi
log_info "Python environment setup complete"
