# Docker Hub images

All first-party images are **public** under [`melnikovit`](https://hub.docker.com/u/melnikovit).

Tag pattern: `melnikovit/mcp-team-hub-<component>:latest` (CI may also push a git-SHA tag).

Compose in this repo pins `:latest` for a simple install. Pin a SHA tag in production if you need reproducible deploys.

## Platform

- `melnikovit/mcp-team-hub-gateway`
- `melnikovit/mcp-team-hub-frontend`
- `melnikovit/mcp-team-hub-backend`
- `melnikovit/mcp-team-hub-orchestrator`
- `melnikovit/mcp-team-hub-embeddings-stub`

## Core MCP workers

- `melnikovit/mcp-team-hub-mcp-secrets`
- `melnikovit/mcp-team-hub-mcp-context`
- `melnikovit/mcp-team-hub-mcp-knowledge`
- `melnikovit/mcp-team-hub-mcp-web-search`
- `melnikovit/mcp-team-hub-mcp-git`
- `melnikovit/mcp-team-hub-mcp-figma`
- `melnikovit/mcp-team-hub-mcp-codebase-memory`
- `melnikovit/mcp-team-hub-mcp-semgrep`

## Integrations

- `melnikovit/mcp-team-hub-mcp-jira`
- `melnikovit/mcp-team-hub-mcp-notion`
- `melnikovit/mcp-team-hub-mcp-confluence`
- `melnikovit/mcp-team-hub-mcp-tracker`
- `melnikovit/mcp-team-hub-mcp-ci`
- `melnikovit/mcp-team-hub-mcp-slack`
- `melnikovit/mcp-team-hub-mcp-telegram`
- `melnikovit/mcp-team-hub-mcp-email`

## Dev / ops tooling

- `melnikovit/mcp-team-hub-mcp-repo-search`
- `melnikovit/mcp-team-hub-mcp-changelog`
- `melnikovit/mcp-team-hub-mcp-openapi`
- `melnikovit/mcp-team-hub-mcp-lighthouse`
- `melnikovit/mcp-team-hub-mcp-bundle`
- `melnikovit/mcp-team-hub-mcp-docker`
- `melnikovit/mcp-team-hub-mcp-database`
- `melnikovit/mcp-team-hub-mcp-http-client`
- `melnikovit/mcp-team-hub-mcp-secrets-scan`
- `melnikovit/mcp-team-hub-mcp-vuln`
- `melnikovit/mcp-team-hub-mcp-playwright`
- `melnikovit/mcp-team-hub-mcp-diagrams`
- `melnikovit/mcp-team-hub-mcp-kubernetes`
- `melnikovit/mcp-team-hub-mcp-terraform`
- `melnikovit/mcp-team-hub-mcp-ansible`
- `melnikovit/mcp-team-hub-mcp-ssh`
- `melnikovit/mcp-team-hub-mcp-utils`
- `melnikovit/mcp-team-hub-mcp-fetch`
- `melnikovit/mcp-team-hub-mcp-s3`
- `melnikovit/mcp-team-hub-mcp-memory-graph`
- `melnikovit/mcp-team-hub-mcp-cloud`
- `melnikovit/mcp-team-hub-mcp-monitoring`
- `melnikovit/mcp-team-hub-mcp-logs`
- `melnikovit/mcp-team-hub-mcp-office`

## Third-party (not under melnikovit)

- `pgvector/pgvector:pg16-bookworm` — shared Postgres + vector extension
- `searxng/searxng:latest` — optional meta-search for mcp-web-search

## Pull examples

```bash
docker pull melnikovit/mcp-team-hub-gateway:latest
docker pull melnikovit/mcp-team-hub-backend:latest
docker pull melnikovit/mcp-team-hub-frontend:latest
docker pull melnikovit/mcp-team-hub-mcp-secrets:latest
```

Or pull everything referenced by Compose:

```bash
docker compose pull
```
