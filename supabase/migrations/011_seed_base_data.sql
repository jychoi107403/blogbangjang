-- =============================================
-- 011_seed_base_data.sql
-- 애드센스 승인용 기초 데이터 삽입
-- 카테고리(5개) + 태그(20+개) + 시리즈(6개)
-- ※ Supabase SQL Editor에서 실행하세요
-- =============================================

-- ─── 1) 카테고리 5개 삽입 ───
-- 이미 존재하는 slug는 건너뜁니다 (ON CONFLICT)
INSERT INTO categories (name, slug, color, description) VALUES
  ('웹 개발',   'web-dev',       '#6366f1', '웹 개발 기술과 프로젝트 경험을 공유합니다'),
  ('AI 활용',   'ai-tools',      '#ec4899', 'AI 도구를 활용한 업무 자동화 팁'),
  ('도구 리뷰', 'tool-review',   '#f59e0b', '생산성 도구 실사용 리뷰'),
  ('수익화',    'monetization',  '#10b981', '블로그와 사이드 프로젝트 수익화 전략'),
  ('일상',      'lifestyle',     '#8b5cf6', '개발자 라이프스타일과 이야기')
ON CONFLICT (slug) DO NOTHING;

-- ─── 2) 태그 20+개 삽입 ───
INSERT INTO tags (name, slug) VALUES
  ('Next.js',      'nextjs'),
  ('TypeScript',   'typescript'),
  ('React',        'react'),
  ('Supabase',     'supabase'),
  ('Vercel',       'vercel'),
  ('ChatGPT',      'chatgpt'),
  ('AI',           'ai'),
  ('자동화',       'automation'),
  ('Notion',       'notion'),
  ('생산성',       'productivity'),
  ('SEO',          'seo'),
  ('애드센스',     'adsense'),
  ('블로그',       'blog'),
  ('HTML',         'html'),
  ('CSS',          'css'),
  ('JavaScript',   'javascript'),
  ('프리랜서',     'freelance'),
  ('부업',         'side-hustle'),
  ('VS Code',      'vscode'),
  ('개발환경',     'dev-environment'),
  ('웹개발',       'web-dev'),
  ('티스토리',     'tistory'),
  ('데이터베이스', 'database'),
  ('배포',         'deployment'),
  ('이메일',       'email'),
  ('PPT',          'ppt'),
  ('엑셀',         'excel')
ON CONFLICT (slug) DO NOTHING;

-- ─── 3) 시리즈 6개 삽입 ───
INSERT INTO series (title, description, slug) VALUES
  ('비개발자의 블로그 만들기',
   '코딩을 전혀 모르던 제가 Next.js로 블로그를 만들어가는 과정을 기록합니다.',
   'building-my-blog'),
  ('직장인 AI 활용법',
   'ChatGPT를 비롯한 AI 도구로 업무 효율을 높이는 실전 팁을 공유합니다.',
   'ai-for-office-workers'),
  ('업무 자동화 도구 리뷰',
   '직접 써보고 추천하는 생산성 도구 리뷰 시리즈입니다.',
   'productivity-tool-reviews'),
  ('웹 개발 입문',
   '코딩을 1도 모르는 당신을 위한 웹 개발 입문 가이드입니다.',
   'web-dev-basics'),
  ('부업 & 수익화',
   '개발 스킬로 부수입을 만드는 현실적인 방법을 이야기합니다.',
   'side-income'),
  ('개발자 라이프스타일',
   '코딩하는 직장인의 일상과 공부법을 솔직하게 기록합니다.',
   'dev-lifestyle')
ON CONFLICT (slug) DO NOTHING;

-- ─── 확인 쿼리 ───
-- 삽입된 데이터 확인용 (실행은 선택사항)
-- SELECT '카테고리' AS type, COUNT(*) AS count FROM categories
-- UNION ALL
-- SELECT '태그', COUNT(*) FROM tags
-- UNION ALL
-- SELECT '시리즈', COUNT(*) FROM series;
