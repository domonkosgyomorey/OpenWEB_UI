#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Updating Open WebUI image and recreating service..."

docker compose -f compose.yaml pull openwebui
docker compose -f compose.yaml up -d --no-deps --pull always openwebui

echo "Showing status and recent logs if the service is unhealthy."
docker compose ps openwebui
docker compose logs --tail=200 openwebui || true
