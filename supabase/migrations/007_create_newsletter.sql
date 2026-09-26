-- =============================================
-- 007_create_newsletter.sql
-- 뉴스레터 구독자 테이블 생성
-- 새 글 발행 시 구독자들에게 이메일 자동 발송 (Resend API 사용)
-- =============================================

CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  -- 고유 ID: UUID 자동 생성
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 구독자 이메일 주소 (중복 불가)
  email TEXT NOT NULL UNIQUE,
  
  -- 이메일 인증 여부
  -- 구독 신청 후 인증 이메일을 확인해야 true로 변경됨
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  
  -- 이메일 인증 토큰 (인증 링크에 포함되는 일회용 토큰)
  -- 인증 완료 후 NULL로 변경
  verification_token TEXT,
  
  -- 구독 취소 여부 (소프트 삭제 방식)
  -- 구독 취소해도 레코드는 유지하고 이 필드를 true로 변경
  is_unsubscribed BOOLEAN NOT NULL DEFAULT FALSE,
  
  -- 구독 신청 시각 (자동 기록)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 이메일로 구독자 조회 인덱스 (중복 체크, 인증 링크 조회 시 최적화)
CREATE INDEX IF NOT EXISTS idx_newsletter_email ON newsletter_subscribers(email);

-- 발송 대상 조회 인덱스 (인증됨 + 구독 취소하지 않은 사람만 이메일 발송)
CREATE INDEX IF NOT EXISTS idx_newsletter_active 
  ON newsletter_subscribers(is_verified, is_unsubscribed);

-- 인증 토큰 조회 인덱스 (인증 링크 클릭 시 토큰으로 구독자 찾을 때 사용)
CREATE INDEX IF NOT EXISTS idx_newsletter_token 
  ON newsletter_subscribers(verification_token) 
  WHERE verification_token IS NOT NULL;

COMMENT ON TABLE newsletter_subscribers IS '뉴스레터 구독자 목록';
COMMENT ON COLUMN newsletter_subscribers.email IS '구독자 이메일 주소 (중복 불가)';
COMMENT ON COLUMN newsletter_subscribers.is_verified IS 'true이면 이메일 인증 완료 (발송 대상)';
COMMENT ON COLUMN newsletter_subscribers.verification_token IS '이메일 인증용 일회성 토큰 (인증 후 NULL)';
COMMENT ON COLUMN newsletter_subscribers.is_unsubscribed IS 'true이면 구독 취소 상태 (발송 제외)';
