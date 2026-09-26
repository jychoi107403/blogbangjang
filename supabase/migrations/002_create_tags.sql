-- =============================================
-- 002_create_tags.sql
-- 태그 테이블 생성
-- 게시글에 달 수 있는 태그 정보를 저장합니다
-- 카테고리와 달리 하나의 글에 여러 태그 가능
-- =============================================

CREATE TABLE IF NOT EXISTS tags (
  -- 고유 ID: UUID 자동 생성
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 태그 이름 (예: "Next.js", "React", "TypeScript")
  name TEXT NOT NULL,
  
  -- URL 슬러그 (예: "nextjs", "react", "typescript")
  slug TEXT NOT NULL UNIQUE,
  
  -- 생성 시각 (자동 기록)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 슬러그 검색 속도를 위한 인덱스
CREATE INDEX IF NOT EXISTS idx_tags_slug ON tags(slug);

-- 태그 이름 검색 속도를 위한 인덱스 (검색 기능 지원)
CREATE INDEX IF NOT EXISTS idx_tags_name ON tags(name);

COMMENT ON TABLE tags IS '블로그 게시글 태그';
COMMENT ON COLUMN tags.slug IS 'URL에 사용되는 고유 식별자 (영문 소문자)';
