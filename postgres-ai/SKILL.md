---
name: postgres-ai
description: Best practices for using PostgreSQL as a vector database for AI agents. Focuses on pgvector, indexing, and RLS.
---

# Postgres for AI Agents

## Vector Search (pgvector)
- **Dimensions**: Match your embedding model (e.g., 1536 for OpenAI `text-embedding-3-small`).
- **Distance Metrics**: Use `cosine` distance (<=>) for most text embeddings.
- **Indexing**: 
  - **HNSW**: Use for high-speed, high-accuracy search. More memory intensive.
  - **IVFFlat**: Use for large datasets where memory is a concern. Needs periodically rebuilt.

## Multi-tenancy & Security
- **Row Level Security (RLS)**: Always enable RLS for user-specific data.
- **Service Role**: Use a restricted role for AI agents, never `postgres` or `superuser`.

## Performance
- **Connection Pooling**: Use `Supavisor` or `PgBouncer` for serverless/edge functions.
- **JSONB**: Store semi-structured metadata alongside vectors for filtering.
- **Batching**: Upsert vectors in batches to minimize RTT.

## AI Agent Workflow
1. **Embed**: Generate embedding from user query.
2. **Search**: `SELECT id, content FROM documents ORDER BY embedding <=> $1 LIMIT 5`.
3. **Filter**: Use RLS and metadata filters (`jsonb`) in the same query.
4. **Augment**: Provide the top-K results to the LLM.
