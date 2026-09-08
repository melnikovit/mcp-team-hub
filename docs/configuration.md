# Configuration: `.env` vs Secrets vault

[README](../README.md) · [Русский README](../README.ru.md) · [Architecture](./architecture.md) · [Capabilities](./capabilities.md)

## Rule of thumb

| Put in `.env` / Compose | Put in **Secrets** (UI after login) |
|---|---|
| Postgres, ports, `APP_PUBLIC_URL`, CORS | Provider API tokens / PATs (Git, Jira, Figma, …) |
| `JWT_SECRET`, `VAULT_MASTER_KEY`, service tokens | Connection JSON (`git_connections`, `jira_connections`, `web_search_connections`, …) |
| Crawl limits, embedding model / Ollama URL | Optional `semgrep_app_token`, `ssh_targets`, … |
| Bootstrap admin for first UI login | Credentials resolved per user via `X-Vault-Access-Token` |

Copy [`.env.example`](../.env.example) → `.env` and replace every `change-me` / `changeme` before a real deployment.

**Do not** put Figma / GitHub / GitLab / Jira / Notion tokens into Compose env on a real install. Store them in **Secrets**.

## Minimum `.env` set

| Area | Variables |
|---|---|
| Public entry | `GATEWAY_PORT`, `APP_PUBLIC_URL`, `CORS_ORIGINS` |
| Auth | `JWT_SECRET`, `BOOTSTRAP_ADMIN_*` |
| Vault crypto | `VAULT_MASTER_KEY`, `VAULT_SERVICE_TOKEN` |
| Internal tokens | `GATEWAY_INTERNAL_TOKEN`, `ORCHESTRATOR_API_TOKEN`, `KNOWLEDGE_SERVICE_TOKEN` |
| Database | `POSTGRES_PASSWORD` (and user/db if not defaults) |

Your own domain:

```env
APP_PUBLIC_URL=https://your-domain.example
CORS_ORIGINS=https://your-domain.example
```

## Vault secret names (common)

| Secret name | Module |
|---|---|
| `git_connections` | Git / CI |
| `web_search_connections` | Web search (prefer over `WEB_SEARCH_CONNECTIONS` env) |
| `jira_connections` | Jira (preferred over legacy flat `jira_*` secrets) |
| `confluence_connections` | Confluence |
| `figma_access_token` | Figma |
| `notion_token` | Notion |
| `semgrep_app_token` | Semgrep Cloud (optional) |
| `ssh_targets` | SSH worker |

## Misleading `.env` names

| Pattern | Meaning |
|---|---|
| `GIT_ADMIN_*`, `JIRA_ADMIN_*`, `WEB_SEARCH_ADMIN_*`, … | That **worker’s admin UI** login — not forge/tracker PATs |
| `NOTION_BASE_URL` / `NOTION_VERSION` | Non-secret defaults; token stays in vault |
| `WEB_SEARCH_CONNECTIONS` | Local compose convenience; production → vault |

`DATABASE_URL` is normally assembled by Compose from `POSTGRES_*`.
