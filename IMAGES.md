# Docker images

First-party images are public under [`melnikovit`](https://hub.docker.com/u/melnikovit).

```
melnikovit/mcp-team-hub-<component>:latest
```

CI may also push a git-SHA tag. Compose in this repo pins `:latest` for a simple install. Pin a digest or SHA tag if you need a reproducible production deploy.

```bash
docker compose pull
```

## Platform

| Image | Role |
|---|---|
| `melnikovit/mcp-team-hub-gateway` | Reverse proxy, MCP auth, hub aggregator |
| `melnikovit/mcp-team-hub-frontend` | Admin SPA |
| `melnikovit/mcp-team-hub-backend` | Admin API |
| `melnikovit/mcp-team-hub-orchestrator` | Docker lifecycle helpers |
| `melnikovit/mcp-team-hub-embeddings-stub` | Optional embeddings stub (`--profile stub`) |

## Core workers

| Image | Role |
|---|---|
| `…-mcp-secrets` | Encrypted vault |
| `…-mcp-context` | Workspace memory |
| `…-mcp-knowledge` | Knowledge / RAG |
| `…-mcp-web-search` | Web search + cache |
| `…-mcp-git` | Git forges |
| `…-mcp-figma` | Figma layout / export |
| `…-mcp-codebase-memory` | Code graph |
| `…-mcp-semgrep` | SAST |

## Other workers

Integrations: Jira, Notion, Confluence, tracker, CI, Slack, Telegram, email.

Dev / ops: repo-search, changelog, OpenAPI, Lighthouse, bundle, Docker, database, HTTP client, secrets-scan, vuln, Playwright, diagrams, Kubernetes, Terraform, Ansible, SSH, utils, fetch, S3, memory-graph, cloud, monitoring, logs, office.

Full Compose service names match `mcp-team-hub-mcp-<id>` on Docker Hub.

## Third-party

| Image | Role |
|---|---|
| `pgvector/pgvector:pg16-bookworm` | Shared Postgres + vector |
| `searxng/searxng:latest` | Meta-search for web-search |
