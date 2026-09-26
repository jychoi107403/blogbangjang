-- =============================================
-- 008_rls_policies.sql
-- Row Level Security (RLS) 정책 설정
-- 
-- RLS란? 데이터베이스 수준에서 데이터 접근을 제어하는 보안 기능입니다.
-- "어떤 사용자가 어떤 데이터를 읽고 쓸 수 있는가"를 규칙으로 정의합니다.
-- 
-- 우리 블로그 보안 정책:
-- - 누구나(anon): 발행된 글, 카테고리, 태그, 시리즈, 승인된 댓글 읽기 가능
-- - service_role(관리자): 모든 데이터 읽기/쓰기/삭제 가능
-- - anon(일반 방문자): 댓글 작성, 뉴스레터 구독 가능
-- =============================================


-- =============================================
-- 1. 모든 테이블에 RLS 활성화
-- =============================================

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE series ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;


-- =============================================
-- 2. categories 테이블 정책
-- =============================================

-- 누구나 카테고리 목록을 볼 수 있음 (블로그 네비게이션 메뉴에 표시)
CREATE POLICY "categories_read_all"
  ON categories FOR SELECT
  TO anon, authenticated
  USING (TRUE);

-- 관리자만 카테고리 추가/수정/삭제 가능 (service_role은 RLS 우회 가능)
-- service_role key를 사용하는 서버 API 라우트에서만 처리


-- =============================================
-- 3. tags 테이블 정책
-- =============================================

-- 누구나 태그 목록을 볼 수 있음
CREATE POLICY "tags_read_all"
  ON tags FOR SELECT
  TO anon, authenticated
  USING (TRUE);


-- =============================================
-- 4. series 테이블 정책
-- =============================================

-- 누구나 시리즈 목록을 볼 수 있음
CREATE POLICY "series_read_all"
  ON series FOR SELECT
  TO anon, authenticated
  USING (TRUE);


-- =============================================
-- 5. posts 테이블 정책
-- =============================================

-- 발행된 글만 일반 방문자에게 공개
-- status = 'published'인 글만 읽을 수 있음
CREATE POLICY "posts_read_published"
  ON posts FOR SELECT
  TO anon, authenticated
  USING (status = 'published');


-- =============================================
-- 6. post_tags 테이블 정책
-- =============================================

-- 발행된 글의 태그 관계만 공개
-- posts 테이블과 JOIN하여 발행된 글의 태그만 볼 수 있음
CREATE POLICY "post_tags_read_published"
  ON post_tags FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM posts
      WHERE posts.id = post_tags.post_id
        AND posts.status = 'published'
    )
  );


-- =============================================
-- 7. comments 테이블 정책
-- =============================================

-- 삭제되지 않은 댓글은 누구나 읽을 수 있음
-- (비밀 댓글은 애플리케이션 레벨에서 처리)
CREATE POLICY "comments_read_all"
  ON comments FOR SELECT
  TO anon, authenticated
  USING (is_deleted = FALSE);

-- 누구나 댓글을 작성할 수 있음 (비회원 댓글 허용)
CREATE POLICY "comments_insert_all"
  ON comments FOR INSERT
  TO anon, authenticated
  WITH CHECK (TRUE);

-- 댓글 삭제는 애플리케이션 레벨에서 비밀번호 검증 후 API를 통해 처리
-- (service_role key 사용)


-- =============================================
-- 8. newsletter_subscribers 테이블 정책
-- =============================================

-- 누구나 구독 신청 가능 (이메일 INSERT)
CREATE POLICY "newsletter_insert_all"
  ON newsletter_subscribers FOR INSERT
  TO anon, authenticated
  WITH CHECK (TRUE);

-- 구독자 목록은 관리자만 볼 수 있음 (service_role 사용)
-- anon은 SELECT 불가 (개인정보 보호)

-- 구독 취소 업데이트는 애플리케이션 레벨에서 토큰 검증 후 API를 통해 처리
-- (service_role key 사용)


-- =============================================
-- 완료 메시지
-- =============================================
-- 위 정책들이 적용되면:
-- ✅ 블로그 방문자: 발행된 글, 카테고리, 태그, 시리즈, 댓글 읽기 가능
-- ✅ 블로그 방문자: 댓글 작성, 뉴스레터 구독 가능
-- ✅ 관리자 (service_role): 모든 데이터 관리 가능
-- ❌ 블로그 방문자: 미발행 글, 구독자 목록 접근 불가
