-- =============================================
-- 012_seed_posts_phase1.sql
-- Phase 1: 블로그 포스트 8편 삽입
-- ★ 발행일을 9/2 ~ 9/23 (약 3주)에 걸쳐 분산
-- ★ created_at은 published_at보다 1~2일 앞서 설정 (자연스러운 작성 흐름)
-- ※ 반드시 011_seed_base_data.sql 실행 후에 실행하세요
-- =============================================

-- ═══════════════════════════════════════════════
-- 포스트 1: 왜 티스토리 대신 직접 블로그를 만들었을까?
-- 카테고리: 웹 개발 | 시리즈: 블로그 만들기 #1
-- 발행일: 2026-09-02
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '왜 티스토리 대신 직접 블로그를 만들었을까?',
  'why-i-built-my-own-blog',
  '티스토리, 워드프레스 대신 Next.js로 블로그를 직접 만든 이유. 비용, 시간, 장단점을 솔직하게 공유합니다.',
  $content$<h2>블로그를 시작하게 된 계기</h2>
<p>솔직히 말하면, 처음에는 티스토리로 블로그를 시작했습니다. 가입하고, 스킨 고르고, 글 쓰기 시작하니까 10분도 안 걸렸죠. "이게 바로 블로그의 매력이구나!" 하고 감탄했습니다.</p>
<p>그런데 시간이 지나면서 불만이 쌓이기 시작했습니다. 스킨을 내 맘대로 수정하고 싶은데 한계가 있고, 광고 배치도 플랫폼이 정한 대로만 할 수 있었죠. 무엇보다 <strong>내 콘텐츠가 남의 플랫폼 위에 있다</strong>는 느낌이 점점 불편해졌습니다.</p>

<h2>기존 블로그 플랫폼의 한계</h2>
<p>제가 느낀 기존 플랫폼의 한계를 정리하면 이렇습니다:</p>
<ul>
<li><strong>디자인 자유도 부족</strong> — 스킨 안에서만 커스터마이징이 가능합니다. CSS를 좀 안다고 해도 구조적인 변경은 불가능하죠.</li>
<li><strong>수익화 제한</strong> — 애드센스를 붙일 수 있지만, 위치나 크기를 세밀하게 제어하기 어렵습니다.</li>
<li><strong>플랫폼 종속성</strong> — 티스토리가 정책을 바꾸거나 서비스를 종료하면? 내 글이 위험해집니다. 실제로 여러 블로그 서비스가 갑자기 종료된 사례가 있습니다.</li>
<li><strong>SEO 한계</strong> — 자체 도메인 설정, 메타태그 세밀한 최적화 등에 한계가 있습니다.</li>
</ul>

<h2>직접 만들기로 결심한 순간</h2>
<p>결정적인 계기는 한 개발 블로그를 읽다가 "이 사이트 뭘로 만들었지?" 하고 찾아본 것이었습니다. Next.js라는 프레임워크로 만들었더라고요. 속도도 빠르고, 디자인도 자유롭고, 무엇보다 <strong>내 서버에 내 코드로 운영</strong>하는 게 멋있어 보였습니다.</p>
<p>"나도 해볼까?" 라는 생각이 드는 순간, 바로 시작했습니다. 물론 쉽지는 않았습니다. 코딩 경험이 거의 없는 상태에서 시작했으니까요. 하지만 하나씩 배워가는 과정 자체가 재미있었습니다.</p>

<h2>실제로 들어간 비용과 시간</h2>
<p>결론부터 말하면, 금전적 비용은 거의 <strong>0원</strong>에 가깝습니다:</p>
<ul>
<li><strong>Vercel (호스팅)</strong> — 무료 플랜으로 충분합니다. 개인 프로젝트에는 넉넉한 트래픽이 제공됩니다.</li>
<li><strong>Supabase (데이터베이스)</strong> — 무료 티어로 블로그 운영에 필요한 모든 것을 커버합니다.</li>
<li><strong>도메인</strong> — 연 1~2만원 정도. 없어도 vercel.app 도메인으로 운영 가능합니다.</li>
</ul>
<p>다만 시간 투자는 꽤 필요했습니다. 매일 퇴근 후 2시간씩, 약 3주 정도 걸렸습니다. 하지만 그 시간 동안 HTML, CSS, JavaScript, React, Next.js의 기초를 자연스럽게 배울 수 있었으니 투자 대비 효과는 훌륭했다고 생각합니다.</p>

<h2>직접 만든 블로그의 장점</h2>
<p>지금 이 블로그가 바로 그 결과물입니다. 직접 만들어보니 이런 점이 좋습니다:</p>
<ul>
<li>디자인을 100% 내 마음대로 할 수 있습니다</li>
<li>다국어 지원(한국어/영어)도 직접 구현했습니다</li>
<li>SEO를 원하는 대로 최적화할 수 있습니다</li>
<li>광고 위치를 자유롭게 배치할 수 있습니다</li>
<li>무엇보다 <strong>개발 실력이 정말 많이 늘었습니다</strong></li>
</ul>

<h2>마치며</h2>
<p>모든 분에게 직접 만들기를 추천하는 건 아닙니다. 글 쓰기에만 집중하고 싶다면 티스토리나 워드프레스도 훌륭한 선택입니다. 하지만 저처럼 "내 것"을 만들고 싶고, 개발도 배우고 싶다면 — 직접 만들어보세요. 생각보다 어렵지 않습니다!</p>
<p>다음 글에서는 제가 선택한 기술 스택인 <strong>Next.js</strong>에 대해 왕초보도 이해할 수 있게 설명해볼게요. 요리에 비유해서 아주 쉽게 풀어보겠습니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'building-my-blog'),
  1,
  'published',
  'ko',
  '2026-09-01T20:00:00+09:00',
  '2026-09-02T09:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 2: 비전공자가 개발을 시작하며 느낀 솔직한 이야기
