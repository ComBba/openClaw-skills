---
name: nextjs-latest
description: Best practices for Next.js 15+ and React 19. Focuses on async request APIs, new caching defaults, and Turbopack.
---

# Next.js Latest (15.0+)

## Async Request APIs (Breaking Changes)
In Next.js 15, certain APIs that were previously synchronous are now asynchronous.
- **Await Params**: `params` and `searchParams` in `Page` and `Layout` must be awaited.
- **Await Headers/Cookies**: `headers()` and `cookies()` must be awaited.

## Caching Defaults
- **GET Routes**: No longer cached by default. Use `export const dynamic = 'force-static'` if caching is needed.
- **Client Router Cache**: Default cache time for `push/replace` is now 0 for page components.

## React 19 Integration
- **Actions**: Use `useActionState` and `useFormStatus` for form handling.
- **Simplified Ref**: No more `forwardRef`; just pass `ref` as a prop.
- **Document Metadata**: Place `<title>`, `<meta>`, and `<link>` directly in components.

## Development & Build
- **Turbopack**: Use `next dev --turbo` for faster startup and HMR.
- **Self-hosting**: Use the `standalone` output mode for Docker deployments.

## Critical Patterns
- Use **Server Components** by default.
- Use **Server Actions** for mutations.
- Use **Loading.tsx** and **Suspense** for granular loading states.
