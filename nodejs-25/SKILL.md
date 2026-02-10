---
name: nodejs-25
description: Best practices for Node.js 25.6+. Focuses on built-in SQLite, type-stripping, and native ESM modules.
---

# Node.js 25.6+ Best Practices

## 🆕 Node.js 25.6.0 Highlights (2026-02-04)
- **OpenSSL 3.5.5**: Updated to latest stable OpenSSL
- **async_hooks improvements**: Better async context tracking
- **ESM embedder API**: Improved native module embedding support
- **Permission Model**: Continued stabilization of `--allow-*` flags

## Built-in Power
- **Native SQLite**: Use `node:sqlite` for local data persistence without external dependencies.
- **Native Testing**: Stick to `node:test` and `node:assert`.
- **Built-in Glob**: Use `node:fs` globbing for file system operations.

## TypeScript Support (v25+)
- **--experimental-strip-types**: Run TS files directly. Node 25 makes this even more stable and performant.

## ESM & Security
- **Strict ESM**: Enforce `"type": "module"` and use the `node:` prefix.
- **Permission Model**: Use the stable `--allow-*` flags for granular security.