-- 카테고리: 일상 | 시리즈: 개발자 라이프스타일 #1
-- 발행일: 2026-09-05
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '비전공자가 개발을 시작하며 느낀 솔직한 이야기',
  'non-major-starting-dev',
  '비전공자가 코딩을 처음 시작하면서 겪은 어려움과 극복 과정. 코딩 독학 3개월의 솔직한 후기입니다.',
  $content$<h2>나는 왜 코딩을 시작했을까?</h2>
<p>전공은 경영학이었습니다. 코딩과는 전혀 관계없는 분야죠. 대학 시절에 엑셀 함수 좀 만져본 게 IT와의 유일한 접점이었습니다. 졸업 후 회사에 다니면서도 "개발자"는 완전히 다른 세계 사람이라고 생각했습니다.</p>
<p>그런데 어느 날, 반복되는 엑셀 작업에 지쳐서 "이걸 자동화할 수 없을까?" 하고 검색하다가 Python이라는 프로그래밍 언어를 알게 됐습니다. 10줄짜리 코드로 2시간 걸리던 작업을 10초 만에 끝내는 걸 보고 충격받았습니다.</p>
<p><strong>"이거... 배워야 한다."</strong></p>
<p>그 순간이 시작이었습니다.</p>

<h2>처음 3개월간 겪은 어려움</h2>
<p>코딩을 시작하면 누구나 겪는 벽이 있습니다. 저도 예외는 아니었어요.</p>
<ul>
<li><strong>용어의 장벽</strong> — 변수, 함수, 객체, 배열... 처음에는 하나하나가 외계어 같았습니다. 튜토리얼을 따라 하면서도 "이게 왜 이렇게 되는 건지" 이해가 안 될 때가 많았습니다.</li>
<li><strong>에러와의 전쟁</strong> — 코드를 쓰면 반은 에러였습니다. 빨간 글씨만 보면 심장이 쿵 하고 내려앉았죠. 세미콜론 하나 빠뜨려서 30분을 허비한 적도 있습니다.</li>
<li><strong>뭘 배워야 할지 모르는 혼란</strong> — Python을 배울까, JavaScript를 배울까, 아니면 HTML부터 시작할까? 정보가 너무 많아서 오히려 방향을 잡기 어려웠습니다.</li>
<li><strong>비교의 함정</strong> — 유튜브에서 "1주일 만에 앱 만들기" 같은 영상을 보면 나만 느린 것 같은 기분이 들었습니다.</li>
</ul>

<h2>어떻게 극복했을까?</h2>
<p>돌이켜보면 저를 가장 많이 도와준 건 이 세 가지였습니다.</p>

<h3>1. 작은 목표부터 시작하기</h3>
<p>"풀스택 개발자가 되겠다" 같은 거창한 목표 대신, <strong>"오늘은 버튼 하나 만들어보자"</strong>라는 아주 작은 목표를 세웠습니다. 작은 성공이 쌓이니 자신감이 붙더라고요.</p>

<h3>2. 프로젝트 중심 학습</h3>
<p>문법만 공부하면 지루해서 금방 포기하게 됩니다. 대신 "내 블로그를 만들자"라는 구체적인 프로젝트를 정하고, 필요한 것만 그때그때 배웠습니다. 이 방법이 저에게는 훨씬 효과적이었습니다.</p>

<h3>3. ChatGPT를 선생님으로 활용</h3>
<p>모르는 게 있으면 ChatGPT에게 물어봤습니다. "이 에러 메시지가 무슨 뜻이야?", "이 코드가 왜 안 돼?" 같은 질문을 하면 친절하게 설명해줍니다. 혼자 독학하는 분들에게는 최고의 도구라고 생각합니다.</p>

<h2>3개월 후 달라진 것들</h2>
<p>코딩을 시작한 지 3개월이 지난 지금, 제가 달라진 점을 정리해보면:</p>
<ul>
<li>이 블로그를 <strong>직접 설계하고 구축</strong>할 수 있게 됐습니다</li>
<li>업무에서 반복 작업을 <strong>자동화</strong>할 수 있게 됐습니다</li>
<li>문제가 생기면 "검색해서 해결하는 능력"이 크게 향상됐습니다</li>
<li>무엇보다 <strong>"나도 할 수 있구나"</strong>라는 자신감을 얻었습니다</li>
</ul>

<h2>비전공자에게 드리는 조언</h2>
<p>혹시 코딩을 시작할까 망설이고 계신 분이 있다면, 이 말씀을 드리고 싶습니다.</p>
<p><strong>전공은 중요하지 않습니다.</strong> 저도 비전공자이고, 지금도 부족한 게 많습니다. 하지만 "시작했다"는 것 자체가 이미 대단한 겁니다. 완벽하지 않아도 괜찮습니다. 어제보다 한 줄이라도 더 이해하면 그것으로 충분합니다.</p>
<p>다음 글에서는 제가 공부할 때 정말 도움이 됐던 무료 학습 자료와 루틴을 공유해볼게요.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'lifestyle'),
  (SELECT id FROM series WHERE slug = 'dev-lifestyle'),
  1,
  'published',
  'ko',
  '2026-09-04T21:30:00+09:00',
  '2026-09-05T10:30:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 3: Next.js가 뭔데? 왕초보가 이해한 방식으로 설명
-- 카테고리: 웹 개발 | 시리즈: 블로그 만들기 #2
-- 발행일: 2026-09-08
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'Next.js가 뭔데? 왕초보가 이해한 방식으로 설명',
  'what-is-nextjs-for-beginners',
  'Next.js를 요리에 비유해서 아주 쉽게 설명합니다. React와의 차이점, 장점, 왜 선택했는지 왕초보 눈높이로 풀어봤어요.',
  $content$<h2>Next.js를 요리에 비유하면</h2>
