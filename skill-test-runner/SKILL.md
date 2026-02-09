# Skill Test Runner

`openclaw skill test ./skill-name` 명령을 통해 스킬의 유효성을 검사하는 자동화 도구입니다.

## 📋 개요

| 항목 | 내용 |
|:---|:---|
| **이름** | skill-test-runner |
| **설명** | OpenClaw 스킬 로컬 검증 도구 |
| **위치** | `~/.openclaw/workspace/openClaw-skills/skill-test-runner/` |
| **사용법** | `openclaw skill test ./skill-name` |

## 🚀 사용법

### 스킬 검사 실행
```bash
openclaw skill test ./my-awesome-skill
```

### 개별 파일 검사
```bash
./skill-test.sh ./my-awesome-skill
```

## 🎯 검사항목

### 1. SKILL.md 검증
- 필수 섹션 존재 여부 (name, description, location, usage 등)
- Markdown 문법 유효성

### 2. 스크립트 검증
- Bash 스크립트 (`*.sh`): `bash -n` 문법 체크
- Python 스크립트 (`*.py`): `py_compile` 문법 체크
- 실행 권한 확인

### 3. 예제 코드 검증
- SKILL.md 내의 코드 블록 구문 검사
- API 키 필요 시 dry-run 모드 안내

## 📊 출력 포맷

결과는 JSON 형태로 출력됩니다:
```json
{
  "skill": "skill-name",
  "passed": true,
  "checks": [
    {"name": "SKILL.md exists", "status": "pass", "message": "SKILL.md found"}
  ],
  "summary": "5/5 checks passed"
}
```

---
**스킬 버전:** 1.0.0
**최종 업데이트:** 2026-02-05
**작성자:** OpenClaw Assistant
