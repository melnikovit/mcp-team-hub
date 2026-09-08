# SearXNG в стеке MCP

Приватный метапоиск для **mcp-web-search** без платных API.

## Сервис

- **Docker hostname:** `searxng:8080` (для `X-Web-Search-Connections` в mcp.json)
- **На хосте (отладка):** `127.0.0.1:8088`
- **Публичный URL:** не выставляем по умолчанию (чтобы не использовать как открытый прокси)

## mcp.json

```json
"X-Web-Search-Connections": "[{\"name\":\"searx\",\"provider\":\"searxng\",\"base_url\":\"http://searxng:8080\",\"default\":true}]"
```

## Прод

1. Смените `server.secret_key` в `settings.yml`: `openssl rand -hex 32`
2. После деплоя: `curl -s 'http://127.0.0.1:8088/search?format=json&q=test' | head`

Движки: Google, Yandex (ru), DuckDuckGo — fallback если Google режет IP.
