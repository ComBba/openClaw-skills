---
name: nextjs-16
description: Forward-looking best practices for Next.js 16 (Canary/Future). Focuses on deeper React Server Components (RSC) integration and Edge-first patterns.
---

# Next.js 16 (Future-ready) Best Practices

## RSC-first Architecture
- **Server Actions Everywhere**: Shift all mutation logic to Server Actions.
- **Partial Prerendering (PPR)**: Maximize the use of static shells with dynamic holes for sub-second LCP.

## Edge & Middleware
- **Localized Compute**: Prefer Edge runtime for global latency reduction.
- **Wasm modules**: Use Wasm for performance-critical logic in the browser or at the edge.
