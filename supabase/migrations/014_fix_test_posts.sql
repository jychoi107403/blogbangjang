-- =============================================
-- 014_fix_test_posts.sql
-- 테스트 글 2편을 비공개(draft) 처리
-- ★ 구글 애드센스 심사에서 내용 없는 테스트 글은
--   "저품질 콘텐츠"로 판단될 수 있으므로 비공개로 전환합니다
-- ※ Supabase SQL Editor에서 실행하세요
-- =============================================

-- "테스트" 슬러그의 글을 draft로 변경
UPDATE posts
  SET status = 'draft', updated_at = NOW()
WHERE slug = '테스트'
  AND locale = 'ko';

-- "first-test-post" 글을 draft로 변경
UPDATE posts
  SET status = 'draft', updated_at = NOW()
WHERE slug = 'first-test-post'
  AND locale = 'ko';

-- ─── 확인 쿼리 ───
-- 변경 결과 확인 (선택 실행)
-- SELECT title, slug, status FROM posts
-- WHERE slug IN ('테스트', 'first-test-post');
