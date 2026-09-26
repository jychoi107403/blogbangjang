// app/[locale]/blog/[slug]/page.tsx
// 블로그 글 상세 페이지
// 본문, 태그, 시리즈 네비게이션, 관련 글, 댓글 섹션 포함

import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { getPostBySlug, getRelatedPosts, getSeriesPosts, incrementViewCount } from "@/lib/utils/posts";
import TagBadge from "@/components/blog/TagBadge";
import CategoryBadge from "@/components/blog/CategoryBadge";
import PostCard from "@/components/blog/PostCard";
import styles from "./page.module.css";

// 페이지 Props 타입
interface PostDetailPageProps {
  params: Promise<{ locale: string; slug: string }>;
}

// SEO 메타데이터 동적 생성
export async function generateMetadata({ params }: PostDetailPageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const post = await getPostBySlug(slug, locale);

  if (!post) {
    return { title: "글을 찾을 수 없습니다" };
  }

  return {
    title: post.title,
    description: post.excerpt ?? undefined,
    openGraph: {
      title: post.title,
      description: post.excerpt ?? undefined,
      images: post.thumbnail_url ? [post.thumbnail_url] : [],
      type: "article",
    },
  };
}

// 날짜 포맷 헬퍼
function formatDate(dateStr: string, locale: string): string {
  return new Date(dateStr).toLocaleDateString(locale === "ko" ? "ko-KR" : "en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

export default async function PostDetailPage({ params }: PostDetailPageProps) {
  const { locale, slug } = await params;

  // 글 상세 정보 조회
  const post = await getPostBySlug(slug, locale);

  // 글이 없으면 404 페이지 표시
  if (!post) {
    notFound();
  }

  // 조회수 증가 (비동기로 처리 — 페이지 렌더링을 막지 않음)
  incrementViewCount(post.id).catch(console.error);

  // 관련 글 & 시리즈 글 목록을 병렬로 조회
  const [relatedPosts, seriesPosts] = await Promise.all([
    getRelatedPosts(post.id, post.category_id ?? null, locale, 3),
    post.series_id ? getSeriesPosts(post.series_id, locale) : Promise.resolve([]),
  ]);

  // 현재 글이 시리즈의 몇 번째인지 찾기
  const currentSeriesIndex = seriesPosts.findIndex((p) => p.id === post.id);

  return (
    <article className="container">
      <div className={styles.layout}>
        {/* ─────────────────────────────── */}
        {/* 메인 콘텐츠 */}
        {/* ─────────────────────────────── */}
        <div className={styles.main}>

          {/* 뒤로 가기 링크 */}
          <Link href={`/${locale}/blog`} className={styles.backLink}>
            ← {locale === "ko" ? "목록으로" : "Back to list"}
          </Link>

          {/* 글 헤더 */}
          <header className={styles.header}>
            {/* 카테고리 뱃지 */}
            {post.categories && (
              <CategoryBadge
                name={(post.categories as {id:string;name:string;slug:string;color?:string|null}).name}
                slug={(post.categories as {id:string;name:string;slug:string;color?:string|null}).slug}
                color={(post.categories as {id:string;name:string;slug:string;color?:string|null}).color}
                locale={locale}
              />
            )}

            {/* 제목 */}
            <h1 className={styles.title}>{post.title}</h1>

            {/* 메타 정보: 날짜, 조회수, 읽기 시간 */}
            <div className={styles.meta}>
              <time dateTime={post.created_at}>
                📅 {formatDate(post.created_at, locale)}
              </time>
              {post.view_count !== null && (
                <span>👁 {(post.view_count ?? 0).toLocaleString()}</span>
              )}
            </div>

            {/* 태그 목록 */}
            {post.tags && post.tags.length > 0 && (
              <div className={styles.tags}>
                {(post.tags as Array<{id: string; name: string; slug: string}>).map((tag) => (
                  <TagBadge
                    key={tag.id}
                    name={tag.name}
                    slug={tag.slug}
                    locale={locale}
                  />
                ))}
              </div>
            )}
          </header>

          {/* 시리즈 네비게이션 박스 (시리즈 글이면 표시) */}
          {seriesPosts.length > 0 && (
            <div className={styles.seriesBox}>
              <div className={styles.seriesHeader}>
                <span className={styles.seriesLabel}>
                  📚 {locale === "ko" ? "시리즈" : "Series"}
                </span>
                <span className={styles.seriesTitle}>
                  {(post.series as {id:string;title:string;slug:string} | null)?.title}
                </span>
              </div>
              <ol className={styles.seriesList}>
                {seriesPosts.map((sp, idx) => (
                  <li key={sp.id} className={`${styles.seriesItem} ${sp.id === post.id ? styles.seriesItemCurrent : ""}`}>
                    <span className={styles.seriesItemNum}>{idx + 1}</span>
                    {sp.id === post.id ? (
                      <span className={styles.seriesItemCurrentText}>{sp.title}</span>
                    ) : (
                      <Link href={`/${locale}/blog/${sp.slug}`} className={styles.seriesItemLink}>
                        {sp.title}
                      </Link>
                    )}
                  </li>
                ))}
              </ol>
            </div>
          )}

          {/* ─── 본문 콘텐츠 (HTML 렌더링) ─── */}
          <div
            className={styles.content}
            // dangerouslySetInnerHTML: 서버에서 저장된 HTML을 직접 렌더링
            // 관리자만 글을 작성하므로 XSS 위험이 낮음
            dangerouslySetInnerHTML={{ __html: post.content ?? "" }}
          />

          {/* 시리즈 이전/다음 글 네비게이션 */}
          {seriesPosts.length > 0 && (
            <nav className={styles.seriesNav}>
              {/* 이전 글 */}
              {currentSeriesIndex > 0 && (
                <Link
                  href={`/${locale}/blog/${seriesPosts[currentSeriesIndex - 1].slug}`}
                  className={`${styles.seriesNavBtn} ${styles.seriesNavPrev}`}
                >
                  <span className={styles.seriesNavLabel}>
                    ← {locale === "ko" ? "이전 글" : "Previous"}
                  </span>
                  <span className={styles.seriesNavTitle}>
                    {seriesPosts[currentSeriesIndex - 1].title}
                  </span>
                </Link>
              )}
              {/* 다음 글 */}
              {currentSeriesIndex < seriesPosts.length - 1 && (
                <Link
                  href={`/${locale}/blog/${seriesPosts[currentSeriesIndex + 1].slug}`}
                  className={`${styles.seriesNavBtn} ${styles.seriesNavNext}`}
                >
                  <span className={styles.seriesNavLabel}>
                    {locale === "ko" ? "다음 글" : "Next"} →
                  </span>
                  <span className={styles.seriesNavTitle}>
                    {seriesPosts[currentSeriesIndex + 1].title}
                  </span>
                </Link>
              )}
            </nav>
          )}

          {/* 관련 글 섹션 */}
          {relatedPosts.length > 0 && (
            <section className={styles.related}>
              <h2 className={styles.relatedTitle}>
                {locale === "ko" ? "관련 글" : "Related Posts"}
              </h2>
              <div className={styles.relatedGrid}>
                {relatedPosts.map((rp) => (
                  <PostCard
                    key={rp.id}
                    post={{ ...rp, categories: null, tags: [] }}
                    locale={locale}
                  />
                ))}
              </div>
            </section>
          )}

          {/* 댓글 섹션 */}
          <section className={styles.comments} id="comments">
            <h2 className={styles.commentsTitle}>
              {locale === "ko" ? "댓글" : "Comments"}
            </h2>

            {/* 댓글 작성 폼 */}
            <form className={styles.commentForm} action="/api/comments" method="POST">
              <input type="hidden" name="post_id" value={post.id} />
              <input type="hidden" name="locale" value={locale} />

              <div className={styles.commentFields}>
                {/* 닉네임 + 비밀번호 (같은 행) */}
                <div className={styles.commentRow}>
                  <div className={styles.formGroup}>
                    <label htmlFor="comment-author" className={styles.formLabel}>
                      {locale === "ko" ? "닉네임" : "Nickname"}
                    </label>
                    <input
                      id="comment-author"
                      type="text"
                      name="nickname"
                      required
                      maxLength={30}
                      placeholder={locale === "ko" ? "닉네임을 입력하세요" : "Enter nickname"}
                      className={styles.formInput}
                    />
                  </div>
                  <div className={styles.formGroup}>
                    <label htmlFor="comment-password" className={styles.formLabel}>
                      {locale === "ko" ? "비밀번호" : "Password"}
                      <span className={styles.formHint}>
                        {locale === "ko" ? "(댓글 삭제 시 필요)" : "(for deletion)"}
                      </span>
                    </label>
                    <input
                      id="comment-password"
                      type="password"
                      name="password"
                      required
                      minLength={4}
                      maxLength={20}
                      placeholder="****"
                      className={styles.formInput}
                    />
                  </div>
                </div>

                {/* 댓글 내용 */}
                <div className={styles.formGroup}>
                  <label htmlFor="comment-content" className={styles.formLabel}>
                    {locale === "ko" ? "내용" : "Content"}
                  </label>
                  <textarea
                    id="comment-content"
                    name="content"
                    required
                    minLength={2}
                    maxLength={500}
                    rows={4}
                    placeholder={locale === "ko" ? "댓글을 입력하세요 (최대 500자)" : "Write a comment (max 500 chars)"}
                    className={styles.formTextarea}
                  />
                </div>
              </div>

              {/* 제출 버튼 */}
              <button type="submit" className={`btn-primary ${styles.commentSubmit}`}>
                {locale === "ko" ? "댓글 작성" : "Submit Comment"}
              </button>
            </form>

            {/* 댓글 목록 (클라이언트 측 로딩은 추후 구현) */}
            <div className={styles.commentsList} id="comments-list">
              <p className={styles.commentsPlaceholder}>
                {locale === "ko"
                  ? "댓글을 불러오는 중..."
                  : "Loading comments..."}
              </p>
            </div>
          </section>
        </div>

        {/* ─────────────────────────────── */}
        {/* 우측 사이드바 (목차 - 추후 JS로 동적 생성) */}
        {/* ─────────────────────────────── */}
        <aside className={styles.sidebar}>
          <div className={styles.tocCard}>
            <h3 className={styles.tocTitle}>
              {locale === "ko" ? "목차" : "Table of Contents"}
            </h3>
            <p className={styles.tocPlaceholder}>
              {locale === "ko"
                ? "스크롤하면 목차가 자동으로 생성됩니다."
                : "Table of contents is generated as you scroll."}
            </p>
          </div>
        </aside>
      </div>
    </article>
  );
}
