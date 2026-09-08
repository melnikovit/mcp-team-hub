# mcp-team-hub

**Один gateway. Общие MCP-инструменты. Админка для команды.**

Self-hosted хаб для [Model Context Protocol](https://modelcontextprotocol.io/): единый авторизованный вход для IDE и агентов плюс веб-админка для пользователей, проектов, секретов и базы знаний.

English README: [README.md](./README.md) · Образы: [IMAGES.md](./IMAGES.md)

---

## Что это

**mcp-team-hub** поднимается через Docker Compose и использует публичные образы Docker Hub (`melnikovit/mcp-team-hub-*`).

- **Gateway** — один HTTP-вход: UI, `/api`, `/mcp/*`
- **Админка** — пользователи, роли, личные наборы MCP, проекты, логи
- **Vault** — шифрованные токены провайдеров (не в env контейнеров)
- **Knowledge / RAG** — импорт документов, embeddings, ответы с опорой на базу
- **IDE connect** — URL хаба и токен для редактора
- **Воркеры** — first-party MCP-микросервисы на общем Postgres

Этот публичный репозиторий — **только документация и шаблоны деплоя**. Исходники приложения здесь не публикуются.

---

## Для кого

- Команде нужен **один общий MCP-вход**, а не десятки конфигов в каждом IDE
- Деплой **у себя** через Docker
- Нужен **доступ по пользователям** к git, поиску, трекерам, документации, сканерам

---

## Архитектура

```
IDE / browser
      │
      ▼
   gateway  ──► frontend (admin SPA)
      ├──► api (auth, catalog, projects, vault)
      ├──► orchestrator (container helpers)
      └──► MCP workers (secrets, git, search, knowledge, …)
                │
                ▼
           shared PostgreSQL (schema per worker)
```

Также в стеке: `pgvector/pgvector` и опционально `searxng/searxng`.

---

## Требования

- Docker Engine + Docker Compose v2
- Рекомендуется ~4 GB RAM для полного набора воркеров
- Порт хоста по умолчанию: `4300`

---

## Быстрый старт

```bash
git clone https://github.com/melnikovit/mcp-team-hub.git
cd mcp-team-hub
cp .env.example .env
# Замените все change-me / changeme перед реальным деплоем
docker compose pull
docker compose up -d
```

Откройте UI: **[http://localhost:4300](http://localhost:4300)**

Bootstrap-админ из `.env.example`: `admin@example.com` / `changeme` — смените до публикации наружу.

---

## Установка по шагам

1. Клонировать репозиторий и скопировать `.env.example` → `.env`.
2. Задать как минимум: `JWT_SECRET`, `VAULT_MASTER_KEY`, `VAULT_SERVICE_TOKEN`, `GATEWAY_INTERNAL_TOKEN`, `ORCHESTRATOR_API_TOKEN`, `BOOTSTRAP_ADMIN_PASSWORD`, `POSTGRES_PASSWORD`.
3. `docker compose pull && docker compose up -d`.
4. Проверить `http://localhost:4300`.

Свой домен:

```env
APP_PUBLIC_URL=https://your-domain.example
CORS_ORIGINS=https://your-domain.example
GATEWAY_PORT=4300
```

TLS завершайте на reverse proxy (Caddy, nginx, Traefik) перед gateway.

Полный список образов: [IMAGES.md](./IMAGES.md).

---

## Конфигурация

Источник: [`.env.example`](./.env.example).

Токены внешних провайдеров (Git, Jira, Figma, …) храните в **Secrets** в UI после входа — не в env compose на проде.

---

## Подключение IDE

```json
{
  "mcpServers": {
    "mcp-hub": {
      "url": "http://localhost:4300/mcp/hub",
      "headers": {
        "X-Vault-Access-Token": "<token-from-ui>"
      }
    }
  }
}
```

Для удалённого деплоя: `https://your-domain.example/mcp/hub`. Реальные токены не коммитьте.

---

## FAQ / неполадки

| Симптом | Что проверить |
|---|---|
| UI не открывается | `docker compose ps`, логи `gateway` |
| Не логинится | Bootstrap-переменные в `.env` |
| Пустой список tools | Vault-токен в IDE, набор MCP у пользователя |
| Нет web-search | Сервис SearXNG и настройки в vault |
| Порт занят | `GATEWAY_PORT` в `.env` |

```bash
docker compose logs gateway --tail=100
docker compose logs api --tail=100
```

---

## Чего здесь нет

- Исходников приложения и приватного CI
- Продакшен-хостов, внутренних IP и операторских runbook’ов
- Реальных секретов

---

## Лицензия

MIT — [LICENSE](./LICENSE).
