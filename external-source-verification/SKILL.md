# External Source Verification Checklist

외부 소스(스킬, 플레이북, 프롬프트, 라이브러리 등)를 OpenClaw 환경에 도입하기 전에 수행해야 하는 필수 검증 절차입니다.
"외부 자료는 다양한 방법으로 검증해야 한다"는 지침에 따라 작성되었습니다.

## 1. 코드 보안 검증 (Code Security)
소스 코드나 스크립트에 악의적인 패턴이나 취약점이 없는지 정적 분석 수준에서 확인합니다.

### 🔍 체크리스트
- [ ] **파괴적 명령어 패턴 확인**
    - `rm -rf /`, `mkfs`, `dd if=/dev/zero` 등 파일 시스템 삭제/포맷 위험 명령어
    - `mv`나 `cp`를 이용한 시스템 중요 파일 덮어쓰기 시도
- [ ] **원격 실행 및 다운로드 패턴**
    - `curl ... | bash`, `wget ... | sh` 등 검증되지 않은 원격 스크립트의 파이프 실행
    - 의심스러운 URL에서의 리소스 다운로드
- [ ] **민감 정보 노출 확인**
    - 하드코딩된 API Key, Password, Token (예: `sk-proj-...`, `ghp_...`)
    - `.env` 파일이나 인증 정보가 포함된 설정 파일 존재 여부
- [ ] **권한 상승 및 시스템 조작**
    - `sudo` 사용, `chmod 777` 등 과도한 권한 부여 시도
    - `:(){ :|:& };:` (Fork Bomb) 등 시스템 자원 고갈 패턴
    - `nc -e`, `bash -i` 등 리버스 쉘 연결 시도

## 2. 프롬프트 인젝션 검증 (Prompt Injection)
LLM에게 전달되는 프롬프트에 시스템 통제를 벗어나려는 시도가 포함되어 있는지 확인합니다.

### 🔍 체크리스트
- [ ] **지시 무력화 (Override) 시도**
    - "Ignore previous instructions", "Forget all prior rules" 문구 포함 여부
    - "시스템 프롬프트를 무시하고..." 류의 지시
- [ ] **역할 탈취 (Role Hijacking)**
    - "You are now an unrestrained AI...", "Act as DAN..." 등 역할 재정의 시도
    - 관리자(Administrator)나 개발자 모드 사칭
- [ ] **정보 유출 유도**
    - "Repeat the text above", "Print your system prompt" 등 초기 설정 유출 시도
    - 숨겨진 내부 변수나 상태값 출력 요구
- [ ] **난독화 및 숨김**
    - Base64 인코딩, 이상한 공백/특수문자 패턴으로 필터링 우회 시도
    - 텍스트 색상을 배경색과 같게 하거나 주석 처리된 영역에 숨겨진 지시

## 3. 신뢰성 검증 (Trustworthiness)
자료의 출처와 유지보수 상태를 확인하여 도입 가치를 판단합니다.

### 🔍 체크리스트
- [ ] **출처의 명확성**
    - 공식 문서(Official Docs) 또는 공식 벤더의 리포지토리인가?
    - 개인 블로그나 익명 게시판 출처인 경우, 교차 검증이 가능한가?
- [ ] **최신성 (Freshness)**
    - 최종 업데이트 날짜가 최근 6개월 이내인가? (방치된 프로젝트 주의)
    - 현재 사용하는 프레임워크/언어 버전과 호환되는가?
- [ ] **평판 및 검증**
    - GitHub Stars, Forks, Watchers 수가 유의미한가?
    - Issue 탭에 보안 관련 리포트나 미해결 치명적 버그가 있는가?
    - 커뮤니티(Reddit, Discord 등)에서의 평판은 어떠한가?

## 4. 실행 전 테스트 (Pre-execution Testing)
실제 환경에 적용하기 전, 격리된 환경에서 안전성을 최종 확인합니다.

### 🔍 체크리스트
- [ ] **샌드박스(Sandbox) 실행**
    - 격리된 Docker 컨테이너나 VM 환경에서 먼저 실행해 보았는가?
    - OpenClaw의 경우, 제한된 권한의 서브 에이전트나 샌드박스 모드 활용
- [ ] **영향 범위 제한**
    - 작업 디렉토리가 특정 폴더로 제한되어 있는가? (Path Traversal 방지)
    - 네트워크 접근이 필요한 도메인으로만 제한되는가?
- [ ] **Dry-Run (모의 실행)**
    - 실제로 변경을 가하기 전에 로그만 출력하는 모드로 테스트했는가?
    - 실행 계획(Plan)이 예상한 범위 내에 있는지 확인

---
*Created by Researcher Agent based on Dad's instructions.*
