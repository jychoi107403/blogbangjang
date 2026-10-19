-- =============================================
-- 018_seed_posts_phase5b.sql
-- Phase 5-B: 검색 유입 확대용 롱테일 키워드 글 4편
--   1) 네이버 서치어드바이저 등록  → 바로 발행 (published)
--   2) GA4 설치 (Next.js)          → 이미지 대기 중 (draft)
--   3) ChatGPT 프롬프트 30선       → 이미지 대기 중 (draft)
--   4) 깃허브 입문                 → 이미지 대기 중 (draft)
-- ※ Supabase SQL Editor에서 실행하세요 (여러 번 실행해도 안전: ON CONFLICT)
-- ※ draft 글은 이미지 추가 후 019 파일의 UPDATE로 발행합니다
-- =============================================


-- ═══════════════════════════════════════════════
-- 포스트 2: 네이버 서치어드바이저 등록 방법
-- 카테고리: 수익화 (monetization) | 상태: 발행
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  '네이버 서치어드바이저 등록 방법 — 사이트맵·RSS 제출하고 네이버 검색에 노출시키기',
  'naver-search-advisor-guide',
  '구글에는 나오는데 네이버에는 내 블로그가 검색되지 않나요? 네이버 서치어드바이저 등록, 소유 확인, 사이트맵과 RSS 제출, 웹 페이지 수집 요청까지 순서대로 정리했습니다.',
  '/blog/naver-search-advisor-guide/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: 네이버는 구글과 별개의 검색엔진이라 <strong>네이버 서치어드바이저</strong>에 직접 사이트를 등록해야 합니다. 사이트 등록 → 소유 확인 → 사이트맵·RSS 제출 → 웹 페이지 수집 요청, 이 네 단계만 하면 되고 비용은 무료입니다.</p>

<h2>구글에는 나오는데 네이버에는 안 나오는 이유</h2>
<p>직접 만든 블로그나 개인 사이트는 네이버가 자동으로 알아채 주지 않는 경우가 많습니다. 네이버 블로그나 티스토리처럼 이미 네이버가 잘 알고 있는 플랫폼과 달리, 내 도메인으로 만든 사이트는 <strong>"여기 사이트가 있어요"라고 먼저 알려야</strong> 네이버 검색 로봇이 방문합니다. 이를 위해 네이버가 제공하는 공식 무료 도구가 바로 <strong>네이버 서치어드바이저</strong>(구 웹마스터 도구)입니다.</p>
<p>국내 검색 사용자 중에는 여전히 네이버로 검색하는 비율이 높습니다. 한국어 블로그라면 구글 서치콘솔과 함께 네이버 서치어드바이저도 반드시 등록해 두는 것이 좋습니다. 구글 쪽 설정이 궁금하시다면 <a href="/ko/blog/google-search-console-guide">구글 서치콘솔 등록 방법 총정리</a>를 먼저 참고하세요.</p>

<h2>시작하기 전에 준비할 것</h2>
<ul>
<li><strong>네이버 계정</strong>: 일반 네이버 아이디면 됩니다.</li>
<li><strong>사이트 주소</strong>: 예) <code>https://내도메인.com</code> (https 주소 권장)</li>
<li><strong>사이트 수정 권한</strong>: 소유 확인을 위해 사이트 코드에 태그를 넣거나 파일을 올릴 수 있어야 합니다.</li>
<li><strong>sitemap.xml, RSS 주소</strong>: 없다면 생성해 두세요. (대부분의 프레임워크가 자동 생성 기능을 제공합니다)</li>
</ul>

