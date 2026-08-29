# Security

- The Open WebUI service is bound to `127.0.0.1` and not exposed to the public Internet.
- Access from mobile/desktop is via Tailscale Serve which terminates HTTPS for tailnet clients.
- Secrets (`DEEPSEEK_API_KEY`, `WEBUI_SECRET_KEY`) must be stored in `.env` and never committed.
- No host-level reverse proxies, no Funnel, no port forwarding are used by default.
- The Docker Compose stack does not mount the Docker socket and containers do not run privileged.
