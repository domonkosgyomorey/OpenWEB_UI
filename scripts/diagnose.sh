#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "System info:"
uname -a || true

echo "Docker version:"
docker version --format '{{.Server.Version}}' || docker version || true

echo "Docker Compose version:"
docker compose version || true

echo "Compose project status:"
docker compose ps || true

echo "Open WebUI recent logs (tail 200):"
docker compose logs --tail=200 openwebui || true

if command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale status:"
  tailscale status || true
  echo "Tailscale serve list (if supported):"
  tailscale serve status 2>/dev/null || true
else
  echo "Tailscale not installed or not on PATH."
fi

echo "Local reachability check (host binding):"
if command -v curl >/dev/null 2>&1; then
  curl -sS --head "http://127.0.0.1:${HOST_PORT:-3000}" || true
else
  echo "curl not available to perform local HTTP check."
fi