<h2>1단계. 사이트 등록하기</h2>
<ol>
<li><a href="https://searchadvisor.naver.com" target="_blank" rel="noopener noreferrer">네이버 서치어드바이저</a>에 접속해 네이버 계정으로 로그인합니다.</li>
<li>상단 메뉴에서 <strong>웹마스터 도구</strong>로 이동합니다.</li>
<li>사이트 URL 입력칸에 내 사이트 주소(<code>https://내도메인.com</code>)를 입력하고 <strong>사이트 등록</strong>을 누릅니다.</li>
</ol>
<p>주소를 입력할 때는 <code>www</code> 유무와 <code>http</code>/<code>https</code> 여부를 <strong>실제 사이트가 쓰는 대표 주소와 동일하게</strong> 맞추는 것이 중요합니다. 다르게 등록하면 별개 사이트로 인식될 수 있습니다.</p>

<h2>2단계. 사이트 소유 확인하기</h2>
<p>등록 직후 "이 사이트가 정말 내 것인지" 확인하는 단계가 나옵니다. 두 가지 방법 중 편한 것을 고르면 됩니다.</p>
<table>
<thead><tr><th>방법</th><th>하는 일</th><th>추천 대상</th></tr></thead>
<tbody>
<tr><td>HTML 파일 업로드</td><td>네이버가 주는 확인용 HTML 파일을 사이트 최상위 경로에 올림</td><td>정적 파일을 올릴 수 있는 환경</td></tr>
<tr><td>HTML 태그</td><td>네이버가 주는 메타 태그를 사이트 &lt;head&gt; 안에 삽입</td><td>Next.js 등 프레임워크로 만든 사이트 (권장)</td></tr>
</tbody>
</table>

<figure>
<img src="/blog/naver-search-advisor-guide/01.webp" alt="웹사이트 소유 확인을 위해 메타 태그 코드와 체크 표시 방패가 함께 있는 일러스트" width="960" height="540" />
<figcaption>소유 확인은 "이 사이트의 주인이 맞다"고 네이버에 증명하는 절차입니다.</figcaption>
</figure>

<h3>HTML 태그 방식 따라 하기</h3>
<ol>
<li>소유 확인 화면에서 <strong>HTML 태그</strong>를 선택하면 <code>&lt;meta name="naver-site-verification" content="..." /&gt;</code> 형태의 코드가 나옵니다.</li>
<li>이 코드를 사이트의 <code>&lt;head&gt;</code> 안에 넣습니다. Next.js의 경우 레이아웃 파일의 메타데이터 설정에 <code>verification</code> 항목을 추가하면 됩니다.</li>
<li>사이트를 <strong>배포</strong>한 뒤(로컬에서는 확인되지 않습니다), 서치어드바이저로 돌아와 <strong>소유확인</strong> 버튼을 누릅니다.</li>
</ol>
<p>"소유확인 완료"가 뜨면 등록이 끝난 것입니다. 실패한다면 배포가 실제로 반영되었는지, 페이지 소스 보기에서 태그가 보이는지 먼저 확인해 보세요.</p>

<h2>3단계. 사이트맵과 RSS 제출하기</h2>
<p>사이트 등록 후 왼쪽 메뉴의 <strong>요청</strong> 항목에서 사이트맵과 RSS를 제출할 수 있습니다.</p>
<ol>
<li><strong>요청 &gt; 사이트맵 제출</strong>을 선택하고 사이트맵 주소(<code>https://내도메인.com/sitemap.xml</code>)를 입력해 제출합니다.</li>
<li><strong>요청 &gt; RSS 제출</strong>을 선택하고 RSS 주소(예: <code>https://내도메인.com/rss.xml</code>)를 입력해 제출합니다.</li>
</ol>
<p>사이트맵은 전체 페이지 목록, RSS는 <strong>최근에 올린 글 목록</strong>이라고 이해하면 쉽습니다. 둘 다 제출해 두면 새 글이 올라올 때 네이버가 더 빨리 알아챌 수 있습니다.</p>

<figure>
<img src="/blog/naver-search-advisor-guide/02.webp" alt="RSS 피드 아이콘과 사이트맵 문서가 검색 서버로 전달되는 모습을 표현한 일러스트" width="960" height="540" loading="lazy" />
<figcaption>사이트맵과 RSS는 검색 로봇에게 내 사이트의 글 목록을 알려주는 안내서입니다.</figcaption>
</figure>

<h2>4단계. 웹 페이지 수집 요청하기</h2>
<p>사이트맵을 제출했더라도 중요한 새 글은 직접 수집을 요청하면 도움이 됩니다.</p>
<ol>
<li>왼쪽 메뉴 <strong>요청 &gt; 웹 페이지 수집</strong>으로 이동합니다.</li>
<li>수집을 요청할 글의 전체 주소(URL)를 입력하고 <strong>확인</strong>을 누릅니다.</li>
</ol>
<p>하루에 요청할 수 있는 개수에 제한이 있으니, 새로 쓴 글이나 크게 수정한 글 위주로 요청하세요. 요청한다고 즉시 노출되는 것은 아니며, 수집과 반영까지는 시간이 걸릴 수 있습니다.</p>

<h2>robots.txt도 꼭 확인하세요</h2>
<p>네이버 검색 로봇이 사이트를 방문하려면 <code>robots.txt</code>에서 접근이 막혀 있지 않아야 합니다. 서치어드바이저의 <strong>검증 &gt; robots.txt</strong> 메뉴에서 내 robots.txt가 올바른지 점검할 수 있습니다. 아래처럼 모든 로봇을 허용하는 설정이면 문제가 없습니다.</p>
<pre><code>User-agent: *
Allow: /

Sitemap: https://내도메인.com/sitemap.xml</code></pre>
<p>특정 경로(예: 관리자 페이지)만 막고 싶다면 <code>Disallow: /admin</code>처럼 해당 경로만 지정하세요. 실수로 <code>Disallow: /</code>가 들어가 있으면 사이트 전체가 검색에서 제외되니 반드시 확인해야 합니다.</p>

<h2>네이버 노출을 늘리는 글쓰기 팁</h2>
<table>
<thead><tr><th>항목</th><th>실천 방법</th></tr></thead>
<tbody>
<tr><td>제목</td><td>사람들이 검색하는 표현을 앞쪽에 배치 (예: "~ 등록 방법", "~ 하는 법")</td></tr>
<tr><td>본문 분량</td><td>핵심 정보를 충분히, 그러나 같은 말 반복은 줄이기</td></tr>
<tr><td>이미지</td><td>직접 만든 이미지 + 구체적인 alt 설명 문장</td></tr>
<tr><td>구조</td><td>소제목(h2, h3)으로 나누고 목록·표 활용</td></tr>
<tr><td>내부 링크</td><td>관련된 내 글끼리 서로 연결</td></tr>
<tr><td>꾸준함</td><td>일정한 주기로 새 글 발행</td></tr>
</tbody>
</table>
<p>글을 어떻게 써야 검색 유입이 늘어나는지 더 자세히 알고 싶다면 <a href="/ko/blog/blog-seo-traffic-growth-guide">블로그 SEO 트래픽 늘리기 가이드</a>도 함께 읽어 보세요.</p>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 등록하면 바로 네이버에 검색되나요?</h3>
<p>아닙니다. 등록은 "내 사이트를 알리는" 단계입니다. 수집과 노출은 며칠에서 수 주가 걸릴 수 있고, 신규 사이트일수록 더 오래 걸릴 수 있습니다.</p>

<h3>Q2. 네이버 블로그가 아니라 내 도메인 사이트도 노출되나요?</h3>
<p>네, 가능합니다. 다만 네이버 블로그·카페보다 노출 우선순위가 낮을 수 있으므로, 구체적인 주제와 롱테일 키워드로 꾸준히 글을 쌓는 것이 중요합니다.</p>

<h3>Q3. 소유 확인이 계속 실패해요.</h3>
<p>대부분 배포가 반영되지 않았거나 태그가 &lt;head&gt; 밖에 들어간 경우입니다. 사이트에 접속해 페이지 소스 보기에서 <code>naver-site-verification</code>을 검색해 태그가 보이는지 확인하세요.</p>

<h3>Q4. 구글 서치콘솔과 같이 등록해도 문제없나요?</h3>
<p>전혀 문제없습니다. 두 도구는 서로 독립적이며, 둘 다 등록하는 것이 일반적입니다.</p>

<h2>마치며: 오늘 해볼 체크리스트</h2>
<ol>
<li>네이버 서치어드바이저에 사이트 등록</li>
<li>HTML 태그로 소유 확인 완료</li>
<li>사이트맵과 RSS 제출</li>
<li>새 글 웹 페이지 수집 요청</li>
<li>robots.txt 점검</li>
</ol>
<p>구글과 네이버 두 곳에 모두 등록해 두면 검색 유입의 기본기가 갖춰진 것입니다. 이제 남은 일은 사람들이 궁금해하는 주제로 꾸준히 좋은 글을 쌓는 것입니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'monetization'),
  'published',
  'ko',
  '2026-10-19T16:20:00+09:00',
  '2026-10-19T16:30:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 3: GA4 설치 방법 (Next.js 블로그)
-- 카테고리: 웹 개발 (web-dev) | 상태: 임시저장(draft) - 본문 이미지 대기
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  'GA4(구글 애널리틱스 4) 설치 방법과 보는 법 — Next.js 블로그에 연동하기',
  'ga4-install-nextjs-guide',
  '내 블로그에 방문자가 얼마나 오는지 궁금하신가요? GA4 계정 만들기부터 측정 ID 발급, Next.js 블로그 연동, 실시간 보고서와 꼭 봐야 할 핵심 지표까지 한 번에 정리했습니다.',
  '/blog/ga4-install-nextjs-guide/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: GA4 계정을 만들고 <strong>측정 ID(G-로 시작)</strong>를 발급받아 사이트에 연결하면 방문자 수, 유입 경로, 인기 글을 무료로 확인할 수 있습니다. Next.js라면 공식 패키지로 몇 줄이면 연동이 끝납니다.</p>

<h2>GA4가 뭐고, 왜 설치해야 할까요?</h2>
<p>GA4(Google Analytics 4)는 구글이 제공하는 무료 웹 분석 도구입니다. 블로그에 몇 명이 들어왔는지, 어디서 왔는지(검색·SNS·직접 접속), 어떤 글이 많이 읽히는지를 숫자로 보여줍니다. 데이터 없이 글을 쓰는 것은 지도 없이 운전하는 것과 같습니다. 어떤 주제가 반응이 좋은지 알아야 다음 글의 방향을 정할 수 있습니다.</p>
<p>검색 노출 쪽 데이터는 <a href="/ko/blog/google-search-console-guide">구글 서치콘솔</a>이, 사이트에 들어온 뒤의 행동 데이터는 GA4가 담당합니다. 두 도구를 함께 쓰면 "검색어 → 방문 → 읽기"의 흐름 전체를 볼 수 있습니다.</p>

<h2>1단계. GA4 계정과 속성 만들기</h2>
<ol>
<li><a href="https://analytics.google.com" target="_blank" rel="noopener noreferrer">구글 애널리틱스</a>에 구글 계정으로 로그인합니다.</li>
<li>왼쪽 아래 <strong>관리</strong>(톱니바퀴)를 누르고 <strong>계정 만들기</strong>를 선택합니다.</li>
<li>계정 이름(예: 내 블로그)을 입력하고 <strong>다음</strong>을 누릅니다.</li>
<li>속성 이름, 보고 시간대(대한민국), 통화(KRW)를 선택합니다.</li>
<li>업종과 비즈니스 규모, 사용 목적을 선택하고 <strong>만들기</strong>를 누릅니다.</li>
</ol>

<h2>2단계. 웹 데이터 스트림 만들고 측정 ID 받기</h2>
<ol>
<li>"데이터 수집 시작" 화면에서 플랫폼으로 <strong>웹</strong>을 선택합니다.</li>
<li>웹사이트 URL(<code>https://내도메인.com</code>)과 스트림 이름을 입력하고 <strong>스트림 만들기</strong>를 누릅니다.</li>
<li>스트림 상세 화면 오른쪽 위에 <code>G-XXXXXXXXXX</code> 형태의 <strong>측정 ID</strong>가 표시됩니다. 복사해 둡니다.</li>
</ol>
<p>이 측정 ID가 "내 사이트의 방문 기록을 이 GA4 속성으로 보내라"는 주소 역할을 합니다.</p>

<h2>3단계. Next.js 블로그에 연동하기</h2>
<p>Next.js는 <code>@next/third-parties</code>라는 공식 패키지에서 GA4 컴포넌트를 제공합니다. 설치부터 적용까지 순서는 다음과 같습니다.</p>

<h3>① 패키지 설치</h3>
<pre><code>npm install @next/third-parties</code></pre>

<h3>② 측정 ID를 환경 변수로 저장</h3>
<p>측정 ID는 코드에 직접 쓰기보다 환경 변수로 관리하는 것이 안전하고 편합니다. 프로젝트 루트의 <code>.env.local</code> 파일에 아래 한 줄을 추가하세요.</p>
<pre><code>NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX</code></pre>
<p>배포 환경(Vercel, Cloudflare 등)의 환경 변수 설정에도 <strong>같은 이름으로 추가</strong>해야 실제 사이트에서 동작합니다. 이 부분을 빼먹어서 데이터가 안 잡히는 경우가 가장 흔합니다.</p>

<h3>③ 레이아웃에 컴포넌트 추가</h3>
<p>최상위 레이아웃 파일(<code>app/layout.tsx</code> 또는 언어별 레이아웃)의 본문 안에 아래처럼 추가합니다.</p>
<pre><code>import { GoogleAnalytics } from "@next/third-parties/google";

// ...레이아웃 컴포넌트 안에서
&lt;body&gt;
  {children}
  {process.env.NEXT_PUBLIC_GA_ID &amp;&amp; (
    &lt;GoogleAnalytics gaId={process.env.NEXT_PUBLIC_GA_ID} /&gt;
  )}
&lt;/body&gt;</code></pre>
<p>환경 변수가 있을 때만 렌더링하도록 조건을 걸어 두면, 로컬 개발 중에는 불필요한 데이터가 쌓이지 않습니다.</p>

<h2>4단계. 제대로 연결됐는지 확인하기</h2>
<ol>
<li>배포가 끝난 뒤 내 사이트에 접속해 둡니다. (다른 탭에서 유지)</li>
<li>GA4 왼쪽 메뉴에서 <strong>보고서 &gt; 실시간</strong>을 엽니다.</li>
<li>"지난 30분 동안의 사용자"에 <strong>1명 이상</strong>이 표시되면 연동 성공입니다.</li>
</ol>
<p>바로 보이지 않더라도 1~2분 정도 기다려 보세요. 광고 차단 프로그램이 켜져 있으면 내 접속이 집계되지 않을 수 있으니 시크릿 창이나 휴대폰으로 테스트하는 것도 방법입니다.</p>

<h2>꼭 봐야 할 GA4 핵심 지표</h2>
<p>GA4는 메뉴가 많아 처음엔 막막합니다. 블로그 운영자라면 아래 지표만 챙기세요.</p>
<table>
<thead><tr><th>지표</th><th>의미</th><th>활용법</th></tr></thead>
<tbody>
<tr><td>활성 사용자</td><td>사이트에 실제로 참여한 방문자 수</td><td>성장 추이 확인</td></tr>
<tr><td>조회수</td><td>페이지가 열린 총 횟수</td><td>인기 글 파악</td></tr>
<tr><td>세션 기본 채널 그룹</td><td>방문자가 들어온 경로 (Organic Search, Direct, Social 등)</td><td>검색 유입 비중 확인</td></tr>
<tr><td>평균 참여 시간</td><td>방문자가 페이지에 머문 시간</td><td>글 품질 점검</td></tr>
<tr><td>국가·도시</td><td>방문자 지역</td><td>타깃 독자 파악</td></tr>
</tbody>
</table>
<p>특히 <strong>세션 기본 채널 그룹</strong>에서 <strong>Organic Search</strong> 수치가 늘어나는지 보는 것이 중요합니다. 검색을 통해 들어오는 방문자가 많아질수록 블로그가 안정적으로 성장하고 있다는 뜻입니다. 이때 <strong>Direct</strong> 수치에는 본인 접속이나 봇 트래픽이 섞여 있을 수 있어 그대로 믿기보다 참고만 하는 것이 좋습니다.</p>

<h2>보고서 메뉴 보는 순서</h2>
<ol>
<li><strong>보고서 &gt; 획득 &gt; 트래픽 획득</strong>: 어떤 경로로 들어왔는지</li>
<li><strong>보고서 &gt; 참여도 &gt; 페이지 및 화면</strong>: 어떤 글이 많이 읽혔는지</li>
<li><strong>보고서 &gt; 사용자 &gt; 인구통계 개요</strong>: 국가·도시별 방문자</li>
</ol>
<p>일주일에 한 번, 위 세 화면만 확인하는 습관을 들이면 충분합니다. 조회수가 높은 글은 후속편을 쓰거나 내용을 보강하고, 조회수가 낮은 글은 제목과 첫 문단을 손보는 식으로 활용해 보세요.</p>

<h2>개인정보와 쿠키 안내도 챙기세요</h2>
<p>GA4는 방문자 정보를 수집하는 도구이므로, 사이트의 <strong>개인정보처리방침</strong>에 "구글 애널리틱스를 사용한다"는 내용을 명시하는 것이 좋습니다. 또한 애드센스를 신청할 계획이라면 쿠키 사용 안내가 필요합니다. 개인을 식별하는 정보를 별도로 GA4에 전송하지 않도록 주의하세요.</p>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 설치했는데 실시간에 아무것도 안 떠요.</h3>
<p>측정 ID가 정확한지, 배포 환경에 환경 변수를 추가했는지, 환경 변수 추가 후 <strong>재배포</strong>를 했는지 확인하세요. 광고 차단 확장 프로그램이 원인인 경우도 많습니다.</p>

<h3>Q2. 예전 구글 애널리틱스(UA)와 뭐가 다른가요?</h3>
<p>기존 UA는 서비스가 종료되었고 현재는 GA4가 표준입니다. GA4는 "페이지뷰" 대신 "이벤트" 중심으로 데이터를 수집하며, 화면 구성과 용어가 크게 달라졌습니다.</p>

<h3>Q3. 내 접속이 통계에 섞이지 않게 할 수 있나요?</h3>
<p>관리 &gt; 데이터 스트림 &gt; 태그 설정에서 내부 트래픽(내 IP)을 정의하고 필터를 적용하면 제외할 수 있습니다.</p>

<h3>Q4. 데이터는 얼마나 지나야 쌓이나요?</h3>
<p>실시간 보고서는 거의 즉시 보이고, 일반 보고서는 반영까지 최대 하루 정도 걸릴 수 있습니다.</p>

<h2>마치며</h2>
<p>GA4를 설치했다면 이제 "감"이 아니라 "데이터"로 블로그를 운영할 수 있습니다. 서치콘솔로 <strong>어떤 검색어로 노출되는지</strong>, GA4로 <strong>들어온 뒤 어떤 글이 읽히는지</strong>를 함께 보면서 다음 글 주제를 정해 보세요. 작은 숫자의 변화도 꾸준히 기록하다 보면 블로그가 성장하는 방향이 보일 것입니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  'draft',
  'ko',
  '2026-10-19T16:25:00+09:00',
  '2026-10-19T17:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 4: ChatGPT 프롬프트 직장인 업무 활용 30선
-- 카테고리: AI 활용 (ai-tools) | 상태: 임시저장(draft) - 이미지 대기
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  'ChatGPT 프롬프트 직장인 업무 활용 30선 — 복사해서 바로 쓰는 이메일·보고서·엑셀 프롬프트',
  'chatgpt-prompts-for-work-30',
  '매번 ChatGPT에 뭐라고 써야 할지 막막하셨나요? 이메일, 보고서, 회의, 엑셀, PPT, 커리어까지 직장인이 바로 복사해서 쓸 수 있는 프롬프트 30개를 상황별로 정리했습니다.',
  '/blog/chatgpt-prompts-for-work-30/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: ChatGPT는 "무엇을 해줘"보다 <strong>역할·상황·형식</strong>을 함께 알려줄 때 훨씬 좋은 답을 줍니다. 이 글의 30개 프롬프트는 [대괄호] 부분만 바꿔서 그대로 복사해 쓸 수 있습니다.</p>

<h2>좋은 프롬프트의 공식: 역할 + 상황 + 요청 + 형식</h2>
<p>같은 AI라도 질문하는 방식에 따라 결과는 크게 달라집니다. 아래 네 가지를 포함하면 결과물이 눈에 띄게 좋아집니다.</p>
<table>
<thead><tr><th>요소</th><th>설명</th><th>예시</th></tr></thead>
<tbody>
<tr><td>역할</td><td>AI에게 맡길 전문가 역할</td><td>"너는 10년 차 마케팅 팀장이야"</td></tr>
<tr><td>상황</td><td>배경과 대상</td><td>"신규 거래처에 처음 보내는 메일이야"</td></tr>
<tr><td>요청</td><td>구체적으로 할 일</td><td>"정중한 톤으로 3문단 이내로 써줘"</td></tr>
<tr><td>형식</td><td>결과물의 모양</td><td>"제목 3개와 본문을 표로 정리해줘"</td></tr>
</tbody>
</table>
<p>또한 <strong>민감한 정보</strong>(고객 개인정보, 회사 기밀, 비밀번호 등)는 입력하지 마세요. 이름이나 숫자는 가명·예시로 바꿔서 사용하는 것이 안전합니다.</p>

<h2>1. 이메일 작성 프롬프트 (6개)</h2>
<p>이메일 쓰기는 AI가 가장 큰 시간을 절약해 주는 영역입니다. 더 자세한 활용법은 <a href="/ko/blog/chatgpt-email-writing-tips">ChatGPT 이메일 작성 팁</a>에서도 확인하실 수 있습니다.</p>
<pre><code>1) 너는 비즈니스 이메일 전문가야. [수신자: 거래처 담당자]에게 [납기 3일 지연]을 사과하고 새로운 일정을 안내하는 정중한 이메일을 써줘. 3문단 이내, 핑계는 짧게 해결책은 구체적으로.

2) 아래 이메일을 읽고 핵심 요청사항만 3줄로 요약해줘. 그리고 내가 답장에서 확인해야 할 질문을 목록으로 뽑아줘.
[이메일 내용 붙여넣기]

3) 아래 초안을 더 간결하고 정중한 톤으로 고쳐줘. 의미는 바꾸지 말고 문장을 30% 줄여줘.
[초안 붙여넣기]

