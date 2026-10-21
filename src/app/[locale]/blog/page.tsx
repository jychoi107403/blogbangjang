// app/[locale]/blog/page.tsx
// 블로그 글 목록 페이지 (전체 발행된 글, 카테고리 필터, 시리즈 필터, 페이지네이션 포함)
// URL 파라미터 예시:
//   - 일반 목록: ?page=1
//   - 카테고리 필터: ?category=web-dev
//   - 시리즈 필터: ?series=building-my-blog

import type { Metadata } from "next";
import Link from "next/link";
import PostCard from "@/components/blog/PostCard";
import { getPublishedPosts } from "@/lib/utils/posts";
import { getAllCategories } from "@/lib/utils/categories";
import { getSeriesBySlug } from "@/lib/utils/series";
import styles from "./page.module.css";

// ─────────────────────────────────────────────
// 페이지 Props 타입 정의
// Next.js 15+ 에서는 params와 searchParams가 Promise로 제공됩니다.
// ─────────────────────────────────────────────
interface BlogPageProps {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{
    page?: string;
    category?: string;
    series?: string; // ★ 시리즈 필터 URL 파라미터 추가 (?series=xxx)
  }>;
}

// ─────────────────────────────────────────────
// SEO 메타데이터 동적 생성
// 카테고리나 시리즈를 보고 있을 때 브라우저 탭 제목과 검색엔진 설명을 알맞게 변경합니다.
// ─────────────────────────────────────────────
export async function generateMetadata({ params, searchParams }: BlogPageProps): Promise<Metadata> {
  const { locale } = await params;
  const { category: categorySlug, series: seriesSlug } = await searchParams;

  let pageTitle = locale === "ko" ? "블로그" : "Blog";
  let pageDesc =
    locale === "ko"
      ? "개발, 기술, 배움에 관한 모든 글 목록입니다."
      : "All posts about development, tech, and learning.";

  // 시리즈 필터가 선택된 경우
  if (seriesSlug) {
    const series = await getSeriesBySlug(seriesSlug);
    if (series) {
      pageTitle = `${series.title} (시리즈) | ${locale === "ko" ? "블로그" : "Blog"}`;
      pageDesc = series.description || pageDesc;
    }
  }
  // 카테고리 필터가 선택된 경우
  else if (categorySlug) {
    const categories = await getAllCategories(locale);
    const category = categories.find((c) => c.slug === categorySlug);
    if (category) {
      pageTitle = `${category.name} | ${locale === "ko" ? "블로그" : "Blog"}`;
    }
  }

  return {
    title: pageTitle,
    description: pageDesc,
    alternates: {
      canonical: `https://bangjang.net/${locale}/blog`,
      languages: {
        ko: "https://bangjang.net/ko/blog",
        en: "https://bangjang.net/en/blog",
        "x-default": "https://bangjang.net/ko/blog",
      },
    },
  };
}

// 페이지당 표시할 글 수 (그리드 3열 레이아웃에 맞춰 9개)
const POSTS_PER_PAGE = 9;

