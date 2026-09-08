# SearXNG in the mcp-team-hub stack
#
# Private meta-search for mcp-web-search — no paid SERP API required.
#
# Docker hostname (from other compose services):
#   http://searxng:8080
#
# Do not publish this service on the public internet by default.
# Prefer storing the connection in the in-app vault after install.

## mcp client / vault connection (example)

```json
{
  "name": "searx",
  "provider": "searxng",
  "base_url": "http://searxng:8080",
  "default": true
}
```

## Before real deployment

1. Change `server.secret_key` in `settings.yml` (`openssl rand -hex 32`).
2. Keep SearXNG on the Docker network only unless you intentionally expose it.

## Engines

Google, Yandex (ru), DuckDuckGo — DuckDuckGo is a useful fallback if Google rate-limits the host IP.

---

### На русском

Приватный метапоиск для **mcp-web-search**. Хост в Docker-сети: `searxng:8080`. Наружу по умолчанию не открывайте. Перед продом смените `server.secret_key` в `settings.yml`.
