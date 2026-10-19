-- =============================================
-- 021_publish_posts_phase6.sql
-- Phase 6: 이미지 제작 완료에 따른 3개 글 정식 발행(published) 전환
--   1) cloudflare-nextjs-free-deploy      (Cloudflare Pages 무료 배포 가이드)
--   2) free-ai-image-generators-comparison (무료 AI 이미지 생성기 비교)
--   3) side-hustle-checklist-for-employees (직장인 부업 시작 전 체크리스트)
--
-- ※ Supabase SQL Editor에 복사하여 실행하세요.
-- ※ 020 마이그레이션이 먼저 실행되어 있어야 합니다.
-- =============================================

-- 1. Cloudflare Pages Next.js 배포 가이드 발행 처리
UPDATE posts
SET 
  status = 'published',
  published_at = COALESCE(published_at, NOW() - INTERVAL '1 day'),
  updated_at = NOW()
WHERE slug = 'cloudflare-nextjs-free-deploy';

-- 2. 무료 AI 이미지 생성 도구 비교 가이드 발행 처리
UPDATE posts
SET 
  status = 'published',
  published_at = COALESCE(published_at, NOW() - INTERVAL '12 hours'),
  updated_at = NOW()
WHERE slug = 'free-ai-image-generators-comparison';

-- 3. 직장인 부업 체크리스트 가이드 발행 처리
UPDATE posts
SET 
  status = 'published',
  published_at = COALESCE(published_at, NOW()),
  updated_at = NOW()
WHERE slug = 'side-hustle-checklist-for-employees';


-- ─────────────────────────────────────────────
-- [확인 쿼리] 이번 1차(5편) + 2차(5편) 총 10편의 발행 상태를 한눈에 확인합니다
-- ─────────────────────────────────────────────
SELECT 
  id,
  title,
  slug,
  status,
  thumbnail_url,
  to_char(published_at, 'YYYY-MM-DD HH24:MI') AS published_date
FROM posts
WHERE slug IN (
  -- 1차 배포 5편
  'google-search-console-guide',
  'naver-search-advisor-guide',
  'ga4-install-nextjs-guide',
  'chatgpt-prompts-for-work-30',
  'github-for-beginners-commit-push',
  -- 2차 배포 5편
  'xlookup-vs-vlookup-guide',
  'claude-code-gemini-cli-guide',
  'cloudflare-nextjs-free-deploy',
  'free-ai-image-generators-comparison',
  'side-hustle-checklist-for-employees'
)
ORDER BY published_at DESC;
