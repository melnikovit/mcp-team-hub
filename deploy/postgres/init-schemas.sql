-- Platform policy: ONE Postgres instance, many schemas (not one container per MCP).
-- Admin API uses public schema in POSTGRES_DB (default mcp_admin).
-- MCP workers set DB_SCHEMA + search_path to their schema below.

CREATE EXTENSION IF NOT EXISTS vector;

CREATE SCHEMA IF NOT EXISTS secrets;
CREATE SCHEMA IF NOT EXISTS web_search;
CREATE SCHEMA IF NOT EXISTS git;
CREATE SCHEMA IF NOT EXISTS jira;
CREATE SCHEMA IF NOT EXISTS confluence;
CREATE SCHEMA IF NOT EXISTS context;
CREATE SCHEMA IF NOT EXISTS codebase_memory;
CREATE SCHEMA IF NOT EXISTS knowledge;
CREATE SCHEMA IF NOT EXISTS artifacts;
CREATE SCHEMA IF NOT EXISTS workspace;
CREATE SCHEMA IF NOT EXISTS memory_graph;

COMMENT ON SCHEMA secrets IS 'mcp-secrets vault';
COMMENT ON SCHEMA web_search IS 'mcp-web-search + pgvector chunks';
COMMENT ON SCHEMA git IS 'mcp-git';
COMMENT ON SCHEMA jira IS 'mcp-jira';
COMMENT ON SCHEMA confluence IS 'mcp-confluence';
COMMENT ON SCHEMA context IS 'mcp-context';
COMMENT ON SCHEMA codebase_memory IS 'mcp-codebase-memory';
COMMENT ON SCHEMA knowledge IS 'mcp-knowledge RAG collections';
COMMENT ON SCHEMA artifacts IS 'user artifacts blobs metadata';
COMMENT ON SCHEMA workspace IS 'user project workspace metadata';
COMMENT ON SCHEMA memory_graph IS 'mcp-memory-graph entities/relations';
