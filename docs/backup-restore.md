# Backup and Restore

Backup:

1. Use `scripts/backup.sh` which creates a timestamped tarball under `backups/` from the `open-webui-data` Docker volume.
2. Backups are created from the named volume without destroying the running service.

Restore:

1. Use `scripts/restore.sh <backup-tar.gz>`.
2. The script prompts for confirmation before proceeding and will stop the Compose stack while restoring.

Notes:

- Store backups off-host for safety.
- Verify backups by extracting them to a temporary location.
