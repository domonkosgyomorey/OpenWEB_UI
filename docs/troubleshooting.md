# Troubleshooting

- Container won't start: run `docker compose logs --tail=200 openwebui` and check `docker compose ps`.
- Wrong architecture: verify the Pi is running 64-bit Linux and the image tag supports arm64.
- API auth failures: verify `DEEPSEEK_API_KEY` in `.env` and check Open WebUI provider settings in the Admin panel.
- Open WebUI unavailable: run `scripts/diagnose.sh` and check that the service is bound on `127.0.0.1:${HOST_PORT:-3000}`.
- Tailscale Serve issues: ensure the host is authenticated into the tailnet and run `tailscale status` and `tailscale serve status`.