4) [미팅 후 감사 인사] 이메일을 써줘. 논의한 내용 [내용 요약]과 다음 단계 [일정]을 포함하고, 5문장 이내로.

5) 아래 상황에서 거절 의사를 정중하게 전달하는 이메일 3가지 버전(부드러운/단호한/대안 제시형)을 써줘.
[상황 설명]

6) 아래 영어 이메일을 자연스러운 한국어로 번역하고, 비즈니스 어투를 유지해줘.
[영어 이메일 붙여넣기]</code></pre>

<h2>2. 보고서·문서 작성 프롬프트 (6개)</h2>
<p>보고서는 구조를 먼저 잡고 살을 붙이는 방식이 효과적입니다. <a href="/ko/blog/ai-report-writing-guide">AI로 보고서 쓰는 법</a>과 함께 활용해 보세요.</p>
<pre><code>7) [주제]에 대한 보고서 목차를 만들어줘. 대상 독자는 [임원/팀원], 분량은 A4 [2]장 기준. 각 항목마다 들어갈 핵심 내용을 한 줄로 적어줘.

8) 아래 내용을 임원 보고용으로 요약해줘. 결론 먼저, 근거 3가지, 다음 액션 순서로 정리해줘.
[내용 붙여넣기]

9) 아래 데이터에서 눈에 띄는 변화 3가지와 그 원인 가설을 정리해줘. 확실하지 않은 내용은 "가설"이라고 표시해줘.
[데이터 붙여넣기]

