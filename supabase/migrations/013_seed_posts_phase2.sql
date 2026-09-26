-- =============================================
-- 013_seed_posts_phase2.sql
-- Phase 2: 블로그 포스트 12편 추가 삽입
-- ★ 발행일을 9/24 ~ 10/14 (약 3주)에 걸쳐 분산
-- ★ Phase 1 (9/2~9/23) 이후로 자연스럽게 이어짐
-- ※ 반드시 011, 012 실행 후에 실행하세요
-- =============================================

-- ═══════════════════════════════════════════════
-- 포스트 9: Supabase로 데이터베이스 연결하기 — 무료로 백엔드 만들기
-- 카테고리: 웹 개발 | 시리즈: 블로그 만들기 #3
-- 발행일: 2026-09-24
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'Supabase로 데이터베이스 연결하기 — 무료로 백엔드 만들기',
  'supabase-database-setup-free',
  'Supabase 무료 티어로 블로그 백엔드를 구축하는 방법. 가입부터 테이블 설계, Next.js 연동까지 경험을 공유합니다.',
  $content$<h2>Supabase를 선택한 이유</h2>
<p>블로그를 직접 만들기로 했을 때, 가장 큰 고민은 <strong>"글 데이터를 어디에 저장하지?"</strong>였습니다. 파일로 저장하는 방법도 있지만, 댓글이나 조회수 같은 동적인 데이터를 다루려면 데이터베이스가 필요했습니다.</p>
<p>여러 선택지를 비교했습니다:</p>
<ul>
<li><strong>Firebase</strong> — 구글 제품이라 안정적이지만, NoSQL 방식이 저에게는 낯설었습니다.</li>
<li><strong>PlanetScale</strong> — MySQL 기반이라 익숙하지만, 무료 플랜이 축소되었습니다.</li>
<li><strong>Supabase</strong> — PostgreSQL 기반, 무료 티어가 넉넉하고, 관리 대시보드가 직관적입니다.</li>
</ul>
<p>결국 <strong>Supabase</strong>를 선택했습니다. 무료로 시작할 수 있고, PostgreSQL이라 SQL을 바로 쓸 수 있어서 학습 가치도 높았습니다.</p>

<h2>Supabase 시작하기: 가입과 프로젝트 생성</h2>
<p>시작은 정말 간단합니다:</p>
<ul>
<li><strong>1단계</strong>: <a href="https://supabase.com" target="_blank" rel="noopener noreferrer">supabase.com</a>에 접속하여 GitHub 계정으로 로그인합니다.</li>
<li><strong>2단계</strong>: "New Project" 버튼을 클릭합니다.</li>
<li><strong>3단계</strong>: 프로젝트 이름, 데이터베이스 비밀번호, 리전(저는 Northeast Asia를 선택)을 설정합니다.</li>
<li><strong>4단계</strong>: 약 2분 후 프로젝트가 생성됩니다.</li>
</ul>
<p>생성 후 대시보드에서 <strong>API URL</strong>과 <strong>anon key</strong>를 확인합니다. 이 두 값을 Next.js 프로젝트의 환경 변수 파일(.env.local)에 넣으면 연동 준비 완료입니다.</p>

<h2>테이블 설계: 블로그에 필요한 데이터 구조</h2>
<p>블로그에 필요한 테이블을 설계하면서 데이터베이스의 기초를 배웠습니다. 제가 만든 테이블은 다음과 같습니다:</p>
<ul>
<li><strong>posts</strong> — 글 제목, 내용, 슬러그, 상태, 조회수 등</li>
<li><strong>categories</strong> — 카테고리 이름, 슬러그, 색상</li>
<li><strong>tags</strong> — 태그 이름, 슬러그</li>
<li><strong>post_tags</strong> — 글과 태그의 다대다 관계를 연결</li>
<li><strong>comments</strong> — 댓글 (닉네임, 내용, 비밀번호)</li>
<li><strong>series</strong> — 시리즈 (여러 글을 묶는 기능)</li>
</ul>
<p>Supabase의 SQL Editor에서 직접 CREATE TABLE 문을 실행해서 테이블을 만들었습니다. 처음에는 SQL 문법이 낯설었지만, ChatGPT에게 물어보며 하나씩 만들었습니다.</p>

<h2>Next.js와 연동하기</h2>
<p>Supabase에서 제공하는 JavaScript 클라이언트 라이브러리를 설치하면 됩니다:</p>
<p><code>npm install @supabase/supabase-js @supabase/ssr</code></p>
<p>그 다음, 클라이언트를 생성하는 유틸리티 파일을 만듭니다. 서버 컴포넌트용과 클라이언트 컴포넌트용 두 가지를 만드는 것이 포인트입니다. Next.js의 서버 컴포넌트에서는 쿠키를 통해 인증 상태를 관리할 수 있습니다.</p>

<h2>RLS(Row Level Security) — 보안 설정</h2>
<p>Supabase에서 가장 중요한 개념 중 하나가 <strong>RLS</strong>입니다. 이것은 "누가 어떤 데이터에 접근할 수 있는지"를 테이블 단위로 설정하는 보안 기능입니다.</p>
<p>예를 들어:</p>
<ul>
<li>발행된 글은 누구나 읽을 수 있음 (SELECT 허용)</li>
<li>글 작성/수정/삭제는 관리자만 가능 (INSERT/UPDATE/DELETE 제한)</li>
<li>댓글은 누구나 작성 가능하지만, 삭제는 비밀번호 확인 후에만 가능</li>
</ul>
<p>처음에는 RLS 설정을 빼먹어서 API 호출 시 빈 배열만 돌아온 적이 있습니다. Supabase에서 RLS가 활성화되면 정책이 없는 테이블은 기본적으로 모든 접근을 차단합니다. 이 점을 꼭 기억하세요!</p>

<h2>마치며</h2>
<p>Supabase 덕분에 무료로 안정적인 백엔드를 구축할 수 있었습니다. 개인 블로그 정도의 트래픽이라면 무료 티어로 충분합니다. SQL을 배우면서 데이터베이스의 기초를 이해하게 된 것도 큰 소득이었습니다.</p>
<p>다음 글에서는 완성된 블로그를 <strong>Vercel에 배포</strong>하는 과정을 공유할게요. 10분이면 내 블로그를 전 세계에 공개할 수 있습니다!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'building-my-blog'),
  3,
  'published',
  'ko',
  '2026-09-23T21:00:00+09:00',
  '2026-09-24T09:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 10: AI로 보고서 작성하기 — 기획서부터 주간보고까지
-- 카테고리: AI 활용 | 시리즈: 직장인 AI 활용법 #3
-- 발행일: 2026-09-26
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'AI로 보고서 작성하기 — 기획서부터 주간보고까지',
  'ai-report-writing-guide',
  'ChatGPT를 활용해 기획서, 주간보고, 제안서의 초안을 빠르게 만드는 방법. 보고서 종류별 프롬프트 템플릿을 공유합니다.',
  $content$<h2>보고서, 왜 이렇게 오래 걸릴까?</h2>
<p>직장인의 업무 중 가장 시간을 많이 잡아먹는 것 중 하나가 보고서 작성입니다. 주간보고, 기획서, 제안서, 분석 보고서... 내용을 구성하고, 문장을 다듬고, 포맷을 맞추는 데 몇 시간이 훌쩍 지나가곤 합니다.</p>
<p>저는 AI를 활용하기 시작한 이후로 보고서 초안 작성 시간을 <strong>평균 60~70% 절약</strong>하고 있습니다. 비결은 보고서 유형별로 최적화된 프롬프트를 미리 만들어두는 것입니다.</p>

<h2>보고서 종류별 프롬프트 가이드</h2>

