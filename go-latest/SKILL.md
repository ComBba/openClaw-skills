---
name: go-latest
description: Best practices for Go 1.26+. Focuses on new() expressions, generic self-references, modernizers, and high-performance JSON processing.
---

# Go Latest (1.26+)

## 🆕 Go 1.26.0 Released (2026-02-10)

Go 1.26 brings powerful language improvements and toolchain enhancements.

### Language Features

**1. `new()` with Expressions** 🎯
```go
type Person struct {
    Name string `json:"name"`
    Age  *int   `json:"age"` // optional field
}

// Now expressions are allowed in new()!
json.Marshal(Person{
    Name: name,
    Age:  new(yearsSince(born)),  // ✨ Go 1.26
})
```

**2. Generic Self-Reference** 🧬
```go
// Generic types can now reference themselves in constraints
type Adder[A Adder[A]] interface {
    Add(A) A
}

func algo[A Adder[A]](x, y A) A {
    return x.Add(y)
}
```

### Tools: `go fix` Modernizers 🛠️
Completely revamped `go fix` now automates code modernization:
```bash
go fix ./...  # Applies dozens of modernizers automatically
```

- Source-level inliner for custom API migrations
- Uses `//go:fix inline` directive
- Built on go vet analysis framework

### Previous: Go 1.25 Highlights
- **Container-aware GOMAXPROCS**: Automatic cgroup CPU limit detection
- **Green Tea GC**: `GOEXPERIMENT=greenteagc` for 10-40% GC overhead reduction
- **encoding/json/v2**: 2-3x faster JSON decoding (experimental)
- **Trace Flight Recorder**: Lightweight runtime trace capture

## 🚨 Security Update (2026-02-05)
Go 1.25.7 and Go 1.24.13 released with security patches for go command and toolchain.
**Update recommended:** `brew upgrade go` or `go install golang.org/dl/go1.25.7@latest`

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
