#!/usr/bin/env bash
set -euo pipefail

echo "=== Docker Cleanup Script ==="
echo "This will remove stopped containers, unused images, and build cache"
echo ""

# Show current usage
echo "Current Docker disk usage:"
docker system df
echo ""

read -p "Continue with cleanup? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled"
    exit 0
fi

# Stop and remove the test container if running
if docker ps -a | grep -q dotfiles-test; then
    echo "Stopping and removing dotfiles-test container..."
    docker stop $(docker ps -a -q --filter ancestor=dotfiles-test) 2>/dev/null || true
    docker rm $(docker ps -a -q --filter ancestor=dotfiles-test) 2>/dev/null || true
fi

# Remove the test image
if docker images | grep -q dotfiles-test; then
    echo "Removing dotfiles-test image..."
    docker rmi dotfiles-test 2>/dev/null || true
fi

# Prune everything unused
echo "Pruning all unused containers, networks, images, and build cache..."
docker system prune -a --volumes -f

echo ""
echo "New Docker disk usage:"
docker system df
echo ""
echo "=== Cleanup complete ==="
