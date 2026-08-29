#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <backup-tar.gz>" >&2
  exit 2
fi

BACKUP_FILE="$1"
if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE" >&2
  exit 2
fi

echo "This operation will restore the backup into the Docker volume 'open-webui-data'."
read -p "Are you sure you want to continue? Type 'yes' to proceed: " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "Aborting."; exit 1
fi

echo "Stopping Open WebUI service..."
docker compose -f compose.yaml down || true

echo "Creating temporary container to restore data..."
docker run --rm \
  -v open-webui-data:/data \
  -v "$(cd $(dirname "$BACKUP_FILE") && pwd)":/backup \
  alpine:3.18 sh -c "cd /data && tar xzf /backup/$(basename $BACKUP_FILE) --strip-components=0"

echo "Restore complete. Starting service..."
docker compose -f compose.yaml up -d
docker compose ps openwebui || true
