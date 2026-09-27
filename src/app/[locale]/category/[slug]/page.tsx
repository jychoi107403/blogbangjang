// app/[locale]/category/[slug]/page.tsx
// 카테고리별 글 목록 페이지

import type { Metadata } from "next";
import { notFound } from "next/navigation";
import PostCard from "@/components/blog/PostCard";
import { getPublishedPosts } from "@/lib/utils/posts";
import { getCategoryBySlug } from "@/lib/utils/categories";
import styles from "./page.module.css";

interface CategoryPageProps {
  params: Promise<{ locale: string; slug: string }>;
}

export async function generateMetadata({ params }: CategoryPageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const category = await getCategoryBySlug(slug);
  if (!category) return { title: "카테고리를 찾을 수 없습니다" };
  return {
    title: locale === "ko" ? `${category.name} | 카테고리` : `${category.name} | Category`,
    description: category.description ?? undefined,
    alternates: {
      canonical: `https://bangjang.net/${locale}/category/${slug}`,
      languages: {
        ko: `https://bangjang.net/ko/category/${slug}`,
        en: `https://bangjang.net/en/category/${slug}`,
        "x-default": `https://bangjang.net/ko/category/${slug}`,
      },
    },
  };
}

export default async function CategoryPage({ params }: CategoryPageProps) {
  const { locale, slug } = await params;

  // 카테고리 정보 조회
  const category = await getCategoryBySlug(slug);
  if (!category) notFound();

  // 해당 카테고리의 글 목록 조회
  const { posts, total } = await getPublishedPosts({
    locale,
    categoryId: category.id,
    limit: 50, // 카테고리 페이지는 페이지네이션 없이 모두 표시
  });

  return (
    <div className="container">
      <div className={styles.page}>
        {/* 페이지 헤더 */}
        <header className={styles.header}>
          {/* 카테고리 색상 바 */}
          {category.color && (
            <div className={styles.colorBar} style={{ backgroundColor: category.color }} />
          )}
          <h1 className={styles.title}>{category.name}</h1>
          {category.description && (
            <p className={styles.description}>{category.description}</p>
          )}
          <p className={styles.count}>
            {locale === "ko" ? `총 ${total}편의 글` : `${total} posts`}
          </p>
        </header>

        {/* 글 목록 */}
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
            <span>📭</span>
            <p>{locale === "ko" ? "아직 글이 없습니다." : "No posts yet."}</p>
          </div>
        )}
      </div>
    </div>
  );
}
