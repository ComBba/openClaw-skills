---
name: go-latest
description: Best practices for Go 1.25+. Focuses on high-performance JSON processing, structured logging, and modern concurrency patterns.
---

# Go Latest (1.25+)

## 🚨 Security Update (2026-02-13)
- **Go 1.26.0** released (2026-02-10).
- Recent minors include **Go 1.25.7** (2026-02-04) with security fixes.

**Update immediately:**
- Homebrew: `brew upgrade go`
- Pin toolchain: `go install golang.org/dl/go1.26.0@latest` (or `go1.26.0 download`)

## 🆕 Go 1.25 Highlights
- **Container-aware GOMAXPROCS**: Automatic cgroup CPU limit detection
- **Green Tea GC**: `GOEXPERIMENT=greenteagc` for 10-40% GC overhead reduction
- **encoding/json/v2**: 2-3x faster JSON decoding (experimental)
- **Trace Flight Recorder**: Lightweight runtime trace capture

## Key Features & Best Practices

### 1. JSON Processing (json/v2)
Go 1.25 introduces `encoding/json/v2`. It's significantly faster and more flexible.
- **Use v2 for new projects**: `import "encoding/json/v2"`
- **Strict Mode**: Use `json.UnmarshalStrict` to catch unknown fields.
- **Omitzero**: Use the `omitzero` struct tag instead of `omitempty` for better control over zero values.

### 2. Structured Logging (slog)
- Prefer `log/slog` over third-party loggers like Zap or Logrus unless specific features are needed.
- Use `slog.Group` to nest related attributes.

### 3. Concurrency
- **Context**: Always propagate `context.Context`.
- **Generics**: Use generics for reusable data structures, but avoid over-engineering.

### 4. Memory Management
- **Green Tea GC**: In Go 1.25, the new GC can be tuned for low-latency workloads.
- **Zero-copy**: Use `unsafe.String` and `unsafe.Slice` for zero-copy conversions when performance is critical (and you know the memory lifecycle).

## Performance Checklist
- [ ] Are you using `json/v2`?
- [ ] Is `GOMAXPROCS` container-aware?
- [ ] Are you using `sync.Pool` for hot objects?
