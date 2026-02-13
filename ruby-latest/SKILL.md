---
name: ruby-latest
description: Ruby 3.2+ / 4.0+ best practices and upgrade guidance. Focuses on security patching, performance (YJIT/ZJIT), and modern Bundler/Rails hygiene.
---

# Ruby Latest (3.2+ / 4.0+)

## 🚨 Recent Releases (security/bugfix hygiene)
- **Ruby 4.0.1** (2026-01-13)
  - Notes mention: bugfix for spurious wakeup from `Kernel#sleep` when a subprocess exits in another thread (plus other fixes).
  - Source: https://www.ruby-lang.org/en/news/2026/01/13/ruby-4-0-1-released/
- **Ruby 3.2.10** (2026-01-14)
  - Source: https://www.ruby-lang.org/en/news/2026/01/14/ruby-3-2-10-released/

**Practical rule:** even when a release is “bugfix”, treat it as **upgrade-soon** if you operate servers or CI runners (supply chain + CVE cadence).

## ✅ Upgrade Playbook (safe defaults)
1. **Pin Ruby** (per-project):
   - `.ruby-version` (rbenv/asdf/chruby all respect it)
2. **Pin Bundler** (avoid “works on my machine”):
   - `BUNDLED WITH` section in `Gemfile.lock`
3. **Automate dependency CVE checks**:
   - `bundler-audit` (CI): fail builds on known vulnerable gems
   - `dependabot` / `renovate` for routine gem bumps
4. **Lock down native deps**:
   - keep `openssl`, `libyaml`, `zlib` patched (esp. if building Ruby yourself)

## ⚡ Performance Notes (quick wins)
- **YJIT/ZJIT**: for Ruby 3.2+ / 4.0+, enable JIT in production *only after* verifying:
  - memory headroom (JIT increases RSS)
  - p95 latency impact
  - boot-time constraints
- **Boot time**: use `bootsnap` (Rails) + reduce autoload churn.

## 🧼 Bundler/Rails Hygiene Checklist
- [ ] `bundle config set --local path vendor/bundle` only for CI/build images (avoid dev machine pollution)
- [ ] `bundle lock --add-platform` for your deploy platforms (linux/arm64, etc.)
- [ ] `RUBYOPT=--yjit` (or `--zjit` when applicable) guarded by env toggle
- [ ] `RAILS_ENV=production` precompile assets in a clean build stage

## 🧯 Incident Response (when a Ruby CVE drops)
- Patch Ruby **and** gems: Ruby patch alone rarely closes the full surface.
- Ship an emergency bump PR + deploy, then follow up with a “cleanup” PR (lockfile churn, perf re-baseline).