10) 아래 문장들을 보고서 문체('~함', '~임'체)로 바꿔줘.
[문장 붙여넣기]

11) [프로젝트]의 장단점과 리스크를 표로 정리하고, 리스크별 대응 방안을 제안해줘.

12) 아래 긴 글을 300자 이내 요약본과 핵심 키워드 5개로 정리해줘.
[글 붙여넣기]</code></pre>

<h2>3. 회의·일정 관리 프롬프트 (4개)</h2>
<p>회의 기록을 자동화하는 방법은 <a href="/ko/blog/auto-meeting-notes-ai">AI 회의록 자동 작성</a>에서 더 자세히 다뤘습니다.</p>
<pre><code>13) 아래 회의 메모를 회의록 형식으로 정리해줘. 항목: 일시, 참석자, 논의 내용, 결정 사항, 담당자별 할 일(마감일 포함).
[메모 붙여넣기]

14) [주제] 회의 안건을 30분 안에 끝낼 수 있도록 시간 배분표로 만들어줘.

15) 이번 주 해야 할 일 목록이야. 중요도와 긴급도로 우선순위를 매기고, 월~금 일정으로 배분해줘.
[할 일 목록]

16) 회의에서 나온 아래 의견들을 찬성/반대/보류로 분류하고 쟁점을 한 줄씩 요약해줘.
[의견 목록]</code></pre>

