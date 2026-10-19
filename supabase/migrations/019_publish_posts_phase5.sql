-- =============================================
-- 019_publish_posts_phase5.sql
-- 임시저장(draft)이던 3편에 본문 이미지를 넣고 발행(published)합니다
--   - GA4 설치 / ChatGPT 프롬프트 30선 / 깃허브 입문
-- ※ 018 파일을 먼저 실행한 뒤 Supabase SQL Editor에서 실행하세요
-- ※ 여러 번 실행해도 안전합니다 (이미 이미지가 있으면 다시 넣지 않음)
-- =============================================


-- ═══════════════════════════════════════════════
-- 1) GA4 설치 글: 본문 이미지 2장 삽입 + 발행
--    - 01.webp: "3단계 Next.js 연동" 제목 앞
--    - 02.webp: "핵심 지표" 제목 앞
-- ═══════════════════════════════════════════════
UPDATE posts
SET content = replace(
      replace(
        content,
        '<h2>3단계. Next.js 블로그에 연동하기</h2>',
        '<figure>
<img src="/blog/ga4-install-nextjs-guide/01.webp" alt="웹사이트 화면에 GA4 추적 코드를 삽입하는 과정을 표현한 일러스트" width="960" height="540" loading="lazy" />
<figcaption>측정 ID가 담긴 추적 코드를 사이트에 연결하면 방문 기록이 GA4로 전송됩니다.</figcaption>
</figure>

<h2>3단계. Next.js 블로그에 연동하기</h2>'
      ),
      '<h2>꼭 봐야 할 GA4 핵심 지표</h2>',
      '<figure>
<img src="/blog/ga4-install-nextjs-guide/02.webp" alt="세계 지도와 유입 경로 원형 차트로 구성된 실시간 방문자 보고서 일러스트" width="960" height="540" loading="lazy" />
<figcaption>실시간 보고서와 유입 경로 차트로 방문자의 지역과 출처를 확인할 수 있습니다.</figcaption>
</figure>

<h2>꼭 봐야 할 GA4 핵심 지표</h2>'
    ),
    status = 'published',
    published_at = '2026-10-19T21:30:00+09:00'
WHERE slug = 'ga4-install-nextjs-guide'
  AND locale = 'ko'
  AND content NOT LIKE '%/blog/ga4-install-nextjs-guide/01.webp%';


-- ═══════════════════════════════════════════════
-- 2) ChatGPT 프롬프트 30선: 본문 이미지 2장 삽입 + 발행
--    - 01.webp: "2. 보고서·문서 작성" 제목 앞 (이메일 파트 마무리)
--    - 02.webp: "4. 엑셀·데이터" 제목 앞
-- ═══════════════════════════════════════════════
UPDATE posts
SET content = replace(
      replace(
        content,
        '<h2>2. 보고서·문서 작성 프롬프트 (6개)</h2>',
        '<figure>
<img src="/blog/chatgpt-prompts-for-work-30/01.webp" alt="AI 대화 말풍선의 도움을 받아 이메일과 회의 보고서 문서를 작성하는 일러스트" width="960" height="540" loading="lazy" />
<figcaption>이메일과 보고서처럼 반복되는 문서 작업은 프롬프트 하나로 초안을 빠르게 만들 수 있습니다.</figcaption>
</figure>

<h2>2. 보고서·문서 작성 프롬프트 (6개)</h2>'
      ),
      '<h2>4. 엑셀·데이터 프롬프트 (4개)</h2>',
      '<figure>
<img src="/blog/chatgpt-prompts-for-work-30/02.webp" alt="AI 도우미가 스프레드시트와 발표 슬라이드를 정리하는 생산성 일러스트" width="960" height="540" loading="lazy" />
<figcaption>엑셀 함수와 발표 자료 구성도 AI에게 단계별로 물어보면 시간이 크게 줄어듭니다.</figcaption>
</figure>

<h2>4. 엑셀·데이터 프롬프트 (4개)</h2>'
    ),
    status = 'published',
    published_at = '2026-10-19T21:35:00+09:00'
WHERE slug = 'chatgpt-prompts-for-work-30'
  AND locale = 'ko'
  AND content NOT LIKE '%/blog/chatgpt-prompts-for-work-30/01.webp%';


-- ═══════════════════════════════════════════════
-- 3) 깃허브 입문: 본문 이미지 2장 삽입 + 발행
--    - 01.webp: "add, commit, push 한 번에 이해하기" 제목 앞
--    - 02.webp: "자주 쓰는 Git 명령어 모음" 제목 앞
-- ═══════════════════════════════════════════════
UPDATE posts
SET content = replace(
      replace(
        content,
        '<h2>add, commit, push 한 번에 이해하기</h2>',
        '<figure>
<img src="/blog/github-for-beginners-commit-push/01.webp" alt="작업 폴더에서 스테이징 상자를 거쳐 커밋 스냅샷으로 파일이 이동하는 Git 작업 흐름 일러스트" width="960" height="540" loading="lazy" />
<figcaption>파일은 작업 폴더 → 스테이징(add) → 커밋(commit) 순서로 기록됩니다.</figcaption>
</figure>

<h2>add, commit, push 한 번에 이해하기</h2>'
      ),
      '<h2>자주 쓰는 Git 명령어 모음</h2>',
      '<figure>
<img src="/blog/github-for-beginners-commit-push/02.webp" alt="노트북의 코드가 로켓과 함께 클라우드 저장소로 푸시되는 모습을 표현한 일러스트" width="960" height="540" loading="lazy" />
<figcaption>push 명령으로 내 컴퓨터의 커밋 기록이 GitHub 저장소로 올라갑니다.</figcaption>
</figure>

<h2>자주 쓰는 Git 명령어 모음</h2>'
    ),
    status = 'published',
    published_at = '2026-10-19T21:40:00+09:00'
WHERE slug = 'github-for-beginners-commit-push'
  AND locale = 'ko'
  AND content NOT LIKE '%/blog/github-for-beginners-commit-push/01.webp%';


-- ═══════════════════════════════════════════════
-- 확인용 쿼리 (결과가 3줄, status = published, 이미지 수 = 2 이면 성공)
-- ═══════════════════════════════════════════════
SELECT slug,
       status,
       thumbnail_url,
       (length(content) - length(replace(content, '<figure>', ''))) / length('<figure>') AS figure_count
FROM posts
WHERE slug IN ('ga4-install-nextjs-guide', 'chatgpt-prompts-for-work-30', 'github-for-beginners-commit-push')
  AND locale = 'ko';