<p>프로그래밍 용어를 처음 접하면 "그래서 그게 뭔데?" 하는 순간이 반복됩니다. 저도 그랬습니다. 그래서 요리에 비유해서 설명해보겠습니다.</p>
<p>웹사이트를 만드는 건 <strong>요리를 하는 것</strong>과 비슷합니다:</p>
<ul>
<li><strong>HTML</strong> = 재료 (고기, 야채, 밥 등). 웹페이지의 뼈대를 이루는 요소들입니다.</li>
<li><strong>CSS</strong> = 플레이팅과 그릇. 같은 요리도 예쁜 접시에 담으면 다르죠? 디자인을 담당합니다.</li>
<li><strong>JavaScript</strong> = 조리 과정. 재료를 볶고, 끓이고, 굽는 것처럼 웹페이지에 움직임과 기능을 더합니다.</li>
<li><strong>React</strong> = 체계적인 레시피북. 요리(코드)를 효율적으로 관리하는 방법을 알려줍니다.</li>
<li><strong>Next.js</strong> = 풀옵션 주방 세트. 오븐, 냉장고, 식기세척기까지 다 갖춘 주방처럼, 웹 개발에 필요한 도구를 한꺼번에 제공합니다.</li>
</ul>
<p>즉, Next.js는 <strong>"웹사이트를 만들기 위한 올인원 도구 세트"</strong>라고 생각하시면 됩니다.</p>

<h2>React와 Next.js는 뭐가 다를까?</h2>
<p>많은 분들이 "React랑 Next.js는 뭐가 다른 건가요?" 하고 궁금해하십니다. 간단하게 설명하면:</p>
<ul>
<li><strong>React</strong>는 레시피(라이브러리)입니다. 요리법은 알려주지만, 주방은 직접 구해야 합니다.</li>
<li><strong>Next.js</strong>는 React를 기반으로 한 프레임워크입니다. 레시피도 있고, 주방(서버)도 제공하고, 배달(배포) 서비스까지 연결해줍니다.</li>
</ul>
<p>실제로 React만으로 웹사이트를 만들면 라우팅(페이지 이동), SEO 최적화, 서버 사이드 렌더링 등을 직접 설정해야 합니다. Next.js는 이런 것들을 <strong>기본으로 제공</strong>해줍니다.</p>

<h2>Next.js의 핵심 장점 4가지</h2>
<h3>1. 파일 기반 라우팅</h3>
<p>폴더를 만들면 자동으로 URL이 생깁니다. 예를 들어 <code>app/blog/page.tsx</code> 파일을 만들면 <code>/blog</code> 주소가 자동으로 생기는 거죠. 별도 설정이 필요 없어서 매우 편리합니다.</p>

<h3>2. SEO 최적화</h3>
<p>서버에서 페이지를 미리 만들어서 보내주기 때문에, 구글 같은 검색엔진이 내 글을 잘 찾을 수 있습니다. 블로그에는 정말 중요한 기능입니다.</p>

<h3>3. 빠른 속도</h3>
<p>Next.js는 필요한 부분만 로딩하는 똑똑한 방식을 사용합니다. 덕분에 페이지가 매우 빠르게 열립니다. 사용자 경험에 큰 차이를 만듭니다.</p>

<h3>4. Vercel과의 완벽한 연동</h3>
<p>Next.js를 만든 회사인 Vercel에서 무료 호스팅을 제공합니다. GitHub에 코드를 올리면 자동으로 배포됩니다. 서버 관리를 신경 쓸 필요가 없죠.</p>

<h2>왜 Next.js를 선택했을까?</h2>
<p>제가 블로그 기술 스택으로 Next.js를 선택한 결정적인 이유는 세 가지였습니다:</p>
<ul>
<li><strong>SEO가 중요했기 때문에</strong> — 블로그는 검색 유입이 핵심입니다. Next.js의 서버 사이드 렌더링은 이에 딱 맞습니다.</li>
<li><strong>무료로 운영 가능</strong> — Vercel 무료 플랜 + Supabase 무료 티어로 비용 0원 운영이 가능합니다.</li>
<li><strong>배울 게 많아서</strong> — React, TypeScript, 서버 컴포넌트 등 최신 웹 기술을 한 번에 경험할 수 있습니다.</li>
</ul>

<h2>마치며</h2>
<p>Next.js가 처음에는 어렵게 느껴질 수 있습니다. 저도 공식 문서를 읽으면서 모르는 단어가 너무 많아 답답했던 적이 한두 번이 아닙니다. 하지만 실제로 써보면 생각보다 직관적이고, 특히 블로그 같은 콘텐츠 중심 사이트에는 최적의 선택이라고 확신합니다.</p>
<p>다음 글에서는 이 블로그의 데이터를 저장하는 <strong>Supabase</strong>에 대해 이야기해볼게요. 무료로 백엔드를 구축하는 방법을 알려드리겠습니다!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'building-my-blog'),
  2,
  'published',
  'ko',
  '2026-09-07T19:00:00+09:00',
  '2026-09-08T09:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 4: 직장인이 ChatGPT를 써야 하는 진짜 이유 (2026년)
-- 카테고리: AI 활용 | 시리즈: 직장인 AI 활용법 #1
-- 발행일: 2026-09-11
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '직장인이 ChatGPT를 써야 하는 진짜 이유 (2026년)',
  'why-office-workers-need-chatgpt-2026',
  '직장인이 ChatGPT를 업무에 활용하면 얼마나 시간을 절약할 수 있을까? 실제 사용 사례와 함께 정리했습니다.',
  $content$<h2>AI를 쓰는 직장인 vs 안 쓰는 직장인</h2>
<p>2026년 현재, 직장에서 AI를 쓰는 사람과 안 쓰는 사람의 업무 속도 차이가 점점 벌어지고 있습니다. 이건 과장이 아니라 제가 직접 경험한 이야기입니다.</p>
<p>저는 약 6개월 전부터 업무에 ChatGPT를 적극적으로 활용하기 시작했습니다. 결과요? <strong>하루 평균 1~2시간의 업무 시간을 절약</strong>하고 있습니다. 그 시간에 더 중요한 일에 집중하거나, 일찍 퇴근할 수 있게 되었죠.</p>