<h3>1. 주간 업무 보고</h3>
<p>주간보고는 정해진 형식이 있기 때문에 AI 활용이 가장 쉬운 보고서입니다.</p>
<p><strong>프롬프트 예시:</strong> "이번 주 업무 내용을 주간보고 형식으로 정리해줘. 완료: [A 기능 개발, B 데이터 분석], 진행중: [C 기획서 작성], 이슈: [D 일정 지연], 다음주 계획: [E 미팅, F 테스트]. 간결한 불릿 포인트 형식으로."</p>
<p>핵심 키워드만 넣어주면 깔끔한 구조의 주간보고가 완성됩니다. 여기에 구체적인 수치(달성률, 진행도 등)만 추가하면 됩니다.</p>

<h3>2. 기획서</h3>
<p>기획서는 구조를 잡는 것이 가장 어렵습니다. AI에게 먼저 목차를 만들게 하고, 각 섹션을 채워나가는 방식이 효율적입니다.</p>
<p><strong>프롬프트 예시:</strong> "사내 업무 효율화를 위한 자동화 시스템 도입 기획서 목차를 만들어줘. 배경 및 필요성, 목표, 현황 분석, 제안 솔루션, 기대 효과, 예산, 일정을 포함해줘."</p>
<p>목차가 나오면 각 항목에 대해 "위 기획서의 '배경 및 필요성' 부분을 300자 내외로 작성해줘" 하고 세부 내용을 요청합니다.</p>

<h3>3. 제안서</h3>
<p>고객이나 파트너에게 보내는 제안서는 설득력이 핵심입니다.</p>
<p><strong>프롬프트 예시:</strong> "B2B SaaS 도입을 제안하는 제안서를 작성해줘. 고객사는 중소기업이고, 주요 페인포인트는 수작업 데이터 관리야. 도입 효과를 수치로 표현하고, 경쟁사 대비 차별점을 강조해줘."</p>

<h3>4. 분석 보고서</h3>
<p>데이터를 분석한 결과를 보고할 때, AI가 데이터 해석과 인사이트 도출을 도와줄 수 있습니다.</p>
<p><strong>프롬프트 예시:</strong> "다음 데이터를 분석해서 인사이트를 도출해줘: 1분기 매출 1.2억, 2분기 1.5억, 3분기 1.1억. 계절 요인, 전년 대비 성장률, 4분기 예측을 포함한 분석 보고서 초안을 만들어줘."</p>

<h2>AI 보고서 작성 시 절대 하면 안 되는 것</h2>
<ul>
<li><strong>그대로 제출하기</strong> — AI가 만든 초안은 반드시 검토하고 수정해야 합니다. 특히 수치와 사실 관계는 반드시 확인하세요.</li>
<li><strong>기밀 정보 입력하기</strong> — 실제 매출 수치, 고객 정보, 내부 전략 등은 일반화해서 입력하세요.</li>
<li><strong>AI가 쓴 것처럼 보이게 하기</strong> — 정형화된 표현이 반복되면 AI가 쓴 티가 납니다. 내 어투로 바꾸세요.</li>
</ul>

<h2>보고서 작성 워크플로우</h2>
<p>제가 실제로 사용하는 보고서 작성 프로세스입니다:</p>
<ul>
<li><strong>Step 1</strong>: AI에게 목차/구조를 먼저 요청 (2분)</li>
<li><strong>Step 2</strong>: 목차를 검토하고 수정 (3분)</li>
<li><strong>Step 3</strong>: 각 섹션의 초안을 AI에게 요청 (5분)</li>
<li><strong>Step 4</strong>: 초안을 내 상황에 맞게 수정하고 수치 추가 (10~15분)</li>
<li><strong>Step 5</strong>: 전체 톤과 흐름 점검 (5분)</li>
</ul>
<p>총 소요 시간: 약 <strong>25~30분</strong>. AI 없이 처음부터 쓰면 2시간 이상 걸릴 내용입니다.</p>

<h2>마치며</h2>
<p>보고서 작성에 AI를 활용하는 것은 "치팅"이 아닙니다. 좋은 도구를 활용해서 효율을 높이는 것입니다. 핵심 내용과 판단은 여전히 사람의 몫이고, AI는 그것을 글로 옮기는 과정을 도와주는 것일 뿐입니다.</p>
<p>다음 글에서는 <strong>엑셀 수식을 AI에게 물어보는 방법</strong>을 공유할게요. VLOOKUP, 피벗테이블 등 복잡한 수식을 AI로 해결하는 팁입니다!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  (SELECT id FROM series WHERE slug = 'ai-for-office-workers'),
  3,
  'published',
  'ko',
  '2026-09-25T20:30:00+09:00',
  '2026-09-26T10:30:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 11: VS Code 설치부터 첫 코드 실행까지
-- 카테고리: 웹 개발 | 시리즈: 웹 개발 입문 #2
-- 발행일: 2026-09-28
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'VS Code 설치부터 첫 코드 실행까지 — 개발 환경 셋업 가이드',
  'vscode-setup-first-code',
  'VS Code 설치, 추천 확장 프로그램, 첫 Hello World까지. 코딩을 시작하기 위한 개발 환경 설정을 단계별로 안내합니다.',
  $content$<h2>코딩의 첫걸음: 개발 환경 설정</h2>
<p>코딩을 배우겠다고 결심한 뒤 가장 먼저 해야 할 일은 <strong>개발 환경을 설정하는 것</strong>입니다. 마치 요리를 시작하기 전에 주방을 세팅하는 것과 같죠. 오늘은 가장 인기 있는 코드 편집기인 VS Code를 설치하고, 첫 번째 코드를 실행하는 것까지 안내해드리겠습니다.</p>

<h2>VS Code란?</h2>
<p>VS Code(Visual Studio Code)는 <strong>마이크로소프트가 만든 무료 코드 편집기</strong>입니다. 전 세계 개발자의 70% 이상이 사용하는 가장 인기 있는 도구입니다.</p>
<p>VS Code가 인기 있는 이유:</p>
<ul>
<li><strong>완전 무료</strong>입니다</li>
<li>Windows, Mac, Linux 모든 운영체제를 지원합니다</li>
<li><strong>확장 프로그램</strong>으로 기능을 무한히 확장할 수 있습니다</li>
<li>가볍고 빠릅니다</li>
<li>코드 자동 완성, 에러 표시, 터미널 내장 등 편의 기능이 뛰어납니다</li>
</ul>

<h2>설치하기 (3분이면 완료)</h2>
<ul>
<li><strong>1단계</strong>: <a href="https://code.visualstudio.com" target="_blank" rel="noopener noreferrer">code.visualstudio.com</a>에 접속합니다.</li>
<li><strong>2단계</strong>: 운영체제에 맞는 다운로드 버튼을 클릭합니다.</li>
<li><strong>3단계</strong>: 다운로드된 설치 파일을 실행하고 "Next"를 계속 클릭하면 설치가 완료됩니다.</li>
<li><strong>4단계</strong>: VS Code를 실행하면 환영 화면이 나타납니다. 여기까지 하면 설치 끝!</li>
</ul>

<h2>추천 확장 프로그램 5가지</h2>
<p>VS Code의 진짜 힘은 확장 프로그램에서 나옵니다. 왼쪽 사이드바의 확장 프로그램 아이콘(네모 블록 모양)을 클릭하고 검색해서 설치하세요.</p>
<ul>
<li><strong>Korean Language Pack</strong> — VS Code를 한국어로 변환합니다. 영어가 불편하신 분은 필수!</li>
<li><strong>Prettier</strong> — 코드를 자동으로 예쁘게 정렬해줍니다. 저장할 때마다 자동 정렬되도록 설정하면 편합니다.</li>
<li><strong>Live Server</strong> — HTML 파일을 작성하면 브라우저에서 실시간으로 결과를 확인할 수 있습니다.</li>
<li><strong>Auto Rename Tag</strong> — HTML 태그의 여는 태그를 수정하면 닫는 태그도 자동으로 바뀝니다.</li>
<li><strong>Material Icon Theme</strong> — 파일/폴더 아이콘을 예쁘게 바꿔줍니다. 가독성이 좋아집니다.</li>
</ul>

