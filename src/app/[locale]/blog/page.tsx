// app/[locale]/blog/page.tsx
// 블로그 글 목록 페이지 (전체 발행된 글, 페이지네이션 포함)
// URL 파라미터: ?page=1&category=xxx

import type { Metadata } from "next";
import Link from "next/link";
import PostCard from "@/components/blog/PostCard";
import { getPublishedPosts } from "@/lib/utils/posts";
import { getAllCategories } from "@/lib/utils/categories";
import styles from "./page.module.css";

// 페이지 Props 타입
interface BlogPageProps {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ page?: string; category?: string }>;
}

// SEO 메타데이터
export async function generateMetadata({ params }: BlogPageProps): Promise<Metadata> {
  const { locale } = await params;
  return {
    title: locale === "ko" ? "블로그" : "Blog",
    description:
      locale === "ko"
        ? "개발, 기술, 배움에 관한 모든 글 목록입니다."
        : "All posts about development, tech, and learning.",
  };
}

// 페이지당 표시할 글 수
const POSTS_PER_PAGE = 9;

export default async function BlogPage({ params, searchParams }: BlogPageProps) {
  const { locale } = await params;
  const { page: pageStr, category: categorySlug } = await searchParams;

  // 현재 페이지 번호 (최소 1)
  const currentPage = Math.max(1, parseInt(pageStr ?? "1", 10));

  // 카테고리 목록 먼저 가져오기 (필터에 사용)
  const categories = await getAllCategories(locale);

  // 선택된 카테고리의 ID 찾기
  const selectedCategory = categorySlug
    ? categories.find((c) => c.slug === categorySlug)
    : null;

  // 글 목록 조회 (카테고리 필터 + 페이지네이션)
  const { posts, total } = await getPublishedPosts({
    locale,
    page: currentPage,
    limit: POSTS_PER_PAGE,
    categoryId: selectedCategory?.id,
  });

  // 총 페이지 수 계산
  const totalPages = Math.ceil(total / POSTS_PER_PAGE);

  // 페이지 URL 생성 헬퍼 (카테고리 필터 유지)
  const getPageUrl = (p: number) => {
    const params = new URLSearchParams();
    if (p > 1) params.set("page", String(p));
    if (categorySlug) params.set("category", categorySlug);
    const qs = params.toString();
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
              {/* 전체 보기 */}
              <Link
                href={`/${locale}/blog`}
                className={`${styles.categoryItem} ${!categorySlug ? styles.categoryItemActive : ""}`}
              >
                <span>{locale === "ko" ? "전체" : "All"}</span>
                <span className={styles.categoryItemCount}>{total}</span>
              </Link>
              {/* 각 카테고리 */}
              {categories.map((cat) => (
                <Link
                  key={cat.id}
                  href={`/${locale}/blog?category=${cat.slug}`}
                  className={`${styles.categoryItem} ${categorySlug === cat.slug ? styles.categoryItemActive : ""}`}
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
        {/* 메인: 글 목록 */}
        {/* ──────────────────────────────── */}
        <main className={styles.main}>
          {/* 페이지 제목 */}
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

          {/* 글 카드 그리드 */}
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
                        : (post.categories as {id: string; name: string; slug: string; color?: string | null} | null),
                    }}
                    locale={locale}
                  />
                ))}
              </div>

              {/* 페이지네이션 */}
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
            // 글이 없을 때
            <div className={styles.emptyState}>
              <span>📭</span>
              <p>
                {selectedCategory
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
