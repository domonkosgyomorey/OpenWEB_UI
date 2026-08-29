#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

BACKUP_DIR="$ROOT_DIR/backups"
mkdir -p "$BACKUP_DIR"

VOLUME_NAME="open-webui-data"

if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  echo "Docker volume $VOLUME_NAME not found." >&2
  exit 2
fi

TS=$(date -u +%Y%m%dT%H%M%SZ)
OUT="$BACKUP_DIR/openwebui-${TS}.tar.gz"

echo "Creating backup to $OUT"

# Use a small container to tar the volume contents into the host backup dir
docker run --rm \
  -v ${VOLUME_NAME}:/data:ro \
  -v "$BACKUP_DIR":/backup \
  alpine:3.18 sh -c "cd /data && tar czf /backup/$(basename $OUT) ."

echo "Backup complete: $OUT"