<h2>첫 번째 코드: Hello World!</h2>
<p>개발 환경이 준비되었으니, 첫 번째 코드를 작성해봅시다.</p>
<ul>
<li><strong>1단계</strong>: 바탕화면에 "my-first-project" 폴더를 만듭니다.</li>
<li><strong>2단계</strong>: VS Code에서 File → Open Folder로 해당 폴더를 엽니다.</li>
<li><strong>3단계</strong>: 왼쪽 파일 탐색기에서 새 파일 아이콘을 클릭하고 <code>index.html</code>을 만듭니다.</li>
<li><strong>4단계</strong>: 다음 코드를 입력합니다 (VS Code에서 <code>!</code>를 입력하고 Tab을 누르면 기본 구조가 자동 생성됩니다).</li>
</ul>
<p>HTML 기본 구조가 생성되면, <code>&lt;body&gt;</code> 태그 안에 <code>&lt;h1&gt;Hello World!&lt;/h1&gt;</code>을 추가합니다. 그리고 Live Server 확장 프로그램의 "Go Live" 버튼을 클릭하면 브라우저에서 결과를 확인할 수 있습니다.</p>
<p><strong>축하합니다!</strong> 여러분은 방금 첫 번째 웹페이지를 만들었습니다. 🎉</p>

<h2>마치며</h2>
<p>개발 환경 설정은 코딩 학습의 첫 관문입니다. VS Code를 설치하고 확장 프로그램을 추가하고 Hello World를 만든 것만으로도 큰 한 걸음을 뗀 겁니다. 다음 글에서는 <strong>HTML로 자기소개 페이지 만들기</strong>를 함께 해볼게요!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'web-dev-basics'),
  2,
  'published',
  'ko',
  '2026-09-27T19:00:00+09:00',
  '2026-09-28T09:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 12: Zapier vs Make — 자동화 도구 어떤 게 나을까?
-- 카테고리: 도구 리뷰 | 시리즈: 업무 자동화 도구 리뷰 #2
-- 발행일: 2026-09-30
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'Zapier vs Make — 자동화 도구 어떤 게 나을까?',
  'zapier-vs-make-comparison',
  'Zapier와 Make(구 Integromat) 두 자동화 도구를 실제로 사용해보고 비교한 솔직한 리뷰. 가격, 기능, 사용성을 비교합니다.',
  $content$<h2>자동화가 왜 필요한가?</h2>
<p>직장에서 반복하는 일들이 있습니다. 이메일 오면 슬랙으로 알림 보내기, 구글 시트에 데이터 입력되면 자동으로 다른 시트에 복사하기, 새 고객이 가입하면 환영 이메일 보내기 같은 것들이요.</p>
<p>이런 반복 작업을 코딩 없이 자동화해주는 도구가 바로 <strong>Zapier</strong>와 <strong>Make</strong>입니다. 둘 다 6개월 이상 사용해보고 비교한 솔직한 후기를 공유합니다.</p>

<h2>Zapier — 간편함의 왕</h2>
<p>Zapier는 자동화 도구 중 가장 유명합니다. <strong>"이 앱에서 이런 일이 생기면(트리거), 저 앱에서 이 일을 해라(액션)"</strong>라는 단순한 구조로 작동합니다.</p>
<p><strong>장점:</strong></p>
<ul>
<li>설정이 매우 쉽습니다. 5분이면 첫 자동화를 만들 수 있습니다.</li>
<li>지원하는 앱이 6,000개 이상으로 압도적입니다.</li>
<li>한국어 서비스가 잘 되어 있지는 않지만, 인터페이스가 직관적이라 영어가 불편해도 사용 가능합니다.</li>
</ul>
<p><strong>단점:</strong></p>
<ul>
<li>무료 플랜은 월 100개 작업만 가능합니다. 금방 한계에 도달합니다.</li>
<li>복잡한 조건 분기(if-else)를 만들기가 어렵습니다.</li>
<li>유료 플랜 가격이 다소 비쌉니다 (월 $19.99~).</li>
</ul>

<h2>Make(구 Integromat) — 파워 유저를 위한 선택</h2>
<p>Make는 이전에 Integromat이라는 이름이었습니다. Zapier보다 복잡한 자동화 시나리오를 만들 수 있는 것이 가장 큰 장점입니다.</p>
<p><strong>장점:</strong></p>
<ul>
<li>비주얼 시나리오 편집기가 직관적이고 강력합니다. 워크플로우를 눈으로 보면서 만들 수 있습니다.</li>
<li>조건 분기, 반복, 에러 처리 등 고급 기능이 무료 플랜에서도 사용 가능합니다.</li>
<li>무료 플랜이 Zapier보다 넉넉합니다 (월 1,000개 작업).</li>
<li>같은 기능이면 Zapier보다 가격이 저렴합니다.</li>
</ul>
<p><strong>단점:</strong></p>
<ul>
<li>초기 학습 곡선이 Zapier보다 높습니다.</li>
<li>지원 앱 수가 Zapier보다 적습니다 (약 1,500개).</li>
</ul>

<h2>실제 사용 시나리오 비교</h2>
<p>제가 실제로 만든 자동화 시나리오 3가지로 비교해봤습니다:</p>
<ul>
<li><strong>시나리오 1</strong> (이메일→슬랙 알림): 둘 다 쉽게 구현 가능. <strong>무승부</strong>.</li>
<li><strong>시나리오 2</strong> (구글 폼 응답→시트 정리→이메일 발송): 조건 분기가 필요해서 <strong>Make가 편리</strong>했습니다.</li>
<li><strong>시나리오 3</strong> (특정 앱 연동): 사용하는 앱이 Zapier에만 있어서 <strong>Zapier가 유일한 선택</strong>이었습니다.</li>
</ul>

<h2>결론: 어떤 걸 선택할까?</h2>
<ul>
<li><strong>Zapier 추천</strong>: 자동화가 처음이거나, 간단한 1:1 연동만 필요한 경우</li>
<li><strong>Make 추천</strong>: 복잡한 워크플로우가 필요하거나, 비용을 아끼고 싶은 경우</li>
</ul>
<p>저는 현재 <strong>Make를 메인으로 사용</strong>하고, Make에서 지원하지 않는 앱이 있을 때만 Zapier를 보조로 쓰고 있습니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'tool-review'),
  (SELECT id FROM series WHERE slug = 'productivity-tool-reviews'),
  2,
  'published',
  'ko',
  '2026-09-29T20:00:00+09:00',
  '2026-09-30T11:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 13: 엑셀 수식 모르겠으면 AI에게 물어봐
-- 카테고리: AI 활용 | 시리즈: 직장인 AI 활용법 #4
-- 발행일: 2026-10-02
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '엑셀 수식 모르겠으면 AI에게 물어봐',
  'ask-ai-for-excel-formulas',
  'VLOOKUP, 피벗테이블 등 복잡한 엑셀 수식을 ChatGPT에게 물어서 해결하는 방법. 실전 예시와 프롬프트를 공유합니다.',
  $content$<h2>엑셀, 사랑하지만 수식은 미워</h2>
<p>직장인이라면 엑셀을 피할 수 없습니다. 그런데 SUM이나 AVERAGE 같은 기본 함수는 괜찮지만, VLOOKUP, INDEX-MATCH, 조건부 서식 같은 복잡한 수식 앞에서는 멘붕이 옵니다.</p>
<p>예전에는 수식이 필요할 때마다 구글링을 했는데, 검색 결과가 영어인 경우가 많고, 내 상황과 딱 맞는 답을 찾기 어려웠습니다. 하지만 지금은 <strong>ChatGPT에게 한국어로 내 상황을 설명</strong>하면 바로 맞춤 수식을 만들어줍니다.</p>

<h2>실전 예시 5가지</h2>

<h3>예시 1: 조건에 맞는 데이터 찾기 (VLOOKUP 대체)</h3>
<p><strong>질문:</strong> "A열에 사원번호, B열에 이름이 있는 시트에서, 사원번호 'EMP003'의 이름을 찾는 수식 알려줘"</p>
<p>ChatGPT는 VLOOKUP 수식은 물론, 더 현대적인 XLOOKUP 수식까지 알려주고, 각각의 차이점도 설명해줍니다.</p>

