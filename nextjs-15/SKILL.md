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
- **React2Shell RCE (CVE-2025-55182 / Next.js tracking CVE-2025-66478)**: affects **App Router** on certain Next.js 15/16 lines. Upgrade immediately to a patched Next.js version for your line.
- **RSC DoS + source exposure (CVE-2025-55184 / CVE-2025-55183; complete DoS fix: CVE-2025-67779)**: affects **App Router endpoints**; upgrade to the latest patched versions (some initial fixes were incomplete).
- **After patching**: rotate secrets if your app was exposed while unpatched; ensure secrets are not inlined into server function code (use runtime env vars).

References:
- https://nextjs.org/blog/CVE-2025-66478
- https://nextjs.org/blog/security-update-2025-12-11
- https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components
