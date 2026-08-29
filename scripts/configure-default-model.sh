#!/usr/bin/env bash
set -euo pipefail

# This helper ensures the Compose service is restarted so mapped OpenAI-compatible
# env vars (OPENAI_API_KEY, OPENAI_API_BASE, OPENAI_MODEL) from .env are applied.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f .env ]; then
  echo ".env not found. Copy .env.example to .env and set DEEPSEEK_API_KEY first." >&2
  exit 2
fi

DEEP_KEY=$(grep -m1 '^DEEPSEEK_API_KEY=' .env | cut -d'=' -f2- || true)
if [ -z "$DEEP_KEY" ]; then
  echo "DEEPSEEK_API_KEY is not set in .env. Please set it before running this helper." >&2
  exit 2
fi

echo "Recreating Open WebUI service so mapped OpenAI-compatible env vars take effect..."
docker compose -f compose.yaml up -d --no-deps --force-recreate openwebui

echo "Service restarted. If Open WebUI supports OpenAI-compatible env vars, it should now pick up the DeepSeek key as a default provider." 
echo "Open the Open WebUI Admin -> Providers to verify the configured provider/model or configure manually if required."