<h3>예시 2: 여러 조건으로 합계 구하기</h3>
<p><strong>질문:</strong> "부서가 '영업팀'이고 날짜가 2026년 9월인 매출 합계를 구하는 수식"</p>
<p>SUMIFS 함수를 사용하는 수식을 만들어주고, 날짜 조건을 설정하는 방법까지 알려줍니다.</p>

<h3>예시 3: 텍스트에서 특정 부분 추출하기</h3>
<p><strong>질문:</strong> "이메일 주소에서 @ 앞부분만 추출하는 수식"</p>
<p>LEFT와 FIND 함수를 조합한 수식을 만들어줍니다.</p>

<h3>예시 4: 중복 데이터 찾기</h3>
<p><strong>질문:</strong> "A열에서 중복된 값이 있으면 '중복'이라고 표시하는 수식"</p>
<p>COUNTIF를 활용한 조건부 수식과 함께, 조건부 서식으로 시각적으로 표시하는 방법도 알려줍니다.</p>

<h3>예시 5: 피벗테이블 만들기</h3>
<p><strong>질문:</strong> "월별 부서별 매출 합계를 보고 싶어. 피벗테이블을 어떻게 만드는지 단계별로 알려줘"</p>
<p>수식이 아니라 기능을 물어볼 수도 있습니다. 스크린샷 없이도 단계별 가이드를 제공합니다.</p>

<h2>더 좋은 답을 받는 팁</h2>
<ul>
<li><strong>데이터 구조를 알려주세요</strong> — "A열에 이름, B열에 부서, C열에 매출이 있어"처럼 시트 구조를 설명하면 더 정확한 수식을 받을 수 있습니다.</li>
<li><strong>예시 데이터를 함께 보여주세요</strong> — 실제 데이터 2~3행을 보여주면 문맥을 더 잘 이해합니다.</li>
<li><strong>"왜 이렇게 되는지도 설명해줘"</strong>를 추가하세요 — 수식의 동작 원리를 이해하면 다음에 비슷한 상황에서 직접 응용할 수 있습니다.</li>
<li><strong>에러가 나면 에러 메시지를 그대로 보여주세요</strong> — "#REF!", "#VALUE!" 같은 에러 메시지를 알려주면 원인과 해결책을 바로 알려줍니다.</li>
</ul>

<h2>마치며</h2>
<p>엑셀 수식 때문에 스트레스받는 시대는 지났습니다. AI에게 한국어로 편하게 물어보세요. 구글링보다 빠르고, 내 상황에 맞는 정확한 답을 줍니다. 다음 글에서는 <strong>회의록을 AI로 자동 정리하는 방법</strong>을 소개할게요!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  (SELECT id FROM series WHERE slug = 'ai-for-office-workers'),
  4,
  'published',
  'ko',
  '2026-10-01T21:00:00+09:00',
  '2026-10-02T14:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 14: HTML로 자기소개 페이지 만들기
-- 카테고리: 웹 개발 | 시리즈: 웹 개발 입문 #3
-- 발행일: 2026-10-04
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'HTML로 자기소개 페이지 만들기 — 첫 번째 실습 프로젝트',
  'html-self-introduction-page',
  'HTML 기본 태그를 배우면서 나만의 자기소개 웹페이지를 만들어봅니다. 코딩 입문자를 위한 실습 가이드.',
  $content$<h2>오늘의 목표</h2>
<p>이론만 공부하면 지루합니다. 오늘은 직접 <strong>자기소개 웹페이지</strong>를 만들어보겠습니다. 이 실습을 통해 HTML의 핵심 태그 10가지를 자연스럽게 익힐 수 있습니다.</p>

<h2>HTML 핵심 태그 10가지</h2>
<p>자기소개 페이지를 만들면서 사용할 태그들입니다:</p>
<ul>
<li><code>&lt;h1&gt;</code> ~ <code>&lt;h6&gt;</code> — 제목 (숫자가 작을수록 큰 제목)</li>
<li><code>&lt;p&gt;</code> — 문단 (paragraph)</li>
<li><code>&lt;img&gt;</code> — 이미지</li>
<li><code>&lt;a&gt;</code> — 링크</li>
<li><code>&lt;ul&gt;</code>, <code>&lt;li&gt;</code> — 목록</li>
<li><code>&lt;div&gt;</code> — 영역 묶기 (그룹핑)</li>
<li><code>&lt;strong&gt;</code> — 굵은 글씨 (강조)</li>
<li><code>&lt;br&gt;</code> — 줄바꿈</li>
<li><code>&lt;hr&gt;</code> — 수평선 (구분선)</li>
</ul>

<h2>실습: 자기소개 페이지 만들기</h2>
<p>VS Code에서 <code>index.html</code> 파일을 열고 다음 구조로 만들어봅니다:</p>
<ul>
<li><strong>상단</strong>: 이름과 한 줄 소개 (<code>h1</code> + <code>p</code>)</li>
<li><strong>소개 섹션</strong>: 자기소개 문단 (<code>h2</code> + <code>p</code>)</li>
<li><strong>관심사 섹션</strong>: 취미/관심사 목록 (<code>h2</code> + <code>ul</code> + <code>li</code>)</li>
<li><strong>기술 섹션</strong>: 배우고 있는 기술 (<code>h2</code> + <code>ul</code>)</li>
<li><strong>연락처 섹션</strong>: 이메일이나 SNS 링크 (<code>h2</code> + <code>a</code>)</li>
</ul>
<p>각 섹션을 <code>&lt;div&gt;</code>로 감싸면 나중에 CSS로 스타일을 적용할 때 편리합니다.</p>

<h2>코딩할 때 자주 하는 실수 3가지</h2>
<ul>
<li><strong>닫는 태그를 빼먹는 것</strong> — <code>&lt;p&gt;안녕하세요</code>가 아니라 <code>&lt;p&gt;안녕하세요&lt;/p&gt;</code>여야 합니다. 단, <code>&lt;img&gt;</code>와 <code>&lt;br&gt;</code>은 닫는 태그가 없는 예외입니다.</li>
<li><strong>태그 이름 오타</strong> — <code>&lt;stong&gt;</code>이 아니라 <code>&lt;strong&gt;</code>입니다. VS Code의 자동 완성 기능을 활용하면 오타를 줄일 수 있습니다.</li>
<li><strong>중첩 순서 틀리기</strong> — <code>&lt;p&gt;&lt;strong&gt;텍스트&lt;/p&gt;&lt;/strong&gt;</code>이 아니라 <code>&lt;p&gt;&lt;strong&gt;텍스트&lt;/strong&gt;&lt;/p&gt;</code>여야 합니다. 먼저 연 태그를 나중에 닫아야 합니다.</li>
</ul>

<h2>완성된 페이지를 브라우저에서 확인하기</h2>
<p>Live Server 확장 프로그램을 설치했다면, VS Code 하단의 "Go Live" 버튼을 클릭하면 브라우저에서 바로 결과를 확인할 수 있습니다. 코드를 수정하고 저장하면 브라우저가 자동으로 새로고침됩니다.</p>
<p>처음에는 밋밋하게 보일 겁니다. 하얀 배경에 검은 글씨, 기본 폰트. 하지만 괜찮습니다! <strong>HTML은 구조를 만드는 것</strong>이고, 예쁘게 꾸미는 건 다음 단계인 CSS의 역할입니다.</p>

<h2>마치며</h2>
<p>축하합니다! 여러분은 방금 첫 번째 실전 웹페이지를 만들었습니다. 비록 간단한 페이지이지만, 웹 개발의 기초를 직접 경험한 것입니다. HTML은 웹의 뼈대이고, 이것을 이해하면 나머지는 그 위에 쌓아올리는 것일 뿐입니다.</p>
<p>다음 글에서는 <strong>CSS로 이 페이지를 예쁘게 꾸미는 방법</strong>을 알려드리겠습니다. 색상, 폰트, 레이아웃의 마법을 경험해보세요!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'web-dev-basics'),
  3,
  'published',
  'ko',
  '2026-10-03T19:30:00+09:00',
  '2026-10-04T10:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 15: Vercel에 블로그 배포하기 — 10분만에 내 사이트