<h2>ChatGPT가 도와줄 수 있는 업무 5가지</h2>

<h3>1. 이메일 작성</h3>
<p>"거래처에 미팅 일정 변경 메일 써줘. 정중하면서도 간결하게." 이렇게 말하면 30초 만에 깔끔한 이메일 초안이 나옵니다. 영어 이메일도 마찬가지입니다. 문법 걱정 없이 자연스러운 비즈니스 영어 메일을 받아볼 수 있습니다.</p>

<h3>2. 보고서 초안 작성</h3>
<p>주간보고, 기획서, 제안서의 초안을 작성할 때 ChatGPT에게 핵심 내용만 알려주면 구조를 잡아줍니다. 물론 그대로 제출하면 안 되고, <strong>초안을 바탕으로 내 언어로 다듬는 과정</strong>이 반드시 필요합니다.</p>

<h3>3. 데이터 정리와 분석</h3>
<p>엑셀에서 VLOOKUP 함수가 갑자기 안 되거나, 피벗테이블을 어떻게 만들어야 할지 모를 때. ChatGPT에게 물어보면 공식을 만들어주고, 왜 그렇게 되는지 설명까지 해줍니다.</p>

<h3>4. 회의 준비</h3>
<p>"다음 주 마케팅 전략 회의에서 발표할 아젠다를 만들어줘" 라고 하면 논리적인 순서로 발표 구조를 제안합니다. 브레인스토밍 파트너로 활용하면 혼자 고민하는 시간을 크게 줄일 수 있습니다.</p>

<h3>5. 학습과 리서치</h3>
<p>새로운 업무를 맡았을 때 해당 분야의 개념을 빠르게 파악하는 데 매우 유용합니다. "디지털 마케팅의 기본 개념을 신입사원도 이해할 수 있게 설명해줘" 같은 질문으로 빠르게 감을 잡을 수 있습니다.</p>

<h2>실제로 절약한 시간 기록</h2>
<p>지난 한 달간 제가 기록한 시간 절약 데이터입니다:</p>
<ul>
<li><strong>이메일 작성</strong>: 하루 평균 30분 → 10분 (20분 절약)</li>
<li><strong>보고서 초안</strong>: 주 1회, 2시간 → 40분 (80분 절약)</li>
<li><strong>엑셀 작업</strong>: 주 2~3회, 수식 검색 시간 90% 감소</li>
<li><strong>리서치</strong>: 새로운 주제 파악 시간 약 60% 감소</li>
</ul>
<p>합산하면 <strong>주당 약 5~7시간</strong>을 절약하고 있습니다. 한 달이면 거의 3일 치 근무 시간에 해당합니다.</p>

<h2>주의할 점: AI는 도구이지 대체자가 아닙니다</h2>
<p>중요한 건, ChatGPT의 결과물을 <strong>그대로 사용하면 안 된다</strong>는 것입니다. AI가 만들어준 초안은 말 그대로 "초안"입니다. 반드시 내 상황에 맞게 수정하고, 사실 관계를 확인해야 합니다.</p>
<p>또한 회사의 민감한 정보나 개인정보를 ChatGPT에 입력하면 안 됩니다. 보안 정책을 꼭 확인하세요.</p>

<h2>마치며</h2>
<p>AI를 쓸지 말지는 더 이상 선택의 문제가 아니라고 생각합니다. 이미 많은 직장인이 조용히 활용하고 있고, 그 격차는 점점 벌어지고 있습니다. 지금 시작해도 늦지 않았습니다.</p>
<p>다음 글에서는 ChatGPT를 활용해서 <strong>이메일을 10배 빠르게 쓰는 구체적인 프롬프트 템플릿</strong>을 공유할게요.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  (SELECT id FROM series WHERE slug = 'ai-for-office-workers'),
  1,
  'published',
  'ko',
  '2026-09-10T22:00:00+09:00',
  '2026-09-11T14:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 5: 웹사이트는 어떻게 만들어질까? — HTML, CSS, JS 쉬운 설명
-- 카테고리: 웹 개발 | 시리즈: 웹 개발 입문 #1
-- 발행일: 2026-09-14
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '웹사이트는 어떻게 만들어질까? — HTML, CSS, JS 쉬운 설명',
  'how-websites-are-made',
  '웹사이트의 3가지 핵심 기술을 집 짓기에 비유해서 설명합니다. 코딩을 전혀 모르는 분도 이해할 수 있어요.',
  $content$<h2>웹사이트 = 집짓기</h2>
<p>인터넷에서 매일 수십 개의 웹사이트를 방문하지만, "이게 어떻게 만들어진 걸까?" 하고 궁금해하신 적 있으신가요? 저도 코딩을 배우기 전에는 전혀 몰랐습니다. 마법 같았죠.</p>
<p>사실 웹사이트는 딱 <strong>3가지 기술</strong>로 만들어집니다. 집을 짓는 것에 비유해서 설명해볼게요.</p>

<h2>HTML — 집의 구조 (뼈대)</h2>
<p>HTML은 <strong>Hyper Text Markup Language</strong>의 약자입니다. 이름은 어려워 보이지만 하는 일은 간단합니다. 웹페이지의 <strong>구조와 내용</strong>을 담당합니다.</p>
<p>집으로 치면 기둥, 벽, 지붕, 방, 문 같은 구조물입니다. "여기는 제목이야", "여기는 문단이야", "여기에 이미지를 넣어" 하고 알려주는 역할을 합니다.</p>
<p>예를 들어, 이 글의 제목도 HTML로 이렇게 표현됩니다:</p>
<p><code>&lt;h2&gt;HTML — 집의 구조 (뼈대)&lt;/h2&gt;</code></p>
<p>보시다시피 <strong>꺽쇠 괄호(&lt; &gt;)</strong>로 감싸는 게 HTML의 특징입니다. 이런 것을 "태그"라고 부릅니다.</p>

