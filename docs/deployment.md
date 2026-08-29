# Deployment

Development (Windows + Docker Desktop):

1. Copy `.env.example` to `.env` and set `OPEN_WEBUI_VERSION`, `WEBUI_SECRET_KEY`, and `DEEPSEEK_API_KEY`.
2. Run `docker compose pull` then `docker compose up -d`.
3. Open `http://localhost:3000` in a browser.

Raspberry Pi (production):

1. Install a 64-bit minimal Linux distribution and enable SSH.
2. Install Docker Engine and Docker Compose (follow official Docker docs for your distro).
3. Install and authenticate Tailscale.
4. Clone this repository on the Pi.
5. Copy `.env.example` to `.env` and populate values.
6. Run `scripts/install.sh` to start the service.
7. Optionally run `scripts/setup-tailscale.sh` to configure Tailscale Serve.