-- 카테고리: 웹 개발 | 시리즈: 블로그 만들기 #4
-- 발행일: 2026-10-06
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'Vercel에 블로그 배포하기 — 10분 만에 내 사이트 만들기',
  'deploy-blog-to-vercel',
  'Next.js 블로그를 Vercel에 무료로 배포하는 방법. GitHub 연동부터 자동 배포, 커스텀 도메인 설정까지 안내합니다.',
  $content$<h2>배포란 뭘까?</h2>
<p>지금까지 우리가 만든 블로그는 내 컴퓨터에서만 볼 수 있었습니다. <strong>배포(Deploy)</strong>란 이 블로그를 인터넷에 올려서 전 세계 누구나 접속할 수 있게 하는 것을 말합니다.</p>
<p>쉽게 말하면, 내 컴퓨터에 있는 요리를 식당에 내놓는 것과 같습니다.</p>

<h2>Vercel을 선택한 이유</h2>
<p>배포 플랫폼은 여러 가지가 있지만, Next.js 프로젝트라면 <strong>Vercel이 최선의 선택</strong>입니다.</p>
<ul>
<li>Next.js를 만든 회사가 운영하는 플랫폼입니다. 궁합이 완벽합니다.</li>
<li>개인 프로젝트는 <strong>완전 무료</strong>입니다.</li>
<li>GitHub에 코드를 올리면 <strong>자동으로 배포</strong>됩니다.</li>
<li>글로벌 CDN으로 전 세계 어디서나 빠르게 접속됩니다.</li>
<li>HTTPS(SSL)가 자동으로 적용됩니다.</li>
</ul>

<h2>배포 과정 (진짜 10분이면 됩니다)</h2>

<h3>Step 1: GitHub에 코드 올리기</h3>
<p>먼저 프로젝트 코드를 GitHub 저장소에 올려야 합니다. GitHub 계정이 없다면 먼저 가입하세요. VS Code의 터미널에서 git 명령어로 코드를 올리거나, GitHub Desktop 앱을 사용하면 됩니다.</p>

<h3>Step 2: Vercel 가입 및 GitHub 연동</h3>
<p><a href="https://vercel.com" target="_blank" rel="noopener noreferrer">vercel.com</a>에 접속해서 GitHub 계정으로 로그인합니다. 그러면 자동으로 GitHub 저장소 목록이 나타납니다.</p>

<h3>Step 3: 프로젝트 가져오기</h3>
<p>블로그 저장소를 선택하고 "Import" 버튼을 클릭합니다. 환경 변수(Supabase URL, API Key 등)를 입력하는 화면이 나오면, .env.local 파일의 내용을 하나씩 추가합니다.</p>

<h3>Step 4: 배포!</h3>
<p>"Deploy" 버튼을 클릭하면 Vercel이 자동으로 빌드하고 배포합니다. 약 1~2분 후에 <code>프로젝트명.vercel.app</code> 주소로 내 블로그에 접속할 수 있습니다.</p>

<h2>커스텀 도메인 연결하기</h2>
<p>vercel.app 도메인도 좋지만, 자체 도메인을 쓰면 더 전문적으로 보입니다. 도메인 구매 사이트(가비아, Namecheap 등)에서 도메인을 구매한 후, Vercel 프로젝트 설정에서 도메인을 추가하면 됩니다.</p>
<p>DNS 설정에서 Vercel이 안내하는 CNAME 또는 A 레코드를 추가하면 보통 5~30분 내에 연결됩니다.</p>

<h2>자동 배포의 마법</h2>
<p>Vercel의 가장 좋은 점 중 하나는 <strong>자동 배포</strong>입니다. GitHub에 코드를 push하면 Vercel이 자동으로 감지하고 새 버전을 배포합니다. 별도의 작업이 필요 없습니다.</p>
<p>심지어 브랜치별로 미리보기 배포(Preview Deployment)도 자동으로 만들어줍니다. 새 기능을 테스트할 때 매우 유용합니다.</p>

<h2>마치며</h2>
<p>배포까지 완료하면 진짜 내 블로그가 인터넷에 살아 있는 것을 확인하는 순간이 옵니다. 그 순간의 기쁨은 직접 경험해보지 않으면 모릅니다. 내가 만든 것이 전 세계에 공개되는 경험, 정말 특별합니다.</p>
<p>다음 글에서는 블로그에 <strong>다국어 지원(한국어/영어)</strong>을 추가하는 방법을 공유할게요!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'building-my-blog'),
  4,
  'published',
  'ko',
  '2026-10-05T20:00:00+09:00',
  '2026-10-06T09:30:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 16: 개인 블로그로 애드센스 수익 만들기
-- 카테고리: 수익화 | 시리즈: 부업 & 수익화 #1
-- 발행일: 2026-10-08
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '개인 블로그로 애드센스 수익 만들기 — 현실적인 가이드',
  'blog-adsense-income-realistic-guide',
  '구글 애드센스로 블로그 수익을 만드는 현실적인 방법. 승인 조건, 수익 구조, CPC 높은 키워드 전략을 공유합니다.',
  $content$<h2>블로그로 정말 돈을 벌 수 있을까?</h2>
<p>결론부터 말하면, <strong>가능하지만 쉽지는 않습니다.</strong> 인터넷에 떠도는 "블로그로 월 100만원!" 같은 이야기에 현혹되면 실망할 수 있습니다. 현실적인 기대치를 가지고 시작하는 것이 중요합니다.</p>
<p>제 경험을 바탕으로 솔직하게 이야기해보겠습니다.</p>

<h2>구글 애드센스란?</h2>
<p>구글 애드센스는 구글이 운영하는 <strong>광고 프로그램</strong>입니다. 내 블로그에 광고를 게재하고, 방문자가 광고를 보거나 클릭하면 수익이 발생하는 구조입니다.</p>
<ul>
<li><strong>CPC (Cost Per Click)</strong> — 클릭당 수익. 키워드에 따라 100원~10,000원 이상 차이가 납니다.</li>
<li><strong>RPM (Revenue Per Mille)</strong> — 1,000회 노출당 수익. 보통 $1~$5 정도입니다.</li>
</ul>

<h2>애드센스 승인 받는 조건</h2>
<p>구글이 공식적으로 밝힌 조건은 없지만, 경험적으로 다음 조건이 중요합니다:</p>
<ul>
<li><strong>오리지널 콘텐츠</strong> — 15~30개 이상의 양질의 원본 글</li>
<li><strong>충분한 분량</strong> — 글당 1,000자 이상</li>
<li><strong>필수 페이지</strong> — 소개(About), 개인정보처리방침(Privacy Policy) 페이지</li>
<li><strong>깔끔한 디자인</strong> — 모바일 반응형, 쉬운 네비게이션</li>
<li><strong>충분한 운영 기간</strong> — 최소 2~4주 이상의 활동 이력</li>
<li><strong>금지 콘텐츠 없음</strong> — 불법, 성인, 도박 관련 콘텐츠 배제</li>
</ul>

<h2>현실적인 수익 예상</h2>
<p>블로그 초기(월 방문자 1,000명 미만)에는 솔직히 수익이 미미합니다. 하루에 커피 한 잔도 안 되는 경우가 대부분입니다.</p>
<ul>
<li><strong>초기 (1~3개월)</strong>: 월 1,000~5,000원. 거의 0에 가깝습니다.</li>
<li><strong>성장기 (3~6개월)</strong>: 월 1~5만원. SEO가 자리 잡기 시작합니다.</li>
<li><strong>안정기 (6개월~)</strong>: 월 5~30만원. 꾸준한 콘텐츠 발행이 전제입니다.</li>
</ul>
<p>물론 이것은 평균적인 수치이고, 틈새 키워드를 잘 공략하면 더 빠르게 성장할 수 있습니다.</p>