<h2>CSS — 인테리어 (디자인)</h2>
<p>CSS는 <strong>Cascading Style Sheets</strong>의 약자입니다. 웹페이지의 <strong>디자인과 레이아웃</strong>을 담당합니다.</p>
<p>집으로 치면 벽지 색깔, 바닥재, 조명, 가구 배치 같은 것이죠. 같은 구조의 집이라도 인테리어에 따라 완전히 다른 느낌을 줄 수 있는 것처럼, CSS로 웹사이트의 분위기를 완전히 바꿀 수 있습니다.</p>
<p>예를 들면:</p>
<ul>
<li>글자 색깔을 파란색으로 바꾸기</li>
<li>배경에 그라데이션 넣기</li>
<li>버튼을 동그랗게 만들기</li>
<li>모바일에서는 한 줄, PC에서는 세 줄로 배치하기</li>
</ul>
<p>지금 보고 계신 이 블로그의 색상, 폰트, 레이아웃 모두 CSS로 만든 것입니다.</p>

<h2>JavaScript — 기능과 동작 (전기/수도)</h2>
<p>JavaScript는 웹페이지에 <strong>동작과 기능</strong>을 추가합니다. 집으로 치면 전기, 수도, 가스 같은 것입니다. 스위치를 누르면 불이 켜지고, 수도꼭지를 틀면 물이 나오는 것처럼요.</p>
<p>웹사이트에서 JavaScript가 하는 일의 예시:</p>
<ul>
<li>버튼을 클릭하면 메뉴가 열리고 닫히기</li>
<li>스크롤을 내리면 새로운 글이 자동으로 로딩되기</li>
<li>검색어를 입력하면 실시간으로 결과가 바뀌기</li>
<li>다크 모드와 라이트 모드 전환하기</li>
</ul>
<p>JavaScript 없이도 웹페이지는 존재할 수 있지만, 움직임이 없는 정적인 페이지만 가능합니다. 요즘 웹사이트들의 부드러운 애니메이션과 인터랙션은 대부분 JavaScript 덕분입니다.</p>

<h2>세 가지가 합쳐지면?</h2>
<p>정리하면 이렇습니다:</p>
<ul>
<li><strong>HTML</strong> = 무엇을 보여줄지 (구조)</li>
<li><strong>CSS</strong> = 어떻게 보여줄지 (디자인)</li>
<li><strong>JavaScript</strong> = 어떻게 동작할지 (기능)</li>
</ul>
<p>이 세 가지만 알면 기본적인 웹사이트를 만들 수 있습니다. 실제로 전 세계 모든 웹사이트는 이 세 가지 기술을 기반으로 하고 있습니다. 네이버도, 구글도, 유튜브도 마찬가지입니다.</p>

<h2>그럼 어디서부터 시작할까?</h2>
<p>웹 개발에 관심이 생기셨다면, 이 순서로 시작하시는 것을 추천합니다:</p>
<ul>
<li><strong>1단계</strong>: HTML로 간단한 자기소개 페이지 만들기</li>
<li><strong>2단계</strong>: CSS로 예쁘게 꾸며보기</li>
<li><strong>3단계</strong>: JavaScript로 간단한 기능 추가하기</li>
</ul>
<p>다음 글에서는 실제로 VS Code를 설치하고 첫 번째 코드를 실행하는 방법을 단계별로 알려드리겠습니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'web-dev-basics'),
  1,
  'published',
  'ko',
  '2026-09-13T18:30:00+09:00',
  '2026-09-14T11:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 6: ChatGPT로 이메일 10배 빠르게 쓰는 법
-- 카테고리: AI 활용 | 시리즈: 직장인 AI 활용법 #2
-- 발행일: 2026-09-17
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'ChatGPT로 이메일 10배 빠르게 쓰는 법',
  'chatgpt-email-writing-tips',
  'ChatGPT를 활용해서 비즈니스 이메일을 10배 빠르게 작성하는 프롬프트 템플릿 5가지를 공유합니다.',
  $content$<h2>이메일 하나 쓰는 데 20분?</h2>
<p>직장 생활에서 가장 많은 시간을 잡아먹는 업무 중 하나가 이메일 작성입니다. 특히 거래처에 보내는 정중한 메일, 상사에게 보고하는 메일, 영어로 보내야 하는 글로벌 메일은 한 통에 20~30분이 걸리기도 합니다.</p>
<p>저도 예전에는 이메일 한 통 쓰는 데 한참 고민했습니다. "이 표현이 너무 딱딱한가?", "혹시 실례가 되진 않을까?" 하면서 말이죠. 하지만 ChatGPT를 활용하기 시작하면서 이메일 작성 시간이 <strong>평균 2~3분</strong>으로 줄었습니다.</p>

<h2>이메일 프롬프트 작성의 핵심 원칙</h2>
<p>ChatGPT에게 이메일을 잘 쓰게 하려면 <strong>3가지 정보</strong>를 명확히 전달해야 합니다:</p>
<ul>
<li><strong>누구에게</strong> 보내는 건지 (거래처, 상사, 동료, 고객 등)</li>
<li><strong>무슨 내용</strong>인지 (요청, 감사, 사과, 일정 조정 등)</li>
<li><strong>어떤 톤</strong>으로 쓸지 (정중하게, 캐주얼하게, 간결하게 등)</li>
</ul>

<h2>바로 쓸 수 있는 프롬프트 템플릿 5가지</h2>

<h3>템플릿 1: 미팅 일정 요청</h3>
<p><strong>프롬프트:</strong> "거래처 김 대리에게 다음 주 화요일 또는 수요일 오후에 30분 미팅을 요청하는 이메일을 써줘. 정중하면서도 간결하게. 주제는 3분기 마케팅 협업 논의야."</p>
<p>이렇게 구체적으로 알려주면 바로 사용할 수 있는 수준의 메일이 나옵니다.</p>

<h3>템플릿 2: 일정 변경 안내</h3>
<p><strong>프롬프트:</strong> "예정된 미팅 일정을 변경해야 하는 상황이야. 원래 10/5 수요일 2시였는데, 10/7 금요일 3시로 바꾸고 싶어. 양해를 구하는 정중한 이메일 써줘."</p>

