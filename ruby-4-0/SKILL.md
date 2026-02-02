---
name: ruby-4-0
description: Best practices for Ruby 4.0.1+. Focuses on YJIT performance, Ractor 2.0 for true parallelism, and native type-checking integrations.
---

# Ruby 4.0.1+ Best Practices

## Performance (YJIT)
- **YJIT by default**: Ruby 4+ is optimized for YJIT. Ensure it's enabled in production for 20-40% speed boost.
- **Memory Management**: Use the new variable-width allocation for reduced memory fragmentation.

## Concurrency (Ractor 2.0)
- **True Parallelism**: Use Ractors for CPU-intensive tasks. Ractor 2.0 has significantly reduced overhead for sharing immutable objects.
- **Async Frameworks**: Combine with Falcon or Iodine for high-concurrency web apps.

## Syntax & Features
- **Pattern Matching**: Extensively use `in` and `case` for complex data structures.
- **Strict Typing**: Use RBS or Sorbet for type safety, as Ruby 4+ has deeper native hooks for type-aware optimizations.

## Constraints
- Avoid legacy thread-unsafe gems.
- Prefer immutable data structures to simplify Ractor communication.