<h2>4. 엑셀·데이터 프롬프트 (4개)</h2>
<p>함수 때문에 막힐 때는 <a href="/ko/blog/ask-ai-for-excel-formulas">AI에게 엑셀 함수 물어보는 법</a>도 참고하세요.</p>
<pre><code>17) 엑셀에서 A열의 [제품명]과 B열의 [판매량]을 이용해 제품별 합계를 구하는 함수를 알려줘. 초보자도 이해하게 단계별로 설명해줘.

18) 아래 엑셀 수식이 오류가 나. 원인을 찾아 고쳐주고 왜 틀렸는지 설명해줘.
[수식 붙여넣기]

19) 아래 표 데이터를 보고 피벗 테이블로 만들면 좋은 분석 3가지를 추천해줘.
[데이터 설명]

20) 중복된 값을 찾아서 제거하는 방법을 엑셀 버전 [2021 / 365] 기준으로 알려줘.</code></pre>

<h2>5. PPT·발표 프롬프트 (4개)</h2>
<pre><code>21) [주제]로 [10]분 발표할 PPT의 슬라이드 구성안을 만들어줘. 슬라이드별 제목과 핵심 문장 한 줄, 넣으면 좋은 시각 자료를 적어줘.

22) 아래 발표 대본을 듣는 사람이 이해하기 쉽도록 짧은 문장으로 바꿔줘. 어려운 용어는 쉬운 말로 풀어줘.
[대본 붙여넣기]