<h2>수익을 높이는 전략</h2>
<ul>
<li><strong>CPC 높은 키워드 공략</strong> — 금융, IT, 보험, 교육 분야의 키워드는 CPC가 높습니다.</li>
<li><strong>SEO 최적화</strong> — 구글 검색에서 상위 노출되면 트래픽이 크게 늘어납니다.</li>
<li><strong>꾸준한 발행</strong> — 일주일에 2~3편씩 꾸준히 글을 발행하세요.</li>
<li><strong>광고 위치 최적화</strong> — 본문 중간, 글 끝 등 클릭률이 높은 위치에 광고를 배치합니다.</li>
<li><strong>긴 글 작성</strong> — 2,000자 이상의 상세한 글은 체류 시간을 높이고, 광고 노출 횟수를 늘립니다.</li>
</ul>

<h2>마치며</h2>
<p>블로그 수익화는 마라톤입니다. 단기간에 큰 수익을 기대하기보다는, 좋은 콘텐츠를 꾸준히 쌓아가면 자연스럽게 따라오는 것이라고 생각합니다. 중요한 건 <strong>내가 진심으로 쓰고 싶은 글</strong>을 쓰는 것입니다. 수익은 그 결과일 뿐입니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'monetization'),
  (SELECT id FROM series WHERE slug = 'side-income'),
  1,
  'published',
  'ko',
  '2026-10-07T20:30:00+09:00',
  '2026-10-08T11:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 17: 회의록 자동 정리하기
-- 카테고리: AI 활용 | 시리즈: 직장인 AI 활용법 #5
-- 발행일: 2026-10-10
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '회의록 자동 정리하기 — 음성 인식 + ChatGPT 조합',
  'auto-meeting-notes-ai',
  '회의 내용을 음성 인식으로 텍스트로 변환하고, ChatGPT로 요약하는 워크플로우를 공유합니다.',
  $content$<h2>회의 끝나고 회의록 쓰느라 또 30분?</h2>
<p>회의에 집중하면서 동시에 깔끔하게 기록하기는 정말 어렵습니다. 그렇다고 회의 끝나고 기억에 의존해서 쓰면 빠뜨리는 내용이 생기죠. 이 문제를 해결하기 위해 <strong>음성 인식 + AI 요약</strong> 조합을 활용하고 있습니다.</p>

<h2>나의 회의록 자동화 워크플로우</h2>

<h3>Step 1: 음성 녹음</h3>
<p>회의 시작 시 스마트폰의 녹음 앱으로 녹음을 시작합니다. 참석자들에게 녹음 동의를 먼저 받는 것이 중요합니다. 대부분의 팀 미팅에서는 "회의록 작성용으로 녹음하겠습니다"라고 하면 동의해주십니다.</p>

<h3>Step 2: 음성→텍스트 변환 (STT)</h3>
<p>녹음 파일을 텍스트로 변환합니다. 제가 사용하는 도구들:</p>
<ul>
<li><strong>Clova Note</strong> — 네이버에서 만든 무료 서비스. 한국어 인식률이 매우 높습니다.</li>
<li><strong>Whisper</strong> — OpenAI의 음성 인식 모델. 정확도가 높고 무료입니다.</li>
<li><strong>구글 문서의 음성 입력</strong> — 간단한 메모용으로 적합합니다.</li>
</ul>
<p>저는 주로 <strong>Clova Note</strong>를 사용합니다. 한국어 회의에서 가장 정확하게 인식합니다.</p>

<h3>Step 3: ChatGPT로 요약 및 정리</h3>
<p>텍스트로 변환된 회의 내용을 ChatGPT에게 넘기고, 정해진 포맷으로 정리를 요청합니다.</p>
<p><strong>프롬프트 예시:</strong> "아래 회의 녹취록을 다음 형식으로 정리해줘: 1) 참석자, 2) 논의 안건, 3) 주요 결정 사항, 4) Action Items (담당자, 마감일 포함), 5) 다음 미팅 일정. 불필요한 잡담은 제외하고 핵심만 간결하게."</p>

<h3>Step 4: 검토 및 공유</h3>
<p>AI가 정리한 회의록을 검토하고, 빠진 내용이나 잘못된 부분을 수정합니다. 그 다음 팀 슬랙이나 이메일로 공유합니다.</p>

<h2>실제 시간 절약 효과</h2>
<ul>
<li><strong>기존 방식</strong>: 1시간 회의 → 회의록 작성 30~45분</li>
<li><strong>AI 활용</strong>: 1시간 회의 → 회의록 정리 10분 (검토 포함)</li>
<li><strong>절약 시간</strong>: 회의당 약 20~35분</li>
</ul>
<p>일주일에 회의가 3~4번이라면, 한 주에 1~2시간을 절약할 수 있습니다.</p>

<h2>주의사항</h2>
<ul>
<li><strong>녹음 동의</strong>는 반드시 받으세요. 법적 이슈가 될 수 있습니다.</li>
<li><strong>기밀 회의</strong> 내용은 외부 AI 서비스에 올리지 마세요. 사내 보안 정책을 확인하세요.</li>
<li>AI 요약 결과를 <strong>반드시 검토</strong>하세요. 맥락을 잘못 이해해서 중요한 내용이 빠질 수 있습니다.</li>
</ul>

<h2>마치며</h2>
<p>회의록 자동화는 AI 활용의 가장 실용적인 사례 중 하나라고 생각합니다. 회의 중에는 토론에 집중하고, 정리는 AI에게 맡기세요. 시간도 절약하고, 회의록의 품질도 올라갑니다.</p>$content$,
  (SELECT id FROM categories WHERE slug = 'ai-tools'),
  (SELECT id FROM series WHERE slug = 'ai-for-office-workers'),
  5,
  'published',
  'ko',
  '2026-10-09T21:00:00+09:00',
  '2026-10-10T09:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 18: CSS로 예쁘게 꾸미기
-- 카테고리: 웹 개발 | 시리즈: 웹 개발 입문 #4
-- 발행일: 2026-10-12
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  'CSS로 예쁘게 꾸미기 — 색상, 폰트, 레이아웃 기초',
  'css-basics-styling-guide',
  'CSS의 핵심 개념을 배우면서 밋밋한 HTML 페이지를 세련된 디자인으로 변신시켜봅니다.',
  $content$<h2>CSS의 마법: 같은 구조, 완전히 다른 느낌</h2>
<p>이전 글에서 HTML로 자기소개 페이지를 만들었습니다. 구조는 완성됐지만, 솔직히 예쁘지는 않았죠? 하얀 배경에 검은 글씨, Times New Roman 폰트... 1990년대 웹사이트 같은 느낌입니다.</p>
<p>오늘은 CSS를 사용해서 <strong>같은 HTML을 세련된 디자인으로 변신</strong>시켜보겠습니다.</p>

<h2>CSS 기본 문법</h2>
<p>CSS의 기본 구조는 아주 간단합니다: <strong>누구를(선택자)</strong> + <strong>어떻게(속성: 값)</strong> 꾸밀지 정하는 것입니다.</p>
<p>예를 들어 "모든 문단의 글자색을 네이비로 바꿔줘"를 CSS로 쓰면:</p>
<p><code>p { color: navy; }</code></p>
<p>이게 전부입니다! <code>p</code>는 선택자(누구를), <code>color: navy;</code>는 속성과 값(어떻게)입니다.</p>

<h2>바로 써먹는 CSS 속성 10가지</h2>
<ul>
<li><strong>color</strong> — 글자 색깔</li>
<li><strong>background-color</strong> — 배경 색깔</li>
<li><strong>font-size</strong> — 글자 크기</li>
<li><strong>font-family</strong> — 글꼴 (폰트)</li>
<li><strong>font-weight</strong> — 글자 굵기 (bold 등)</li>
<li><strong>margin</strong> — 요소 바깥 여백</li>
<li><strong>padding</strong> — 요소 안쪽 여백</li>
<li><strong>border</strong> — 테두리</li>
<li><strong>border-radius</strong> — 둥근 모서리</li>
<li><strong>text-align</strong> — 텍스트 정렬 (center, left, right)</li>
</ul>

