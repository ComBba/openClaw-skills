# Trivy Security Scanning 🛡️

```yaml
name: trivy-security
description: Comprehensive security scanner for containers, code, and cloud
version: 0.60.0
tags: [security, scanning, containers, vulnerabilities, secrets, sbom]
author: ComBbaJunior
```

## Overview

Trivy는 컨테이너, 파일시스템, Git 리포지토리, Kubernetes, 클라우드 환경에서 보안 취약점을 스캔하는 종합 보안 도구입니다.

## 설치

```bash
# macOS (Homebrew)
brew install trivy

# Docker
docker pull aquasec/trivy

# Binary (Linux/macOS)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

## 핵심 스캔 타겟

| 타겟 | 명령어 | 용도 |
|:---|:---|:---|
| Container Image | `trivy image <name>` | Docker/OCI 이미지 취약점 스캔 |
| Filesystem | `trivy fs <path>` | 로컬 프로젝트 스캔 |
| Git Repository | `trivy repo <url>` | 원격 리포 스캔 |
| Kubernetes | `trivy k8s cluster` | K8s 클러스터 스캔 |
| SBOM | `trivy sbom <file>` | Software Bill of Materials 분석 |

## 스캐너 유형

| 스캐너 | 플래그 | 탐지 대상 |
|:---|:---|:---|
| vuln | `--scanners vuln` | CVE 취약점 |
| misconfig | `--scanners misconfig` | IaC 설정 오류 (Terraform, K8s manifests 등) |
| secret | `--scanners secret` | API 키, 비밀번호, 토큰 |
| license | `--scanners license` | 오픈소스 라이선스 |

## 실전 워크플로우

### 1. 프로젝트 종합 스캔

```bash
# 취약점 + 비밀정보 + 설정오류 한번에 스캔
trivy fs --scanners vuln,secret,misconfig ./myproject

# JSON 출력 (CI/CD 연동용)
trivy fs --format json --output results.json ./myproject
```

### 2. Docker 이미지 스캔

```bash
# 빌드 전 이미지 스캔
trivy image python:3.12-slim

# 심각도 필터 (HIGH, CRITICAL만)
trivy image --severity HIGH,CRITICAL myapp:latest

# 무시할 CVE 지정
trivy image --ignore-unfixed --ignorefile .trivyignore myapp:latest
```

### 3. CI/CD 통합 (GitHub Actions)

```yaml
# .github/workflows/security.yml
name: Security Scan
on: [push, pull_request]

jobs:
  trivy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          scanners: 'vuln,secret,misconfig'
          severity: 'HIGH,CRITICAL'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: 'trivy-results.sarif'
```

### 4. Kubernetes 클러스터 스캔

```bash
# 클러스터 전체 요약
trivy k8s --report summary cluster

# 특정 네임스페이스만
trivy k8s -n production --report all cluster

# 워크로드별 상세
trivy k8s --scanners vuln,misconfig deployment/myapp
```

### 5. 비밀정보 탐지 (Secret Scanning)

```bash
# 프로젝트에서 유출된 비밀정보 찾기
trivy fs --scanners secret .

# Git 히스토리 포함 스캔 (원격 리포)
trivy repo --scanners secret https://github.com/user/repo
```

## .trivyignore 파일

특정 CVE나 경로를 무시할 때 사용:

```
# .trivyignore
# CVE 무시
CVE-2021-44228

# 경로 무시
testdata/
vendor/
```

## OpenClaw 연동 예시

```bash
# 프로젝트 스캔 후 보고서 생성
trivy fs --format table --scanners vuln,secret . 2>&1 | head -100

# 심각한 이슈만 추출
trivy fs --format json --scanners vuln,secret . | jq '.Results[] | select(.Vulnerabilities != null) | .Vulnerabilities[] | select(.Severity == "CRITICAL")'
```

## 주요 출력 포맷

| 포맷 | 플래그 | 용도 |
|:---|:---|:---|
| table | `--format table` | 사람이 읽기 편한 기본 출력 |
| json | `--format json` | 프로그래밍 처리용 |
| sarif | `--format sarif` | GitHub Code Scanning 연동 |
| cyclonedx | `--format cyclonedx` | SBOM 표준 출력 |
| template | `--format template` | 커스텀 템플릿 |

## Pro Tips

1. **캐시 활용**: `trivy image --cache-dir ~/.cache/trivy` 로 캐시 지정하면 재스캔 빠름
2. **오프라인 모드**: `trivy image --skip-db-update` 로 DB 업데이트 없이 스캔
3. **파이프라인 실패 조건**: `--exit-code 1` 로 취약점 발견 시 CI 실패 처리
4. **SBOM 먼저 생성**: 대규모 이미지는 SBOM 먼저 생성 후 별도 스캔이 효율적

## 관련 도구 비교

| 도구 | 강점 |
|:---|:---|
| Trivy | 올인원 (컨테이너 + 코드 + K8s + 클라우드) |
| Grype | 빠른 컨테이너 이미지 스캔 |
| Semgrep | 코드 패턴 기반 정적 분석 |
| Gitleaks | Git 히스토리 비밀정보 특화 |

## 참고 자료

- 공식 문서: https://trivy.dev/docs/
- GitHub: https://github.com/aquasecurity/trivy (26k+ ⭐)
- GitHub Action: https://github.com/aquasecurity/trivy-action
- VS Code 확장: https://github.com/aquasecurity/trivy-vscode-extension
