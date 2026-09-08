# mcp-team-hub

**One gateway. Shared MCP tools. Team admin.**

Self-hosted hub for the [Model Context Protocol](https://modelcontextprotocol.io/): a single authenticated entry for IDEs and agents, plus a web admin for users, projects, secrets, and knowledge.

> **RU.** Self-hosted хаб MCP: один авторизованный вход для IDE и агентов, веб-админка для пользователей, проектов, секретов и базы знаний.

[Quick start](#quick-start) · [Configuration](#configuration) · [IDE connect](#connect-your-ide) · [Русская версия](./README.ru.md) · [Docker images](./IMAGES.md)

---

## What it is

**mcp-team-hub** runs as Docker Compose and pulls public images from Docker Hub (`melnikovit/mcp-team-hub-*`).

| Capability | What you get |
|---|---|
| Gateway | One HTTP entry for UI, `/api`, and `/mcp/*` |
| Admin UI | Users, roles, per-user MCP sets, projects, logs |
| Secrets vault | Encrypted provider tokens (not baked into container env) |
| Knowledge / RAG | Crawl/ingest docs, embeddings, grounded answers |
| IDE connect | Hub URL + access token for your editor |
| Worker suite | First-party MCP microservices on shared Postgres |

This public repository is **documentation and deploy templates only**. Application source is not published here.

### На русском

**mcp-team-hub** поднимается через Docker Compose и тянет публичные образы с Docker Hub.

Один gateway — точка входа; админка — пользователи и наборы MCP; vault — секреты; knowledge/RAG — документы; IDE connect — URL и токен для редактора.

Публичный репозиторий содержит **только документацию и шаблоны деплоя**. Исходники приложения здесь не публикуются.

---

## Who it's for

- Teams that want **one shared MCP endpoint** instead of dozens of ad-hoc server configs in every IDE
- Operators who prefer **self-hosted** tooling with Docker
- Admins who need **per-user access** to git, search, trackers, docs, scanners, and more

### На русском

- Команды, которым нужен **один общий MCP-вход**, а не десятки конфигов в каждом редакторе
- Операторы, которые деплоят **у себя** через Docker
- Админы, которым нужен **доступ по пользователям** к git, поиску, трекерам, документации, сканерам

---

## Architecture

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

Third-party images in the stack: `pgvector/pgvector` (database) and `searxng/searxng` (optional meta-search for web-search).

### На русском

Браузер и IDE ходят в **gateway**. Он отдаёт SPA, проксирует API и маршруты MCP-воркеров. Всё пишет в **общий Postgres** (отдельная schema на воркер).

---

## Requirements

- Docker Engine
- Docker Compose v2
- ~4 GB RAM recommended for the full worker suite
- Ports: `4300` on the host by default (gateway)

### На русском

Нужны Docker Engine и Compose v2. Для полного набора воркеров лучше от ~4 GB RAM. По умолчанию на хосте открыт порт `4300`.

---

## Quick start

```bash
git clone https://github.com/melnikovit/mcp-team-hub.git
cd mcp-team-hub
cp .env.example .env
# Replace every change-me / changeme before any real deployment
docker compose pull
docker compose up -d
```

Open the admin UI: **[http://localhost:4300](http://localhost:4300)**

Bootstrap admin (from `.env.example`):

- Email: `admin@example.com`
- Password: `changeme`

Change these before exposing the stack beyond localhost.

### На русском

Клонируйте репозиторий, скопируйте `.env.example` → `.env`, замените плейсхолдеры, затем `docker compose pull && docker compose up -d`. UI: http://localhost:4300. Логин/пароль bootstrap — из `.env.example`; смените их до публикации наружу.

---

## Install & deploy

### 1. Clone and configure

```bash
git clone https://github.com/melnikovit/mcp-team-hub.git
cd mcp-team-hub
cp .env.example .env
```

Edit `.env` and set at least:

- `JWT_SECRET`
- `VAULT_MASTER_KEY`
- `VAULT_SERVICE_TOKEN`
- `GATEWAY_INTERNAL_TOKEN`
- `ORCHESTRATOR_API_TOKEN`
- `BOOTSTRAP_ADMIN_PASSWORD`
- `POSTGRES_PASSWORD`

### 2. Pull images and start

```bash
docker compose pull
docker compose up -d
docker compose ps
```

### 3. Verify

```bash
curl -sS -o /dev/null -w "%{http_code}\n" http://localhost:4300/
```

Expect `200` (or a redirect). Then sign in at http://localhost:4300.

### 4. Your own domain (optional)

```env
APP_PUBLIC_URL=https://your-domain.example
CORS_ORIGINS=https://your-domain.example
GATEWAY_PORT=4300
```

Terminate TLS on a reverse proxy (Caddy, nginx, Traefik) in front of the gateway. Do not commit real certificates or secrets to this repo.

### Images

- Namespace: [`melnikovit`](https://hub.docker.com/u/melnikovit)
- Pattern: `melnikovit/mcp-team-hub-<component>:latest`
- Full list: [IMAGES.md](./IMAGES.md)

```bash
docker pull melnikovit/mcp-team-hub-gateway:latest
docker pull melnikovit/mcp-team-hub-backend:latest
docker pull melnikovit/mcp-team-hub-frontend:latest
```

### На русском

1. Клонировать → `cp .env.example .env` → заменить секреты.  
2. `docker compose pull && docker compose up -d`.  
3. Проверить http://localhost:4300.  
4. Для своего домена задать `APP_PUBLIC_URL` / `CORS_ORIGINS` и TLS на reverse proxy.  
Список образов — в [IMAGES.md](./IMAGES.md).

---

## Configuration

Source of truth: [`.env.example`](./.env.example).

| Area | Variables |
|---|---|
| Public entry | `GATEWAY_PORT`, `APP_PUBLIC_URL`, `CORS_ORIGINS` |
| Auth | `JWT_SECRET`, bootstrap admin fields |
| Vault | `VAULT_MASTER_KEY`, `VAULT_SERVICE_TOKEN` |
| Internal tokens | `GATEWAY_INTERNAL_TOKEN`, `ORCHESTRATOR_API_TOKEN`, `KNOWLEDGE_SERVICE_TOKEN` |
| Optional SMTP / OIDC | `SMTP_*`, `OIDC_*` |

**Provider tokens** (Git, Jira, Figma, …) belong in the in-app **Secrets** vault after login — not in compose env for real deployments.

### На русском

Скопируйте `.env.example`, заполните секреты платформы. Токены внешних провайдеров кладите в vault в UI после входа, а не в env контейнеров на проде.

---

## Connect your IDE

1. Open the admin UI and complete **IDE connect** (or copy the hub URL + vault access token from the UI).
2. Add a server to your MCP client config:

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

For a remote install, replace the URL with `https://your-domain.example/mcp/hub`.

Never commit real tokens. Prefer placeholders in docs and rotate anything that leaked.

### На русском

В UI возьмите URL хаба и vault-токен, добавьте их в конфиг MCP-клиента. Для удалённого деплоя используйте `https://your-domain.example`. Реальные токены в git не коммитьте.

---

## Troubleshooting

| Symptom | What to check |
|---|---|
| UI not loading | `docker compose ps`, gateway logs: `docker compose logs gateway --tail=100` |
| Login fails | Bootstrap vars in `.env`; recreate admin only on a fresh DB volume |
| MCP tools empty | Vault token in IDE headers; user MCP set in admin; worker health via `docker compose ps` |
| Web search empty | SearXNG service up; connection stored in vault / settings |
| Port busy | Change `GATEWAY_PORT` in `.env` |

```bash
docker compose logs api --tail=100
docker compose logs mcp-secrets --tail=100
docker compose down   # stop stack (keeps volumes)
```

### На русском

Смотрите `docker compose ps` и логи `gateway` / `api` / нужного воркера. Пустой список tools — чаще всего токен в IDE или набор MCP у пользователя. Занятый порт — смените `GATEWAY_PORT`.

---

## What is not in this repo

- Application source and private CI
- Production hostnames, internal IPs, or operator runbooks
- Real secrets or private registry credentials

---

## License

MIT — see [LICENSE](./LICENSE).
