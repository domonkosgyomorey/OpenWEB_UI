# Architecture

Service layout:

- Open WebUI (container) — single instance, multi-user, connects outbound to DeepSeek API.
- Data persisted in Docker named volume `open-webui-data` mounted at `/app/backend/data`.
- Host binds published port to `127.0.0.1:${HOST_PORT:-3000}`; Tailscale Serve proxies the host-local endpoint to the tailnet.

Data flow:

Client (tailnet) -> HTTPS (Tailscale Serve) -> Host 127.0.0.1:HOST_PORT -> Docker published port -> Open WebUI container -> outbound HTTPS -> DeepSeek API
