---
name: go-latest
description: Best practices for Go 1.24+. Focuses on high-performance JSON processing, structured logging, and modern concurrency patterns.
---

# Go Latest (1.24+)

## 🆕 Go 1.24 Released! (Feb 11, 2025) 🔥

🎉 **Go 1.24 공식 출시!** (2025년 2월 11일)

### Major Features
- **Generic Type Aliases**: 타입 별칭도 제네릭 파라미터 사용 가능
- **Performance**: CPU 오버헤드 2-3% 감소 (Swiss Tables 기반 새 map)
- **Tool Directives**: `go get -tool`로 도구 의존성 관리
- **testing.B.Loop**: 더 빠르고 안전한 벤치마크
- **FIPS 140-3**: 표준 라이브러리에 준수 메커니즘 추가

### Upgrade
```bash
brew update && brew upgrade go
# 또는
go install golang.org/dl/go1.24@latest && go1.24 download
```

---

## 🚨 Security Update (2026-02-05)
Go 1.25.7 and Go 1.24.13 released with security patches for go command and toolchain.
**Update immediately:** `brew upgrade go` or `go install golang.org/dl/go1.25.7@latest`

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
