-- =============================================
-- 020_seed_posts_phase6.sql
-- Phase 6: 검색 유입 확대 2차 - 롱테일 키워드 글 5편
--   1) 엑셀 XLOOKUP 사용법        → 바로 발행 (published)
--   2) Claude Code·Gemini CLI 입문 → 바로 발행 (published)
--   3) Cloudflare 무료 배포        → 이미지 대기 (draft)
--   4) 무료 AI 이미지 도구 비교    → 이미지 대기 (draft)
--   5) 직장인 부업 체크리스트      → 이미지 대기 (draft)
-- ※ Supabase SQL Editor에서 실행하세요 (여러 번 실행해도 안전: ON CONFLICT)
-- ※ draft 글은 이미지 추가 후 021 파일의 UPDATE로 발행합니다
-- =============================================


-- ═══════════════════════════════════════════════
-- 포스트 6: 엑셀 XLOOKUP 사용법 (VLOOKUP과 차이)
-- 카테고리: 도구 리뷰 (tool-review) | 상태: 발행
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  '엑셀 XLOOKUP 사용법 총정리 — VLOOKUP과 차이점, 예제로 5분 만에 배우기',
  'xlookup-vs-vlookup-guide',
  'VLOOKUP이 자꾸 오류가 나서 답답하셨나요? XLOOKUP은 왼쪽 열도 찾고, 열이 추가돼도 깨지지 않습니다. 기본 사용법부터 VLOOKUP과의 비교, 자주 나는 오류 해결까지 예제로 정리했습니다.',
  '/blog/xlookup-vs-vlookup-guide/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: XLOOKUP은 "찾을 값, 찾을 범위, 가져올 범위" 세 가지만 지정하면 되는 새로운 조회 함수입니다. VLOOKUP과 달리 <strong>왼쪽 열도 찾을 수 있고, 열 번호를 세지 않아도 되며, 기본값이 정확히 일치</strong>라 실수가 크게 줄어듭니다.</p>

<h2>XLOOKUP이 뭔가요?</h2>
<p>엑셀에서 "상품코드로 상품명을 찾아오기", "사번으로 부서를 찾아오기"처럼 <strong>다른 표에서 값을 찾아 가져오는 일</strong>은 정말 자주 하는 작업입니다. 오랫동안 이 일을 해온 함수가 VLOOKUP이고, 이를 개선해 새로 나온 함수가 XLOOKUP입니다.</p>
<p>XLOOKUP은 <strong>Microsoft 365와 Excel 2021 이상</strong>에서 사용할 수 있습니다. Excel 2019 이하 버전에서는 지원되지 않아 <code>#NAME?</code> 오류가 나므로, 내 엑셀 버전을 먼저 확인하세요. 구글 스프레드시트에서도 XLOOKUP을 사용할 수 있습니다.</p>

<h2>기본 문법: 인수 3개면 충분합니다</h2>
<pre><code>=XLOOKUP(찾을값, 찾을범위, 가져올범위)</code></pre>
<ul>
<li><strong>찾을값</strong>: 내가 찾고 싶은 값 (예: 상품코드 A102)</li>
<li><strong>찾을범위</strong>: 그 값이 들어 있는 열 (예: 상품코드 열 전체)</li>
<li><strong>가져올범위</strong>: 결과로 돌려받을 값이 있는 열 (예: 상품명 열 전체)</li>
</ul>

<h3>따라 해 보기</h3>
<p>아래와 같은 상품표가 A1:C5에 있다고 가정해 봅니다.</p>
<table>
<thead><tr><th>상품코드 (A열)</th><th>상품명 (B열)</th><th>가격 (C열)</th></tr></thead>
<tbody>
<tr><td>A101</td><td>무선 마우스</td><td>25,000</td></tr>
<tr><td>A102</td><td>기계식 키보드</td><td>89,000</td></tr>
<tr><td>A103</td><td>노트북 거치대</td><td>32,000</td></tr>
<tr><td>A104</td><td>USB 허브</td><td>18,000</td></tr>
</tbody>
</table>
<p>E1 셀에 상품코드 <code>A102</code>를 입력하고, F1 셀에 아래 수식을 넣으면 "기계식 키보드"가 나옵니다.</p>
<pre><code>=XLOOKUP(E1, A2:A5, B2:B5)</code></pre>
<p>가격이 필요하다면 가져올 범위만 C열로 바꾸면 됩니다.</p>
<pre><code>=XLOOKUP(E1, A2:A5, C2:C5)</code></pre>

<figure>
<img src="/blog/xlookup-vs-vlookup-guide/01.webp" alt="두 개의 스프레드시트 표 사이를 좌우 양방향 화살표로 연결해 어느 방향으로도 값을 찾는 모습을 표현한 일러스트" width="960" height="540" loading="lazy" />
<figcaption>XLOOKUP은 찾을 열이 가져올 열의 오른쪽에 있어도 문제없이 동작합니다.</figcaption>
</figure>

<h2>VLOOKUP과 XLOOKUP 비교</h2>
<p>같은 작업을 두 함수로 해 보면 차이가 분명합니다.</p>
<pre><code>VLOOKUP : =VLOOKUP(E1, A2:C5, 2, FALSE)
XLOOKUP : =XLOOKUP(E1, A2:A5, B2:B5)</code></pre>
<table>
<thead><tr><th>비교 항목</th><th>VLOOKUP</th><th>XLOOKUP</th></tr></thead>
<tbody>
<tr><td>찾는 방향</td><td>항상 <strong>오른쪽</strong>으로만 가능</td><td>왼쪽·오른쪽 모두 가능</td></tr>
<tr><td>가져올 열 지정</td><td>열 번호(2, 3…)를 직접 세야 함</td><td>가져올 열을 직접 선택</td></tr>
<tr><td>열을 추가·삭제하면</td><td>열 번호가 어긋나 <strong>결과가 틀어질 수 있음</strong></td><td>범위가 함께 이동해 안전</td></tr>
<tr><td>기본 일치 방식</td><td>생략하면 <strong>근사 일치</strong>(위험)</td><td>기본이 <strong>정확히 일치</strong></td></tr>
<tr><td>못 찾았을 때</td><td>#N/A 오류 (IFERROR 필요)</td><td>"못 찾으면 이 값" 인수를 내장</td></tr>
<tr><td>여러 값 한 번에</td><td>불가능</td><td>여러 열을 한 번에 반환 가능</td></tr>
<tr><td>사용 가능 버전</td><td>모든 버전</td><td>Microsoft 365, Excel 2021 이상</td></tr>
</tbody>
</table>
<p>특히 VLOOKUP은 마지막 인수를 <code>FALSE</code>로 적지 않으면 근사 일치로 동작해, 눈에 띄지 않는 <strong>엉뚱한 값</strong>을 가져오는 사고가 잦습니다. XLOOKUP은 이 문제가 기본적으로 해결되어 있습니다.</p>

<h2>XLOOKUP 실전 활용 5가지</h2>

<h3>1. 못 찾았을 때 문구 표시하기</h3>
<p>네 번째 인수에 "찾지 못했을 때 보여줄 값"을 적으면 IFERROR 없이도 깔끔하게 처리됩니다.</p>
<pre><code>=XLOOKUP(E1, A2:A5, B2:B5, "해당 상품 없음")</code></pre>

<h3>2. 왼쪽 열에서 값 가져오기</h3>
<p>상품명(B열)으로 상품코드(A열)를 찾는 식으로, 가져올 열이 왼쪽에 있어도 됩니다. VLOOKUP으로는 표를 재배열해야 했던 작업입니다.</p>
<pre><code>=XLOOKUP(E1, B2:B5, A2:A5)</code></pre>

<h3>3. 여러 열을 한꺼번에 가져오기</h3>
<p>가져올 범위를 두 열 이상으로 지정하면 결과가 옆 칸으로 자동으로 펼쳐집니다(스필).</p>
<pre><code>=XLOOKUP(E1, A2:A5, B2:C5)</code></pre>
<p>이 경우 상품명과 가격이 한 번에 나타납니다. 결과가 펼쳐질 오른쪽 칸이 비어 있어야 합니다.</p>

<h3>4. 가장 마지막에 나온 값 찾기</h3>
<p>같은 값이 여러 번 있을 때 가장 최근(아래쪽) 기록을 가져오고 싶다면 여섯 번째 인수를 <code>-1</code>로 지정합니다.</p>
<pre><code>=XLOOKUP(E1, A2:A100, C2:C100, "없음", 0, -1)</code></pre>
<p>다섯 번째 인수 <code>0</code>은 정확히 일치, 여섯 번째 인수 <code>-1</code>은 아래에서 위로 검색을 뜻합니다.</p>

