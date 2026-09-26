-- =============================================
-- 005_create_post_tags.sql
-- 게시글-태그 연결 테이블 생성
-- 하나의 글에 여러 태그를, 하나의 태그를 여러 글에 연결
-- 이런 다대다(M:N) 관계를 "중간 테이블"로 구현합니다
-- =============================================

CREATE TABLE IF NOT EXISTS post_tags (
  -- 게시글 ID (외래키: posts 테이블 참조)
  -- 게시글 삭제 시 연결된 태그 관계도 함께 삭제 (CASCADE)
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  
  -- 태그 ID (외래키: tags 테이블 참조)
  -- 태그 삭제 시 연결된 게시글 관계도 함께 삭제 (CASCADE)
  tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  
  -- 같은 글에 같은 태그가 중복으로 달리지 않도록 복합 기본키 설정
  PRIMARY KEY (post_id, tag_id)
);

-- 태그별로 어떤 글들이 있는지 조회하는 인덱스
-- 예: "React" 태그가 달린 모든 글 목록 조회 시 최적화
CREATE INDEX IF NOT EXISTS idx_post_tags_tag_id ON post_tags(tag_id);

COMMENT ON TABLE post_tags IS '게시글과 태그의 다대다(M:N) 연결 테이블';
COMMENT ON COLUMN post_tags.post_id IS '연결된 게시글의 ID';
COMMENT ON COLUMN post_tags.tag_id IS '연결된 태그의 ID';
