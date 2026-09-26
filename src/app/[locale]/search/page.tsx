// app/[locale]/search/page.tsx
// 검색 결과 페이지
// URL 파라미터: ?q=검색어

import type { Metadata } from "next";
import { searchPosts } from "@/lib/utils/posts";
import PostCard from "@/components/blog/PostCard";
import styles from "./page.module.css";

interface SearchPageProps {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ q?: string }>;
}

export async function generateMetadata({ searchParams }: SearchPageProps): Promise<Metadata> {
  const { q } = await searchParams;
  return {
    title: q ? `'${q}' 검색 결과` : "검색",
    description: q ? `'${q}'에 대한 검색 결과입니다.` : "블로그 글을 검색하세요.",
  };
}

export default async function SearchPage({ params, searchParams }: SearchPageProps) {
  const { locale } = await params;
  const { q: query } = await searchParams;

  // 검색어가 있으면 결과를 가져오고, 없으면 빈 배열
  const posts = query && query.trim().length >= 2
    ? await searchPosts(query.trim(), locale)
    : [];

  return (
    <div className="container">
      <div className={styles.page}>
        {/* 페이지 헤더 + 검색 폼 */}
        <div className={styles.searchSection}>
          <h1 className={styles.title}>
            {locale === "ko" ? "🔍 검색" : "🔍 Search"}
          </h1>

          {/* 검색 폼 (GET 방식, URL에 q= 파라미터 추가) */}
          <form className={styles.searchForm} method="GET">
            <div className={styles.searchInputWrapper}>
              <span className={styles.searchIcon}>🔍</span>
              <input
                id="search-input"
                type="search"
                name="q"
                defaultValue={query ?? ""}
                placeholder={
                  locale === "ko"
                    ? "검색어를 입력하세요 (최소 2자)"
                    : "Type to search (min 2 chars)"
                }
                className={styles.searchInput}
                autoFocus
              />
            </div>
            <button type="submit" className={`btn-primary ${styles.searchBtn}`}>
              {locale === "ko" ? "검색" : "Search"}
            </button>
          </form>
        </div>

        {/* 검색 결과 */}
        {query ? (
          <div className={styles.results}>
            <p className={styles.resultCount}>
              {locale === "ko"
                ? `'${query}'에 대한 검색 결과: ${posts.length}건`
                : `Found ${posts.length} result(s) for '${query}'`}
            </p>

            {posts.length > 0 ? (
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
            ) : (
              <div className={styles.emptyState}>
                <span>🔍</span>
                <p>
                  {locale === "ko"
                    ? `'${query}'에 대한 검색 결과가 없습니다.`
                    : `No results found for '${query}'.`}
                </p>
                <p className={styles.emptyHint}>
                  {locale === "ko"
                    ? "다른 검색어를 시도해 보세요."
                    : "Try different keywords."}
                </p>
              </div>
            )}
          </div>
        ) : (
          // 검색어가 없을 때 안내 메시지
          <div className={styles.emptyState}>
            <span>✍️</span>
            <p>
              {locale === "ko"
                ? "위의 검색창에 검색어를 입력하세요."
                : "Enter keywords in the search box above."}
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
