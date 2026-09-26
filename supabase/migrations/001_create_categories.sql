-- =============================================
-- 001_create_categories.sql
-- 카테고리 테이블 생성
-- 블로그 글을 분류하는 카테고리 정보를 저장합니다
-- =============================================

CREATE TABLE IF NOT EXISTS categories (
  -- 고유 ID: UUID 자동 생성
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 카테고리 이름 (예: "개발", "일상", "여행")
  name TEXT NOT NULL,
  
  -- URL 슬러그 (예: "dev", "daily", "travel")
  -- URL에 사용되므로 영문 소문자, 숫자, 하이픈만 허용
  slug TEXT NOT NULL UNIQUE,
  
  -- 카테고리 색상 (예: "#FF5733")
  -- 카테고리 뱃지 색상으로 사용됨
  color TEXT NOT NULL DEFAULT '#6366f1',
  
  -- 생성 시각 (자동 기록)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 슬러그 검색 속도를 위한 인덱스
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);

-- Supabase 대시보드에서 테이블 설명 확인용 코멘트
COMMENT ON TABLE categories IS '블로그 게시글 카테고리';
COMMENT ON COLUMN categories.slug IS 'URL에 사용되는 고유 식별자 (영문 소문자)';
COMMENT ON COLUMN categories.color IS '카테고리 뱃지 색상 (HEX 코드)';
