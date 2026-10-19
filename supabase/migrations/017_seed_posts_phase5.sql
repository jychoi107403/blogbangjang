-- =============================================
-- 017_seed_posts_phase5.sql
-- Phase 5: 검색 유입 확대용 롱테일 키워드 글
-- 현재 수록: 1편 (구글 서치콘솔 등록·색인 요청 방법)
-- ※ Supabase SQL Editor에서 실행하세요 (여러 번 실행해도 안전: ON CONFLICT)
-- ※ 이미지는 public/blog/<슬러그>/ 폴더의 WebP 파일을 사용합니다
-- =============================================


-- ═══════════════════════════════════════════════
-- 포스트 1: 구글 서치콘솔 등록·색인 요청 방법
-- 카테고리: 수익화 (monetization) | 발행일: 2026-10-19
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  '구글 서치콘솔 등록 방법 총정리 — 블로그 글이 검색에 안 나올 때 색인 요청하는 법',
  'google-search-console-guide',
  '블로그 글을 올렸는데 구글에 검색되지 않나요? 구글 서치콘솔 등록부터 사이트맵 제출, 색인 생성 요청, "색인이 생성되지 않음" 오류 해결까지 따라 하기만 하면 되는 순서로 정리했습니다.',
  '/blog/google-search-console-guide/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: 구글 서치콘솔에 사이트를 등록하고(소유권 확인) → 사이트맵을 제출한 뒤 → 새 글마다 URL 검사에서 "색인 생성 요청"을 누르면, 검색에 노출되기까지 걸리는 시간을 크게 줄일 수 있습니다. 비용은 무료이고 처음 설정에는 15분이면 충분합니다.</p>

<h2>구글 서치콘솔이 뭐길래 꼭 해야 하나요?</h2>
<p>구글 서치콘솔(Google Search Console)은 내 사이트가 구글 검색에서 어떻게 보이는지 알려주는 <strong>구글 공식 무료 도구</strong>입니다. 블로그를 만들고 글을 올려도, 구글 로봇(크롤러)이 내 글을 발견해 저장(색인)하지 않으면 검색 결과에는 절대 나타나지 않습니다. 서치콘솔은 이 과정을 직접 확인하고 도와주는 창구입니다.</p>
<p>서치콘솔로 할 수 있는 일은 크게 네 가지입니다.</p>
<ul>
<li><strong>색인 상태 확인</strong>: 내 글이 구글에 저장되었는지, 안 되었다면 이유가 무엇인지 확인</li>
<li><strong>색인 생성 요청</strong>: 새 글을 구글 로봇에게 "빨리 와서 봐주세요"라고 요청</li>
<li><strong>검색어 분석</strong>: 사람들이 어떤 검색어로 내 글에 들어왔는지, 노출·클릭·평균 순위 확인</li>
<li><strong>문제 알림</strong>: 모바일 사용성, 보안 문제 등 오류를 메일로 안내</li>
</ul>
<p>특히 신규 블로그는 구글이 사이트의 존재를 알기까지 몇 주가 걸리기도 합니다. 서치콘솔 등록은 그 기간을 줄이는 가장 확실한 방법입니다.</p>

<h2>1단계. 서치콘솔에 사이트 등록하기</h2>
<p><a href="https://search.google.com/search-console" target="_blank" rel="noopener noreferrer">구글 서치콘솔</a>에 접속해 구글 계정으로 로그인한 뒤, 왼쪽 위 속성 선택 메뉴에서 <strong>속성 추가</strong>를 누르면 두 가지 방식 중 하나를 고르게 됩니다.</p>
<table>
<thead><tr><th>방식</th><th>특징</th><th>추천 대상</th></tr></thead>
<tbody>
<tr><td>도메인</td><td>하위 도메인(www 등)과 http/https를 한 번에 관리, <strong>DNS 설정 필요</strong></td><td>내 도메인을 직접 구매해 DNS를 관리할 수 있는 경우</td></tr>
<tr><td>URL 접두어</td><td>입력한 주소 하나만 관리, 소유권 확인 방법이 다양</td><td>처음 시작하는 초보자 (설정이 쉬움)</td></tr>
</tbody>
</table>
<p>도메인을 직접 구매했다면 <strong>도메인 방식</strong>을 권장합니다. 주소가 www 유무나 http/https로 나뉘어도 데이터가 한곳에 모이기 때문입니다.</p>

