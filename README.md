# mcp-team-hub

## What it is / Что это

**EN.** **mcp-team-hub** is a self-hosted team hub for [MCP](https://modelcontextprotocol.io/) (Model Context Protocol). One gateway gives your IDE and agents a single entry to many tools; a web admin manages users, projects, and which MCP servers each person can use; a vault stores credentials; knowledge/RAG workers index docs for grounded answers; and an IDE-connect flow issues the tokens and config you need to plug the hub into your editor.

**RU.** **mcp-team-hub** — self-hosted хаб MCP для команды. Один gateway — единая точка входа IDE и агентов ко многим tools; веб-админка управляет пользователями, проектами и набором MCP у каждого; vault хранит секреты; knowledge/RAG индексирует документы для ответов с опорой на базу знаний; подключение IDE выдаёт токены и конфиг для редактора.

Use it when a team wants shared MCP tooling (git, search, trackers, docs, security scanners, …) behind one authenticated endpoint instead of dozens of ad-hoc server configs.

Подходит команде, которой нужен общий набор MCP-инструментов за одним авторизованным входом, а не десятки разрозненных конфигов в каждом редакторе.

### Highlights / Возможности

| EN | RU |
|----|----|
| **Gateway + MCP hub** — fan-out `tools/list`, per-server routes, knowledge-first options | **Gateway + MCP hub** — агрегация tools, маршруты по серверам, knowledge-first |
| **Admin UI** — users/roles, per-user MCP sets, projects, analytics, logs | **Админка** — пользователи/роли, личные наборы MCP, проекты, аналитика, логи |
| **Secrets vault** — encrypted provider tokens; not baked into container env | **Vault** — шифрованные токены провайдеров; не в env контейнеров |
| **Knowledge / RAG** — crawl/ingest docs, embeddings, internal knowledge API | **Knowledge / RAG** — обход/импорт документов, embeddings, internal API |
| **IDE connect** — hub URL + vault access token (and optional per-server bundle) | **Подключение IDE** — URL hub + vault-токен (опционально бандл per-server) |
| **Worker suite** — first-party MCP microservices on a shared Postgres | **Воркеры** — first-party MCP-микросервисы на общем Postgres |

```
IDE / browser
    │
    ▼
 gateway  ──► frontend (admin SPA)
    ├──► api (auth, catalog, projects, vault integration)
    ├──► orchestrator (container lifecycle helpers)
    └──► MCP workers (secrets, git, search, knowledge, …)
              │
              ▼
         shared PostgreSQL (schema per worker)
```

> This public repository is **docs + deploy templates only** (Docker Compose pulling public images). Application source lives elsewhere.

> Этот публичный репозиторий — **только документация и шаблоны деплоя** (Compose с публичными образами). Исходники приложения публикуются отдельно.

---

## Deploy with Docker Hub images / Деплой с образами Docker Hub

Requirements: Docker Engine + Docker Compose v2.

```bash
git clone https://github.com/melnikovit/mcp-team-hub.git
cd mcp-team-hub
cp .env.example .env
# edit secrets in .env before any real deployment
docker compose pull
docker compose up -d
```

Open the UI: [http://localhost:4300](http://localhost:4300)

Default bootstrap admin (from `.env.example`): `admin@example.com` / `changeme` — change before exposing beyond localhost.

### Your own domain / Свой домен

```env
APP_PUBLIC_URL=https://your-domain.example
CORS_ORIGINS=https://your-domain.example
GATEWAY_PORT=4300
```

Terminate TLS on your reverse proxy (Caddy, nginx, Traefik) in front of the gateway. Do not commit real certificates or secrets here.

### Images / Образы

Public namespace: [`melnikovit`](https://hub.docker.com/u/melnikovit)  
Pattern: `melnikovit/mcp-team-hub-<component>:latest` (CI also pushes a git-SHA tag)  
Full list: [IMAGES.md](./IMAGES.md)

```bash
docker pull melnikovit/mcp-team-hub-gateway:latest
docker pull melnikovit/mcp-team-hub-backend:latest
docker pull melnikovit/mcp-team-hub-frontend:latest
```

Also used: `pgvector/pgvector:pg16-bookworm`, `searxng/searxng:latest`.

| Component | Role |
|-----------|------|
| **gateway** | Single HTTP entry (UI + `/api` + `/mcp/*`) |
| **frontend** | Admin SPA |
| **api** (image `mcp-team-hub-backend`) | JWT auth, catalog, projects, vault |
| **orchestrator** | Docker lifecycle helpers |
| **mcp-*** workers | First-party MCP servers |
| **postgres** | Shared DB (`pgvector`) |
| **searxng** | Optional meta-search for web-search |

### Configuration / Конфигурация

Copy [`.env.example`](./.env.example) → `.env` and replace every `change-me` / `changeme`:

- `JWT_SECRET`, `VAULT_MASTER_KEY`, `VAULT_SERVICE_TOKEN`
- `GATEWAY_INTERNAL_TOKEN`, `ORCHESTRATOR_API_TOKEN`
- Bootstrap admin password

Provider API tokens (Git, Jira, Figma, …) go into the in-app **Secrets** vault after login — not into compose env for real deployments.

### MCP / IDE connection / Подключение IDE

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

Remote install: use `https://your-domain.example` instead of localhost.

## What is not here / Чего здесь нет

- Application source code and private CI
- Production hostnames, internal IPs, or operator runbooks
- Real secrets or registry credentials

## License

MIT — see [LICENSE](./LICENSE).
