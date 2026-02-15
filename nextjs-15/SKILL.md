---
name: nextjs-15
description: Best practices for Next.js 15. Focuses on Async Request APIs, React 19, and the new caching defaults.
---

# Next.js 15 Best Practices

## Breaking Changes & Async APIs
- **Params/SearchParams**: Must be awaited in Pages and Layouts.
- **Headers/Cookies**: Must be awaited.

## React 19 Integration
- **useActionState**: The new standard for handling form state and server actions.
- **Ref as Prop**: Directly pass `ref` without `forwardRef`.

## Caching
- **Default to Uncached**: GET handlers are no longer cached by default. Use `force-static` if needed.

## Security (App Router / RSC)
- **React2Shell RCE (CVE-2025-55182 / Next.js tracking CVE-2025-66478)**: affects **App Router** on Next.js **15.x/16.x** and some canary lines. Upgrade immediately.
  - Fixed versions (initial advisory window): **15.0.5 / 15.1.9 / 15.2.6 / 15.3.6 / 15.4.8 / 15.5.7** (and canary **15.6.0-canary.58**)
  - If you were online unpatched around the initial disclosure window: **rotate secrets** after patch + redeploy.
- **RSC DoS + source exposure**: **CVE-2025-55184 / CVE-2025-55183** (complete DoS fix tracked as **CVE-2025-67779**)
  - Fixed versions (Next.js advisory 2025-12-11): **15.0.7 / 15.1.11 / 15.2.8 / 15.3.8 / 15.4.10 / 15.5.9**
- **Additional DoS (Jan 26, 2026)**: **CVE-2026-23864** (React RSC protocol)
  - Updated minimum patched versions (React blog update): **15.0.8 / 15.1.12 / 15.2.9 / 15.3.9 / 15.4.11 / 15.5.10**
- **Operational shortcuts**:
  - Use `npx fix-react2shell-next` for deterministic bumps.
  - Keep secrets out of compiled Server Functions (prefer runtime env vars).

References:
- https://nextjs.org/blog/CVE-2025-66478
- https://nextjs.org/blog/security-update-2025-12-11
- https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components (updated Jan 26, 2026)
