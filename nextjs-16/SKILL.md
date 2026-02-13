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

## Security (App Router / RSC)
- Next.js 16 is typically **App Router + RSC-heavy**, so track RSC protocol advisories closely.
- Key advisories in the React/Next.js RSC protocol ecosystem:
  - **CVE-2025-55182 (React2Shell, RCE)** / **CVE-2025-66478 (Next.js advisory tracking)**
  - **CVE-2025-55184 (DoS)** + **CVE-2025-55183 (source code exposure)**; complete DoS fix issued as **CVE-2025-67779**
- **Operational guidance**: patch quickly, rotate secrets if potentially exposed, and keep secrets out of compiled server functions (use runtime env vars).

References:
- https://nextjs.org/blog/CVE-2025-66478
- https://nextjs.org/blog/security-update-2025-12-11
- https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components
