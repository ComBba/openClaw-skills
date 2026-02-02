---
name: nodejs-latest
description: Best practices for Node.js 23+. Focuses on built-in tools, TypeScript support, and performance.
---

# Node.js Latest (23.0+)

## Built-in Productivity
Node.js is increasingly providing native alternatives to popular libraries.
- **node --run**: Use the stable `node --run <script>` for faster execution of `package.json` scripts.
- **node --test**: Use the built-in test runner. No need for Jest/Mocha for most projects.
- **glob**: Use `require('node:fs').glob` or `globSync` for file patterns.

## TypeScript Support
- **--experimental-strip-types**: Run `.ts` files directly without an external transpiler (Strips type annotations).
- **ESM by default**: Prefer `.mjs` or `"type": "module"` in `package.json`.

## Core API Best Practices
- **node: prefix**: Always use the `node:` prefix for built-in modules (e.g., `import fs from 'node:fs'`).
- **Web APIs**: Prefer `fetch`, `AbortController`, and `Web Streams` over Node-specific equivalents.
- **Watch Mode**: Use `node --watch` for automatic restarts during development.

## Performance
- **Permissions Model**: Use the stable permission model (`--allow-read`, etc.) for better security.
- **V8 Maglev**: Node 23 includes the Maglev compiler for better mid-tier performance.
