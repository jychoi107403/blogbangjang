// app/[locale]/tag/[slug]/page.tsx
// 태그별 글 목록 페이지

import type { Metadata } from "next";
import { notFound } from "next/navigation";
import PostCard from "@/components/blog/PostCard";
import { getPublishedPosts } from "@/lib/utils/posts";
import { getTagBySlug } from "@/lib/utils/tags";
import styles from "./page.module.css";

interface TagPageProps {
  params: Promise<{ locale: string; slug: string }>;
}

export async function generateMetadata({ params }: TagPageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const tag = await getTagBySlug(slug);
  if (!tag) return { title: "태그를 찾을 수 없습니다" };
  return {
    title: locale === "ko" ? `#${tag.name} | 태그` : `#${tag.name} | Tag`,
  };
}

export default async function TagPage({ params }: TagPageProps) {
  const { locale, slug } = await params;

  // 태그 정보 조회
  const tag = await getTagBySlug(slug);
  if (!tag) notFound();

  // 해당 태그의 글 목록 조회
  const { posts, total } = await getPublishedPosts({
    locale,
    tagId: tag.id,
    limit: 50,
  });

  return (
    <div className="container">
      <div className={styles.page}>
        {/* 페이지 헤더 */}
        <header className={styles.header}>
          <div className={styles.tagLabel}># {tag.name}</div>
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
            <span>🏷️</span>
            <p>{locale === "ko" ? "해당 태그의 글이 없습니다." : "No posts with this tag."}</p>
          </div>
        )}
      </div>
    </div>
  );
}
