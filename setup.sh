#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/scripts/.local/lib/utils.sh"

log_info "Starting system setup..."

for script in "${SCRIPT_DIR}"/scripts/.local/bin/setup/*.sh; do
    if [ -f "$script" ]; then
        log_info "Running $(basename "$script")..."
        "$script" || log_error "Failed: $(basename "$script")"
    fi
done

log_info "Setup complete!"
