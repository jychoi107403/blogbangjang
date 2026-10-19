# 블로그 글 작성 시 이미지 포함 규칙

블로그 글(포스트)을 작성하거나 시드 SQL로 만들 때는 **항상 이미지까지 함께 만들어서** 글에 넣는다.

## 1. 이미지 구성
| 종류 | 개수 | 용도 | 크기 |
|------|------|------|------|
| 표지(썸네일) | 1장 | `posts.thumbnail_url` 에 저장 (카드·OG 이미지) | 1200×630 WebP |
| 본문 이미지 | 글당 2~3장 | 소제목(`<h2>`) 아래 설명용 | 960×540 WebP |

## 2. 이미지 만들기 & 압축 (필수)
1. `generate_image` 도구로 이미지를 만든다. (글 주제와 관련된 플랫 일러스트, **이미지 안에 글자는 넣지 않도록** `no text` 지정)
2. 만든 JPG/PNG를 **WebP로 변환**해 용량을 줄인다. 목표: 파일당 **50KB 이하** (품질 70~75).
   ```powershell
   npx.cmd -y sharp-cli -i "원본.jpg" -o "public/blog/<글슬러그>/cover.webp" -f webp -q 72 resize 1200 630
   ```
   - PowerShell 실행 정책 때문에 `npx` 대신 반드시 `npx.cmd` 를 쓴다.
3. 저장 위치: `public/blog/<글슬러그>/` (표지: `cover.webp`, 본문: `01.webp`, `02.webp` …)

## 3. 글에 넣는 방법 (본문은 마크다운이 아니라 HTML)
이 블로그는 `posts.content` 의 **HTML을 그대로 렌더링**한다(`dangerouslySetInnerHTML`). 마크다운 `![]()` 문법은 변환되지 않으므로 아래 HTML 형식을 쓴다.

```html
<figure>
  <img src="/blog/<글슬러그>/01.webp"
       alt="이미지를 설명하는 한글 문장"
       width="960" height="540" loading="lazy" />
  <figcaption>이미지 설명 (선택)</figcaption>
</figure>
```

- `alt` 는 반드시 구체적으로 작성한다(SEO·접근성).
- `width`/`height` 를 항상 지정한다(화면 흔들림 방지).
- 첫 번째 본문 이미지를 제외한 나머지는 `loading="lazy"` 를 쓴다.
- 표지는 본문에 넣지 않고 `thumbnail_url = '/blog/<글슬러그>/cover.webp'` 로만 저장한다.

## 4. 글 작성 체크리스트
- [ ] 표지 1장 생성 → WebP 변환 → `thumbnail_url` 지정
- [ ] 본문 이미지 2~3장 생성 → WebP 변환 → `<figure><img>` 삽입
- [ ] 모든 이미지 `alt` 작성, 파일당 50KB 이하 확인
- [ ] 한국어/영어 글은 같은 이미지를 공유해도 되지만 `alt` 는 각 언어로 작성
- [ ] SQL 시드 파일은 `supabase/migrations/` 에 `000_` 순번을 붙여 생성