<h2>실습: 자기소개 페이지 꾸미기</h2>

<h3>1. 예쁜 폰트 적용하기</h3>
<p>기본 폰트 대신 Google Fonts에서 무료 폰트를 가져와 적용합니다. "Noto Sans KR"은 한국어에 최적화된 깔끔한 폰트입니다.</p>

<h3>2. 배경색과 카드 디자인</h3>
<p>전체 배경을 연한 회색으로 하고, 콘텐츠 영역을 흰색 카드로 만들면 훨씬 세련되어 보입니다. <code>box-shadow</code> 속성을 추가하면 카드가 살짝 떠 있는 효과도 줄 수 있습니다.</p>

<h3>3. Flexbox로 레이아웃 잡기</h3>
<p>CSS의 핵심 개념 중 하나인 Flexbox를 사용하면 요소들을 가로로 나란히 배치하거나, 가운데 정렬하는 것이 매우 쉬워집니다. <code>display: flex;</code> 한 줄만 추가하면 마법이 시작됩니다.</p>

<h3>4. 반응형 디자인</h3>
<p>PC에서는 넓게, 모바일에서는 세로로 쌓이도록 하는 반응형 디자인. <code>@media</code> 쿼리를 사용합니다. 화면 너비가 768px 이하이면 모바일로 판단하고 레이아웃을 변경합니다.</p>

<h2>색상 고르는 팁</h2>
<p>색상 조합이 어렵다면 이 도구들을 활용해보세요:</p>
<ul>
<li><strong>Coolors.co</strong> — 스페이스바 한 번으로 색상 조합 생성</li>
<li><strong>Google Material Design Colors</strong> — 검증된 색상 팔레트</li>
<li><strong>ColorHunt.co</strong> — 다른 디자이너가 만든 색 조합 참고</li>
</ul>

<h2>마치며</h2>
<p>CSS를 처음 배울 때는 속성이 너무 많아서 압도당하는 느낌이 들 수 있습니다. 하지만 위에서 소개한 10가지 속성만으로도 충분히 멋진 디자인을 만들 수 있습니다. 나머지는 필요할 때 하나씩 배우면 됩니다.</p>
<p>다음 글에서는 <strong>JavaScript</strong>의 세계로 들어갑니다. 버튼을 클릭하면 반응하는, 살아 있는 웹페이지를 만들어봅시다!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'web-dev-basics'),
  4,
  'published',
  'ko',
  '2026-10-11T19:30:00+09:00',
  '2026-10-12T10:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 19: 내 개발 장비 & 데스크 셋업
-- 카테고리: 일상 | 시리즈: 개발자 라이프스타일 #3
-- 발행일: 2026-10-13
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '내 개발 장비 & 데스크 셋업 — 생산성 200% 올리기',
  'my-dev-desk-setup',
  '퇴근 후 코딩에 최적화된 데스크 셋업을 공유합니다. 모니터, 키보드, 마우스 추천과 가격대별 가이드.',
  $content$<h2>환경이 생산성을 결정한다</h2>
<p>3개월간 퇴근 후 코딩을 하면서 느낀 것 중 하나는, <strong>작업 환경이 생산성에 엄청난 영향을 미친다</strong>는 것입니다. 처음에는 노트북 화면 하나로 코딩했는데, 외장 모니터를 추가한 후 체감 효율이 두 배 이상 올랐습니다.</p>
<p>오늘은 제 현재 데스크 셋업과 장비들을 공유합니다. 모든 것을 한 번에 갖출 필요는 없고, 예산에 맞게 우선순위를 정해서 하나씩 추가하는 것을 추천합니다.</p>

<h2>내 장비 목록</h2>

<h3>1. 모니터 — LG 27인치 4K (27UP850)</h3>
<p>가장 먼저 구매하길 추천하는 장비는 <strong>외장 모니터</strong>입니다. 코딩할 때 한쪽에는 코드, 한쪽에는 브라우저(결과 확인)나 문서를 띄워놓으면 작업 효율이 확 올라갑니다.</p>
<p>4K는 텍스트가 매우 선명해서 코드 가독성이 좋습니다. 다만 FHD(1080p) 모니터도 충분합니다. 예산에 따라 선택하세요.</p>

<h3>2. 키보드 — 한성컴퓨터 기계식 키보드 (갈축)</h3>
<p>코딩은 타이핑이 많은 작업이라 키보드가 중요합니다. 기계식 키보드 중 <strong>갈축(브라운 스위치)</strong>은 타건감이 좋으면서도 소음이 적어서 집에서 쓰기 좋습니다.</p>
<p>꼭 비싼 키보드가 아니어도 괜찮습니다. 3~5만원대 기계식 키보드도 충분히 훌륭합니다.</p>

<h3>3. 마우스 — 로지텍 M750</h3>
<p>멀티 디바이스 연결이 가능하고, 손에 잘 맞는 크기입니다. 블루투스로 최대 3대까지 연결하고 버튼 하나로 전환할 수 있어서 노트북과 데스크탑을 함께 쓸 때 편합니다.</p>

<h3>4. 노트북 거치대</h3>
<p>외장 모니터를 쓸 때 노트북은 보조 화면으로 사용합니다. 거치대에 올려놓으면 목이 편하고, 데스크 공간도 절약됩니다. 1~2만원짜리 알루미늄 거치대면 충분합니다.</p>

<h3>5. 조명 — 모니터 바 LED</h3>
<p>밤에 코딩할 때 모니터만 밝으면 눈이 쉽게 피로해집니다. 모니터 바 LED를 달면 키보드 주변을 은은하게 비춰줘서 눈의 부담을 줄여줍니다.</p>

<h2>가격대별 추천 셋업</h2>
<ul>
<li><strong>10만원 이하</strong>: 기계식 키보드(3만원) + 노트북 거치대(1.5만원) + 무선 마우스(2만원) → 이것만으로도 큰 변화!</li>
<li><strong>30만원 이하</strong>: 위 + FHD 24인치 모니터(15~20만원)</li>
<li><strong>50만원 이하</strong>: 위 + 4K 27인치 모니터 + 모니터 바 LED</li>
</ul>

<h2>데스크 정리 팁</h2>
<ul>
<li><strong>케이블 정리</strong>: 케이블 클립이나 케이블 트레이로 선을 정리하면 데스크가 훨씬 깔끔해집니다.</li>
<li><strong>책상 위 최소화</strong>: 꼭 필요한 것만 데스크 위에 두세요. 물건이 적을수록 집중력이 올라갑니다.</li>
<li><strong>커피/물 자리 고정</strong>: 음료 쏟아서 키보드 망가지는 건 한 번이면 충분합니다. 모니터에서 먼 곳에 음료 자리를 정해두세요.</li>
</ul>

<h2>마치며</h2>
<p>좋은 장비가 좋은 코드를 쓰게 해주는 건 아닙니다. 하지만 편안한 환경은 <strong>더 오래, 더 집중해서 공부</strong>할 수 있게 해줍니다. 처음에는 키보드 하나만 바꿔도 코딩이 즐거워집니다. 하나씩 천천히 업그레이드해보세요!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'lifestyle'),
  (SELECT id FROM series WHERE slug = 'dev-lifestyle'),
  3,
  'published',
  'ko',
  '2026-10-12T22:00:00+09:00',
  '2026-10-13T13:00:00+09:00'
);

