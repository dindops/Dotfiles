#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/scripts/.local/lib/utils.sh"

log_info "Setting up Flatpak applications..."

if ! command_exists flatpak; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

FLATPAK_APPS=(
    "com.spotify.Client"
    "com.jgraph.drawio.desktop"
    "org.videolan.VLC"
    "org.mozilla.firefox"
    "com.github.tchx84.Flatseal"
    "com.discordapp.Discord"
)

for app in "${FLATPAK_APPS[@]}"; do
    if ! flatpak list | grep -q "$app"; then
        log_info "Installing $app..."
        flatpak install -y flathub "$app"
    else
        log_info "$app already installed"
    fi
done

log_info "Updating all Flatpak applications..."
flatpak update -y