<h3>5. 구간별 값 찾기 (등급·수수료율)</h3>
<p>점수에 따른 등급처럼 "이 값 이하 중 가장 가까운 값"이 필요할 때는 다섯 번째 인수를 <code>-1</code>(정확히 일치하거나 다음으로 작은 항목)로 설정합니다.</p>
<pre><code>=XLOOKUP(E1, A2:A6, B2:B6, "해당 없음", -1)</code></pre>
<p>이때 찾을 범위(A열)는 오름차순으로 정렬해 두는 것이 안전합니다.</p>

<h3>인수 한눈에 보기</h3>
<table>
<thead><tr><th>순서</th><th>인수</th><th>설명</th></tr></thead>
<tbody>
<tr><td>1</td><td>찾을값</td><td>검색할 값</td></tr>
<tr><td>2</td><td>찾을범위</td><td>값을 검색할 열 또는 행</td></tr>
<tr><td>3</td><td>가져올범위</td><td>결과로 반환할 열 또는 행</td></tr>
<tr><td>4</td><td>못찾을때(선택)</td><td>일치하는 값이 없을 때 표시할 내용</td></tr>
<tr><td>5</td><td>일치유형(선택)</td><td>0 정확히 일치(기본), -1 정확히 또는 다음 작은 값, 1 정확히 또는 다음 큰 값, 2 와일드카드</td></tr>
<tr><td>6</td><td>검색모드(선택)</td><td>1 위→아래(기본), -1 아래→위, 2·-2 이진 검색</td></tr>
</tbody>
</table>

<figure>
<img src="/blog/xlookup-vs-vlookup-guide/02.webp" alt="스프레드시트 셀의 오류 표시를 렌치로 고치고 초록색 체크 표시가 나타나는 문제 해결 일러스트" width="960" height="540" loading="lazy" />
<figcaption>대부분의 XLOOKUP 오류는 데이터 형식과 범위 크기만 확인해도 해결됩니다.</figcaption>
</figure>

<h2>자주 나는 오류와 해결법</h2>
<table>
<thead><tr><th>오류</th><th>주요 원인</th><th>해결 방법</th></tr></thead>
<tbody>
<tr><td>#N/A</td><td>찾을 값이 범위에 없음, 앞뒤 공백, 숫자와 텍스트 형식 불일치</td><td>TRIM 함수로 공백 제거, 두 열의 형식을 통일, 4번째 인수로 안내 문구 지정</td></tr>
<tr><td>#VALUE!</td><td>찾을범위와 가져올범위의 크기(행 수)가 다름</td><td>두 범위의 시작·끝 행을 똑같이 맞춤</td></tr>
<tr><td>#SPILL!</td><td>결과가 펼쳐질 칸에 이미 값이 있음</td><td>오른쪽·아래쪽 빈칸 확보</td></tr>
<tr><td>#NAME?</td><td>XLOOKUP을 지원하지 않는 엑셀 버전</td><td>Microsoft 365 또는 Excel 2021 이상 사용, 또는 INDEX/MATCH 대체</td></tr>
</tbody>
</table>
<p>#N/A가 가장 흔한데, 눈으로 보면 같은 값인데도 한쪽에 <strong>보이지 않는 공백</strong>이 있거나 한쪽은 숫자, 한쪽은 텍스트로 저장된 경우가 대부분입니다. 찾을값에 <code>TRIM(E1)</code>을 사용해 보세요.</p>
<pre><code>=XLOOKUP(TRIM(E1), A2:A5, B2:B5, "없음")</code></pre>

<h2>엑셀 2019 이하라면: INDEX + MATCH 대안</h2>
<p>XLOOKUP을 쓸 수 없는 버전이라면 INDEX와 MATCH를 조합하면 왼쪽 열도 찾을 수 있습니다.</p>
<pre><code>=INDEX(B2:B5, MATCH(E1, A2:A5, 0))</code></pre>
<p>MATCH가 "몇 번째 줄인지"를 찾고, INDEX가 그 줄의 값을 가져오는 방식입니다. 수식이 조금 길어도 모든 버전에서 안정적으로 동작합니다.</p>

<h2>수식이 어렵다면 AI에게 물어보세요</h2>
<p>데이터 구조를 말로 설명하면 AI가 수식을 만들어 주기도 합니다. 질문하는 요령은 <a href="/ko/blog/ask-ai-for-excel-formulas">AI에게 엑셀 함수 물어보는 법</a>에서 자세히 다뤘으니 함께 참고해 보세요. 다만 AI가 알려준 수식은 반드시 <strong>작은 샘플 데이터로 먼저 검증</strong>한 뒤 실제 업무 파일에 적용하세요.</p>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. VLOOKUP은 이제 쓰면 안 되나요?</h3>
<p>그렇지 않습니다. 모든 엑셀 버전에서 동작하고 기존 파일에 많이 쓰이고 있어서 계속 쓸 수 있습니다. 다만 새로 만드는 파일이고 XLOOKUP을 쓸 수 있는 환경이라면 XLOOKUP이 더 안전합니다.</p>

<h3>Q2. XLOOKUP이 VLOOKUP보다 느린가요?</h3>
<p>일반적인 업무 규모에서는 체감 차이가 거의 없습니다. 수십만 행 이상의 큰 데이터에서는 범위를 필요한 만큼만 지정하는 것이 성능에 도움이 됩니다.</p>

<h3>Q3. 다른 시트나 다른 파일에서도 찾을 수 있나요?</h3>
<p>네, 찾을범위와 가져올범위에 다른 시트의 범위를 지정하면 됩니다. 예: <code>=XLOOKUP(A2, 상품표!A:A, 상품표!B:B)</code>. 다른 파일을 참조할 때는 원본 파일이 열려 있거나 경로가 유지되어야 합니다.</p>

<h3>Q4. 열 전체(A:A)를 지정해도 되나요?</h3>
<p>가능합니다. 데이터가 계속 늘어나는 표에서 편리하지만, 아주 큰 파일에서는 필요한 범위만 지정하는 편이 계산이 빠릅니다.</p>

<h2>마치며: 오늘 바로 바꿔볼 것</h2>
<ol>
<li>내 엑셀이 Microsoft 365 또는 2021 이상인지 확인</li>
<li>자주 쓰는 VLOOKUP 하나를 XLOOKUP으로 바꿔 보기</li>
<li>4번째 인수에 "없음" 같은 안내 문구 넣기</li>
<li>#N/A가 나면 TRIM과 데이터 형식부터 확인하기</li>
</ol>
<p>XLOOKUP은 한 번 익히면 다시 VLOOKUP으로 돌아가기 어려울 만큼 편한 함수입니다. 열 번호를 세다가 실수하던 경험이 있다면 오늘부터 XLOOKUP을 써 보세요.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'tool-review'),
  'published',
  'ko',
  '2026-10-19T21:50:00+09:00',
  '2026-10-19T22:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 7: Claude Code·Gemini CLI 입문
-- 카테고리: AI 활용 (ai-tools) | 상태: 임시저장(draft) - 본문 이미지 1장 대기
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  'Claude Code·Gemini CLI 입문 — 터미널에서 AI에게 코딩 맡기는 방법 (설치부터 첫 사용까지)',
  'claude-code-gemini-cli-guide',
  '터미널에서 AI가 직접 파일을 읽고 코드를 고쳐주는 시대입니다. Claude Code와 Gemini CLI의 설치 방법, 첫 사용 순서, 안전하게 쓰는 요령, 두 도구의 차이를 비전공자 눈높이로 정리했습니다.',
  '/blog/claude-code-gemini-cli-guide/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: Claude Code와 Gemini CLI는 <strong>내 프로젝트 폴더에서 실행하면 AI가 파일을 직접 읽고 수정까지 도와주는 터미널 도구</strong>입니다. 채팅창에 코드를 복사·붙여넣기 하던 방식보다 훨씬 빠르지만, 변경 사항을 승인하기 전에 꼭 확인하는 습관이 필요합니다.</p>

<h2>터미널 AI 코딩 도구가 뭔가요?</h2>
<p>ChatGPT 같은 채팅형 AI는 코드를 대화창에 보여줄 뿐, 내 컴퓨터의 파일에는 접근하지 못합니다. 반면 <strong>터미널형 AI 코딩 에이전트</strong>는 내가 지정한 프로젝트 폴더 안의 파일 구조를 읽고, 필요한 파일을 열어 보고, 수정안을 만들어 반영해 줍니다. "로그인 페이지에 이메일 형식 검사를 추가해줘"처럼 말로 지시하면 알아서 관련 파일을 찾아 고칩니다.</p>
<p>대표적인 도구가 Anthropic의 <strong>Claude Code</strong>와 Google의 <strong>Gemini CLI</strong>입니다. 에디터 안에서 쓰는 방식이 궁금하다면 <a href="/ko/blog/cursor-ai-coding-guide">Cursor AI 실전 가이드</a>나 <a href="/ko/blog/github-copilot-review-2026">GitHub Copilot 리뷰</a>도 함께 참고해 보세요.</p>

