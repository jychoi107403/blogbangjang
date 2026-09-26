-- =============================================
-- 004_create_posts.sql
-- 게시글 테이블 생성
-- 블로그의 핵심! 모든 글 정보를 저장합니다
-- categories, series 테이블이 먼저 존재해야 합니다 (외래키 참조)
-- =============================================

CREATE TABLE IF NOT EXISTS posts (
  -- 고유 ID: UUID 자동 생성
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 글 제목
  title TEXT NOT NULL,
  
  -- URL 슬러그 (예: /blog/my-first-post)
  -- 언어별로 같은 슬러그 사용 가능하므로 UNIQUE 제약 없음
  -- locale + slug 조합이 유일해야 함
  slug TEXT NOT NULL,
  
  -- 글 본문 (HTML 형태로 저장)
  content TEXT NOT NULL DEFAULT '',
  
  -- 요약문 (목록 페이지에서 미리보기로 표시)
  excerpt TEXT NOT NULL DEFAULT '',
  
  -- 썸네일 이미지 URL (Supabase Storage 경로)
  thumbnail_url TEXT,
  
  -- 카테고리 (외래키: categories 테이블 참조)
  -- 카테고리 삭제 시 이 필드를 NULL로 설정
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  
  -- 시리즈 (외래키: series 테이블 참조)
  -- 시리즈 삭제 시 이 필드를 NULL로 설정
  series_id UUID REFERENCES series(id) ON DELETE SET NULL,
  
  -- 시리즈 내 순서 (1, 2, 3...)
  series_order INT,
  
  -- 발행 상태: 'draft'(임시저장) 또는 'published'(발행됨)
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  
  -- 언어: 'ko'(한국어) 또는 'en'(영어)
  locale TEXT NOT NULL DEFAULT 'ko' CHECK (locale IN ('ko', 'en')),
  
  -- 조회수 (기본값 0, 음수 불가)
  view_count INT NOT NULL DEFAULT 0 CHECK (view_count >= 0),
  
  -- 생성 시각 (자동 기록)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- 수정 시각 (자동 기록)
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- 발행 시각 (NULL이면 미발행)
  published_at TIMESTAMPTZ,
  
  -- locale + slug 조합이 유일해야 함
  -- (같은 한국어 슬러그를 영어 글에도 쓸 수 있음)
  UNIQUE(locale, slug)
);

-- 슬러그 검색 인덱스 (블로그 글 상세 페이지 접근 시 빠른 조회)
CREATE INDEX IF NOT EXISTS idx_posts_slug ON posts(slug);

-- 언어별 슬러그 검색 인덱스
CREATE INDEX IF NOT EXISTS idx_posts_locale_slug ON posts(locale, slug);

-- 발행 상태 + 언어 조합 인덱스 (목록 조회 시 최적화)
CREATE INDEX IF NOT EXISTS idx_posts_status_locale ON posts(status, locale);

-- 카테고리별 조회 인덱스
CREATE INDEX IF NOT EXISTS idx_posts_category_id ON posts(category_id);

-- 시리즈별 조회 인덱스
CREATE INDEX IF NOT EXISTS idx_posts_series_id ON posts(series_id);

-- 생성 시각 기준 정렬 인덱스 (최신 글 순서로 목록 표시 시 최적화)
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);

-- updated_at 자동 업데이트를 위한 트리거 함수 생성
-- 글을 수정할 때마다 updated_at이 자동으로 현재 시각으로 갱신됩니다
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  -- NEW는 업데이트 후의 새로운 레코드를 의미합니다
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- posts 테이블에 트리거 적용
-- posts 테이블의 행이 UPDATE될 때마다 위 함수를 자동 실행
CREATE TRIGGER update_posts_updated_at
  BEFORE UPDATE ON posts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE posts IS '블로그 게시글';
COMMENT ON COLUMN posts.slug IS 'URL에 사용되는 식별자 (locale + slug 조합이 유일)';
COMMENT ON COLUMN posts.content IS '글 본문 (TipTap 에디터에서 생성된 HTML)';
COMMENT ON COLUMN posts.excerpt IS '글 목록 페이지에서 보여줄 미리보기 텍스트';
COMMENT ON COLUMN posts.status IS '발행 상태: draft(임시저장), published(발행됨)';
COMMENT ON COLUMN posts.locale IS '언어 코드: ko(한국어), en(영어)';
COMMENT ON COLUMN posts.view_count IS '글 조회수';
