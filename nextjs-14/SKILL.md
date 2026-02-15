---
name: nextjs-14
description: Best practices for Next.js 14 (stable). Includes App Router guidance and critical RSC security patch levels (React2Shell follow-ups).
---

# Next.js 14 Best Practices (Stable)

## App Router / RSC fundamentals
- Prefer **Server Components by default**, use Client Components only when you need interactivity.
- Keep **secrets out of compiled code** (no hardcoded tokens inside Server Actions). Use runtime env vars.
- Treat every **App Router endpoint** as potentially attacker-reachable.

## Caching & Data Fetching
- Be explicit about caching semantics (`fetch` cache options, `revalidate`, route segment config).
- For mutations, prefer **Server Actions** + `revalidatePath`/`revalidateTag` to keep cache coherent.

## Security (App Router / RSC)
React Server Components protocol vulnerabilities impacted multiple Next.js lines.

### RSC DoS + source exposure (follow-up advisories)
- **DoS**: CVE-2025-55184 (initial fix was incomplete; complete fix tracked as **CVE-2025-67779**)
- **Source code exposure**: CVE-2025-55183
- **Additional DoS (Jan 26, 2026)**: **CVE-2026-23864** (React RSC protocol)
- Affected: **Next.js >= 13.3** (App Router/RSC)
- **Patched version for Next.js 14.x**: upgrade to **14.2.35**

```bash
npm install next@14.2.35
```

### React2Shell (RCE) context
- The original **RCE** (React2Shell) primarily affected Next.js **15.x/16.x** and certain **14.3+ canary** releases.
- If you were using **14.3+ canary**, downgrade to stable 14.x (and patch to 14.2.35).

References:
- https://nextjs.org/blog/security-update-2025-12-11
- https://nextjs.org/blog/CVE-2025-66478
- https://react.dev/blog/2025/12/11/denial-of-service-and-source-code-exposure-in-react-server-components
- https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components (updated Jan 26, 2026)

## Security watchlist (ecosystem)
- **MDX rendering (next-mdx-remote, etc.)**: treat *untrusted* MDX as code. Prefer disabling JS/expressions unless you fully trust the content source, and sandbox/serialize carefully.
  - Note: there are reports (Feb 2026) of SSR arbitrary code execution risk when evaluating unsanitized MDX/expressions. Please verify against the package’s **GitHub Security Advisories / npm advisories** before upgrading/pinning.