<h2>시작하기 전에 준비할 것</h2>
<ul>
<li><strong>Node.js</strong>: 두 도구 모두 npm으로 설치하므로 Node.js가 필요합니다. 요구 버전은 도구마다 다르고 바뀔 수 있으니 공식 문서의 안내를 확인하세요. 대체로 최신 LTS 버전을 설치하면 안전합니다.</li>
<li><strong>터미널</strong>: Windows는 PowerShell, macOS는 터미널 앱, 또는 VS Code 내장 터미널을 쓰면 됩니다.</li>
<li><strong>계정</strong>: Claude Code는 Anthropic 계정(구독 또는 API), Gemini CLI는 Google 계정이 필요합니다.</li>
<li><strong>Git</strong>: AI가 파일을 바꾸기 전에 되돌릴 수 있도록 Git 사용을 강력히 권장합니다. 처음이라면 <a href="/ko/blog/github-for-beginners-commit-push">깃허브 입문 가이드</a>를 먼저 보세요.</li>
</ul>

<h2>1단계. 설치하기</h2>
<p>터미널에서 아래 명령으로 전역 설치합니다. (설치 명령은 버전에 따라 바뀔 수 있으니, 안 되면 공식 문서를 확인하세요.)</p>

<h3>Claude Code</h3>
<pre><code>npm install -g @anthropic-ai/claude-code</code></pre>

<h3>Gemini CLI</h3>
<pre><code>npm install -g @google/gemini-cli</code></pre>

<p>설치가 끝나면 터미널을 새로 열어 아래 명령으로 실행되는지 확인합니다.</p>
<pre><code>claude --version
gemini --version</code></pre>

<figure>
<img src="/blog/claude-code-gemini-cli-guide/01.webp" alt="터미널 창과 다운로드 진행 막대, 패키지 상자로 표현한 설치 과정 일러스트" width="960" height="540" loading="lazy" />
<figcaption>두 도구 모두 npm 명령 한 줄로 설치할 수 있습니다.</figcaption>
</figure>

<h2>2단계. 프로젝트 폴더에서 실행하고 로그인하기</h2>
<ol>
<li>터미널에서 내 프로젝트 폴더로 이동합니다. (예: <code>cd my-blog</code>)</li>
<li>Claude Code는 <code>claude</code>, Gemini CLI는 <code>gemini</code>를 입력해 실행합니다.</li>
<li>처음 실행하면 로그인 안내가 나옵니다. 브라우저가 열리면 계정으로 로그인해 허용합니다.</li>
<li>입력창이 나타나면 준비가 끝난 것입니다.</li>
</ol>
<p>중요한 점은 <strong>반드시 프로젝트 폴더 안에서 실행</strong>해야 한다는 것입니다. 홈 폴더나 바탕화면처럼 넓은 위치에서 실행하면 AI가 불필요한 파일까지 읽게 됩니다.</p>

<h2>3단계. 첫 번째 지시 내려보기</h2>
<p>처음에는 파일을 바꾸지 않는 <strong>읽기·설명 요청</strong>부터 시작하는 것이 안전합니다.</p>
<pre><code>이 프로젝트의 폴더 구조를 설명해줘.
어떤 파일이 어떤 역할을 하는지 초보자도 이해하게 정리해줘.</code></pre>
<p>구조를 이해했다면 작은 수정을 요청해 봅니다.</p>
<pre><code>README.md 파일의 맨 위에 프로젝트 한 줄 소개를 추가해줘.
수정하기 전에 어떤 내용을 넣을지 먼저 보여줘.</code></pre>
<p>AI가 수정안을 제시하면 <strong>승인(허용) 여부를 묻는 화면</strong>이 나옵니다. 내용을 읽고 맞으면 허용, 아니면 거절하고 다시 지시하세요.</p>

<h2>자주 쓰는 기본 명령 (슬래시 명령)</h2>
<table>
<thead><tr><th>명령</th><th>설명</th></tr></thead>
<tbody>
<tr><td><code>/help</code></td><td>사용 가능한 명령 목록 보기</td></tr>
<tr><td><code>/clear</code></td><td>대화 내용을 비우고 새로 시작</td></tr>
<tr><td><code>/init</code></td><td>(Claude Code) 프로젝트 설명 파일(CLAUDE.md) 생성</td></tr>
<tr><td><code>Ctrl + C</code></td><td>진행 중인 작업 중단</td></tr>
</tbody>
</table>
<p>Claude Code는 프로젝트 루트의 <code>CLAUDE.md</code>, Gemini CLI는 <code>GEMINI.md</code> 파일에 "이 프로젝트의 규칙"을 적어두면 매번 설명하지 않아도 그 내용을 참고합니다. 예를 들어 "답변은 한국어로 해줘", "수정 전에 계획을 먼저 보여줘" 같은 규칙을 적어 두면 편리합니다. 명령어 이름은 버전에 따라 바뀔 수 있으니 <code>/help</code>로 확인하세요.</p>

<h2>Claude Code vs Gemini CLI 비교</h2>
<table>
<thead><tr><th>항목</th><th>Claude Code</th><th>Gemini CLI</th></tr></thead>
<tbody>
<tr><td>제공사</td><td>Anthropic</td><td>Google</td></tr>
<tr><td>실행 명령</td><td><code>claude</code></td><td><code>gemini</code></td></tr>
<tr><td>프로젝트 설명 파일</td><td>CLAUDE.md</td><td>GEMINI.md</td></tr>
<tr><td>로그인</td><td>Anthropic 계정(구독 또는 API)</td><td>Google 계정</td></tr>
<tr><td>비용</td><td>유료 요금제 또는 API 사용량 기준</td><td>무료 제공 한도가 있으나 변동될 수 있음</td></tr>
<tr><td>특징</td><td>대규모 코드 수정·리팩토링에 강점으로 평가</td><td>무료로 체험하기 좋음</td></tr>
</tbody>
</table>
<p>요금 정책과 무료 한도, 지원 모델은 자주 바뀝니다. 이용 전에 <strong>공식 요금 안내 페이지</strong>를 꼭 확인하세요. 처음 체험하는 용도라면 무료 한도가 있는 Gemini CLI로 시작해 감을 잡고, 필요에 따라 다른 도구를 추가하는 방법도 좋습니다.</p>

<h2>안전하게 쓰는 5가지 원칙</h2>
<ol>
<li><strong>작업 전에 Git 커밋</strong>: AI가 파일을 대량으로 바꿔도 <code>git diff</code>로 확인하고 되돌릴 수 있어야 합니다.</li>
<li><strong>변경 내용은 직접 읽고 승인</strong>: "모두 허용" 옵션은 익숙해진 뒤에도 신중히 사용하세요.</li>
<li><strong>비밀 정보 주의</strong>: <code>.env</code> 같은 비밀번호·API 키 파일을 AI가 읽거나 외부로 보내지 않도록 주의하고, 해당 파일은 가급적 열람 대상에서 제외하세요.</li>
<li><strong>작게 쪼개서 요청</strong>: "사이트 전체 만들어줘"보다 "댓글 입력창 하나 추가해줘"가 훨씬 정확합니다.</li>
<li><strong>이해하며 진행</strong>: 이해가 안 되는 코드는 "이 부분이 왜 필요한지 설명해줘"라고 물어보세요.</li>
</ol>

<h2>이럴 때 이렇게 쓰세요</h2>
<table>
<thead><tr><th>상황</th><th>프롬프트 예시</th></tr></thead>
<tbody>
<tr><td>오류가 났을 때</td><td>"이 오류 메시지의 원인을 찾아서 고쳐줘. 수정 전에 원인부터 설명해줘."</td></tr>
<tr><td>낯선 코드를 이해할 때</td><td>"이 파일이 하는 일을 한 줄씩 쉬운 말로 설명해줘."</td></tr>
<tr><td>작은 기능 추가</td><td>"문의 폼에 이메일 형식 검사를 추가해줘. 기존 스타일은 유지해줘."</td></tr>
<tr><td>정리·개선</td><td>"중복되는 코드를 찾아서 정리 방법을 제안해줘. 아직 수정은 하지 마."</td></tr>
</tbody>
</table>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 코딩을 전혀 몰라도 쓸 수 있나요?</h3>
<p>설치와 기본 사용은 가능합니다. 다만 AI가 틀릴 수 있으므로 결과를 확인하고 되돌릴 수 있는 최소한의 지식(Git 기본, 파일 구조)은 필요합니다.</p>

