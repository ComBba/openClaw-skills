---
name: voxtral-transcribe
description: Mistral AI Voxtral로 음성을 텍스트로 변환. 13개 언어 지원, sub-200ms 실시간 처리.
emoji: 🎤
requires:
  - curl 또는 mistral SDK
---

# Voxtral Transcribe - Mistral AI 음성인식 스킬

Mistral AI의 Voxtral Transcribe 2를 활용한 고품질 음성-텍스트 변환.

## 📋 개요

| 항목 | 내용 |
|:---|:---|
| **제공자** | Mistral AI |
| **모델** | Voxtral Mini V2 (배치), Voxtral Realtime (실시간) |
| **가격** | $0.003/min (Mini), $0.006/min (Realtime) |
| **라이선스** | Apache 2.0 (Realtime 오픈웨이트) |
| **지원 언어** | 13개 (한국어 포함) |

## 🌍 지원 언어

English, Chinese, Hindi, Spanish, Arabic, French, Portuguese, Russian, German, Japanese, **Korean**, Italian, Dutch

## 🚀 빠른 시작

### API 키 설정
```bash
export MISTRAL_API_KEY="your-api-key"
```

### Python SDK 설치
```bash
pip install mistralai
```

### 기본 사용
```python
from mistralai import Mistral
import base64

client = Mistral(api_key="your-api-key")

# 파일 업로드
with open("audio.mp3", "rb") as f:
    audio_data = base64.b64encode(f.read()).decode()

# 트랜스크립션
response = client.audio.transcriptions.create(
    model="voxtral-mini-transcribe-v2",
    file_data=audio_data,
    file_name="audio.mp3"
)
print(response.text)
```

## 📊 모델 비교

### Voxtral Mini Transcribe V2 (배치)
- **용도:** 녹음 파일, 비실시간 처리
- **가격:** $0.003/min
- **최대 길이:** 3시간
- **특징:**
  - 최고 정확도 (FLEURS 4% WER)
  - 화자 분리 (Diarization)
  - 단어별 타임스탬프
  - 컨텍스트 바이어싱

### Voxtral Realtime (실시간)
- **용도:** 라이브 스트리밍, 보이스 에이전트
- **가격:** $0.006/min
- **지연:** sub-200ms
- **특징:**
  - 스트리밍 아키텍처
  - 실시간 자막
  - 4B 파라미터 (엣지 배포 가능)
  - Apache 2.0 오픈웨이트

## 🎯 주요 기능

### 1. 화자 분리 (Diarization)
```python
response = client.audio.transcriptions.create(
    model="voxtral-mini-transcribe-v2",
    file_data=audio_data,
    file_name="meeting.mp3",
    diarization=True
)

for segment in response.segments:
    print(f"[Speaker {segment.speaker}] {segment.text}")
```

### 2. 컨텍스트 바이어싱
고유명사, 기술 용어 교정:
```python
response = client.audio.transcriptions.create(
    model="voxtral-mini-transcribe-v2",
    file_data=audio_data,
    file_name="tech-talk.mp3",
    context_bias=["OpenClaw", "Vibelingo", "ComBba", "Mistral AI"]  # 최대 100개
)
```

### 3. 단어별 타임스탬프
```python
response = client.audio.transcriptions.create(
    model="voxtral-mini-transcribe-v2",
    file_data=audio_data,
    file_name="podcast.mp3",
    timestamp_granularity="word"
)

for word in response.words:
    print(f"[{word.start:.2f}-{word.end:.2f}] {word.text}")
```

### 4. 실시간 스트리밍
```python
import asyncio

async def stream_transcription():
    async with client.audio.transcriptions.stream(
        model="voxtral-realtime",
        language="ko"
    ) as stream:
        async for chunk in audio_source:
            await stream.send(chunk)
            result = await stream.receive()
            if result.text:
                print(result.text, end="", flush=True)

asyncio.run(stream_transcription())
```

## 🔧 CLI 사용

