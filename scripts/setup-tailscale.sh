#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale CLI not found. Install Tailscale on the host and authenticate before running this helper." >&2
  exit 2
fi

echo "Checking Tailscale status..."
tailscale status || true

echo "This helper will offer a recommended 'tailscale serve' command to proxy the local Open WebUI service (localhost:${HOST_PORT:-3000})."
echo "It will NOT enable Funnel or expose the service publicly. Serve remains within your tailnet and obeys Tailscale ACLs."

read -p "Do you want me to print the recommended command? (yes/no) " RESP
if [ "$RESP" != "yes" ]; then
  echo "Cancelled by user."; exit 0
fi

echo "Recommended command (do NOT run with hard-coded secrets):"
echo
echo "tailscale serve --http :https=http://127.0.0.1:${HOST_PORT:-3000}"
echo
echo "If your tailscale version supports a declarative 'serve' configuration file, prefer that."
echo "To run the command now, run it as the tailscale admin user on the Pi or run with sudo if required."

read -p "Run the recommended tailscale serve command now? Type 'yes' to run: " RUNNOW
if [ "$RUNNOW" = "yes" ]; then
  echo "Running tailscale serve..."
  tailscale serve --http :https=http://127.0.0.1:${HOST_PORT:-3000}
  echo "tailscale serve started. Use 'tailscale status' or 'tailscale serve status' to inspect." || true
else
  echo "Skipped running tailscale serve."; exit 0
fi