<h3>Q2. 어떤 파일이 외부로 전송되나요?</h3>
<p>AI가 작업을 위해 읽은 파일 내용은 해당 서비스의 서버로 전송될 수 있습니다. 각 서비스의 개인정보·데이터 정책을 확인하고, 비밀 키나 고객 정보가 든 파일은 다루지 않는 것이 안전합니다.</p>

<h3>Q3. 에디터형 AI(Cursor 등)와 뭐가 다른가요?</h3>
<p>에디터형은 화면에서 마우스로 변경 사항을 보며 작업하기 편하고, 터미널형은 명령 중심이라 자동화나 큰 단위 작업에 유리합니다. 둘을 함께 쓰는 사람도 많습니다.</p>

<h3>Q4. 설치가 안 돼요.</h3>
<p>대부분 Node.js 버전 문제이거나 권한 문제입니다. <code>node --version</code>으로 버전을 확인하고, 공식 문서의 설치 요구 사항과 비교해 보세요.</p>

<h2>마치며</h2>
<p>터미널 AI 도구는 "AI가 내 대신 코드를 짜주는" 경험을 한 단계 끌어올립니다. 오늘은 작은 연습용 프로젝트 하나에서 <strong>폴더 구조 설명 → 작은 수정 → 변경 내용 확인</strong>의 흐름만 한 번 해 보세요. 그 한 번이 앞으로의 개발 방식을 바꿔 놓을 수 있습니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  'published',
  'ko',
  '2026-10-19T21:52:00+09:00',
  '2026-10-19T22:10:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 8: Cloudflare로 Next.js 무료 배포
-- 카테고리: 웹 개발 (web-dev) | 상태: 임시저장(draft) - 이미지 대기
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  'Cloudflare로 Next.js 블로그 무료 배포하기 — OpenNext와 GitHub Actions 자동 배포 설정법',
  'cloudflare-nextjs-free-deploy',
  'Vercel 말고 Cloudflare에도 Next.js 블로그를 배포할 수 있습니다. OpenNext 어댑터 설치, wrangler 설정, API 토큰 발급, GitHub Actions 자동 배포, 환경 변수 주의점까지 실제 운영 중인 구성 기준으로 정리했습니다.',
  '/blog/cloudflare-nextjs-free-deploy/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: Next.js를 Cloudflare Workers에 올리려면 <strong>@opennextjs/cloudflare 어댑터 + wrangler 설정 + API 토큰</strong>이 필요합니다. 한 번 세팅해 두면 GitHub에 push할 때마다 GitHub Actions가 빌드부터 배포까지 자동으로 처리합니다. 이 글은 실제로 운영 중인 블로그 구성을 기준으로 설명합니다.</p>

<h2>왜 Cloudflare에 배포할까요?</h2>
<p>Next.js 배포 하면 Vercel을 가장 먼저 떠올리지만, Cloudflare도 좋은 선택지입니다. 전 세계 엣지 네트워크에서 빠르게 응답하고, 도메인·DNS·보안을 한곳에서 관리할 수 있으며, 개인 블로그 규모에서는 무료 플랜으로 시작할 수 있습니다. Vercel 배포 방법은 <a href="/ko/blog/deploy-blog-to-vercel">Vercel로 블로그 배포하기</a>에서 다뤘으니 두 방법을 비교해 보세요.</p>
<p>Next.js는 Cloudflare 환경에서 바로 돌아가지 않기 때문에 <strong>OpenNext의 Cloudflare 어댑터</strong>가 빌드 결과물을 Workers가 이해하는 형태로 변환해 줍니다. 이 글에서 쓰는 설정은 모두 이 어댑터의 기본 구성입니다.</p>

<h2>배포 전체 흐름 한눈에 보기</h2>
<ol>
<li>Cloudflare 계정 만들기 + API 토큰·계정 ID 준비</li>
<li>프로젝트에 어댑터와 wrangler 설치</li>
<li>설정 파일(wrangler.jsonc, open-next.config.ts) 준비</li>
<li>배포 명령 스크립트 등록</li>
<li>로컬에서 미리보기 → 첫 수동 배포</li>
<li>GitHub Actions로 자동 배포</li>
<li>커스텀 도메인 연결</li>
</ol>

<h2>1단계. Cloudflare 계정과 인증 정보 준비</h2>
<ol>
<li><a href="https://dash.cloudflare.com" target="_blank" rel="noopener noreferrer">Cloudflare 대시보드</a>에서 무료 계정을 만듭니다.</li>
<li><strong>계정 ID</strong>: 대시보드의 Workers 관련 화면 우측에서 Account ID를 복사해 둡니다.</li>
<li><strong>API 토큰</strong>: 프로필의 API 토큰 메뉴에서 토큰을 만듭니다. "Edit Cloudflare Workers" 같은 Workers 편집 권한 템플릿을 사용하면 편리합니다.</li>
</ol>
<p>API 토큰은 <strong>비밀번호와 같습니다</strong>. 코드나 GitHub 저장소에 직접 적지 말고, 뒤에서 설명할 GitHub Secrets에만 저장하세요.</p>

<h2>2단계. 어댑터와 wrangler 설치</h2>
<p>Next.js 프로젝트 폴더에서 아래 명령을 실행합니다.</p>
<pre><code>npm install @opennextjs/cloudflare@latest
npm install -D wrangler@latest</code></pre>
<p>wrangler는 Cloudflare의 공식 명령줄 도구이고, @opennextjs/cloudflare는 Next.js 빌드 결과를 Workers용으로 바꿔 주는 어댑터입니다.</p>

<h2>3단계. 설정 파일 준비</h2>

<h3>① wrangler.jsonc</h3>
<p>프로젝트 최상위에 Workers 배포 설정 파일을 둡니다. 핵심 항목은 다음과 같습니다.</p>
<pre><code>{
  "main": ".open-next/worker.js",
  "name": "myblog",
  "compatibility_date": "2026-09-26",
  "compatibility_flags": ["nodejs_compat", "global_fetch_strictly_public"],
  "assets": {
    "directory": ".open-next/assets",
    "binding": "ASSETS"
  }
}</code></pre>
<ul>
<li><code>main</code>: 어댑터가 만들어 주는 워커 진입 파일 경로</li>
<li><code>name</code>: 워커 이름 (workers.dev 주소에 사용됨)</li>
<li><code>nodejs_compat</code>: Node.js 호환 기능 활성화 (Next.js에 필요)</li>
<li><code>assets</code>: 이미지·CSS 같은 정적 파일 위치</li>
</ul>

<h3>② open-next.config.ts</h3>
<p>어댑터 설정 파일입니다. 처음에는 기본값만으로 충분합니다.</p>
<pre><code>import { defineCloudflareConfig } from "@opennextjs/cloudflare";

export default defineCloudflareConfig({});</code></pre>
<p>캐시를 더 정교하게 쓰고 싶어지면 이후에 R2 같은 저장소를 연결하는 옵션을 추가하면 됩니다.</p>

<h2>4단계. package.json에 배포 스크립트 등록</h2>
<pre><code>"scripts": {
  "preview": "opennextjs-cloudflare build &amp;&amp; opennextjs-cloudflare preview",
  "deploy": "opennextjs-cloudflare build &amp;&amp; opennextjs-cloudflare deploy"
}</code></pre>
<ul>
<li><code>npm run preview</code>: 배포 전에 로컬에서 Cloudflare 환경으로 미리 실행</li>
<li><code>npm run deploy</code>: 빌드 후 Cloudflare에 실제 배포</li>
</ul>

<figure>
<img src="/blog/cloudflare-nextjs-free-deploy/01.webp" alt="코드 저장소가 자동 배포 파이프라인을 거쳐 클라우드 서버로 전달되는 지속적 배포 일러스트" width="960" height="540" loading="lazy" />
<figcaption>GitHub에 push하면 빌드와 배포가 자동으로 이어지는 구조를 만들 수 있습니다.</figcaption>
</figure>

<h2>5단계. 첫 배포 해보기</h2>
<p>터미널에서 아래 순서로 진행합니다.</p>
<ol>
<li><code>npx wrangler login</code>으로 Cloudflare 계정에 로그인합니다.</li>
<li><code>npm run preview</code>로 로컬에서 정상 동작하는지 확인합니다.</li>
<li><code>npm run deploy</code>로 배포합니다.</li>
<li>완료되면 <code>https://워커이름.계정명.workers.dev</code> 형태의 주소가 출력됩니다.</li>
</ol>
<p>이 주소로 접속해 사이트가 정상적으로 열리면 첫 배포 성공입니다.</p>