23) 발표 후 나올 수 있는 예상 질문 10개와 답변 가이드를 만들어줘.
[발표 내용 요약]

24) 아래 내용을 슬라이드 한 장에 들어갈 3줄 핵심 문구로 줄여줘.
[내용 붙여넣기]</code></pre>

<h2>6. 커리어·자기계발 프롬프트 (3개)</h2>
<pre><code>25) 내 경력은 [경력 요약]이야. 지원하는 직무 [직무]에 맞는 자기소개서 첫 문단 3가지 버전을 써줘.

26) 면접관이 [직무] 면접에서 자주 묻는 질문 10개와 좋은 답변의 구조를 알려줘. 나는 면접자 입장이야. 모의 면접처럼 한 번에 하나씩 질문해줘.

27) 내가 올해 배우고 싶은 것은 [분야]야. 하루 [1]시간씩 [3]개월 학습 로드맵을 주 단위로 짜줘.</code></pre>

<h2>7. 아이디어·글쓰기 프롬프트 (3개)</h2>
<pre><code>28) [주제]로 블로그 글을 쓰려고 해. 사람들이 검색할 만한 제목 후보 10개와, 각각의 핵심 독자·검색 의도를 표로 정리해줘.

29) 아래 글을 읽고 부족한 부분, 논리적 허점, 더 보강하면 좋을 내용을 날카롭게 지적해줘. 칭찬은 생략해줘.
[글 붙여넣기]

30) [상품/서비스]의 장점을 처음 듣는 사람도 이해할 수 있게 초등학생에게 설명하듯 3문장으로 설명해줘.</code></pre>

<h2>프롬프트를 더 잘 쓰는 5가지 요령</h2>
<ol>
<li><strong>한 번에 끝내려 하지 마세요</strong>: 초안을 받은 뒤 "더 짧게", "표로", "근거를 추가해서"처럼 후속 지시로 다듬으세요.</li>
<li><strong>예시를 주세요</strong>: 원하는 문체의 예시 문장을 하나 보여주면 결과가 훨씬 비슷해집니다.</li>
<li><strong>제약을 명시하세요</strong>: 글자 수, 문단 수, 말투, 포함할 키워드를 구체적으로 적으세요.</li>
<li><strong>결과를 반드시 검토하세요</strong>: AI는 그럴듯하게 틀린 말을 할 수 있습니다. 숫자·고유명사·법률·의학 정보는 반드시 직접 확인하세요.</li>
<li><strong>좋았던 프롬프트는 저장하세요</strong>: 메모 앱이나 노션에 모아 두면 나만의 프롬프트 라이브러리가 됩니다.</li>
</ol>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 무료 버전으로도 이 프롬프트를 쓸 수 있나요?</h3>
<p>네, 대부분 무료 버전에서도 사용할 수 있습니다. 다만 긴 문서 처리나 복잡한 분석은 유료 모델이 더 안정적일 수 있습니다.</p>

<h3>Q2. 회사 자료를 넣어도 되나요?</h3>
<p>회사의 보안 정책을 먼저 확인하세요. 개인정보, 영업 기밀, 계약 내용 등은 입력하지 않거나, 가명 처리해서 사용하는 것이 안전합니다.</p>

<h3>Q3. 같은 프롬프트인데 매번 답이 달라요.</h3>
<p>AI는 같은 질문에도 조금씩 다른 답을 내는 특성이 있습니다. 형식과 제약을 구체적으로 지정할수록 결과의 편차가 줄어듭니다.</p>

<h3>Q4. ChatGPT 말고 다른 AI에도 쓸 수 있나요?</h3>
<p>네, Claude, Gemini 같은 다른 대화형 AI에도 거의 그대로 사용할 수 있습니다.</p>

<h2>마치며</h2>
<p>프롬프트는 외우는 것이 아니라 <strong>내 업무에 맞게 바꿔 쓰는 틀</strong>입니다. 이 글의 30개 중 오늘 업무에 쓸 수 있는 것 두세 개만 골라서 먼저 써 보세요. 하루 30분만 절약해도 한 달이면 10시간이 넘습니다. 이 글을 북마크해 두고 필요할 때마다 꺼내 쓰세요.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  'draft',
  'ko',
  '2026-10-19T16:28:00+09:00',
  '2026-10-19T18:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 5: 깃허브(GitHub) 입문 — 커밋·푸시
-- 카테고리: 웹 개발 (web-dev) | 상태: 임시저장(draft) - 이미지 대기
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  '깃허브(GitHub) 입문 — Git 설치부터 커밋·푸시까지 비전공자도 따라 하는 방법',
  'github-for-beginners-commit-push',
  'Git과 GitHub가 뭔지, 어떻게 쓰는지 막막하신가요? Git 설치, GitHub 가입, 저장소 만들기, 커밋과 푸시, 자주 만나는 오류 해결까지 비전공자 눈높이로 따라 할 수 있게 정리했습니다.',
  '/blog/github-for-beginners-commit-push/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: <strong>Git</strong>은 내 컴퓨터에서 코드의 변경 이력을 기록하는 도구이고, <strong>GitHub</strong>는 그 기록을 인터넷에 안전하게 보관하는 저장소입니다. <code>add → commit → push</code> 세 단계만 익히면 입문은 끝입니다.</p>

