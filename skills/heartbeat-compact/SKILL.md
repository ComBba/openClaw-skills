# heartbeat-compact

HEARTBEAT.md 자동 요약 및 아카이브 스킬

## Description

HEARTBEAT.md 파일이 과도하게 커지는 것을 방지하기 위해 자동으로 요약하고 과거 내역을 아카이브합니다.

**문제 해결:**
- HEARTBEAT.md가 1,900줄 이상으로 과부하 → 컨텍스트 낭비
- 매시간 50-100줄씩 추가되어 파일 비대화
- 과거 완료 내역이 현재 작업 추적을 방해

**기대 효과:**
- 빠른 현황 파악 (200줄 이하 유지)
- 컨텍스트 절약
- 일일 아카이브 자동 생성

## Installation

```bash
# 스킬 디렉토리 확인
ls ~/.openclaw/workspace/skills/heartbeat-compact/

# 스크립트 권한 확인
chmod +x ~/.openclaw/workspace/skills/heartbeat-compact/compact.sh
```

## Usage

### 1. 수동 실행

```bash
# 기본 요약 (300줄 이상일 때만 실행)
~/.openclaw/workspace/scripts/heartbeat-compact-v2.sh

# 또는 스킬 경로로
~/.openclaw/workspace/skills/heartbeat-compact/compact.sh
```

### 2. OpenClaw에서 사용

```javascript
// HEARTBEAT.md 요약 실행
exec({
  command: "~/.openclaw/workspace/skills/heartbeat-compact/compact.sh"
})
```

### 3. 자동화 (크론 설정)

```javascript
// 매일 새벽 2시에 자동 요약
cron({
  action: "add",
  job: {
    name: "heartbeat-compact-daily",
    schedule: { kind: "cron", expr: "0 2 * * *", tz: "Asia/Seoul" },
    payload: { 
      kind: "systemEvent", 
      text: "HEARTBEAT.md 자동 요약 실행: ~/.openclaw/workspace/skills/heartbeat-compact/compact.sh"
    },
    sessionTarget: "main"
  }
})
```

## How It Works

### 요약 규칙

1. **보존 (Keep)**
   - 현재 상태 요약 (📊)
   - 진행 중인 작업 (🏃)
   - PR 대기 상태 (📋)
   - 오늘 완료 내역 (📋 오늘 완료)
   - 현재 블로커 (🚧)
   - 메모/아이디어 (📝)

2. **아카이브 (Archive)**
   - 이전 완료 내역 (어제, 그 이전)
   - 과거 상세 규칙
   - 2주 이상 된 메모

3. **삭제 (Remove)**
   - 중복된 상태 업데이트
   - outdated 블로커 (해결된 것)

### 파일 구조

```
~/.openclaw/workspace/
├── HEARTBEAT.md                    # 요약된 현재 상태 (≤200줄)
└── memory/
    └── archive/
        └── heartbeat/
            ├── 2026-02-09-backup-20260209-1540.md      # 원본 백업
            └── 2026-02-09-archive-20260209-1540.md     # 과거 내역
```

## Options

### 환경 변수

```bash
# 커스텀 워크스페이스 경로
export HEARTBEAT_WORKSPACE="/custom/path"

# 강제 실행 (300줄 미만도 실행)
export HEARTBEAT_FORCE=1

# 아카이브만 생성 (HEARTBEAT.md는 수정하지 않음)
export HEARTBEAT_DRY_RUN=1
```

### 명령행 옵션

```bash
# dry-run 모드 (수정 없이 미리보기)
~/.openclaw/workspace/skills/heartbeat-compact/compact.sh --dry-run

# 상태만 확인
~/.openclaw/workspace/skills/heartbeat-compact/compact.sh --status

# 특정 날짜까지 아카이브
~/.openclaw/workspace/skills/heartbeat-compact/compact.sh --archive-until 2026-02-01
```

## Example Output

```
🧠 HEARTBEAT.md 스마트 요약 시작...
   파일: ~/.openclaw/workspace/HEARTBEAT.md
   시간: 2026-02-09 15:45:30

📊 현재 상태: 1900줄
   백업: ~/.openclaw/workspace/memory/archive/heartbeat/2026-02-09-backup-154030.md

✅ 새 HEARTBEAT.md 작성 완료 (180줄)
📦 아카이브 저장: ~/.openclaw/workspace/memory/archive/heartbeat/2026-02-09-archive-154030.md

✨ 요약 완료!
   📉 1900줄 → 180줄 (90% 감소)

📁 생성된 파일:
   - 백업: ~/.openclaw/workspace/memory/archive/heartbeat/2026-02-09-backup-154030.md
   - 아카이브: ~/.openclaw/workspace/memory/archive/heartbeat/2026-02-09-archive-154030.md
```

## Integration

### GitHub Actions 연동

```yaml
name: HEARTBEAT Compact
on:
  schedule:
    - cron: '0 2 * * *'  # 매일 새벽 2시
  workflow_dispatch:

jobs:
  compact:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run heartbeat-compact
        run: |
          ~/.openclaw/workspace/skills/heartbeat-compact/compact.sh
      - name: Commit changes
        run: |
          git config user.name "github-actions"
          git config user.email "actions@github.com"
          git add HEARTBEAT.md memory/archive/
          git commit -m "📝 HEARTBEAT 자동 요약 (cron)"
          git push
```

## Requirements

- bash 4.0+
- python3 (스마트 파싱용)
- wc, date, mkdir 기본 명령어

## Changelog

### v1.0.0 (2026-02-09)
- 초기 버전 출시
- 스마트 섹션 파싱 (Python)
- 자동 백업 및 아카이브
- 300줄 임계값 자동 감지

## License

MIT