<h2>6단계. GitHub Actions로 자동 배포</h2>
<p><code>.github/workflows/deploy.yml</code> 파일을 만들어 main 브랜치에 push될 때마다 자동으로 배포되게 합니다.</p>
<pre><code>name: Deploy to Cloudflare

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with:
          version: 10
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: "pnpm"
      - run: pnpm install --no-frozen-lockfile
      - run: pnpm run deploy
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}</code></pre>
<p>npm을 쓰는 프로젝트라면 pnpm 관련 단계를 npm 명령으로 바꾸면 됩니다. 리눅스 환경(<code>ubuntu-latest</code>)에서 빌드하는 이유는 OpenNext가 리눅스·macOS 환경에서 가장 안정적이기 때문입니다. Windows에서 빌드가 자주 실패한다면 WSL이나 GitHub Actions를 활용하세요.</p>

<h3>GitHub Secrets 등록 방법</h3>
<ol>
<li>GitHub 저장소 → <strong>Settings</strong> → <strong>Secrets and variables</strong> → <strong>Actions</strong>를 엽니다.</li>
<li><strong>New repository secret</strong>을 누르고 이름과 값을 입력합니다.</li>
<li><code>CLOUDFLARE_API_TOKEN</code>, <code>CLOUDFLARE_ACCOUNT_ID</code>를 등록합니다.</li>
</ol>

<figure>
<img src="/blog/cloudflare-nextjs-free-deploy/02.webp" alt="클라우드 서버와 연결된 자물쇠 금고에 비밀 키가 안전하게 보관되는 환경 변수 관리 일러스트" width="960" height="540" loading="lazy" />
<figcaption>API 키와 비밀번호는 코드가 아니라 Secrets(비밀 저장소)에 보관해야 안전합니다.</figcaption>
</figure>

<h2>환경 변수 주의점 (가장 많이 막히는 부분)</h2>
<p>Supabase 키 같은 값을 쓰는 사이트라면 환경 변수 설정이 중요합니다.</p>
<table>
<thead><tr><th>종류</th><th>예시</th><th>주의점</th></tr></thead>
<tbody>
<tr><td><code>NEXT_PUBLIC_</code>으로 시작</td><td>NEXT_PUBLIC_SUPABASE_URL</td><td><strong>빌드할 때</strong> 코드에 포함되므로, 빌드가 실행되는 환경(GitHub Actions)에 값이 있어야 함</td></tr>
<tr><td>서버 전용 비밀 값</td><td>서비스 롤 키, 이메일 API 키</td><td>브라우저에 노출되면 안 됨. 공개 저장소에 올리지 말 것</td></tr>
</tbody>
</table>
<p>GitHub Actions에서 빌드하는 경우, 워크플로의 <code>env:</code> 항목에 <code>${{ secrets.이름 }}</code> 형태로 필요한 값을 모두 넘겨야 합니다. 이 부분을 빼먹으면 배포는 성공해도 사이트에서 데이터를 불러오지 못하는 문제가 생깁니다.</p>

<h2>7단계. 커스텀 도메인 연결</h2>
<ol>
<li>도메인을 Cloudflare에서 구입했거나 DNS를 Cloudflare로 옮겨 둡니다.</li>
<li>Cloudflare 대시보드에서 해당 Worker를 열고 <strong>설정 → 도메인 및 경로(Domains &amp; Routes)</strong>로 이동합니다.</li>
<li><strong>커스텀 도메인 추가</strong>를 선택해 내 도메인을 입력합니다.</li>
<li>인증서(HTTPS)는 자동으로 발급됩니다.</li>
</ol>
<p>연결 후에는 <code>www</code>와 루트 도메인 중 대표 주소를 정하고 한쪽에서 다른 쪽으로 이동시키는 설정을 해 두면 검색엔진에도 좋습니다. 도메인 연결 후에는 <a href="/ko/blog/google-search-console-guide">구글 서치콘솔 등록</a>도 잊지 마세요.</p>

<h2>무료 플랜 한도와 주의점</h2>
<p>Cloudflare Workers는 무료 플랜으로 시작할 수 있지만 <strong>요청 수, 실행 시간, 배포 파일 크기에 제한</strong>이 있습니다. 특히 Next.js 앱은 규모가 커지면 압축된 워커 크기가 무료 한도에 걸릴 수 있습니다. 한도 수치는 수시로 바뀌므로 <strong>배포 전 공식 문서의 Workers 한도(Limits) 항목</strong>을 확인하세요. 한도를 넘는 경우 유료 플랜이 필요할 수 있습니다.</p>

<h2>자주 만나는 문제와 해결법</h2>
<table>
<thead><tr><th>증상</th><th>원인</th><th>해결</th></tr></thead>
<tbody>
<tr><td>빌드 중 오류 (Windows)</td><td>OpenNext의 Windows 환경 불안정</td><td>WSL 또는 GitHub Actions(리눅스)에서 빌드</td></tr>
<tr><td>인증 실패 (Authentication error)</td><td>API 토큰 권한 부족 또는 계정 ID 불일치</td><td>토큰 권한과 Account ID를 다시 확인</td></tr>
<tr><td>배포는 됐는데 데이터가 비어 있음</td><td>빌드 시 환경 변수 누락</td><td>워크플로 env에 NEXT_PUBLIC 값 전달 확인</td></tr>
<tr><td>워커 크기 초과</td><td>번들이 무료 한도 초과</td><td>불필요한 패키지 제거 또는 유료 플랜 검토</td></tr>
</tbody>
</table>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. Vercel과 Cloudflare 중 뭐가 더 좋나요?</h3>
<p>Vercel은 Next.js와의 호환성과 설정 편의성이 높고, Cloudflare는 도메인·보안·네트워크를 함께 관리하기 좋습니다. 처음 시작하는 초보자는 Vercel이 더 쉽고, 이미 Cloudflare를 쓰고 있다면 Cloudflare 배포도 훌륭한 선택입니다.</p>

<h3>Q2. 자동 배포는 꼭 해야 하나요?</h3>
<p>필수는 아니지만, 한 번 설정해 두면 push만으로 배포가 끝나서 매우 편합니다. 수동 배포로 먼저 성공해 본 뒤에 자동화하는 순서를 권합니다.</p>

<h3>Q3. 배포가 성공했는데 반영이 안 보여요.</h3>
<p>브라우저 캐시일 수 있습니다. 강력 새로고침(Ctrl+F5)을 해 보고, GitHub의 Actions 탭에서 최신 배포가 성공했는지 확인하세요.</p>

<h3>Q4. 비용이 갑자기 나올 수 있나요?</h3>
<p>무료 플랜은 한도를 넘으면 유료 전환을 안내받는 방식이므로, 자동 청구가 되기 전에 사용량을 대시보드에서 주기적으로 확인하면 됩니다.</p>

<h2>마치며</h2>
<p>처음에는 설정 파일과 토큰이 낯설지만, 순서대로 한 번만 해 두면 이후에는 글을 쓰고 GitHub에 올리는 것만으로 사이트가 자동 갱신됩니다. 오늘은 우선 <strong>로컬 preview → 수동 deploy</strong>까지 성공해 보고, 이후에 자동 배포를 붙여 보세요.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  'draft',
  'ko',
  '2026-10-19T21:54:00+09:00',
  '2026-10-19T23:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 9: 무료 AI 이미지 생성 도구 비교
-- 카테고리: 도구 리뷰 (tool-review) | 상태: 임시저장(draft) - 이미지 대기
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  '무료 AI 이미지 생성 도구 비교 2026 — 블로그 썸네일 만들기 좋은 서비스 고르는 기준',
  'free-ai-image-generators-comparison',
  '블로그 썸네일과 본문 이미지를 AI로 만들고 싶다면 어떤 도구를 써야 할까요? 무료 AI 이미지 생성 서비스를 고르는 5가지 기준, 서비스별 특징 비교, 상업적 이용 주의점, WebP 압축까지 정리했습니다.',
  '/blog/free-ai-image-generators-comparison/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: 무료 AI 이미지 도구를 고를 때는 <strong>무료 제공량, 상업적 이용 가능 여부, 한글 글자 정확도, 스타일 일관성, 속도</strong> 다섯 가지를 보세요. 그리고 만든 이미지는 반드시 WebP로 압축해서 올려야 블로그 속도가 느려지지 않습니다.</p>