<h3>템플릿 3: 프로젝트 진행 상황 보고</h3>
<p><strong>프롬프트:</strong> "팀장에게 보내는 주간 프로젝트 보고 이메일 써줘. 완료: 디자인 시안 확정, UI 개발 70% 완료. 진행 중: 백엔드 API 연동. 이슈: 서버 응답 속도 최적화 필요. 간결한 불릿 포인트 형식으로."</p>

<h3>템플릿 4: 감사 메일</h3>
<p><strong>프롬프트:</strong> "어제 미팅에서 시간 내주신 것에 대한 감사 이메일 써줘. 논의한 내용(제품 가격 협상, 납기 일정)을 요약하고, 다음 단계(견적서 발송)를 언급해줘."</p>

<h3>템플릿 5: 영어 비즈니스 이메일</h3>
<p><strong>프롬프트:</strong> "Write a professional email in English to John from ABC Corp. I want to follow up on our previous conversation about the partnership proposal. Ask if they've had a chance to review it and suggest a call next week. Keep it concise and friendly."</p>
<p>영어 이메일이야말로 ChatGPT가 빛을 발하는 영역입니다. 문법 걱정 없이 자연스러운 비즈니스 영어가 가능해집니다.</p>

<h2>더 잘 쓰는 팁</h2>
<ul>
<li><strong>결과물을 반드시 검토하세요</strong> — AI가 만든 초안을 그대로 보내지 마세요. 내 상황에 맞게 수정하는 과정은 필수입니다.</li>
<li><strong>"~처럼 써줘"를 활용하세요</strong> — "스타트업 대표가 쓰는 것처럼", "MBB 컨설턴트 스타일로" 같은 지시를 추가하면 톤이 확 달라집니다.</li>
<li><strong>여러 버전을 요청하세요</strong> — "위 메일의 더 캐주얼한 버전도 써줘" 하면 상황에 맞는 버전을 고를 수 있습니다.</li>
<li><strong>회사 기밀은 절대 입력하지 마세요</strong> — 프로젝트 코드명, 내부 수치, 개인정보 등은 일반화해서 입력하세요.</li>
</ul>

<h2>마치며</h2>
<p>이메일 작성은 업무의 핵심이지만, 그 자체가 성과를 만드는 건 아닙니다. ChatGPT를 활용해 이메일에 쓰는 시간을 줄이고, 정말 중요한 업무에 집중하는 것이 현명한 시간 관리법이라고 생각합니다.</p>
<p>다음 글에서는 ChatGPT를 활용한 <strong>보고서 작성법</strong>에 대해 이야기해볼게요. 기획서, 주간보고, 제안서를 빠르게 만드는 방법을 공유합니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  (SELECT id FROM series WHERE slug = 'ai-for-office-workers'),
  2,
  'published',
  'ko',
  '2026-09-16T20:30:00+09:00',
  '2026-09-17T09:30:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 7: Notion 완벽 가이드 — 직장인을 위한 실전 활용법
-- 카테고리: 도구 리뷰 | 시리즈: 업무 자동화 도구 리뷰 #1
-- 발행일: 2026-09-20
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'Notion 완벽 가이드 — 직장인을 위한 실전 활용법',
  'notion-complete-guide-for-workers',
  'Notion으로 업무 대시보드, 프로젝트 관리, 회의록 정리까지. 직장인을 위한 실전 활용법 총정리.',
  $content$<h2>왜 Notion인가?</h2>
<p>업무 도구 시장에는 수많은 선택지가 있습니다. Evernote, OneNote, Google Docs, Trello... 그 중에서 제가 최종적으로 정착한 도구는 <strong>Notion</strong>입니다.</p>
<p>이유는 단순합니다. Notion 하나로 <strong>메모, 프로젝트 관리, 데이터베이스, 위키, 캘린더</strong>를 전부 처리할 수 있기 때문입니다. 여러 도구를 왔다 갔다 하는 시간을 줄이는 것만으로도 생산성이 크게 올라갑니다.</p>

<h2>Notion으로 만든 나의 업무 시스템</h2>
<p>제가 실제로 사용하고 있는 Notion 시스템을 공유합니다. 약 3개월간 다듬어서 지금의 형태가 되었습니다.</p>

<h3>1. 주간 대시보드</h3>
<p>매주 월요일 아침에 여는 첫 번째 페이지입니다. 이번 주의 할 일, 미팅 일정, 목표를 한 눈에 볼 수 있게 구성했습니다.</p>
<ul>
<li><strong>이번 주 목표</strong> — 3가지 이내로 핵심 목표 설정</li>
<li><strong>할 일 목록</strong> — 데이터베이스 뷰로 우선순위별 정렬</li>
<li><strong>미팅 일정</strong> — 캘린더 뷰에서 이번 주 미팅 한 눈에 파악</li>
<li><strong>지난 주 회고</strong> — 잘한 점, 개선할 점 간단 기록</li>
</ul>

<h3>2. 프로젝트 관리 보드</h3>
<p>Trello 스타일의 칸반 보드를 Notion 데이터베이스로 만들었습니다. 칼럼은 <strong>할 일 → 진행 중 → 리뷰 → 완료</strong>로 구성합니다. 각 카드에는 담당자, 마감일, 우선순위 태그를 달 수 있습니다.</p>
<p>이 보드의 장점은 같은 데이터를 <strong>여러 뷰</strong>로 볼 수 있다는 것입니다. 칸반 보드로 전체 현황을 보다가, 타임라인 뷰로 전환해서 일정을 확인하고, 테이블 뷰로 필터링할 수 있습니다.</p>