<h2>Git과 GitHub, 뭐가 다른가요?</h2>
<p>이름이 비슷해 헷갈리지만 역할이 다릅니다.</p>
<table>
<thead><tr><th>구분</th><th>Git</th><th>GitHub</th></tr></thead>
<tbody>
<tr><td>정체</td><td>버전 관리 프로그램</td><td>Git 저장소를 올려두는 웹 서비스</td></tr>
<tr><td>위치</td><td>내 컴퓨터</td><td>인터넷(클라우드)</td></tr>
<tr><td>하는 일</td><td>변경 이력 기록, 이전 상태로 되돌리기</td><td>백업, 공유, 협업, 자동 배포 연동</td></tr>
<tr><td>비유</td><td>게임의 저장 기능</td><td>저장 파일을 올려두는 클라우드</td></tr>
</tbody>
</table>
<p>"작업하다가 망가졌을 때 어제 상태로 돌아갈 수 있다"는 것이 가장 큰 장점입니다. 또한 Vercel, Cloudflare 같은 배포 서비스는 GitHub에 푸시하면 자동으로 사이트를 업데이트해 줍니다. 배포 방법은 <a href="/ko/blog/deploy-blog-to-vercel">Vercel로 블로그 배포하기</a>에서 이어서 확인하세요.</p>

<h2>1단계. Git 설치하기</h2>
<ol>
<li><a href="https://git-scm.com/downloads" target="_blank" rel="noopener noreferrer">git-scm.com</a>에서 내 운영체제에 맞는 설치 파일을 받습니다.</li>
<li>Windows는 설치 중 나오는 옵션을 모두 기본값으로 두고 <strong>Next</strong>를 눌러 진행해도 됩니다.</li>
<li>설치가 끝나면 터미널(또는 VS Code의 터미널)에서 아래 명령으로 확인합니다.</li>
</ol>
<pre><code>git --version</code></pre>
<p>버전 번호가 출력되면 설치 성공입니다. VS Code 사용이 처음이라면 <a href="/ko/blog/vscode-setup-first-code">VS Code 설치와 첫 코드 작성</a>을 먼저 보고 오시면 편합니다.</p>

<h2>2단계. 내 정보 등록하기 (처음 한 번만)</h2>
<p>커밋 기록에 "누가 수정했는지"가 남도록 이름과 이메일을 등록합니다.</p>
<pre><code>git config --global user.name "내이름"
git config --global user.email "내이메일@example.com"</code></pre>
<p>이메일은 GitHub 계정에 등록한 주소와 같게 하는 것이 좋습니다. 같아야 내 활동 기록(잔디)에 정상 반영됩니다.</p>

