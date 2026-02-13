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

## 🔐 Security Releases Note (2026-01-13)
Node.js shipped security updates for **25.x / 24.x / 22.x / 20.x** addressing multiple issues (3 high, 4 medium, 1 low).
If you’re running Node 25 in production, treat this as a reminder to **stay on the latest patch**.
Notable high-severity items included:
- **CVE-2025-55131**: timeout-related race can make `Buffer.alloc`/`Uint8Array` allocations non-zero-filled (uninitialized memory exposure).
- **CVE-2025-55130**: permission model `--allow-fs-read/write` bypass via crafted symlink paths.
- **CVE-2025-59465**: malformed HTTP/2 HEADERS frame can crash the process (DoS) if TLS socket errors aren’t handled.
Dependency updates mentioned in the advisory: **c-ares 1.34.6**, **undici 6.23.0/7.18.0**.
(Source: https://nodejs.org/en/blog/vulnerability/december-2025-security-releases)

## Built-in Power
- **Native SQLite**: Use `node:sqlite` for local data persistence without external dependencies.
- **Native Testing**: Stick to `node:test` and `node:assert`.
- **Built-in Glob**: Use `node:fs` globbing for file system operations.

## TypeScript Support (v25+)
- **--experimental-strip-types**: Run TS files directly. Node 25 makes this even more stable and performant.

## ESM & Security
- **Strict ESM**: Enforce `"type": "module"` and use the `node:` prefix.
- **Permission Model**: Use the stable `--allow-*` flags for granular security.
