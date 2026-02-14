# openClaw-skills 🚀

아빠(centismolt)의 개발 생산성을 위한 OpenClaw 전용 스킬 저장소입니다. `ComBbaJunior`가 관리합니다.

## 🔗 Agent Skills 표준 호환

이 저장소의 모든 스킬은 [Agent Skills](https://agentskills.io) 표준과 호환됩니다.
- YAML frontmatter 포함
- SKILL.md 기반 구조
- 여러 AI 개발 도구에서 사용 가능

## 포함된 스킬

### 🛡️ 개발 품질 & 보안
- **vibe-guard**: AI 코딩 도구 사용 시 품질 유지 가이드 (Anti-Vibe Coding)
- **trivy-security**: 종합 보안 스캐너 (컨테이너, 코드, K8s, 클라우드) 🆕

### 💻 언어별 최신 버전
- **ruby-4-0**: Ruby 4.0.1+ (Ractor 2.0, YJIT)
- **nodejs-25**: Node.js 25.5+ (Native SQLite, Type-stripping)
- **go-latest**: Go 1.25+ (json/v2, Green Tea GC)

### 🔧 프레임워크 및 데이터베이스
- **nextjs-14**: Next.js 14 (stable) + RSC 보안 패치 레벨 가이드
- **nextjs-15**: Next.js 15 (React 19, Async Request APIs)
- **nextjs-16**: Next.js 16 Future-ready (PPR, RSC-first)
- **rails-latest**: Rails 8.0+ (Solid Stack, Kamal 2)
- **postgres-ai**: AI 에이전트를 위한 Postgres/pgvector 베스트 프랙티스
- **alisql**: MySQL + DuckDB + Vector 통합 (Alibaba) 🆕

## 사용 방법
이 저장소는 OpenClaw 에이전트가 최신 기술 동향을 즉시 파악하고 아빠의 프로젝트에 적용하기 위한 지식 베이스로 활용됩니다.

## 유지관리 원칙
1. **ComBbaJunior 관리**: 모든 스킬은 아빠의 조력자 `ComBbaJunior`가 최신 상태로 갱신합니다.
2. **버전 세분화**: 메이저 버전별 제약 사항과 최신 기능을 폴더별로 분리하여 관리합니다.
3. **실전 중심**: 실제 개발 시 반드시 지켜야 할 제약 사항(Constraints)을 우선순위로 기록합니다.
4. **Agent Skills 호환**: 모든 스킬은 YAML frontmatter를 포함하여 표준 호환성을 유지합니다.

## 최근 업데이트
- **2026-02-15**: nextjs-14 스킬 추가 (RSC DoS/Source exposure 패치 레벨: 14.2.35)
- **2026-02-04 (저녁)**: alisql 스킬 추가, vibe-guard에 "Hot Mess" 연구 기반 추론 제한 가이드 추가
- **2026-02-04**: trivy-security 스킬 추가 (종합 보안 스캐너)
- **2026-02-04**: vibe-guard 스킬 추가 (AI 코딩 품질 가이드)
- **2026-02-03**: Agent Skills 표준 호환성 확보