<h2>3단계. GitHub 가입하고 저장소 만들기</h2>
<ol>
<li><a href="https://github.com" target="_blank" rel="noopener noreferrer">github.com</a>에서 무료 계정을 만듭니다.</li>
<li>오른쪽 위 <strong>+</strong> 버튼에서 <strong>New repository</strong>를 선택합니다.</li>
<li>저장소 이름(예: <code>my-blog</code>)을 입력합니다.</li>
<li>공개 범위를 선택합니다. 연습용이나 개인 자료는 <strong>Private</strong>을 권장합니다.</li>
<li><strong>Create repository</strong>를 누르면 저장소 주소(<code>https://github.com/내아이디/my-blog.git</code>)가 나옵니다.</li>
</ol>

<h2>4단계. 내 프로젝트를 GitHub에 올리기</h2>
<p>프로젝트 폴더에서 터미널을 열고 아래 명령을 <strong>순서대로</strong> 실행합니다.</p>
<pre><code># 1. 이 폴더를 Git이 관리하도록 시작
git init

# 2. 모든 변경 파일을 "올릴 후보"로 담기
git add .

# 3. 변경 내용을 기록으로 남기기 (메시지는 자유롭게)
git commit -m "첫 번째 커밋"

# 4. 기본 브랜치 이름을 main으로 설정
git branch -M main

# 5. GitHub 저장소 주소 연결
git remote add origin https://github.com/내아이디/my-blog.git

# 6. GitHub로 올리기
git push -u origin main</code></pre>
<p>처음 push할 때 로그인 창이 뜨면 GitHub 계정으로 로그인하세요. 성공하면 GitHub 저장소 페이지를 새로고침했을 때 내 파일들이 보입니다.</p>

<h2>add, commit, push 한 번에 이해하기</h2>
<table>
<thead><tr><th>명령</th><th>하는 일</th><th>비유</th></tr></thead>
<tbody>
<tr><td><code>git add</code></td><td>저장할 파일을 선택해서 담기</td><td>택배 상자에 물건 담기</td></tr>
<tr><td><code>git commit</code></td><td>담은 내용을 하나의 기록으로 확정</td><td>상자 포장하고 송장 쓰기</td></tr>
<tr><td><code>git push</code></td><td>기록을 GitHub로 전송</td><td>택배 발송</td></tr>
</tbody>
</table>
<p>이후 코드를 수정할 때마다 <code>git add .</code> → <code>git commit -m "수정 내용"</code> → <code>git push</code> 세 줄만 반복하면 됩니다.</p>

<h2>자주 쓰는 Git 명령어 모음</h2>
<table>
<thead><tr><th>명령</th><th>설명</th></tr></thead>
<tbody>
<tr><td><code>git status</code></td><td>지금 어떤 파일이 바뀌었는지 확인</td></tr>
<tr><td><code>git log --oneline</code></td><td>커밋 기록을 한 줄씩 보기</td></tr>
<tr><td><code>git diff</code></td><td>무엇이 어떻게 바뀌었는지 상세 비교</td></tr>
<tr><td><code>git pull</code></td><td>GitHub의 최신 내용을 내 컴퓨터로 가져오기</td></tr>
<tr><td><code>git clone 주소</code></td><td>GitHub 저장소를 내 컴퓨터에 통째로 복사</td></tr>
</tbody>
</table>

<h2>꼭 지켜야 할 보안 습관: .gitignore</h2>
<p>비밀번호, API 키, 환경 변수 파일(<code>.env.local</code> 등)은 <strong>절대 GitHub에 올리면 안 됩니다</strong>. 특히 공개 저장소에 올라간 키는 순식간에 악용될 수 있습니다. 프로젝트 최상위에 <code>.gitignore</code> 파일을 만들고 아래처럼 올리지 않을 파일을 적어 두세요.</p>
<pre><code>node_modules/
.env
.env.local
.next/</code></pre>
<p>이미 실수로 올렸다면 해당 키를 즉시 <strong>폐기하고 새로 발급</strong>받으세요. 파일만 삭제해도 과거 커밋 기록에 남아 있기 때문입니다.</p>

<h2>자주 만나는 오류와 해결법</h2>
<table>
<thead><tr><th>오류 메시지</th><th>원인</th><th>해결</th></tr></thead>
<tbody>
<tr><td>fatal: not a git repository</td><td>git init을 하지 않은 폴더</td><td>프로젝트 폴더에서 <code>git init</code> 실행</td></tr>
<tr><td>remote origin already exists</td><td>이미 주소가 연결됨</td><td><code>git remote set-url origin 새주소</code></td></tr>
<tr><td>Authentication failed</td><td>로그인·인증 실패</td><td>브라우저 로그인 재시도 또는 개인용 액세스 토큰 사용</td></tr>
<tr><td>rejected (non-fast-forward)</td><td>GitHub에 내 컴퓨터에 없는 변경이 있음</td><td><code>git pull</code> 후 다시 push</td></tr>
<tr><td>nothing to commit</td><td>변경된 파일이 없음</td><td>정상 상태, 수정 후 다시 시도</td></tr>
</tbody>
</table>
<p>GitHub는 비밀번호 방식 인증을 중단하고, 브라우저 로그인이나 <strong>개인용 액세스 토큰(PAT)</strong>을 사용하도록 하고 있습니다. 푸시할 때 비밀번호를 물어도 계정 비밀번호가 통하지 않는 이유입니다.</p>

<h2>명령어가 어렵다면: GUI 도구 쓰기</h2>
<p>터미널이 부담스럽다면 마우스로 할 수 있는 도구도 있습니다.</p>
<ul>
<li><strong>VS Code 소스 제어 탭</strong>: 왼쪽의 분기 아이콘에서 변경 파일 확인, 메시지 입력 후 커밋·푸시</li>
<li><strong>GitHub Desktop</strong>: 공식 무료 프로그램으로 가장 초보자 친화적</li>
</ul>
<p>다만 명령어 몇 개는 알아두는 것이 문제가 생겼을 때 훨씬 도움이 됩니다.</p>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. GitHub는 유료인가요?</h3>
<p>개인 사용은 무료로 충분합니다. 비공개(Private) 저장소도 무료 계정에서 만들 수 있습니다.</p>

<h3>Q2. 커밋 메시지는 어떻게 쓰나요?</h3>
<p>"무엇을 바꿨는지"를 짧게 쓰면 됩니다. 예: "메인 페이지 이미지 추가", "댓글 오류 수정". 나중에 기록을 볼 때 큰 도움이 됩니다.</p>

<h3>Q3. push를 잘못했어요. 되돌릴 수 있나요?</h3>
<p>가능은 하지만 초보자에게는 어려울 수 있습니다. 중요한 작업 전에는 항상 커밋을 자주 남기고, 모르는 상황에서는 무리하게 강제 푸시(<code>--force</code>)를 하지 마세요.</p>

<h3>Q4. 비전공자도 꼭 배워야 하나요?</h3>
<p>코드를 만든다면 강력히 권합니다. 백업, 되돌리기, 자동 배포까지 한 번에 해결되기 때문입니다.</p>

<h2>마치며: 오늘의 3줄 정리</h2>
<ol>
<li>Git은 기록 도구, GitHub는 인터넷 보관소다.</li>
<li>수정할 때마다 <code>add → commit → push</code>를 반복한다.</li>
<li>비밀 키(.env)는 절대 올리지 않는다.</li>
</ol>
<p>처음에는 명령어가 낯설지만 열 번만 반복하면 손에 익습니다. 오늘 작은 프로젝트 하나를 만들어 GitHub에 올려보세요. 그 순간부터 내 코드가 안전하게 보관되는 개발자의 첫걸음이 시작됩니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  'draft',
  'ko',
  '2026-10-19T16:30:00+09:00',
  '2026-10-19T19:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트-태그 연결 (post_tags)
-- ═══════════════════════════════════════════════

-- 포스트 2: 네이버 서치어드바이저
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'naver-search-advisor-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'seo')),
  ((SELECT id FROM posts WHERE slug = 'naver-search-advisor-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog')),
  ((SELECT id FROM posts WHERE slug = 'naver-search-advisor-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'adsense'))
ON CONFLICT DO NOTHING;

-- 포스트 3: GA4 설치
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'ga4-install-nextjs-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'seo')),
  ((SELECT id FROM posts WHERE slug = 'ga4-install-nextjs-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs')),
  ((SELECT id FROM posts WHERE slug = 'ga4-install-nextjs-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog'))
ON CONFLICT DO NOTHING;

-- 포스트 4: ChatGPT 프롬프트 30선
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'chatgpt-prompts-for-work-30' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'chatgpt')),
  ((SELECT id FROM posts WHERE slug = 'chatgpt-prompts-for-work-30' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'chatgpt-prompts-for-work-30' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity')),
  ((SELECT id FROM posts WHERE slug = 'chatgpt-prompts-for-work-30' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'excel'))
ON CONFLICT DO NOTHING;

-- 포스트 5: 깃허브 입문
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'github-for-beginners-commit-push' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'dev-environment')),
  ((SELECT id FROM posts WHERE slug = 'github-for-beginners-commit-push' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev')),
  ((SELECT id FROM posts WHERE slug = 'github-for-beginners-commit-push' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'vscode')),
  ((SELECT id FROM posts WHERE slug = 'github-for-beginners-commit-push' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'deployment'))
ON CONFLICT DO NOTHING;