### cURL로 직접 호출
```bash
# 파일 트랜스크립션
curl -X POST "https://api.mistral.ai/v1/audio/transcriptions" \
  -H "Authorization: Bearer $MISTRAL_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F "model=voxtral-mini-transcribe-v2" \
  -F "file=@audio.mp3" \
  -F "language=ko"
```

### ffmpeg로 오디오 전처리
```bash
# MP3로 변환 (지원 형식: mp3, wav, m4a, flac, ogg)
ffmpeg -i video.mp4 -vn -acodec libmp3lame -q:a 2 audio.mp3

# 16kHz 모노로 최적화 (실시간용)
ffmpeg -i input.wav -ar 16000 -ac 1 output.wav
```

## 📱 Vibelingo 통합 예시

```typescript
// Vibelingo에서 음성 피드백 분석
import { Mistral } from "@mistralai/mistralai";

const mistral = new Mistral({ apiKey: process.env.MISTRAL_API_KEY });

export async function transcribeUserSpeech(audioBlob: Blob): Promise<{
  text: string;
  words: Array<{ text: string; start: number; end: number }>;
}> {
  const buffer = await audioBlob.arrayBuffer();
  const base64 = Buffer.from(buffer).toString("base64");

  const response = await mistral.audio.transcriptions.create({
    model: "voxtral-mini-transcribe-v2",
    fileData: base64,
    fileName: "speech.wav",
    language: "ko",
    timestampGranularity: "word"
  });

  return {
    text: response.text,
    words: response.words || []
  };
}
```

## 🏠 로컬 배포 (Realtime)

### HuggingFace에서 다운로드
```bash
# 모델 다운로드
pip install huggingface_hub
huggingface-cli download mistralai/Voxtral-Mini-4B-Realtime-2602 --local-dir ./voxtral-realtime
```

### vLLM으로 서빙
```bash
pip install vllm
vllm serve mistralai/Voxtral-Mini-4B-Realtime-2602 --port 8000
```

### Transformers로 직접 사용
```python
from transformers import AutoModelForSpeechSeq2Seq, AutoProcessor
import torch

model = AutoModelForSpeechSeq2Seq.from_pretrained(
    "mistralai/Voxtral-Mini-4B-Realtime-2602",
    torch_dtype=torch.float16,
    device_map="auto"
)
processor = AutoProcessor.from_pretrained("mistralai/Voxtral-Mini-4B-Realtime-2602")

# 추론
inputs = processor(audio_array, sampling_rate=16000, return_tensors="pt")
generated_ids = model.generate(**inputs.to("cuda"))
transcription = processor.batch_decode(generated_ids, skip_special_tokens=True)
```

## 🆚 경쟁 서비스 비교

| 서비스 | 가격 | WER (FLEURS) | 특징 |
|:---|:---|:---|:---|
| **Voxtral Mini V2** | $0.003/min | ~4% | 최고 가성비 |
| GPT-4o mini Transcribe | $0.006/min | ~5% | OpenAI 생태계 |
| Gemini 2.5 Flash | $0.004/min | ~6% | Google 통합 |
| Assembly Universal | $0.006/min | ~5% | 풍부한 기능 |
| Deepgram Nova | $0.004/min | ~5% | 실시간 특화 |
| ElevenLabs Scribe v2 | $0.015/min | ~4% | 고품질, 비쌈 |

## ⚠️ 제한사항

- **컨텍스트 바이어싱:** 영어에 최적화, 다른 언어는 실험적
- **화자 분리:** 겹치는 발화 시 한 화자만 처리
- **최대 파일 크기:** 1GB
- **지원 형식:** mp3, wav, m4a, flac, ogg

## 🔗 참고 자료

- [공식 문서](https://docs.mistral.ai/capabilities/audio_transcription)
- [Mistral Studio 플레이그라운드](https://console.mistral.ai/build/audio/speech-to-text)
- [HuggingFace 모델](https://huggingface.co/mistralai/Voxtral-Mini-4B-Realtime-2602)
- [Le Chat에서 테스트](https://chat.mistral.ai)

---
**스킬 버전:** 1.0.0
**최종 업데이트:** 2026-02-05
**작성자:** ComBbaJunior
