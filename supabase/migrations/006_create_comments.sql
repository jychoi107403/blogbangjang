-- =============================================
-- 006_create_comments.sql
-- 댓글 테이블 생성
-- 비회원도 닉네임/비밀번호로 댓글 작성 가능
-- 비밀번호는 해시화하여 저장 (보안)
-- 대댓글 기능 지원 (parent_id)
-- =============================================

CREATE TABLE IF NOT EXISTS comments (
  -- 고유 ID: UUID 자동 생성
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 댓글이 달린 게시글 ID (외래키: posts 테이블 참조)
  -- 게시글 삭제 시 댓글도 함께 삭제 (CASCADE)
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  
  -- 부모 댓글 ID (대댓글인 경우에만 값이 있음)
  -- NULL이면 최상위 댓글, UUID이면 해당 댓글의 답글
  -- 부모 댓글 삭제 시 대댓글도 함께 삭제 (CASCADE)
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  
  -- 작성자 닉네임 (비회원도 입력 가능)
  nickname TEXT NOT NULL,
  
  -- 비밀번호 해시 (댓글 수정/삭제 시 검증용)
  -- 평문 비밀번호를 절대 저장하지 않고 해시값만 저장합니다 (보안)
  password_hash TEXT NOT NULL,
  
  -- 댓글 본문
  content TEXT NOT NULL,
  
  -- 비밀 댓글 여부 (true면 작성자와 블로그 주인만 볼 수 있음)
  is_secret BOOLEAN NOT NULL DEFAULT FALSE,
  
  -- 삭제 여부 (소프트 삭제: 실제로 지우지 않고 삭제 표시만 함)
  -- 대댓글이 있는 댓글을 삭제할 때 "삭제된 댓글입니다"로 표시하기 위해 사용
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  
  -- 생성 시각 (자동 기록)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 특정 게시글의 댓글 목록 조회 인덱스
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON comments(post_id);

-- 대댓글 조회 인덱스 (parent_id로 자식 댓글 조회 시 최적화)
CREATE INDEX IF NOT EXISTS idx_comments_parent_id ON comments(parent_id);

-- 최신 댓글 순서로 정렬 인덱스
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON comments(created_at DESC);

COMMENT ON TABLE comments IS '게시글 댓글 (비회원 닉네임/비밀번호 방식, 대댓글 지원)';
COMMENT ON COLUMN comments.parent_id IS '부모 댓글 ID (NULL이면 최상위 댓글, 값이 있으면 대댓글)';
COMMENT ON COLUMN comments.password_hash IS '삭제/수정 검증용 비밀번호 해시 (bcrypt)';
COMMENT ON COLUMN comments.is_secret IS 'true이면 작성자와 블로그 주인만 내용 확인 가능';
COMMENT ON COLUMN comments.is_deleted IS 'true이면 삭제된 댓글 (소프트 삭제 - 대댓글이 있는 경우 보존)';
