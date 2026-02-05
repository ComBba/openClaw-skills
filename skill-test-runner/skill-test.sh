#!/bin/bash

SKILL_PATH=$1
if [ -z "$SKILL_PATH" ]; then
    echo "Usage: $0 <skill-path>"
    exit 1
fi

# Normalize path
SKILL_PATH=$(realpath "$SKILL_PATH")
SKILL_NAME=$(basename "$SKILL_PATH")

passed_count=0
total_count=0
checks_json="[]"

add_check() {
    local name=$1
    local status=$2
    local message=$3
    total_count=$((total_count + 1))
    if [ "$status" == "pass" ]; then
        passed_count=$((passed_count + 1))
    fi
    
    # Escape special characters for JSON
    local escaped_message=$(echo "$message" | sed 's/"/\\"/g' | tr -d '\n')
    
    local check="{\"name\": \"$name\", \"status\": \"$status\", \"message\": \"$escaped_message\"}"
    if [ "$checks_json" == "[]" ]; then
        checks_json="[$check]"
    else
        checks_json="${checks_json%?}, $check]"
    fi
}

# 1. SKILL.md Check
SKILL_MD="$SKILL_PATH/SKILL.md"
if [ -f "$SKILL_MD" ]; then
    add_check "SKILL.md exists" "pass" "SKILL.md found"
    
    # Check sections (name, description, location, usage)
    # Mapping to Korean terms as well
    missing=""
    grep -qiE "(# |## )" "$SKILL_MD" || missing="Structure"
    grep -qiE "(name|이름|제공자)" "$SKILL_MD" || missing="$missing name"
    grep -qiE "(description|설명|개요)" "$SKILL_MD" || missing="$missing description"
    grep -qiE "(location|위치|경로)" "$SKILL_MD" || missing="$missing location"
    grep -qiE "(usage|사용법|빠른 시작)" "$SKILL_MD" || missing="$missing usage"
    
    if [ -z "$missing" ]; then
        add_check "SKILL.md content" "pass" "All required sections found"
    else
        add_check "SKILL.md content" "fail" "Missing or incomplete sections:$missing"
    fi
else
    add_check "SKILL.md exists" "fail" "SKILL.md not found"
fi

# 2. Script Validation
scripts=$(find "$SKILL_PATH" -maxdepth 2 \( -name "*.sh" -o -name "*.py" \))
if [ -n "$scripts" ]; then
    for script in $scripts; do
        sname=$(basename "$script")
        # Syntax check
        if [[ "$script" == *.sh ]]; then
            if bash -n "$script" 2>/dev/null; then
                add_check "Syntax: $sname" "pass" "Bash syntax OK"
            else
                add_check "Syntax: $sname" "fail" "Bash syntax error"
            fi
        elif [[ "$script" == *.py ]]; then
            if python3 -m py_compile "$script" 2>/dev/null; then
                add_check "Syntax: $sname" "pass" "Python syntax OK"
            else
                add_check "Syntax: $sname" "fail" "Python syntax error"
            fi
        fi
        
        # Exec permission
        if [ -x "$script" ]; then
            add_check "Permission: $sname" "pass" "Executable"
        else
            add_check "Permission: $sname" "fail" "Not executable"
        fi
    done
else
    # It's okay not to have scripts if it's just a doc skill, but usually skills have scripts.
    # We won't fail here, just no checks added.
    :
fi

# 3. Example Code Validation
if [ -f "$SKILL_MD" ]; then
    # Simple check for API keys and dry-run
    if grep -qiE "(API_KEY|token|secret)" "$SKILL_MD"; then
        if grep -qi "dry-run" "$SKILL_MD"; then
            add_check "API safety" "pass" "Dry-run documented"
        else
            add_check "API safety" "fail" "API key mentioned without dry-run instruction"
        fi
    fi
    
    # Code block count
    code_blocks=$(grep -c "^ \` \` \` " "$SKILL_MD" | tr -d ' ' || echo 0)
    # Note: the above grep is tricky due to backticks.
    code_blocks=$(grep -c '```' "$SKILL_MD")
    if [ "$code_blocks" -gt 0 ]; then
        add_check "Code blocks" "pass" "Found $code_blocks code segments"
    else
        add_check "Code blocks" "fail" "No code blocks found in SKILL.md"
    fi
fi

# 4. Final Output
passed="false"
if [ "$passed_count" -eq "$total_count" ] && [ "$total_count" -gt 0 ]; then
    passed="true"
fi

cat <<EOF
{
  "skill": "$SKILL_NAME",
  "passed": $passed,
  "checks": $checks_json,
  "summary": "$passed_count/$total_count checks passed"
}
EOF