<h3>3. 회의록 시스템</h3>
<p>회의록 관리가 정말 편해졌습니다. 회의록 데이터베이스를 만들고, 템플릿을 설정해두면 새 회의록을 만들 때마다 동일한 형식으로 작성할 수 있습니다.</p>
<p>제 회의록 템플릿 구성:</p>
<ul>
<li>회의 일시 / 참석자</li>
<li>논의 안건 (체크리스트)</li>
<li>결정 사항</li>
<li>Action Items (담당자 + 마감일)</li>
<li>다음 미팅 일정</li>
</ul>

<h3>4. 지식 베이스 (개인 위키)</h3>
<p>업무 중 배운 것들, 자주 쓰는 정보, 절차 매뉴얼을 모아두는 곳입니다. 나중에 같은 상황이 오면 검색해서 바로 찾을 수 있습니다. 한 번 정리해두면 계속 써먹을 수 있어서 시간 투자 대비 효과가 큽니다.</p>

<h2>Notion 초보자를 위한 시작 팁</h2>
<ul>
<li><strong>처음부터 완벽하게 만들려고 하지 마세요</strong> — 간단한 페이지 하나부터 시작하고, 필요에 따라 점점 확장하세요.</li>
<li><strong>템플릿을 적극 활용하세요</strong> — Notion 공식 템플릿 갤러리에서 원하는 것을 골라 복제하면 빠르게 시작할 수 있습니다.</li>
<li><strong>데이터베이스를 꼭 배우세요</strong> — Notion의 핵심은 데이터베이스입니다. 이것만 이해하면 활용도가 10배로 뛰어납니다.</li>
<li><strong>단축키를 익히세요</strong> — <code>/</code> 명령어, <code>Ctrl+K</code> 빠른 검색 등 단축키를 알면 속도가 확 빨라집니다.</li>
</ul>

<h2>무료 플랜으로 충분할까?</h2>
<p>결론부터 말하면, <strong>개인 사용이라면 무료 플랜으로 충분합니다</strong>. 무료 플랜에서도 무제한 페이지, 무제한 블록을 사용할 수 있습니다. 팀으로 협업해야 하거나 고급 기능이 필요한 경우에만 유료 플랜을 고려하면 됩니다.</p>

<h2>마치며</h2>
<p>Notion은 배울수록 더 많은 것을 할 수 있는 도구입니다. 처음에는 단순한 메모장으로 시작했지만, 지금은 업무의 거의 모든 것을 Notion 안에서 관리하고 있습니다. 체계적인 시스템이 있으면 머릿속이 가벼워지고, 업무에 더 집중할 수 있다는 걸 느끼고 있습니다.</p>
<p>다음 글에서는 <strong>Zapier vs Make</strong> — 두 가지 자동화 도구를 비교해볼게요. 반복 업무를 자동으로 처리하는 마법 같은 도구들입니다!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'tool-review'),
  (SELECT id FROM series WHERE slug = 'productivity-tool-reviews'),
  1,
  'published',
  'ko',
  '2026-09-19T21:00:00+09:00',
  '2026-09-20T13:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 8: 퇴근 후 2시간 코딩 루틴 — 번아웃 없이 꾸준히 공부하는 법
-- 카테고리: 일상 | 시리즈: 개발자 라이프스타일 #2
-- 발행일: 2026-09-23
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '퇴근 후 2시간 코딩 루틴 — 번아웃 없이 꾸준히 공부하는 법',
  'after-work-coding-routine',
  '퇴근 후 매일 2시간 코딩 공부를 3개월째 이어오고 있습니다. 번아웃 없이 꾸준히 하는 비결을 공유합니다.',
  $content$<h2>왜 퇴근 후에 코딩을 할까?</h2>
<p>직장을 다니면서 코딩을 배운다는 건 결코 쉬운 일이 아닙니다. 하루 8시간 일하고 집에 오면 소파에 누워서 유튜브를 보고 싶은 게 솔직한 마음이죠. 그런데 저는 3개월째 퇴근 후 2시간 코딩 루틴을 이어오고 있습니다.</p>
<p>비결이요? 의지력이 아닙니다. <strong>시스템</strong>입니다.</p>

<h2>나의 퇴근 후 루틴 공개</h2>
<p>제 평일 저녁 루틴을 시간대별로 공개합니다:</p>
<ul>
<li><strong>18:30</strong> — 퇴근 후 귀가</li>
<li><strong>18:30~19:00</strong> — 저녁 식사 + 가벼운 휴식</li>
<li><strong>19:00~19:10</strong> — 커피 한 잔 + 오늘의 공부 목표 설정 (Notion에 기록)</li>
<li><strong>19:10~20:10</strong> — 🔥 집중 코딩 세션 1 (60분)</li>
<li><strong>20:10~20:20</strong> — 휴식 (스트레칭, 물 마시기)</li>
<li><strong>20:20~21:10</strong> — 🔥 집중 코딩 세션 2 (50분)</li>
<li><strong>21:10~21:30</strong> — 오늘 배운 것 정리 (블로그 글감 또는 메모)</li>
<li><strong>21:30~</strong> — 자유 시간 (넷플릭스, 독서, 게임 등)</li>
</ul>
<p>핵심은 <strong>시작 시간을 고정</strong>하는 것입니다. 매일 19시에 시작한다는 규칙을 정하면, 생각할 필요 없이 자동으로 모드가 전환됩니다.</p>

<h2>번아웃 없이 지속하는 5가지 비결</h2>

<h3>1. 작은 목표를 세운다</h3>
<p>"React 마스터하기" 같은 큰 목표는 부담만 됩니다. 대신 <strong>"오늘은 버튼 컴포넌트 하나 만들기"</strong> 같은 작고 구체적인 목표를 세웁니다. 완료하면 성취감이 생기고, 그 성취감이 내일의 동기가 됩니다.</p>

<h3>2. 쉬는 날은 확실히 쉰다</h3>
<p>주말 중 하루는 반드시 코딩을 하지 않습니다. 처음에는 "하루라도 쉬면 뒤처질까봐" 불안했지만, 쉬어야 머릿속이 정리되고 새로운 아이디어가 떠오르더라고요. <strong>휴식도 공부의 일부</strong>입니다.</p>

