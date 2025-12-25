#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up Flatpak applications..."

if ! command_exists flatpak; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

FLATPAK_PACKAGES_FILE="${SCRIPT_DIR}/share/flatpak.packages.list"
if [ -f "$FLATPAK_PACKAGES_FILE" ]; then
    log_info "Installing/updating Flatpak applications from flatpak.packages.list..."
    while IFS= read -r app || [ -n "$app" ]; do
        [[ "$app" =~ ^#.*$ ]] && continue
        [[ -z "$app" ]] && continue
        app=$(echo "$app" | xargs)
        if ! flatpak list | grep -q "$app"; then
            log_info "Installing $app..."
            flatpak install -y flathub "$app"
        else
            log_info "$app already installed"
        fi
    done < "$FLATPAK_PACKAGES_FILE"
fi

log_info "Updating all Flatpak applications..."
flatpak update -y