<h2>블로그 이미지, 왜 AI로 만들까요?</h2>
<p>블로그 글에 이미지가 있으면 체류 시간이 늘고 검색 결과에서도 눈에 띄지만, 저작권 걱정 없이 쓸 이미지를 매번 찾는 일은 번거롭습니다. 직접 찍거나 그리기도 어렵고요. 그래서 많은 블로거가 글의 주제에 맞는 이미지를 AI로 직접 생성해 사용합니다. 이 블로그의 일러스트도 AI 도구로 만든 것입니다.</p>
<p>다만 "무료"라고 해서 다 같은 조건이 아닙니다. 도구마다 하루 생성 횟수, 이미지 크기, 상업적 이용 허용 범위가 다릅니다. 아래 기준을 먼저 알아 두면 시행착오를 줄일 수 있습니다.</p>

<h2>무료 AI 이미지 도구 고르는 5가지 기준</h2>
<table>
<thead><tr><th>기준</th><th>확인할 점</th><th>왜 중요한가</th></tr></thead>
<tbody>
<tr><td>1. 무료 제공량</td><td>하루·한 달 생성 가능 횟수, 대기 시간</td><td>글 한 편에 이미지가 3장이면 한도가 금방 소진됨</td></tr>
<tr><td>2. 상업적 이용</td><td>블로그·광고 수익 사이트에 써도 되는지</td><td>애드센스 등 수익 블로그에 쓸 때 약관 위반 방지</td></tr>
<tr><td>3. 한글 글자 정확도</td><td>이미지 안의 한글이 깨지는지</td><td>대부분 한글 텍스트가 어색하게 나옴</td></tr>
<tr><td>4. 스타일 일관성</td><td>같은 프롬프트로 비슷한 분위기를 유지하는지</td><td>블로그 전체 디자인 통일감</td></tr>
<tr><td>5. 해상도·다운로드</td><td>원하는 비율(16:9 등)과 해상도 지원 여부</td><td>썸네일·본문 이미지에 바로 쓰기 위해</td></tr>
</tbody>
</table>

<figure>
<img src="/blog/free-ai-image-generators-comparison/01.webp" alt="풍경, 인물, 아이콘, 추상화 등 서로 다른 스타일의 액자 네 개를 나란히 비교하는 일러스트" width="960" height="540" loading="lazy" />
<figcaption>같은 주제라도 도구마다 스타일이 달라, 내 블로그와 어울리는 도구를 고르는 것이 중요합니다.</figcaption>
</figure>

<h2>대표적인 AI 이미지 생성 서비스 비교</h2>
<p>아래는 널리 쓰이는 서비스들의 <strong>성격과 특징</strong>을 정리한 표입니다. 무료 제공량과 이용 약관은 수시로 변경되므로, 정확한 조건은 반드시 <strong>이용 시점의 공식 안내</strong>에서 확인하세요.</p>
<table>
<thead><tr><th>서비스</th><th>특징</th><th>이런 분께 추천</th></tr></thead>
<tbody>
<tr><td>ChatGPT 이미지 생성</td><td>대화로 수정 요청이 쉬움, 프롬프트 이해도가 높은 편</td><td>대화하면서 이미지를 다듬고 싶은 분</td></tr>
<tr><td>Google Gemini</td><td>구글 계정으로 바로 시작, 대화형 생성</td><td>구글 서비스를 이미 쓰는 분</td></tr>
<tr><td>Microsoft Designer / Copilot</td><td>마이크로소프트 계정 기반, 디자인 템플릿 연계</td><td>간단한 카드뉴스·SNS 이미지가 필요한 분</td></tr>
<tr><td>Adobe Firefly</td><td>저작권 측면을 강조한 학습 데이터 정책을 내세움</td><td>상업적 이용의 안정성을 중시하는 분</td></tr>
<tr><td>Canva (AI 이미지 기능)</td><td>생성 후 바로 디자인 편집·썸네일 제작 가능</td><td>글자와 레이아웃을 함께 넣고 싶은 분</td></tr>
<tr><td>Leonardo.ai 등 전문 서비스</td><td>스타일·모델 선택 폭이 넓음</td><td>이미지 스타일을 세밀하게 조정하고 싶은 분</td></tr>
<tr><td>Stable Diffusion 계열 (오픈소스)</td><td>내 컴퓨터에서 직접 실행 가능, 설정이 복잡</td><td>제한 없이 실험하고 싶은 숙련자</td></tr>
</tbody>
</table>
<p>처음 시작하는 분께는 <strong>이미 계정이 있는 서비스</strong>(ChatGPT, Gemini, Microsoft 등) 중 하나로 시작해 보는 것을 권합니다. 계정 생성이나 설치 없이 오늘 바로 만들어 볼 수 있기 때문입니다.</p>

<h2>블로그용 이미지 프롬프트 공식</h2>
<p>원하는 이미지를 얻으려면 <strong>주제 + 스타일 + 색상 + 구도 + 제외할 것</strong>을 함께 적어 주세요.</p>
<pre><code>[주제]를 표현한 플랫 벡터 일러스트,
[보라색과 파란색 그라데이션] 배경,
깔끔하고 미니멀한 스타일, 16:9 비율,
이미지 안에 글자, 숫자, 라벨은 넣지 마세요.</code></pre>
<p>이미지 안에 글자를 넣지 말라고 명시하는 것이 중요합니다. AI는 글자를 그릴 때 철자나 한글이 깨지는 경우가 많기 때문입니다. 글자가 필요하다면 이미지에 넣지 말고 <strong>HTML 텍스트나 캡션</strong>으로 따로 쓰는 것이 SEO에도 좋습니다.</p>

<h2>상업적 이용과 저작권 주의사항</h2>
<ul>
<li><strong>약관 확인</strong>: 무료 플랜에서도 상업적 이용이 가능한지, 출처 표기가 필요한지 확인하세요.</li>
<li><strong>실존 인물·유명 캐릭터·브랜드 로고</strong>는 생성하거나 사용하지 마세요. 초상권·상표권 문제가 생길 수 있습니다.</li>
<li><strong>생성 기록 보관</strong>: 어떤 도구로 언제 만들었는지 메모해 두면 분쟁 시 도움이 됩니다.</li>
<li><strong>AI 생성 이미지임을 밝히기</strong>: 필요에 따라 블로그 소개나 이미지 설명에 AI 사용 사실을 알리면 신뢰도에 도움이 됩니다.</li>
</ul>
<p>저작권과 관련 법규는 국가와 시기에 따라 달라질 수 있으므로 중요한 상업 프로젝트라면 전문가나 공식 기준을 확인하세요.</p>

<h2>꼭 해야 할 일: WebP로 압축해서 올리기</h2>
<p>AI가 만든 이미지는 원본이 1~2MB가 넘는 경우가 많습니다. 그대로 올리면 페이지가 느려지고 검색 순위에도 불리합니다. <strong>WebP 형식으로 변환하고 크기를 줄이면 용량을 크게 줄일 수 있습니다.</strong></p>
<pre><code>npx sharp-cli -i 원본.jpg -o cover.webp -f webp -q 72 resize 1200 630</code></pre>
<ul>
<li><code>-f webp</code>: WebP 형식으로 변환</li>
<li><code>-q 72</code>: 품질 72 (70~75 정도가 용량과 화질의 균형이 좋음)</li>
<li><code>resize 1200 630</code>: 대표 이미지 권장 크기</li>
</ul>
<p>이렇게 하면 이미지 한 장이 수십 KB 수준으로 줄어듭니다. 용량 목표는 <strong>장당 50KB 이하</strong>로 잡아 보세요. 명령줄이 어렵다면 Squoosh 같은 웹 기반 이미지 압축 도구를 사용해도 됩니다.</p>

<figure>
<img src="/blog/free-ai-image-generators-comparison/02.webp" alt="블로그 썸네일 이미지를 가벼운 파일로 압축하고 저작권 보호 방패와 체크 표시가 함께 있는 일러스트" width="960" height="540" loading="lazy" />
<figcaption>생성한 이미지는 압축하고 저작권 조건을 확인한 뒤에 사용하세요.</figcaption>
</figure>

<h2>이미지를 올릴 때 SEO 체크리스트</h2>
<table>
<thead><tr><th>항목</th><th>실천 방법</th></tr></thead>
<tbody>
<tr><td>파일 이름</td><td>의미 있는 영문 이름 사용 (예: <code>cover.webp</code>, <code>01.webp</code>)</td></tr>
<tr><td>alt 설명</td><td>이미지 내용을 구체적인 한글 문장으로 작성</td></tr>
<tr><td>크기 지정</td><td>width, height 속성 지정으로 화면 흔들림 방지</td></tr>
<tr><td>지연 로딩</td><td>첫 이미지 외에는 loading="lazy" 사용</td></tr>
<tr><td>용량</td><td>장당 50KB 이하 목표</td></tr>
</tbody>
</table>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 무료로도 충분히 블로그를 운영할 수 있나요?</h3>
<p>글 한 편에 이미지 2~3장 정도라면 무료 한도로도 충분히 가능합니다. 하루에 많은 양을 만들고 싶다면 여러 서비스를 번갈아 쓰거나 유료 요금제를 검토해 보세요.</p>