<h3>3. 프로젝트를 병행한다</h3>
<p>단순히 튜토리얼만 따라 하면 금방 지겨워집니다. 반드시 <strong>자기 프로젝트</strong>를 함께 진행하세요. 이 블로그가 바로 제 프로젝트입니다. 내가 만든 것이 실제로 인터넷에 올라가는 경험은 엄청난 동기부여가 됩니다.</p>

<h3>4. 기록한다</h3>
<p>매일 10~15분씩 "오늘 배운 것"을 정리합니다. 나중에 돌아보면 성장 과정이 눈에 보이고, 블로그 글감으로도 활용할 수 있습니다. 일석이조죠.</p>

<h3>5. 커뮤니티와 연결한다</h3>
<p>혼자 하면 외롭습니다. 온라인 개발 커뮤니티(디스코드, 블로그, 트위터)에 가입해서 비슷한 목표를 가진 사람들과 소통합니다. 서로의 진행 상황을 공유하면 자극이 되고, 포기하기 어려워집니다.</p>

<h2>실제로 3개월간 달라진 것들</h2>
<p>매일 2시간이면 한 달에 약 60시간, 3개월이면 약 180시간입니다. 이 시간 동안:</p>
<ul>
<li>HTML, CSS, JavaScript의 기본을 익혔습니다</li>
<li>React와 Next.js로 이 블로그를 만들었습니다</li>
<li>Supabase로 데이터베이스를 설계하고 연결했습니다</li>
<li>Git과 GitHub 기본 사용법을 배웠습니다</li>
<li>이 블로그 글을 쓸 수 있을 정도의 지식을 쌓았습니다</li>
</ul>
<p>180시간이 적어 보일 수 있지만, <strong>매일 꾸준히</strong> 한 180시간은 몰아서 한 것과는 차원이 다릅니다.</p>

<h2>마치며</h2>
<p>완벽한 환경이 갖춰질 때까지 기다리면 영원히 시작할 수 없습니다. 퇴근 후 피곤한 몸을 이끌고 컴퓨터 앞에 앉는 것 자체가 대단한 일입니다. 오늘 30분이라도 좋습니다. 시작하는 게 중요합니다.</p>
<p>여러분도 자신만의 루틴을 만들어보세요. 3개월 후의 자신이 달라져 있을 겁니다. 화이팅! 💪</p>$content$,
  (SELECT id FROM categories WHERE slug = 'lifestyle'),
  (SELECT id FROM series WHERE slug = 'dev-lifestyle'),
  2,
  'published',
  'ko',
  '2026-09-22T19:30:00+09:00',
  '2026-09-23T10:00:00+09:00'
);


-- ═══════════════════════════════════════════════
-- 포스트-태그 연결 (post_tags)
-- 각 포스트에 관련 태그 연결
-- ═══════════════════════════════════════════════

-- 포스트 1: 왜 티스토리 대신 직접 블로그를 만들었을까?
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'why-i-built-my-own-blog' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog')),
  ((SELECT id FROM posts WHERE slug = 'why-i-built-my-own-blog' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'tistory')),
  ((SELECT id FROM posts WHERE slug = 'why-i-built-my-own-blog' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs')),
  ((SELECT id FROM posts WHERE slug = 'why-i-built-my-own-blog' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'supabase')),
  ((SELECT id FROM posts WHERE slug = 'why-i-built-my-own-blog' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));

-- 포스트 2: 비전공자가 개발을 시작하며 느낀 솔직한 이야기
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'non-major-starting-dev' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog')),
  ((SELECT id FROM posts WHERE slug = 'non-major-starting-dev' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'dev-environment')),
  ((SELECT id FROM posts WHERE slug = 'non-major-starting-dev' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));

-- 포스트 3: Next.js가 뭔데?
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'what-is-nextjs-for-beginners' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs')),
  ((SELECT id FROM posts WHERE slug = 'what-is-nextjs-for-beginners' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'react')),
  ((SELECT id FROM posts WHERE slug = 'what-is-nextjs-for-beginners' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'typescript')),
  ((SELECT id FROM posts WHERE slug = 'what-is-nextjs-for-beginners' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));

-- 포스트 4: 직장인이 ChatGPT를 써야 하는 진짜 이유
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'why-office-workers-need-chatgpt-2026' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'chatgpt')),
  ((SELECT id FROM posts WHERE slug = 'why-office-workers-need-chatgpt-2026' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'why-office-workers-need-chatgpt-2026' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'automation')),
  ((SELECT id FROM posts WHERE slug = 'why-office-workers-need-chatgpt-2026' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'));

-- 포스트 5: 웹사이트는 어떻게 만들어질까?
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'how-websites-are-made' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'html')),
  ((SELECT id FROM posts WHERE slug = 'how-websites-are-made' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'css')),
  ((SELECT id FROM posts WHERE slug = 'how-websites-are-made' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'javascript')),
  ((SELECT id FROM posts WHERE slug = 'how-websites-are-made' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));

-- 포스트 6: ChatGPT로 이메일 10배 빠르게 쓰는 법
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'chatgpt-email-writing-tips' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'chatgpt')),
  ((SELECT id FROM posts WHERE slug = 'chatgpt-email-writing-tips' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'chatgpt-email-writing-tips' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'email')),
  ((SELECT id FROM posts WHERE slug = 'chatgpt-email-writing-tips' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'));

-- 포스트 7: Notion 완벽 가이드
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'notion-complete-guide-for-workers' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'notion')),
  ((SELECT id FROM posts WHERE slug = 'notion-complete-guide-for-workers' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity')),
  ((SELECT id FROM posts WHERE slug = 'notion-complete-guide-for-workers' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'automation'));

-- 포스트 8: 퇴근 후 2시간 코딩 루틴
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'after-work-coding-routine' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'dev-environment')),
  ((SELECT id FROM posts WHERE slug = 'after-work-coding-routine' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity')),
  ((SELECT id FROM posts WHERE slug = 'after-work-coding-routine' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog'));
