---
name: nodejs-25
description: Best practices for Node.js 25.5+. Focuses on built-in SQLite, type-stripping, and native ESM modules.
---

# Node.js 25.5+ Best Practices

## Built-in Power
- **Native SQLite**: Use `node:sqlite` for local data persistence without external dependencies.
- **Native Testing**: Stick to `node:test` and `node:assert`.
- **Built-in Glob**: Use `node:fs` globbing for file system operations.

## TypeScript Support (v25+)
- **--experimental-strip-types**: Run TS files directly. Node 25 makes this even more stable and performant.

## ESM & Security
- **Strict ESM**: Enforce `"type": "module"` and use the `node:` prefix.
- **Permission Model**: Use the stable `--allow-*` flags for granular security.