<h3>Q2. AI 이미지를 쓰면 구글 검색에 불리한가요?</h3>
<p>이미지가 AI로 만들어졌다는 이유만으로 불이익을 받는다고 알려져 있지 않습니다. 중요한 것은 글의 내용 품질, 이미지와 글의 관련성, alt 설명, 로딩 속도입니다.</p>

<h3>Q3. 이미지 속 한글이 계속 깨져요.</h3>
<p>현재 대부분의 도구에서 한글 텍스트 생성은 불안정합니다. 이미지는 글자 없이 만들고, 필요한 문구는 Canva 같은 편집 도구로 얹거나 본문 텍스트로 처리하세요.</p>

<h3>Q4. 같은 스타일로 계속 만들려면 어떻게 하나요?</h3>
<p>프롬프트의 스타일 문장("플랫 벡터 일러스트, 미니멀, 그라데이션 배경")을 고정해 두고 주제만 바꿔 쓰면 일관성이 높아집니다. 그 문장을 메모해 두고 복사해 쓰세요.</p>

<h2>마치며</h2>
<p>AI 이미지 도구는 계속 바뀌지만 <strong>고르는 기준과 사용 습관</strong>은 변하지 않습니다. 약관을 확인하고, 글자는 이미지에 넣지 않고, WebP로 압축하고, alt를 꼼꼼히 쓰는 것. 이 네 가지만 지켜도 블로그 이미지 품질과 속도를 모두 잡을 수 있습니다. 오늘 글 한 편의 썸네일부터 만들어 보세요.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'tool-review'),
  'draft',
  'ko',
  '2026-10-19T21:56:00+09:00',
  '2026-10-19T23:30:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트 10: 직장인 부업 시작 전 체크리스트
