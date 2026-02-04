---
name: claude-code-local-fallback
description: Claude Code 쿼터 소진 시 LM Studio/Ollama로 로컬 모델 폴백 설정.
emoji: 💻
requires:
  - LM Studio 또는 Ollama
---

# Claude Code 로컬 모델 폴백

쿼터 소진 시 로컬 오픈소스 모델로 Claude Code 계속 사용하기.

## 언제 사용하나요?

- Anthropic API 일일/주간 쿼터 소진 시
- 오프라인 환경에서 코딩할 때
- 비용 절감이 필요할 때
- 민감한 코드를 로컬에서만 처리하고 싶을 때

## 쿼터 확인

```bash
# Claude Code에서 현재 사용량 확인
/usage
```

## 추천 오픈소스 모델

| 모델 | 특징 | 권장 상황 |
|:---|:---|:---|
| **GLM-4.7-Flash** | 빠른 속도, Z.AI | 빠른 반복 작업 |
| **Qwen3-Coder-Next** | 높은 품질 | 복잡한 코딩 |
| Quantized 버전 | 작은 용량 | GPU 메모리 부족 시 |

## 방법 1: LM Studio (권장)

가장 쉬운 설정 방법.

### 1. 설치

```bash
# macOS
brew install --cask lm-studio

# 또는 직접 다운로드
# https://lmstudio.ai/download
```

### 2. 모델 다운로드

1. LM Studio 실행
2. 모델 검색 (🔍 버튼)
3. **GLM-4.7-Flash** 또는 **Qwen3-Coder-Next** 다운로드
4. ⚠️ 컨텍스트 25K+ 이상 설정 필수!

### 3. 서버 시작 & Claude Code 연결

```bash
# LM Studio 서버 시작
lms server start --port 1234

# 새 터미널에서 환경변수 설정
export ANTHROPIC_BASE_URL=http://localhost:1234
export ANTHROPIC_AUTH_TOKEN=lmstudio

# Claude Code 시작 (로컬 모델 사용)
claude --model openai/gpt-oss-20b
```

### 4. 모델 확인/전환

```bash
# 현재 사용 중인 모델 확인
/model

# Anthropic API로 복귀 (쿼터 회복 후)
# 새 터미널에서 환경변수 없이 시작
claude
```

## 방법 2: llama.cpp 직접 연결

LM Studio 없이 직접 연결 (고급 사용자용).

### 설치 & 실행

```bash
# llama.cpp 설치
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
make

# 모델 다운로드 (HuggingFace에서)
# 서버 실행
./server -m ./models/your-model.gguf -c 32768 --port 1234

# Claude Code 연결 (방법 1과 동일)
export ANTHROPIC_BASE_URL=http://localhost:1234
export ANTHROPIC_AUTH_TOKEN=llama
claude --model openai/gpt-oss-20b
```

### 참고
- 자세한 가이드: https://unsloth.ai/docs/basics/claude-codex
- 파인튜닝이 필요한 경우에만 권장

## 방법 3: Ollama 연결

Ollama를 이미 사용 중이라면:

```bash
# Ollama 서버 (기본 포트 11434)
ollama serve

# 모델 다운로드
ollama pull qwen2.5-coder:32b

# OpenAI 호환 엔드포인트 사용
export ANTHROPIC_BASE_URL=http://localhost:11434/v1
export ANTHROPIC_AUTH_TOKEN=ollama
claude --model openai/qwen2.5-coder:32b
```

## ⚠️ 주의사항

### 기대치 조정 필요
- **속도 저하**: 로컬 모델은 API보다 느림
- **품질 차이**: 복잡한 작업에서 품질 저하 가능
- **메모리 요구**: 큰 모델은 16GB+ RAM 필요

### 하드웨어 권장 사양
| 모델 크기 | RAM | GPU VRAM |
|:---|:---|:---|
| 7B | 8GB+ | 6GB+ |
| 14B | 16GB+ | 12GB+ |
| 32B+ | 32GB+ | 24GB+ |

### 하이브리드 전략
```
1. 쿼터 확인 (/usage)
2. 80% 이상 → 간단한 작업만 진행
3. 쿼터 소진 → 로컬 모델 전환
4. 복잡한 작업 → 쿼터 회복까지 대기
5. 쿼터 회복 → Anthropic API 복귀
```

## 문제 해결

### 연결 실패
```bash
# 서버 상태 확인
curl http://localhost:1234/v1/models

# 포트 충돌 시 다른 포트 사용
lms server start --port 8080
export ANTHROPIC_BASE_URL=http://localhost:8080
```

### 메모리 부족
```bash
# 더 작은 quantized 모델 사용
# Q4_K_M < Q5_K_M < Q8_0 (품질순, 용량역순)
```

### 응답이 너무 느림
```bash
# GPU 가속 확인
# LM Studio 설정 → GPU Offload 활성화

# 또는 더 작은 모델 선택
```

## 쉘 별칭 설정 (선택)

```bash
# ~/.zshrc 또는 ~/.bashrc에 추가

# 로컬 모델로 Claude Code 시작
alias claude-local='ANTHROPIC_BASE_URL=http://localhost:1234 ANTHROPIC_AUTH_TOKEN=lmstudio claude --model openai/gpt-oss-20b'

# LM Studio 서버 시작
alias lms-start='lms server start --port 1234'

# 쿼터 확인 후 적절한 모드 선택
claude-check() {
  echo "쿼터 확인 후 선택하세요:"
  echo "1. claude (API)"
  echo "2. claude-local (로컬 모델)"
}
```

## 참고 자료

- [LM Studio Claude Code 연동 가이드](https://lmstudio.ai/blog/claudecode)
- [llama.cpp 직접 연결](https://unsloth.ai/docs/basics/claude-codex)
- [GLM-4.7 모델 문서](https://docs.z.ai/guides/llm/glm-4.7)
- [Qwen3-Coder-Next 블로그](https://qwen.ai/blog?id=qwen3-coder-next)
