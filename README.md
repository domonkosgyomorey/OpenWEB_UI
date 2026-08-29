# Open WebUI on Raspberry Pi (DeepSeek + Tailscale)

This repository provides a minimal Docker Compose deployment of Open WebUI
for Raspberry Pi (ARM64) and Windows development (Docker Desktop). Open WebUI
connects to the DeepSeek hosted API. Access is provided privately via
Tailscale Serve and the Open WebUI service is bound to localhost on the host.

Overview

- Compose file: `compose.yaml` (service: `openwebui`)
- Persistent volume: `open-webui-data` -> `/app/backend/data`
- Env example: `.env.example`
- Scripts: `scripts/` for install, update, backup, restore, diagnose, tailscale helper

Quick start (development on Windows Docker Desktop)

1. Copy `.env.example` to `.env` and edit values (`OPEN_WEBUI_VERSION`, `WEBUI_SECRET_KEY`, `DEEPSEEK_API_KEY`).
2. Run:

```bash
docker compose pull
docker compose up -d
```

3. Browse to `http://localhost:3000` (or whatever `HOST_PORT` you set).

Raspberry Pi (production)

1. Install 64-bit Linux, Docker Engine, Docker Compose, and Tailscale on the Pi.
2. Clone this repo to the Pi, copy `.env.example` to `.env` and set secrets.
3. Run `scripts/install.sh` to validate and start the service.
4. Configure Tailscale Serve to proxy the local service (see `scripts/setup-tailscale.sh`).

Security model

- Open WebUI is bound to `127.0.0.1` on the host; it is NOT publicly exposed.
- Access is via Tailscale Serve which terminates HTTPS for tailnet clients.
- `DEEPSEEK_API_KEY` and `WEBUI_SECRET_KEY` must never be committed.

See `docs/` for architecture, deployment, backup and troubleshooting guides.