<figure>
<img src="/blog/google-search-console-guide/01.webp" alt="웹사이트 소유권을 DNS 레코드로 인증하는 과정을 표현한 방패와 체크 표시 일러스트" width="960" height="540" />
<figcaption>소유권 확인은 "이 사이트의 주인이 맞다"는 것을 구글에 증명하는 절차입니다.</figcaption>
</figure>

<h3>도메인 방식: DNS TXT 레코드로 소유권 확인</h3>
<ol>
<li>속성 유형에서 <strong>도메인</strong>을 선택하고 내 도메인(예: <code>example.com</code>)을 입력한 뒤 <strong>계속</strong>을 누릅니다.</li>
<li>화면에 <code>google-site-verification=</code>으로 시작하는 TXT 레코드 값이 나타납니다. <strong>복사</strong>를 눌러 저장해 둡니다.</li>
<li>도메인을 관리하는 곳(Cloudflare, 가비아, 후이즈 등)의 DNS 설정 화면으로 이동합니다.</li>
<li>레코드를 추가합니다. 유형은 <strong>TXT</strong>, 이름은 <strong>@</strong>(또는 비워 둠), 값은 방금 복사한 문자열을 붙여 넣습니다.</li>
<li>저장 후 서치콘솔로 돌아와 <strong>확인</strong>을 누릅니다.</li>
</ol>
<p>DNS 변경이 반영되는 데 몇 분에서 길게는 몇 시간이 걸릴 수 있습니다. 바로 실패 메시지가 뜨더라도 당황하지 말고 잠시 뒤 다시 눌러보세요.</p>

<h3>URL 접두어 방식: HTML 태그로 확인</h3>
<p>DNS 설정이 어렵다면 URL 접두어 방식을 쓰고, 소유권 확인 방법으로 <strong>HTML 태그</strong>를 선택합니다. 구글이 알려주는 <code>&lt;meta name="google-site-verification" content="..." /&gt;</code> 한 줄을 사이트의 <code>&lt;head&gt;</code> 안에 넣고 배포한 뒤 확인을 누르면 끝입니다. Google Analytics(GA4)나 Google 태그 관리자를 이미 설치했다면 별도 작업 없이 그것으로 확인할 수도 있습니다.</p>

<h2>2단계. 사이트맵 제출하기</h2>
<p>사이트맵은 "내 사이트에 이런 글들이 있어요"를 목록으로 정리한 파일입니다. 구글 로봇이 새 글을 빠짐없이 찾을 수 있게 도와줍니다. 대부분의 블로그 플랫폼과 프레임워크는 <code>/sitemap.xml</code> 주소로 사이트맵을 자동 생성합니다.</p>
<ol>
<li>서치콘솔 왼쪽 메뉴에서 <strong>Sitemaps</strong>(사이트맵)를 선택합니다.</li>
<li>"새 사이트맵 추가" 칸에 <code>sitemap.xml</code>을 입력하고 <strong>제출</strong>을 누릅니다.</li>
<li>상태가 <strong>성공</strong>으로 표시되면 완료입니다. "가져올 수 없음"이 나오면 브라우저에서 <code>내주소/sitemap.xml</code>이 실제로 열리는지 먼저 확인하세요.</li>
</ol>
<p>사이트맵을 한 번 제출해 두면 이후 새 글은 로봇이 알아서 다시 확인합니다. 다만 즉시 반영되는 것은 아니므로, 중요한 글은 아래 3단계로 직접 요청하는 것이 좋습니다.</p>

<figure>
<img src="/blog/google-search-console-guide/02.webp" alt="사이트맵에 정리된 여러 페이지가 검색 엔진 로봇에게 전달되는 색인 요청 일러스트" width="960" height="540" loading="lazy" />
<figcaption>사이트맵을 제출하면 구글 로봇이 내 사이트의 글을 한꺼번에 파악할 수 있습니다.</figcaption>
</figure>

