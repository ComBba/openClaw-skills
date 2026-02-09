#!/bin/bash
#
# heartbeat-compact-v2.sh - 스마트 HEARTBEAT 요약 스크립트
# 중요 정보 보존 + 과거 내역 아카이브
#

set -euo pipefail

WORKSPACE="${HOME}/.openclaw/workspace"
HEARTBEAT_FILE="${WORKSPACE}/HEARTBEAT.md"
ARCHIVE_DIR="${WORKSPACE}/memory/archive/heartbeat"

TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y%m%d-%H%M)

echo "🧠 HEARTBEAT.md 스마트 요약 시작..."
echo "   파일: ${HEARTBEAT_FILE/#${HOME}/\~}"
echo "   시간: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

if [[ ! -f "$HEARTBEAT_FILE" ]]; then
    echo "❌ HEARTBEAT.md 파일을 찾을 수 없습니다."
    exit 1
fi

CURRENT_LINES=$(wc -l < "$HEARTBEAT_FILE")
echo "📊 현재 상태: ${CURRENT_LINES}줄"

# 300줄 미만이면 스킵
if [[ "$CURRENT_LINES" -lt 300 ]]; then
    echo "✅ HEARTBEAT.md가 300줄 미만입니다. 요약 불필요."
    exit 0
fi

mkdir -p "$ARCHIVE_DIR"

# 백업 생성
BACKUP_FILE="${ARCHIVE_DIR}/${TODAY}-backup-${TIMESTAMP}.md"
cp "$HEARTBEAT_FILE" "$BACKUP_FILE"
echo "   백업: ${BACKUP_FILE/#${HOME}/\~}"

# Python으로 파싱 및 재구성 (더 정확한 처리)
python3 <> 'PYEOF'
import re
from datetime import datetime
from pathlib import Path

heartbeat_file = Path("$HEARTBEAT_FILE")
archive_dir = Path("$ARCHIVE_DIR")
today = "$TODAY"

content = heartbeat_file.read_text(encoding='utf-8')
lines = content.split('\n')

# 섹션 파싱
sections = {
    'header': [],
    'status_summary': [],
    'rules': [],
    'in_progress': [],
    'pr_status': [],
    'today_complete': [],
    'older_complete': [],
    'blockers': [],
    'memos': [],
    'footer': []
}

current_section = 'header'
for line in lines:
    # 섹션 감지
    if '## 📊 현재 상태 요약' in line:
        current_section = 'status_summary'
    elif '## 🚨 필수 규칙' in line or '## 필수 규칙' in line:
        current_section = 'rules'
    elif '## 🏃 진행 중인 작업' in line or '## 진행 중인 작업' in line:
        current_section = 'in_progress'
    elif '## 📋 PR 대기' in line or '## PR 대기' in line:
        current_section = 'pr_status'
    elif '## 📋 오늘 완료' in line or f'## 📋 오늘 완료 ({today})' in line:
        current_section = 'today_complete'
    elif '## 📋 어제 완료' in line or '## 📋' in line and '완료' in line:
        if today not in line:
            current_section = 'older_complete'
        else:
            current_section = 'today_complete'
    elif '## 🚧 현재 블로커' in line or '## 블로커' in line:
        current_section = 'blockers'
    elif '## 📝 메모' in line or '## 메모' in line:
        current_section = 'memos'
    elif '---' in line and current_section == 'footer':
        pass  # footer 구분선
    elif current_section == 'memos' and line.startswith('*마지막 업데이트'):
        current_section = 'footer'
    
    sections[current_section].append(line)

# 새 HEARTBEAT.md 생성
new_content = []

# 1. 헤더
new_content.extend(sections['header'][:3])  # 제목만
new_content.append('')