-- 카테고리: 수익화 (monetization) | 상태: 임시저장(draft) - 이미지 대기
-- ※ 실제 수익을 지어내지 않고, 시작 전 점검 기준 중심으로 구성
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, thumbnail_url, content, category_id, status, locale, created_at, published_at)
VALUES (
  '직장인 부업 시작 전 꼭 확인할 7가지 — 겸업 금지, 세금, 시간당 수익 계산법',
  'side-hustle-checklist-for-employees',
  '부업을 시작하기 전에 회사 규정, 세금, 시간 계산부터 확인하세요. 겸업 금지 조항 점검법, 소득 종류별 세금 개요, 시간당 수익 계산법, 부업 유형별 비교까지 시작 전 체크리스트로 정리했습니다.',
  '/blog/side-hustle-checklist-for-employees/cover.webp',
  $content$<p><strong>한 줄 요약</strong>: 부업은 "무엇을 할까"보다 <strong>"시작해도 되는가, 세금은 어떻게 되는가, 내 시간은 충분한가"</strong>를 먼저 확인해야 안전합니다. 이 글은 시작 전에 점검할 7가지를 체크리스트로 정리했습니다.</p>

<h2>부업, 시작 전에 이것부터 보세요</h2>
<p>물가는 오르고 월급만으로는 불안하다는 이야기가 많아지면서 직장인 부업에 관심이 커졌습니다. 하지만 "월 수백만 원" 같은 광고성 문구에 끌려 시작했다가 회사 규정 위반, 예상치 못한 세금, 본업 성과 하락으로 곤란해지는 사례도 적지 않습니다.</p>
<p>이 글에는 특정 수익 금액을 약속하는 내용이 없습니다. 대신 <strong>실패 확률을 줄이는 점검 기준</strong>을 다룹니다. 개발 기술을 활용한 구체적인 방법은 <a href="/ko/blog/developer-side-income-guide">개발자 부업 가이드</a>를, 블로그 수익의 현실은 <a href="/ko/blog/blog-adsense-income-realistic-guide">블로그 애드센스 수익 현실 가이드</a>를 참고해 보세요.</p>

<h2>체크 1. 회사의 겸업 금지 규정 확인</h2>
<p>가장 먼저 확인할 것은 회사 규정입니다. 부업 자체가 불법은 아니지만, <strong>회사가 취업규칙이나 근로계약서에서 겸업을 제한</strong>하는 경우가 있습니다.</p>
<ul>
<li><strong>근로계약서·취업규칙</strong>의 "겸업", "영리 활동", "복무" 관련 조항을 찾아 읽어 보세요.</li>
<li>동종 업계 일이나 <strong>회사 업무와 경쟁 관계</strong>가 되는 활동은 특히 위험합니다.</li>
<li>회사 장비, 근무 시간, 회사 정보를 부업에 사용하면 규정 위반 소지가 큽니다.</li>
<li>공무원 등 법령으로 영리 활동이 제한되는 직군도 있으니 해당 법령을 확인해야 합니다.</li>
</ul>
<p>애매하다면 인사 담당 부서에 문의하거나 사전 신고·허가 절차가 있는지 확인하세요. 규정은 회사마다 크게 다릅니다.</p>

<figure>
<img src="/blog/side-hustle-checklist-for-employees/01.webp" alt="서류에 도장이 찍히고 경고 방패가 함께 있는 회사 규정과 겸업 확인 일러스트" width="960" height="540" loading="lazy" />
<figcaption>부업을 시작하기 전에 취업규칙과 근로계약서의 겸업 조항부터 확인하세요.</figcaption>
</figure>

<h2>체크 2. 세금 구조 이해하기</h2>
<p>부업으로 돈을 벌면 소득에 따라 <strong>세금 신고 의무</strong>가 생길 수 있습니다. 아래는 이해를 돕는 개요이며, 실제 기준은 법과 해마다 바뀔 수 있으므로 <strong>국세청 홈택스나 세무사 상담</strong>으로 꼭 확인하세요.</p>
<table>
<thead><tr><th>구분</th><th>개요</th><th>확인할 점</th></tr></thead>
<tbody>
<tr><td>근로소득</td><td>회사에서 받는 월급</td><td>연말정산으로 정산</td></tr>
<tr><td>사업소득</td><td>프리랜서·스마트스토어·블로그 광고 수익 등 지속적·반복적 활동</td><td>사업자등록 필요 여부, 종합소득세 신고</td></tr>
<tr><td>기타소득</td><td>일시적·비정기적 수익(강연료 등)</td><td>소득 금액에 따른 신고 방식</td></tr>
</tbody>
</table>
<ul>
<li>프리랜서 수입은 지급받을 때 <strong>3.3%가 원천징수</strong>되는 경우가 많습니다. 이것이 세금의 끝이 아니라 이후 <strong>종합소득세 신고(통상 5월)</strong>에서 최종 정산됩니다.</li>
<li>본업의 근로소득과 부업의 소득을 <strong>합산해 신고</strong>해야 하는 경우가 있습니다.</li>
<li>수입이 늘면 건강보험료나 부양가족 자격 등에 영향을 줄 수 있어, 소득 기준을 미리 확인해야 합니다.</li>
<li>수입·지출 내역과 영수증은 <strong>처음부터 기록</strong>해 두세요.</li>
</ul>
<p>"신고하지 않으면 모르겠지"라는 생각은 가장 위험합니다. 세금 문제는 나중에 가산세로 돌아올 수 있으니 투명하게 기록하고 신고하는 것이 결국 이득입니다.</p>

<h2>체크 3. 시간당 수익 계산해 보기</h2>
<p>부업은 결국 <strong>내 시간을 파는 일</strong>이므로, 시간당 얼마를 버는지 계산해 보면 현실이 보입니다.</p>
<pre><code>시간당 수익 = (월 수익 - 월 비용) ÷ 월 투입 시간</code></pre>
<p>아래는 계산 방법을 설명하기 위한 <strong>가정 예시</strong>입니다. (실제 수익이 아닙니다.)</p>
<table>
<thead><tr><th>항목</th><th>가정 값</th></tr></thead>
<tbody>
<tr><td>월 수익</td><td>500,000원</td></tr>
<tr><td>월 비용 (도구 구독, 광고비 등)</td><td>100,000원</td></tr>
<tr><td>월 투입 시간 (주 10시간 × 4주)</td><td>40시간</td></tr>
<tr><td>시간당 수익</td><td>(500,000 − 100,000) ÷ 40 = 10,000원</td></tr>
</tbody>
</table>
<p>이 값을 <strong>최저임금과 비교</strong>해 보세요. 부업 초기에는 시간당 수익이 낮은 것이 정상이지만, 일정 기간이 지나도 개선되지 않는다면 방향을 바꿔야 한다는 신호입니다. 세금과 건강보험 영향까지 고려한 <strong>세후 수익</strong>으로 계산하면 더 정확합니다.</p>

<figure>
<img src="/blog/side-hustle-checklist-for-employees/02.webp" alt="계산기와 달력, 동전, 세금 서류가 함께 놓인 소득과 시간 계산 일러스트" width="960" height="540" loading="lazy" />
<figcaption>월 수익, 비용, 투입 시간을 기록하면 시간당 수익이 보이고 현실적인 판단을 할 수 있습니다.</figcaption>
</figure>

<h2>체크 4. 초기 비용과 위험 점검</h2>
<ul>
<li><strong>돈이 먼저 나가는 부업</strong>(재고 구매, 고가 강의 결제, 보증금)은 손실 위험이 큽니다.</li>
<li>"선입금하면 수익 보장" 같은 제안은 <strong>사기 가능성</strong>이 높으니 가까이하지 마세요.</li>
<li>처음에는 <strong>잃어도 괜찮은 금액</strong>만 투자하고, 소액으로 검증한 뒤 키우세요.</li>
<li>다단계, 고수익 보장, 코인·투자 리딩을 부업으로 소개하는 경우는 특히 조심하세요.</li>
</ul>

<h2>체크 5. 내 시간과 체력 계산하기</h2>
<p>본업이 있는 상태에서는 <strong>쓸 수 있는 시간이 한정</strong>되어 있습니다. 평일 퇴근 후 2시간, 주말 하루 같은 식으로 현실적인 투입 시간을 먼저 정하세요.</p>
<ul>
<li>수면과 휴식을 줄이는 계획은 오래가지 못합니다.</li>
<li>본업 성과가 떨어지면 부업 수익보다 손해가 큽니다.</li>
<li>주 5~10시간 정도에서 시작해 보고, 부담 정도에 따라 조절하세요.</li>
</ul>

<h2>체크 6. 부업 유형별 비교</h2>
<table>
<thead><tr><th>유형</th><th>시작 장벽</th><th>초기 비용</th><th>수익이 나는 속도</th><th>시간 유연성</th></tr></thead>
<tbody>
<tr><td>블로그·콘텐츠(광고 수익)</td><td>낮음</td><td>낮음</td><td>느림 (수개월~)</td><td>높음</td></tr>
<tr><td>프리랜서 (디자인·개발·번역)</td><td>기술 필요</td><td>낮음</td><td>비교적 빠름</td><td>보통</td></tr>
<tr><td>온라인 판매 (스마트스토어 등)</td><td>보통</td><td>재고에 따라 다름</td><td>보통</td><td>보통</td></tr>
<tr><td>강의·전자책</td><td>전문성 필요</td><td>낮음~보통</td><td>보통 (제작 기간 필요)</td><td>높음</td></tr>
<tr><td>시간제 아르바이트</td><td>낮음</td><td>없음</td><td>빠름</td><td>낮음 (시간 고정)</td></tr>
</tbody>
</table>
<p>나에게 맞는 유형은 <strong>내가 가진 기술, 쓸 수 있는 시간, 감당할 수 있는 초기 비용</strong>에 따라 달라집니다. 블로그 같은 콘텐츠 부업은 수익이 나기까지 오래 걸리므로 초기에는 성과가 없어도 꾸준히 지속할 수 있는지가 핵심입니다. 블로그 운영의 기본기는 <a href="/ko/blog/blog-seo-traffic-growth-guide">블로그 SEO 트래픽 늘리기 가이드</a>에서 확인할 수 있습니다.</p>

<h2>체크 7. 본업이 최우선, 목표와 기한을 정하기</h2>
<ol>
<li><strong>목표 금액과 기한</strong>을 정하세요. (예: 6개월 동안 월 목표 설정)</li>
<li><strong>중간 점검 시점</strong>(3개월 등)을 정해 시간당 수익을 다시 계산하세요.</li>
<li><strong>중단 기준</strong>도 미리 정하세요. (예: 6개월 후에도 수입이 비용을 못 넘으면 방향 전환)</li>
<li>본업의 안정적인 월급이 있다는 점을 활용해 <strong>느리더라도 안전하게</strong> 진행하세요.</li>
</ol>

<h2>시작 전 최종 체크리스트</h2>
<table>
<thead><tr><th>확인 항목</th><th>완료</th></tr></thead>
<tbody>
<tr><td>근로계약서·취업규칙의 겸업 조항 확인</td><td>☐</td></tr>
<tr><td>소득 종류별 세금 신고 방법 파악</td><td>☐</td></tr>
<tr><td>수입·지출 기록 방법 정하기</td><td>☐</td></tr>
<tr><td>월 투입 시간과 시간당 수익 목표 계산</td><td>☐</td></tr>
<tr><td>초기 비용 한도 정하기 (잃어도 되는 금액)</td><td>☐</td></tr>
<tr><td>사기성 제안인지 점검 (선입금, 수익 보장)</td><td>☐</td></tr>
<tr><td>3개월·6개월 점검 일정과 중단 기준 정하기</td><td>☐</td></tr>
</tbody>
</table>

<h2>자주 묻는 질문 (FAQ)</h2>
<h3>Q1. 회사에 말하지 않고 부업해도 되나요?</h3>
<p>회사 규정과 법령에 따라 다릅니다. 겸업을 금지하거나 신고를 요구하는 회사도 있으므로 반드시 먼저 규정을 확인하세요. 규정을 어기면 징계 등 불이익이 생길 수 있습니다.</p>

<h3>Q2. 부업 수입이 적어도 세금 신고를 해야 하나요?</h3>
<p>소득 종류와 금액에 따라 신고 의무가 다릅니다. 금액이 적더라도 원천징수된 세금을 돌려받거나 정산하기 위해 신고가 필요할 수 있으니, 국세청이나 세무 전문가에게 확인하세요.</p>

<h3>Q3. 어떤 부업이 가장 좋나요?</h3>
<p>정답은 없습니다. 내 기술, 시간, 자금, 성향에 맞는 것이 최선입니다. 위의 비교표와 시간당 수익 계산을 활용해 후보 두세 가지를 소액으로 먼저 검증해 보세요.</p>

<h3>Q4. 부업으로 얼마까지 벌 수 있나요?</h3>
<p>개인의 기술, 투입 시간, 시장 상황에 따라 크게 다르며 보장된 금액은 없습니다. "누구나 월 얼마"라는 식의 광고는 의심하고, 내 상황으로 직접 계산해 보세요.</p>

<h2>마치며</h2>
<p>좋은 부업은 화려한 수익 인증이 아니라 <strong>규정을 지키고, 세금을 알고, 내 시간을 지키면서 오래 지속할 수 있는 일</strong>입니다. 오늘은 체크리스트 7개 중 아직 확인하지 않은 것부터 하나씩 점검해 보세요. 준비가 탄탄할수록 시작 이후의 시행착오가 줄어듭니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'monetization'),
  'draft',
  'ko',
  '2026-10-19T21:58:00+09:00',
  '2026-10-20T00:00:00+09:00'
) ON CONFLICT (locale, slug) DO NOTHING;


-- ═══════════════════════════════════════════════
-- 포스트-태그 연결 (post_tags)
-- ═══════════════════════════════════════════════

-- 포스트 6: XLOOKUP
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'xlookup-vs-vlookup-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'excel')),
  ((SELECT id FROM posts WHERE slug = 'xlookup-vs-vlookup-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'))
ON CONFLICT DO NOTHING;

-- 포스트 7: Claude Code·Gemini CLI
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'claude-code-gemini-cli-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'claude-code-gemini-cli-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'dev-environment')),
  ((SELECT id FROM posts WHERE slug = 'claude-code-gemini-cli-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'))
ON CONFLICT DO NOTHING;

-- 포스트 8: Cloudflare 배포
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'cloudflare-nextjs-free-deploy' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'deployment')),
  ((SELECT id FROM posts WHERE slug = 'cloudflare-nextjs-free-deploy' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs')),
  ((SELECT id FROM posts WHERE slug = 'cloudflare-nextjs-free-deploy' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'))
ON CONFLICT DO NOTHING;

-- 포스트 9: 무료 AI 이미지 도구
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'free-ai-image-generators-comparison' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'free-ai-image-generators-comparison' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog')),
  ((SELECT id FROM posts WHERE slug = 'free-ai-image-generators-comparison' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'seo'))
ON CONFLICT DO NOTHING;

-- 포스트 10: 직장인 부업 체크리스트
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'side-hustle-checklist-for-employees' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'side-hustle')),
  ((SELECT id FROM posts WHERE slug = 'side-hustle-checklist-for-employees' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'freelance')),
  ((SELECT id FROM posts WHERE slug = 'side-hustle-checklist-for-employees' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog'))
ON CONFLICT DO NOTHING;