export default async function BlogPage({ params, searchParams }: BlogPageProps) {
  const { locale } = await params;
  const { page: pageStr, category: categorySlug, series: seriesSlug } = await searchParams;

  // 1. 현재 페이지 번호 (기본 1, 음수나 0 방지)
  const currentPage = Math.max(1, parseInt(pageStr ?? "1", 10));

  // 2. 카테고리 목록 가져오기 (사이드바 표시에 사용)
  const categories = await getAllCategories(locale);

  // 3. 선택된 카테고리 정보 조회 (카테고리 필터용)
  const selectedCategory = categorySlug
    ? categories.find((c) => c.slug === categorySlug)
    : null;

  // 4. 선택된 시리즈 정보 조회 (시리즈 필터용)
  // 주소창에 ?series=xxx 가 들어왔을 때 Supabase에서 해당 시리즈의 ID를 찾습니다
  const selectedSeries = seriesSlug
    ? await getSeriesBySlug(seriesSlug)
    : null;

  // 5. 글 목록 조회 (카테고리 또는 시리즈 필터 + 페이지네이션 적용)
  // seriesId가 전달되면 posts.ts에서 series_order 오름차순(1편부터 차례대로)으로 정렬합니다
  const { posts, total } = await getPublishedPosts({
    locale,
    page: currentPage,
    limit: POSTS_PER_PAGE,
    categoryId: selectedCategory?.id,
    seriesId: selectedSeries?.id, // ★ 시리즈 ID를 넘겨주어 해당 시리즈 글만 가져옵니다
  });

  // 6. 총 페이지 수 계산
  const totalPages = Math.ceil(total / POSTS_PER_PAGE);

  // 7. 페이지 URL 생성 헬퍼 함수 (카테고리 및 시리즈 필터 상태를 그대로 유지하면서 페이지 이동)
  const getPageUrl = (p: number) => {
    const query = new URLSearchParams();
    if (p > 1) query.set("page", String(p));
    if (categorySlug) query.set("category", categorySlug);
    if (seriesSlug) query.set("series", seriesSlug); // ★ 페이지 이동 시에도 시리즈 필터 유지
    const qs = query.toString();
    return `/${locale}/blog${qs ? `?${qs}` : ""}`;
  };

  return (
    <div className="container">
      <div className={styles.layout}>
        {/* ──────────────────────────────── */}
        {/* 사이드바: 카테고리 필터 */}
        {/* ──────────────────────────────── */}
        <aside className={styles.sidebar}>
          <div className={styles.sidebarCard}>
            <h3 className={styles.sidebarTitle}>
              {locale === "ko" ? "카테고리" : "Categories"}
            </h3>
            <nav className={styles.categoryNav}>
              {/* 전체 보기 버튼 (카테고리 및 시리즈 필터 해제) */}
              <Link
                href={`/${locale}/blog`}
                className={`${styles.categoryItem} ${!categorySlug && !seriesSlug ? styles.categoryItemActive : ""}`}
              >
                <span>{locale === "ko" ? "전체 보기" : "All Posts"}</span>
                {!seriesSlug && !categorySlug && (
                  <span className={styles.categoryItemCount}>{total}</span>
                )}
              </Link>

              {/* 각 카테고리 목록 */}
              {categories.map((cat) => (
                <Link
                  key={cat.id}
                  href={`/${locale}/blog?category=${cat.slug}`}
                  className={`${styles.categoryItem} ${categorySlug === cat.slug && !seriesSlug ? styles.categoryItemActive : ""}`}
                >
                  {/* 카테고리 색상 점 */}
                  {cat.color && (
                    <span
                      className={styles.categoryDot}
                      style={{ backgroundColor: cat.color }}
                    />
                  )}
                  <span>{cat.name}</span>
                  <span className={styles.categoryItemCount}>{cat.post_count}</span>
                </Link>
              ))}
            </nav>
          </div>
        </aside>

        {/* ──────────────────────────────── */}
        {/* 메인: 글 목록 및 헤더 배너 */}
        {/* ──────────────────────────────── */}
        <main className={styles.main}>
          {/* ① 시리즈 필터가 걸려 있을 때: 시리즈 전용 안내 배너 표시 */}
          {selectedSeries ? (
            <div className={styles.seriesBanner}>
              <span className={styles.seriesBadge}>
                {locale === "ko" ? "📚 시리즈 연재" : "📚 Ongoing Series"}
              </span>
              <h1 className={styles.seriesBannerTitle}>{selectedSeries.title}</h1>
              {selectedSeries.description && (
                <p className={styles.seriesBannerDesc}>{selectedSeries.description}</p>
              )}
              <div className={styles.seriesBannerMeta}>
                <span className={styles.seriesCount}>
                  {locale === "ko"
                    ? `연재 중인 글 총 ${total}편 (순서대로 정렬)`
                    : `Total ${total} posts in series (ordered)`}
                </span>
                {/* 필터 해제하고 전체 글 목록으로 돌아가는 버튼 */}
                <Link href={`/${locale}/blog`} className={styles.clearFilterBtn}>
                  {locale === "ko" ? "✕ 전체 글 보기" : "✕ View All Posts"}
                </Link>
              </div>
            </div>
          ) : (
            /* ② 일반 또는 카테고리 필터일 때: 기본 페이지 헤더 */
            <div className={styles.pageHeader}>
              <h1 className={styles.pageTitle}>
                {selectedCategory
                  ? selectedCategory.name
                  : locale === "ko" ? "모든 글" : "All Posts"}
              </h1>
              <p className={styles.pageSubtitle}>
                {locale === "ko"
                  ? `총 ${total}편의 글`
                  : `${total} posts total`}
              </p>
            </div>
          )}

          {/* 글 카드 그리드 (3열) */}
          {posts.length > 0 ? (
            <>
              <div className={styles.postsGrid}>
                {posts.map((post) => (
                  <PostCard
                    key={post.id}
                    post={{
                      ...post,
                      categories: Array.isArray(post.categories)
                        ? post.categories[0] ?? null
                        : (post.categories as { id: string; name: string; slug: string; color?: string | null } | null),
                    }}
                    locale={locale}
                  />
                ))}
              </div>

              {/* 페이지네이션 (글이 10개 이상일 때) */}
              {totalPages > 1 && (
                <nav className={styles.pagination} aria-label="페이지 네비게이션">
                  {/* 이전 페이지 버튼 */}
                  {currentPage > 1 ? (
                    <Link href={getPageUrl(currentPage - 1)} className={styles.pageBtn}>
                      ← {locale === "ko" ? "이전" : "Prev"}
                    </Link>
                  ) : (
                    <span className={`${styles.pageBtn} ${styles.pageBtnDisabled}`}>
                      ← {locale === "ko" ? "이전" : "Prev"}
                    </span>
                  )}

                  {/* 페이지 번호 목록 */}
                  <div className={styles.pageNumbers}>
                    {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
                      <Link
                        key={p}
                        href={getPageUrl(p)}
                        className={`${styles.pageNumber} ${p === currentPage ? styles.pageNumberActive : ""}`}
                      >
                        {p}
                      </Link>
                    ))}
                  </div>

                  {/* 다음 페이지 버튼 */}
                  {currentPage < totalPages ? (
                    <Link href={getPageUrl(currentPage + 1)} className={styles.pageBtn}>
                      {locale === "ko" ? "다음" : "Next"} →
                    </Link>
                  ) : (
                    <span className={`${styles.pageBtn} ${styles.pageBtnDisabled}`}>
                      {locale === "ko" ? "다음" : "Next"} →
                    </span>
                  )}
                </nav>
              )}
            </>
          ) : (
            // 필터링 결과 글이 없을 때
            <div className={styles.emptyState}>
              <span>📭</span>
              <p>
                {selectedSeries
                  ? (locale === "ko"
                      ? `'${selectedSeries.title}' 시리즈에 아직 등록된 글이 없습니다.`
                      : `No posts in '${selectedSeries.title}' series yet.`)
                  : selectedCategory
                  ? (locale === "ko"
                      ? `'${selectedCategory.name}' 카테고리에 아직 글이 없습니다.`
                      : `No posts in '${selectedCategory.name}' yet.`)
                  : (locale === "ko" ? "아직 작성된 글이 없습니다." : "No posts yet.")}
              </p>
            </div>
          )}
        </main>
      </div>
    </div>
  );
}
