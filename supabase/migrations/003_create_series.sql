-- =============================================
-- 003_create_series.sql
-- 시리즈 테이블 생성
-- 여러 글을 묶어서 시리즈로 구성할 때 사용합니다
-- 예: "Next.js 기초부터 배우기" 시리즈에 10개의 글 묶기
-- =============================================

CREATE TABLE IF NOT EXISTS series (
  -- 고유 ID: UUID 자동 생성
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 시리즈 제목 (예: "Next.js 기초부터 배우기")
  title TEXT NOT NULL,
  
  -- 시리즈 설명
  description TEXT NOT NULL DEFAULT '',
  
  -- URL 슬러그 (예: "nextjs-basics")
  slug TEXT NOT NULL UNIQUE,
  
  -- 생성 시각 (자동 기록)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 슬러그 검색 속도를 위한 인덱스
CREATE INDEX IF NOT EXISTS idx_series_slug ON series(slug);

COMMENT ON TABLE series IS '블로그 게시글 시리즈 (여러 글을 하나로 묶음)';
COMMENT ON COLUMN series.slug IS 'URL에 사용되는 고유 식별자 (영문 소문자)';