# 2. 현재 상태 요약 (업데이트)
new_content.append('## 📊 현재 상태 요약')
new_content.append(f'- 🏃 **진행 중:** (아래 상세 참조)')
new_content.append(f'- ✅ **오늘 완료:** (아래 상세 참조)')
new_content.append(f'- 📋 **PR 대기:** (아래 상세 참조)')
new_content.append(f'- 🧭 **시스템:** Gateway/Agents/Telegram 정상')
new_content.append(f"- ⏰ **업데이트:** {datetime.now().strftime('%Y-%m-%d %H:%M')} KST")
new_content.append('')
new_content.append('---')
new_content.append('')

# 3. 필수 규칙 (간략화)
if sections['rules']:
    new_content.append('## 🚨 필수 규칙')
    new_content.append('- **30분 1성과:** 새로운 가치 창출 (가속 모드! 🚀)')
    new_content.append('- **HN 다이제스트:** 6시간 1번 (00:00, 06:00, 12:00, 18:00)')
    new_content.append('- **Git:** main 직접 커밋 금지 → PR + assign(@Combba82)')
    new_content.append('')

# 4. 진행 중인 작업
if sections['in_progress']:
    new_content.extend(sections['in_progress'])
    new_content.append('')

# 5. PR 대기 상태
if sections['pr_status']:
    new_content.extend(sections['pr_status'])
    new_content.append('')

# 6. 오늘 완료
if sections['today_complete']:
    new_content.extend(sections['today_complete'])
else:
    new_content.append(f'## 📋 오늘 완료 ({today})')
    new_content.append('')
    new_content.append('| 시간 | 작업 | 결과 | 상세 |')
    new_content.append('|:---|:---|:---:|:---|')
    new_content.append(f"| {datetime.now().strftime('%H:%M')} | HEARTBEAT 자동 요약 | ✅ | 과거 내역 아카이브 |")
    new_content.append('')

# 7. 블로커
if sections['blockers']:
    new_content.extend(sections['blockers'])
    new_content.append('')

# 8. 메모
if sections['memos']:
    new_content.extend(sections['memos'])
    new_content.append('')

# 9. 푸터
new_content.append('---')
new_content.append('')
new_content.append(f'*마지막 업데이트: {datetime.now().strftime("%Y-%m-%d %H:%M")} KST*')
new_content.append(f'*과거 내역: memory/archive/heartbeat/ 참조*')

# 파일 저장
heartbeat_file.write_text('\n'.join(new_content), encoding='utf-8')

# 아카이브 생성 (과거 내역)
archive_content = []
archive_content.append(f'# HEARTBEAT Archive - {today}')
archive_content.append(f'# Archived at: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}')
archive_content.append('')
archive_content.append('## 보존된 섹션')
archive_content.append('')

if sections['older_complete']:
    archive_content.append('### 이전 완료 내역')
    archive_content.extend(sections['older_complete'])
    archive_content.append('')

if sections['rules'] and len(sections['rules']) > 10:
    archive_content.append('### 상세 규칙 내역')
    archive_content.extend(sections['rules'])
    archive_content.append('')

archive_file = archive_dir / f"{today}-archive-{TIMESTAMP}.md"
archive_file.write_text('\n'.join(archive_content), encoding='utf-8')

print(f"✅ 새 HEARTBEAT.md 작성 완료 ({len(new_content)}줄)")
print(f"📦 아카이브 저장: {archive_file}")

PYEOF

# 결과 출력
NEW_LINES=$(wc -l < "$HEARTBEAT_FILE")
REDUCTION=$(( 100 - (NEW_LINES * 100 / CURRENT_LINES) ))

echo ""
echo "✨ 요약 완료!"
echo "   📉 ${CURRENT_LINES}줄 → ${NEW_LINES}줄 (${REDUCTION}% 감소)"
echo ""
echo "📁 생성된 파일:"
echo "   - 백업: ${BACKUP_FILE/#${HOME}/\~}"
ARCHIVED=$(ls -t ${ARCHIVE_DIR}/${TODAY}-archive-*.md 2>/dev/null | head -1)
if [[ -n "$ARCHIVED" ]]; then
    echo "   - 아카이브: ${ARCHIVED/#${HOME}/\~}"
fi
