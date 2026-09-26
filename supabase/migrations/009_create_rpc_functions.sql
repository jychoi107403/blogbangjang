-- 009_create_rpc_functions.sql
-- 서버사이드 RPC(Remote Procedure Call) 함수들
-- Supabase에서 복잡한 로직을 안전하게 처리하기 위해 SQL 함수로 정의

-- ================================================================
-- 1. 조회수 원자적 증가 함수
-- 문제: 여러 사람이 동시에 같은 글을 보면 조회수가 정확하지 않을 수 있음
-- 해결: SQL 함수로 처리하면 DB가 알아서 동시성 문제를 해결함
-- ================================================================
CREATE OR REPLACE FUNCTION increment_view_count(post_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER  -- 함수 소유자(서버) 권한으로 실행 (RLS 우회 가능)
AS $$
BEGIN
  UPDATE posts
  SET view_count = view_count + 1
  WHERE id = post_id;
END;
$$;

-- 모든 사용자(anon 포함)가 이 함수를 호출할 수 있도록 권한 부여
GRANT EXECUTE ON FUNCTION increment_view_count(UUID) TO anon, authenticated;


-- ================================================================
-- 2. 이메일 인증 완료 함수 (선택적 사용)
-- newsletter_subscribers 테이블에서 특정 이메일의 is_verified를 true로 변경
-- ================================================================
CREATE OR REPLACE FUNCTION verify_newsletter_email(p_email TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE newsletter_subscribers
  SET is_verified = true
  WHERE email = p_email AND is_verified = false;
END;
$$;

GRANT EXECUTE ON FUNCTION verify_newsletter_email(TEXT) TO anon, authenticated;