<h2>3단계. 새 글 색인 생성 요청하기 (가장 중요!)</h2>
<p>새 글을 발행한 뒤 아래 순서대로 요청하면, 보통 며칠에서 1~2주 걸리던 색인이 훨씬 빨라지는 경우가 많습니다. (구글이 보장하는 시간은 아니므로 결과는 사이트마다 다를 수 있습니다.)</p>
<ol>
<li>서치콘솔 화면 맨 위 검색창에 <strong>새 글의 전체 주소(URL)</strong>를 붙여 넣고 Enter를 누릅니다.</li>
<li>"URL이 Google에 등록되어 있지 않음"이라고 나오면 아직 색인되지 않은 상태입니다.</li>
<li><strong>색인 생성 요청</strong> 버튼을 누릅니다. 1~2분 정도 라이브 테스트가 진행됩니다.</li>
<li>"색인 생성 요청됨" 메시지가 뜨면 완료입니다.</li>
</ol>
<p>하루에 요청할 수 있는 개수에는 제한이 있으므로(대략 10개 안팎), 신규 글이나 크게 수정한 글 위주로 요청하는 것을 권장합니다. 같은 URL을 반복해서 요청한다고 더 빨리 처리되지는 않습니다.</p>

<h2>"색인이 생성되지 않음"이 뜰 때 원인과 해결법</h2>
<p>서치콘솔의 <strong>페이지</strong>(색인 생성) 메뉴에서는 색인되지 않은 페이지와 그 이유를 볼 수 있습니다. 자주 만나는 상태는 다음과 같습니다.</p>
<table>
<thead><tr><th>상태 메시지</th><th>의미</th><th>해결 방법</th></tr></thead>
<tbody>
<tr><td>발견됨 - 현재 색인이 생성되지 않음</td><td>주소는 알지만 아직 로봇이 방문하지 않음</td><td>시간이 지나면 해결되는 경우가 많음. 내부 링크를 늘리고 색인 요청</td></tr>
<tr><td>크롤링됨 - 현재 색인이 생성되지 않음</td><td>방문은 했지만 품질 등의 이유로 저장하지 않음</td><td>글 내용을 보강(분량·고유한 정보·이미지)하고 재요청</td></tr>
<tr><td>noindex 태그에 의해 제외됨</td><td>페이지에 "색인하지 말라"는 설정이 있음</td><td>메타 태그의 <code>noindex</code> 설정을 제거</td></tr>
<tr><td>robots.txt에 의해 차단됨</td><td>robots.txt가 로봇의 접근을 막고 있음</td><td>robots.txt에서 해당 경로의 Disallow 제거</td></tr>
<tr><td>중복 페이지 / 대표 페이지 없음</td><td>비슷한 페이지가 여럿이라 하나만 선택됨</td><td>canonical 주소를 올바르게 지정</td></tr>
</tbody>
</table>
<p>신규 블로그에서 가장 흔한 것은 앞의 두 가지입니다. 이 경우 요청 버튼만 반복해서 누르기보다, <strong>글의 품질을 올리고 다른 글에서 이 글로 연결되는 링크</strong>를 만들어 주는 편이 효과적입니다.</p>

