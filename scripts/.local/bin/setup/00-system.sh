#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up system packages..."

sudo apt update

if [ -f "${SCRIPT_DIR}/apt.packages.list" ]; then
    mapfile -t packages < <(grep -v '^#' "${SCRIPT_DIR}/apt.packages.list" | grep -v '^$')
    ensure_apt_packages "${packages[@]}"
fi

log_info "Upgrading all system packages..."
sudo apt upgrade -y
