# Capabilities

[README](../README.md) · [Русский README](../README.ru.md) · [Architecture](./architecture.md)

The hub exposes **namespaces**, not a flat dump of every tool name. Enable modules per user in the admin UI (`/mcp`). After a config change, reload MCP in the client and open a new agent chat.

## Core

| Area | What agents do | Typical tools |
|---|---|---|
| Universal search | Look in knowledge, memory, code, and web cache **before** the open web | `hub_search` |
| Knowledge | Ingest URLs, crawl a site, retrieve a document, chat over a collection | `kb_search`, `kb_ingest_url`, `kb_start_crawl`, `kb_get_document` |
| Workspace memory | Brief, decisions, facts, tasks, notes for a git folder / project | `context_get_brief`, `context_add_*`, `context_upsert_task` |
| Vault | List and store credentials; reveal only when the human asked | `secrets_search`, `secrets_list`, `secrets_remember` |
| Code graph | Index a repo, find symbols, follow calls | `list_projects`, `search_graph`, `trace_path` |
| Workspace rg | Text search in an indexed tree | `repo_rg_search` |

## Integrations (optional)

| Area | Role |
|---|---|
| Git | GitHub / GitLab / Bitbucket PRs, MRs, issues via stored connections |
| Web | Search and research, optional promote into knowledge |
| Figma | Parse a file URL, layout tree, export |
| Semgrep | SAST scan of a path |
| Trackers | Jira, Notion, Confluence, generic tracker |
| Messaging | Slack, Telegram, email |
| Ops | Docker, SSH, Kubernetes, Terraform, Ansible, logs, monitoring |
| Quality | OpenAPI, Lighthouse, bundle, vuln / secrets scan |

The image list for every worker is in [IMAGES.md](../IMAGES.md). You do not need every worker: turn modules on in `/mcp` and store provider tokens in **Secrets**.

## Admin UI

| Page | Purpose |
|---|---|
| Dashboard | Activity overview |
| MCP | Per-user enabled servers |
| Knowledge | Collections, ingest, crawl, inbox |
| IDE connect | Hub snippet, token, optional skills/rules zip |
| Secrets | Encrypted credentials |
| Logs | MCP operational log |
| Users / Analytics | Admin only |

## IDE connect

Recommended client config — **only** the hub:

```json
{
  "mcpServers": {
    "mcp-hub": {
      "url": "https://your-domain.example/mcp/hub",
      "headers": {
        "X-Vault-Access-Token": "<token-from-ui>"
      }
    }
  }
}
```

Do not add separate `mcp-*-http` entries for knowledge, secrets, context, or Figma. Those tools already appear on the hub.

The connect page can also emit a **per-server** list if you need it. Prefer hub mode.

Skills and rules for agents download from the same page (zip / copy). They describe *when* to call `hub_search`, `context_*`, and the rest — they are not a second protocol.

## Suggested agent order

1. `hub_search` before an external web search
2. `context_get_brief` before non-trivial edits
3. `secrets_search` when credentials are required (`secrets_reveal` only if the user asked)
4. Graph / `repo_rg_search` for code structure
5. `context_append_note` (or a decision / task) when the work is done

Never write passwords or API keys into `context_*`.
