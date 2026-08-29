#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running installer checks..."

if [ "$(uname -s)" != "Linux" ]; then
  echo "This installer is intended for Linux hosts (Raspberry Pi)." >&2
fi

ARCH=$(uname -m || true)
echo "Detected architecture: ${ARCH}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found. Please install Docker Engine before running this installer." >&2
  exit 1
fi

if ! docker version >/dev/null 2>&1; then
  echo "Docker is not responding. Ensure Docker daemon is running." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker command required" >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose plugin not available. Install Docker Compose (docker compose)." >&2
  exit 1
fi

# Create .env from .env.example if missing
if [ ! -f .env ]; then
  echo "Creating .env from .env.example"
  cp .env.example .env
  echo ".env created. Please edit .env to add your DEEPSEEK_API_KEY and set OPEN_WEBUI_VERSION if needed." >&2
fi

# Generate WEBUI_SECRET_KEY if missing
if ! grep -q '^WEBUI_SECRET_KEY=' .env || [ -z "$(grep '^WEBUI_SECRET_KEY=' .env | cut -d'=' -f2)" ]; then
  if command -v openssl >/dev/null 2>&1; then
    SECRET=$(openssl rand -hex 32)
    # insert without printing secret to stdout
    sed -i "s/^WEBUI_SECRET_KEY=.*/WEBUI_SECRET_KEY=${SECRET}/" .env
    echo "Generated WEBUI_SECRET_KEY and stored in .env"
  else
    echo "openssl not available; please generate a secure WEBUI_SECRET_KEY and place it into .env" >&2
  fi
fi

echo "Validating docker compose configuration..."
docker compose -f compose.yaml config >/dev/null

echo "Pulling images..."
docker compose -f compose.yaml pull openwebui || true

echo "Starting Open WebUI..."
docker compose -f compose.yaml up -d openwebui

echo "Waiting a few seconds for the container to report status..."
sleep 3

echo "Container status:"
docker compose ps openwebui

echo "Installer finished. If Tailscale is installed and authenticated you can run scripts/setup-tailscale.sh to help create a Serve mapping." 
