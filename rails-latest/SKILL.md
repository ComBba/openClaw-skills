---
name: rails-latest
description: Best practices for Rails 8+. Focuses on "No-Paas" deployment with Kamal, and the "Solid" adapter ecosystem to reduce infrastructure complexity.
---

# Rails Latest (8.0+)

## The "Solid" Stack
Rails 8 moves away from Redis as a hard requirement for many features.
- **Solid Cache**: Use for low-latency database-backed caching.
- **Solid Queue**: Database-backed job queue. Replace Sidekiq for small to medium workloads.
- **Solid Cable**: Database-backed Action Cable.

## Deployment with Kamal 2
- Use **Kamal 2** for zero-downtime deployments to any cloud/VPS.
- Leverage **Kamal Proxy** (replaces Traefik) for easier configuration.

## Modern Frontend
- **PWA by default**: Rails 8 generates PWA manifest and service worker files.
- **Turbo & Stimulus**: Stick to Hotwire for most CRUD operations.
- **Propshaft**: Use the new asset pipeline for simplicity.

## Development Constraints
- Use `bin/dev` to run the development server.
- Ensure `rubocop-rails` is enabled for best practice enforcement.
- **Thruster**: Use the Thruster proxy in production for HTTP/2 and asset compression.