<h2>서치콘솔 데이터 보는 법: 이것만 챙기세요</h2>
<p>서치콘솔의 <strong>실적</strong> 메뉴에서는 네 가지 숫자를 볼 수 있습니다.</p>
<ul>
<li><strong>총 클릭수</strong>: 검색 결과에서 내 글을 눌러 들어온 횟수</li>
<li><strong>총 노출수</strong>: 검색 결과에 내 글이 표시된 횟수</li>
<li><strong>평균 CTR</strong>: 노출 대비 클릭 비율 (제목과 요약이 매력적일수록 높아짐)</li>
<li><strong>평균 게재 순위</strong>: 검색 결과에서 내 글이 평균 몇 번째에 보였는지</li>
</ul>
<p>초기에는 클릭이 거의 없어도 <strong>노출수가 늘고 있다면 잘 가고 있는 것</strong>입니다. 아래 표를 참고해 다음 행동을 정해 보세요.</p>
<table>
<thead><tr><th>상황</th><th>의미</th><th>할 일</th></tr></thead>
<tbody>
<tr><td>노출 많음, 클릭 적음</td><td>순위는 되는데 제목이 끌리지 않음</td><td>제목·요약(메타 설명)을 검색어에 맞게 수정</td></tr>
<tr><td>평균 순위 11~20위</td><td>2페이지에 걸려 있음</td><td>글을 보강하고 관련 글끼리 내부 링크 연결</td></tr>
<tr><td>노출 자체가 없음</td><td>색인이 안 되었거나 키워드 경쟁이 심함</td><td>색인 상태 확인, 더 구체적인 키워드로 글 작성</td></tr>
</tbody>
</table>
<p>검색어(쿼리) 목록에서 이미 노출되고 있는 키워드를 찾아, 그 키워드를 더 자세히 다루는 글을 추가로 쓰는 것도 좋은 전략입니다. 블로그 방문자를 늘리는 전반적인 방법은 <a href="/ko/blog/blog-seo-traffic-growth-guide">블로그 SEO 트래픽 늘리기 가이드</a>에서, 블로그 플랫폼 선택 기준은 <a href="/ko/blog/blog-platform-comparison-for-adsense">애드센스를 위한 블로그 플랫폼 비교</a>에서 확인하실 수 있습니다.</p>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 서치콘솔에 등록하면 바로 검색에 노출되나요?</h3>
<p>아닙니다. 등록은 구글에 "내 사이트를 봐주세요"라고 알리는 단계이고, 실제 색인과 노출까지는 보통 며칠에서 몇 주가 걸립니다. 신규 도메인은 더 오래 걸릴 수 있으므로 꾸준히 글을 올리면서 기다리는 것이 중요합니다.</p>

<h3>Q2. 색인 생성 요청을 했는데 며칠이 지나도 안 돼요.</h3>
<p>요청은 "우선순위를 높여 달라"는 신호일 뿐 색인을 보장하지 않습니다. 구글이 글의 품질이나 중복 여부를 판단해 저장하지 않을 수도 있습니다. 글 분량과 고유한 정보를 보강하고, 다른 글에서 해당 글로 내부 링크를 걸어 주세요.</p>

<h3>Q3. 네이버에서도 검색되게 하려면 어떻게 하나요?</h3>
<p>네이버는 별도로 <strong>네이버 서치어드바이저</strong>에 사이트를 등록하고 사이트맵과 RSS를 제출해야 합니다. 구글 서치콘솔과 방식이 비슷하니 둘 다 등록해 두시길 권장합니다.</p>

<h3>Q4. 서치콘솔 등록이 애드센스 승인에 도움이 되나요?</h3>
<p>직접적인 승인 조건은 아니지만, 사이트가 구글에 제대로 색인되어 있고 오류가 없는지 확인할 수 있어 간접적으로 도움이 됩니다. 색인이 되지 않는 사이트는 심사에서도 불리할 수 있습니다.</p>

<h2>마치며: 오늘 바로 해볼 체크리스트</h2>
<ol>
<li>서치콘솔에 사이트 등록 및 소유권 확인</li>
<li><code>sitemap.xml</code> 제출 후 상태 "성공" 확인</li>
<li>새 글 발행 후 URL 검사에서 색인 생성 요청</li>
<li>일주일 뒤 <strong>실적</strong> 메뉴에서 노출수 확인</li>
<li>노출되는 검색어를 보고 다음 글 주제 정하기</li>
</ol>
<p>서치콘솔은 한 번 설정해 두면 계속 쓸 수 있는 무료 도구입니다. 오늘 15분만 투자해 등록해 두고, 새 글을 올릴 때마다 색인 요청하는 습관을 만들어 보세요. 시간이 지나면 어떤 검색어로 사람들이 찾아오는지 눈으로 확인하는 재미도 생길 것입니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'monetization'),
  'published',
  'ko',
  '2026-10-19T15:50:00+09:00',
  '2026-10-19T16:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트-태그 연결 (post_tags)
-- ═══════════════════════════════════════════════

-- 포스트 1: 구글 서치콘솔 등록 방법
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'google-search-console-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'seo')),
  ((SELECT id FROM posts WHERE slug = 'google-search-console-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog')),
  ((SELECT id FROM posts WHERE slug = 'google-search-console-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'adsense'))
ON CONFLICT DO NOTHING;
