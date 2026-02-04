---
name: alisql
description: AliSQL - MySQL + DuckDB + Vector 통합 데이터베이스 가이드
version: 1.0.0
author: ComBbaJunior
tags: [database, mysql, duckdb, vector, ai, alibaba]
---

# AliSQL 🐬🦆🤖

MySQL 호환성 + DuckDB 분석 + 벡터 검색을 통합한 Alibaba의 오픈소스 데이터베이스입니다.

## 🎯 핵심 기능

### 1. DuckDB 스토리지 엔진
MySQL 인터페이스로 DuckDB 분석 기능 사용:
```sql
-- DuckDB 테이블 생성
CREATE TABLE analytics (
    id INT PRIMARY KEY,
    data JSON
) ENGINE=DUCKDB;

-- MySQL 쿼리로 DuckDB 분석
SELECT * FROM analytics WHERE data->>'$.category' = 'sales';
```

### 2. 벡터 검색 (최대 16,383 차원!)
HNSW 알고리즘 기반 ANN (Approximate Nearest Neighbor) 검색:
```sql
-- 벡터 인덱스 생성
CREATE TABLE embeddings (
    id INT PRIMARY KEY,
    content TEXT,
    embedding VECTOR(1536)  -- OpenAI ada-002 호환
);

CREATE VECTOR INDEX idx_embedding ON embeddings(embedding) 
    USING HNSW WITH (m=16, ef_construction=200);

-- 유사도 검색
SELECT id, content, 
       VECTOR_COSINE_DISTANCE(embedding, [0.1, 0.2, ...]) as distance
FROM embeddings
ORDER BY distance
LIMIT 10;
```

### 3. MySQL 8.0.44 호환
기존 MySQL 지식과 도구 100% 활용 가능:
- MySQL Workbench
- mysqldump
- 기존 ORM (ActiveRecord, GORM, Prisma 등)

---

## 🚀 빠른 시작

### 설치
```bash
# 소스 빌드
git clone https://github.com/alibaba/AliSQL.git
cd AliSQL
sh build.sh -t release -d /usr/local/alisql

# Docker (권장)
docker run -d \
  --name alisql \
  -e MYSQL_ROOT_PASSWORD=<your-strong-password> \
  -p 3306:3306 \
  alibaba/alisql:8.0.44
```

### DuckDB 노드 설정
```bash
# DuckDB 분석 노드 빠른 설정
# 참고: https://github.com/alibaba/AliSQL/wiki/duckdb/how-to-setup-duckdb-node-en.md

# 1. 설정 파일 추가
cat >> /etc/my.cnf << EOF
[mysqld]
duckdb_enabled=ON
duckdb_memory_limit=4G
duckdb_threads=4
EOF

# 2. 재시작
systemctl restart alisql
```

---

## 📊 사용 사례

### 1. AI 앱 - 시맨틱 검색
```sql
-- 문서 임베딩 저장
INSERT INTO documents (title, content, embedding) VALUES
('제품 소개', '우리 제품은...', VECTOR_FROM_JSON('[0.1, 0.2, ...]'));

-- 자연어 검색
SET @query_embedding = GET_EMBEDDING('유사한 제품 찾기');
SELECT title, content
FROM documents
ORDER BY VECTOR_COSINE_DISTANCE(embedding, @query_embedding)
LIMIT 5;
```

### 2. 실시간 분석 + OLTP 혼합
```sql
-- OLTP: 일반 MySQL 테이블
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    total DECIMAL(10,2),
    created_at TIMESTAMP
) ENGINE=InnoDB;

-- OLAP: DuckDB 분석 테이블
CREATE TABLE order_analytics ENGINE=DUCKDB AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as order_count,
    SUM(total) as revenue
FROM orders
GROUP BY DATE(created_at);

-- 실시간 동기화 (CDC)
-- MySQL → DuckDB 자동 복제 설정 가능
```

### 3. RAG (Retrieval-Augmented Generation)
```python
import mysql.connector
import openai
import os
import json

# AliSQL 연결
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password=os.environ.get('DB_PASSWORD'), # 환경 변수에서 비밀번호를 가져오세요.
    database='rag_db'
)

def search_similar(query: str, top_k: int = 5):
    # 쿼리 임베딩 생성
    embedding = openai.embeddings.create(
        model="text-embedding-ada-002",
        input=query
    ).data[0].embedding
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT content, 
               VECTOR_COSINE_DISTANCE(embedding, VECTOR_FROM_JSON(%s)) as distance
        FROM documents
        ORDER BY distance
        LIMIT %s
    """, (json.dumps(embedding), top_k))
    
    return cursor.fetchall()

# RAG 파이프라인
similar_docs = search_similar("OpenClaw 설정 방법")
# 검색 결과를 LLM이 이해하기 쉬운 형태로 가공합니다.
context = "\n".join([f"- {doc[0]}" for doc in similar_docs])
response = openai.chat.completions.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": f"다음 컨텍스트를 참고하여 사용자의 질문에 답변하세요:\n\n{context}"},
        {"role": "user", "content": "OpenClaw 설정 방법 알려줘"}
    ]
)
```

---

## ⚙️ 최적화 팁

### 벡터 인덱스 튜닝
```sql
-- HNSW 파라미터
-- m: 연결 수 (높을수록 정확, 느림) 기본값: 16
-- ef_construction: 인덱스 생성 시 탐색 폭 (높을수록 정확) 기본값: 200
-- ef_search: 검색 시 탐색 폭 기본값: 50

CREATE VECTOR INDEX idx ON embeddings(embedding) USING HNSW 
    WITH (m=32, ef_construction=400);

-- 검색 시 정확도/속도 조절
SET SESSION hnsw_ef_search = 100;  -- 더 정확, 더 느림
```

### DuckDB 메모리 설정
```sql
-- DuckDB 전용 메모리 설정
SET GLOBAL duckdb_memory_limit = '8G';
SET GLOBAL duckdb_threads = 8;

-- 대용량 쿼리 시 임시 디렉토리
SET GLOBAL duckdb_temp_directory = '/ssd/duckdb_temp';
```

---

## 🔗 리소스

- **GitHub**: https://github.com/alibaba/AliSQL
- **DuckDB 가이드**: https://github.com/alibaba/AliSQL/wiki/duckdb
- **벡터 검색 문서**: https://github.com/alibaba/AliSQL/wiki/vidx
- **Alibaba Cloud RDS**: https://help.aliyun.com/rds/

---

## 🆚 대안 비교

| 기능 | AliSQL | PGVector | Milvus |
|:---|:---|:---|:---|
| SQL 호환 | MySQL ✅ | PostgreSQL ✅ | ❌ |
| 분석 통합 | DuckDB ✅ | ❌ | ❌ |
| 벡터 차원 | 16,383 | 2,000 | 32,768 |
| 운영 복잡도 | 낮음 | 중간 | 높음 |
| 기존 MySQL 마이그레이션 | 쉬움 | 어려움 | 불가 |

**추천:**
- MySQL 기반 앱에 AI 기능 추가 → **AliSQL** ✅
- PostgreSQL 기반 → PGVector
- 대규모 벡터 전용 → Milvus

---

**작성자:** ComBbaJunior
**최종 업데이트:** 2026-02-04
**출처:** HN (202 pts), GitHub alibaba/AliSQL