-- ═══════════════════════════════════════════════
-- 포스트 20: 다국어 블로그 만들기
-- 카테고리: 웹 개발 | 시리즈: 블로그 만들기 #5
-- 발행일: 2026-10-14
-- ═══════════════════════════════════════════════
INSERT INTO posts (title, slug, excerpt, content, category_id, series_id, series_order, status, locale, created_at, published_at)
VALUES (
  '다국어 블로그 만들기 — 한국어/영어 동시 지원하는 법',
  'multilingual-blog-setup',
  'Next.js에서 next-intl을 사용하여 한국어와 영어를 동시 지원하는 다국어 블로그를 만드는 방법을 공유합니다.',
  $content$<h2>왜 다국어를 지원할까?</h2>
<p>블로그를 만들면서 "영어 버전도 제공하면 어떨까?"라는 생각이 들었습니다. 한국어로만 쓰면 한국 독자만 볼 수 있지만, 영어를 추가하면 전 세계 독자에게 다가갈 수 있으니까요.</p>
<p>물론 글을 두 번 쓰는 건 쉽지 않지만, <strong>DeepL 같은 AI 번역 도구</strong>를 활용하면 부담이 크게 줄어듭니다.</p>

<h2>next-intl 라이브러리 소개</h2>
<p>Next.js에서 다국어(i18n)를 구현하는 방법은 여러 가지가 있지만, 저는 <strong>next-intl</strong>을 선택했습니다.</p>
<p>선택 이유:</p>
<ul>
<li>Next.js App Router와 완벽하게 호환됩니다</li>
<li>서버 컴포넌트에서도 번역 함수를 사용할 수 있습니다</li>
<li>TypeScript 지원이 우수합니다</li>
<li>공식 문서가 잘 되어 있습니다</li>
</ul>

<h2>구현 과정</h2>

<h3>1. 폴더 구조 설계</h3>
<p>Next.js App Router에서 다국어를 지원하려면 URL에 언어 코드를 포함시킵니다. 예를 들어 <code>/ko/blog</code>, <code>/en/blog</code> 형태입니다. 이를 위해 <code>app/[locale]/</code> 동적 경로를 사용합니다.</p>

<h3>2. 번역 파일 관리</h3>
<p>각 언어별 번역 메시지를 JSON 파일로 관리합니다. <code>messages/ko.json</code>과 <code>messages/en.json</code>에 UI 텍스트를 정의합니다. 네비게이션, 버튼, 안내 메시지 등 고정 텍스트는 이 파일에서 관리합니다.</p>

<h3>3. 서버 컴포넌트에서 번역 사용</h3>
<p>next-intl의 <code>getTranslations</code> 함수를 사용하면 서버 컴포넌트에서도 번역된 텍스트를 불러올 수 있습니다. 클라이언트 컴포넌트에서는 <code>useTranslations</code> 훅을 사용합니다.</p>

<h3>4. 블로그 글 다국어 처리</h3>
<p>블로그 글은 번역 파일이 아니라 <strong>데이터베이스</strong>에서 관리합니다. posts 테이블에 locale 칼럼을 추가해서 같은 slug라도 한국어 버전과 영어 버전을 별도로 저장합니다.</p>

<h3>5. 언어 전환 기능</h3>
<p>헤더에 언어 전환 버튼을 추가했습니다. 한국어 페이지에서 영어로 전환하면 같은 페이지의 영어 버전으로 이동합니다. 현재 URL의 locale 부분만 교체하는 간단한 로직입니다.</p>

<h2>어려웠던 점</h2>
<ul>
<li><strong>날짜 포맷</strong> — 한국어는 "2026년 9월 1일", 영어는 "September 1, 2026" 형태로 다르게 표시해야 합니다. Intl.DateTimeFormat API를 활용했습니다.</li>
<li><strong>SEO 최적화</strong> — 각 언어별로 별도의 메타태그, hreflang 태그를 설정해야 합니다.</li>
<li><strong>번역 품질</strong> — DeepL로 번역한 후 직접 교정하는 과정이 필요합니다. 기술 용어는 특히 주의해야 합니다.</li>
</ul>

<h2>마치며</h2>
<p>다국어 지원은 처음 설정할 때는 복잡하지만, 한 번 구조를 잡아놓으면 이후에는 번역 파일만 추가하면 됩니다. 글로벌 독자를 목표로 한다면 충분히 투자할 가치가 있는 기능입니다.</p>
<p>이것으로 블로그 만들기 시리즈의 주요 과정을 모두 다루었습니다. 다음에는 전체 과정의 총정리와 솔직한 후기를 공유할 예정입니다!</p>$content$,
  (SELECT id FROM categories WHERE slug = 'web-dev'),
  (SELECT id FROM series WHERE slug = 'building-my-blog'),
  5,
  'published',
  'ko',
  '2026-10-13T21:00:00+09:00',
  '2026-10-14T10:00:00+09:00'
);


-- ═══════════════════════════════════════════════
-- Phase 2 포스트-태그 연결
-- ═══════════════════════════════════════════════

-- 포스트 9: Supabase
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'supabase-database-setup-free' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'supabase')),
  ((SELECT id FROM posts WHERE slug = 'supabase-database-setup-free' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'database')),
  ((SELECT id FROM posts WHERE slug = 'supabase-database-setup-free' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs')),
  ((SELECT id FROM posts WHERE slug = 'supabase-database-setup-free' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));

-- 포스트 10: AI 보고서
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'ai-report-writing-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'chatgpt')),
  ((SELECT id FROM posts WHERE slug = 'ai-report-writing-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'ai-report-writing-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'));

-- 포스트 11: VS Code
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'vscode-setup-first-code' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'vscode')),
  ((SELECT id FROM posts WHERE slug = 'vscode-setup-first-code' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'dev-environment')),
  ((SELECT id FROM posts WHERE slug = 'vscode-setup-first-code' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'html'));

-- 포스트 12: Zapier vs Make
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'zapier-vs-make-comparison' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'automation')),
  ((SELECT id FROM posts WHERE slug = 'zapier-vs-make-comparison' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'));

-- 포스트 13: 엑셀 AI
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'ask-ai-for-excel-formulas' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'chatgpt')),
  ((SELECT id FROM posts WHERE slug = 'ask-ai-for-excel-formulas' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'ask-ai-for-excel-formulas' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'excel'));

-- 포스트 14: HTML 실습
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'html-self-introduction-page' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'html')),
  ((SELECT id FROM posts WHERE slug = 'html-self-introduction-page' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev')),
  ((SELECT id FROM posts WHERE slug = 'html-self-introduction-page' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'css'));

-- 포스트 15: Vercel 배포
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'deploy-blog-to-vercel' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'vercel')),
  ((SELECT id FROM posts WHERE slug = 'deploy-blog-to-vercel' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'deployment')),
  ((SELECT id FROM posts WHERE slug = 'deploy-blog-to-vercel' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs'));

-- 포스트 16: 애드센스 수익
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'blog-adsense-income-realistic-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'adsense')),
  ((SELECT id FROM posts WHERE slug = 'blog-adsense-income-realistic-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'blog')),
  ((SELECT id FROM posts WHERE slug = 'blog-adsense-income-realistic-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'seo'));

-- 포스트 17: 회의록 AI
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'auto-meeting-notes-ai' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'chatgpt')),
  ((SELECT id FROM posts WHERE slug = 'auto-meeting-notes-ai' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'ai')),
  ((SELECT id FROM posts WHERE slug = 'auto-meeting-notes-ai' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'automation'));

-- 포스트 18: CSS 기초
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'css-basics-styling-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'css')),
  ((SELECT id FROM posts WHERE slug = 'css-basics-styling-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'html')),
  ((SELECT id FROM posts WHERE slug = 'css-basics-styling-guide' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));

-- 포스트 19: 데스크 셋업
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'my-dev-desk-setup' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'dev-environment')),
  ((SELECT id FROM posts WHERE slug = 'my-dev-desk-setup' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'productivity'));

-- 포스트 20: 다국어 블로그
INSERT INTO post_tags (post_id, tag_id) VALUES
  ((SELECT id FROM posts WHERE slug = 'multilingual-blog-setup' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'nextjs')),
  ((SELECT id FROM posts WHERE slug = 'multilingual-blog-setup' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'typescript')),
  ((SELECT id FROM posts WHERE slug = 'multilingual-blog-setup' AND locale = 'ko'), (SELECT id FROM tags WHERE slug = 'web-dev'));
