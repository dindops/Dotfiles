#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
source "${SCRIPT_DIR}/lib/utils.sh"

log_info "Setting up Docker..."

if command_exists docker; then
    log_info "Docker is already installed, checking for updates..."
    sudo apt-get update
    sudo apt-get install -y --only-upgrade docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null || log_info "Docker packages are up to date"
else
    log_info "Installing Docker..."

    sudo apt-get install -y ca-certificates curl

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    log_info "Docker installed successfully"
fi

if ! getent group docker >/dev/null; then
    log_info "Creating docker group..."
    sudo groupadd docker
else
    log_info "Docker group already exists"
fi

if ! groups "$USER" | grep -q docker; then
    log_info "Adding $USER to docker group..."
    sudo usermod -aG docker "$USER"
    log_warn "You'll need to log out and back in for docker group membership to take effect"
else
    log_info "$USER is already in docker group"
fi

log_info "Docker setup complete!"
log_info "Docker version: $(docker --version)"
