# mcp-team-hub

**mcp-team-hub** is a self-hosted platform for team MCP (Model Context Protocol) tooling: a web admin UI, API, gateway, orchestrator, shared PostgreSQL, and a suite of MCP worker microservices.

This public repository contains **deployment documentation and compose templates** that pull **pre-built public images from Docker Hub**. Application source code is not published here.

## Architecture (overview)

```
IDE / browser
    │
    ▼
 gateway  ──► frontend (SPA)
    ├──► api (admin / auth / catalog)
    ├──► orchestrator (container lifecycle)
    └──► MCP workers (secrets, git, search, knowledge, …)
              │
              ▼
         shared PostgreSQL (schemas per worker)
```

| Component | Role |
|-----------|------|
| **gateway** | Single HTTP entry (UI + `/api` + `/mcp/*`) |
| **frontend** | Admin SPA |
| **api** (image: `mcp-team-hub-backend`) | JWT auth, catalog, projects, vault integration |
| **orchestrator** | Docker lifecycle helpers |
| **mcp-*** workers | First-party MCP servers |
| **postgres** | Shared DB (`pgvector` image) |
| **searxng** | Optional meta-search backend for web-search |

## Quick start

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

Default bootstrap admin (from `.env.example`):

- email: `admin@example.com`
- password: `changeme`

Change these before exposing the stack beyond localhost.

### Behind your own domain

Set in `.env`:

```env
APP_PUBLIC_URL=https://your-domain.example
CORS_ORIGINS=https://your-domain.example
GATEWAY_PORT=4300
```

Put a reverse proxy (Caddy, nginx, Traefik) in front of the gateway port and terminate TLS there. Do not commit real certificates or secrets into this repo.

## Docker Hub images

All application images are public:

- Namespace: [`melnikovit`](https://hub.docker.com/u/melnikovit)
- Naming: `melnikovit/mcp-team-hub-<component>:latest` (also tagged with git SHA from CI)
- Full list: see [IMAGES.md](./IMAGES.md)

Examples:

```bash
docker pull melnikovit/mcp-team-hub-gateway:latest
docker pull melnikovit/mcp-team-hub-backend:latest
docker pull melnikovit/mcp-team-hub-frontend:latest
```

Third-party images used by compose:

- `pgvector/pgvector:pg16-bookworm`
- `searxng/searxng:latest`

## Configuration

Copy [`.env.example`](./.env.example) to `.env` and replace every `change-me` / `changeme` value:

- `JWT_SECRET`, `VAULT_MASTER_KEY`, `VAULT_SERVICE_TOKEN`
- `GATEWAY_INTERNAL_TOKEN`, `ORCHESTRATOR_API_TOKEN`
- Bootstrap admin password
- Per-worker admin passwords where applicable

User API tokens for external providers (Git, Jira, Figma, …) belong in the in-app **Secrets** vault after first login — not in compose environment files for production.

## MCP / IDE connection

With the stack running locally, a typical hub endpoint looks like:

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

For a remote install, replace the host with `https://your-domain.example`.

## What is not in this repository

- Application source code and private CI
- Production hostnames, internal IPs, or operator runbooks
- Real secrets or registry credentials

## License

MIT — see [LICENSE](./LICENSE).
