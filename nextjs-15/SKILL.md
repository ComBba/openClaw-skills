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
