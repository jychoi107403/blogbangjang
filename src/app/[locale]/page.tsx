// app/[locale]/page.tsx
// 블로그 홈 페이지
// 히어로 섹션 + 최신 글 목록 + 카테고리 필터 + 뉴스레터 구독 폼

import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import Link from "next/link";
import PostCard from "@/components/blog/PostCard";
import { getRecentPosts } from "@/lib/utils/posts";
import { getAllCategories } from "@/lib/utils/categories";
import styles from "./page.module.css";

// 페이지 Props 타입
interface HomePageProps {
  params: Promise<{ locale: string }>;
}

// SEO 메타데이터 동적 생성
export async function generateMetadata({
  params,
}: HomePageProps): Promise<Metadata> {
  const { locale } = await params;
  return {
    title: locale === "ko" ? "방장 블로그 — 개발과 배움의 기록" : "Bangjang Blog — Dev Notes & Learnings",
    description:
      locale === "ko"
        ? "Next.js, TypeScript, 웹 개발 등 다양한 주제의 글을 공유합니다."
        : "Sharing articles on Next.js, TypeScript, web development and more.",
  };
}

export default async function HomePage({ params }: HomePageProps) {
  const { locale } = await params;
  const t = await getTranslations("home");

  // 서버에서 데이터 가져오기 (병렬 처리로 속도 최적화)
  const [recentPosts, categories] = await Promise.all([
    getRecentPosts(locale, 6),  // 최신 글 6개
    getAllCategories(locale),     // 전체 카테고리 목록
  ]);

  return (
    <div className={styles.page}>
      {/* ══════════════════════════════════════════ */}
      {/* 히어로 섹션: 블로그 소개 */}
      {/* ══════════════════════════════════════════ */}
      <section className={styles.hero}>
        <div className={`container ${styles.heroInner}`}>
          {/* 작은 레이블 */}
          <div className={styles.heroLabel}>
            <span>✦</span>
            <span>{locale === "ko" ? "개발 & 배움의 기록" : "Dev & Learning Notes"}</span>
          </div>

          {/* 메인 타이틀 */}
          <h1 className={styles.heroTitle}>
            {locale === "ko" ? (
              <>
                코드로 쌓아가는<br />
                <span className={styles.heroAccent}>방장의 이야기</span>
              </>
            ) : (
              <>
                Stories built<br />
                <span className={styles.heroAccent}>with code</span>
              </>
            )}
          </h1>

          {/* 부제목 */}
          <p className={styles.heroDesc}>
            {locale === "ko"
              ? "Next.js, TypeScript, 웹 개발 등 배우고 경험한 것들을 솔직하게 기록합니다."
              : "Honest records of what I learn and experience in Next.js, TypeScript, and web development."}
          </p>

          {/* CTA 버튼 */}
          <div className={styles.heroCta}>
            <Link href={`/${locale}/blog`} className="btn-primary">
              {locale === "ko" ? "📖 모든 글 보기" : "📖 Browse All Posts"}
            </Link>
            <Link href={`/${locale}/series`} className={styles.btnSecondary}>
              {locale === "ko" ? "📚 시리즈 보기" : "📚 Browse Series"}
            </Link>
          </div>
        </div>

        {/* 히어로 배경 장식 (CSS 애니메이션) */}
        <div className={styles.heroBg} aria-hidden="true">
          <div className={styles.heroBgBlob1} />
          <div className={styles.heroBgBlob2} />
        </div>
      </section>

      {/* ══════════════════════════════════════════ */}
      {/* 카테고리 빠른 탐색 */}
      {/* ══════════════════════════════════════════ */}
      {categories.length > 0 && (
        <section className={styles.categories}>
          <div className="container">
            <div className={styles.categoryList}>
              {/* 전체 보기 버튼 */}
              <Link
                href={`/${locale}/blog`}
                className={`${styles.categoryChip} ${styles.categoryChipAll}`}
              >
                {locale === "ko" ? "✨ 전체" : "✨ All"}
              </Link>
              {categories.map((cat) => (
                <Link
                  key={cat.id}
                  href={`/${locale}/category/${cat.slug}`}
                  className={styles.categoryChip}
                  style={
                    cat.color
                      ? { borderColor: `${cat.color}66`, color: cat.color }
                      : undefined
                  }
                >
                  {cat.name}
                  {cat.post_count > 0 && (
                    <span className={styles.categoryCount}>{cat.post_count}</span>
                  )}
                </Link>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* ══════════════════════════════════════════ */}
      {/* 최신 글 목록 */}
      {/* ══════════════════════════════════════════ */}
      <section className={styles.latestPosts}>
        <div className="container">
          {/* 섹션 헤더 */}
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>
              {locale === "ko" ? "최신 글" : "Latest Posts"}
            </h2>
            <Link href={`/${locale}/blog`} className={styles.seeAll}>
              {locale === "ko" ? "전체 보기 →" : "See all →"}
            </Link>
          </div>

          {/* 글 카드 그리드 */}
          {recentPosts.length > 0 ? (
            <div className={styles.postsGrid}>
              {recentPosts.map((post) => (
                <PostCard
                  key={post.id}
                  post={{
                    ...post,
                    // Supabase 조인 결과에서 카테고리 데이터 추출
                    categories: Array.isArray(post.categories)
                      ? post.categories[0] ?? null
                      : (post.categories as {id: string; name: string; slug: string; color?: string | null} | null),
                  }}
                  locale={locale}
                />
              ))}
            </div>
          ) : (
            // 글이 없을 때 안내 메시지
            <div className={styles.emptyState}>
              <span>📝</span>
              <p>{locale === "ko" ? "아직 작성된 글이 없습니다." : "No posts yet."}</p>
              <Link href={`/${locale}/blog`} className="btn-primary">
                {locale === "ko" ? "블로그 바로가기" : "Go to Blog"}
              </Link>
            </div>
          )}
        </div>
      </section>

      {/* ══════════════════════════════════════════ */}
      {/* 뉴스레터 구독 섹션 */}
      {/* ══════════════════════════════════════════ */}
      <section className={styles.newsletter}>
        <div className="container">
          <div className={styles.newsletterBox}>
            {/* 이모지 아이콘 */}
            <div className={styles.newsletterIcon}>📬</div>

            <h2 className={styles.newsletterTitle}>
              {locale === "ko"
                ? "새 글이 올라오면 바로 알려드릴게요"
                : "Get notified when new posts arrive"}
            </h2>
            <p className={styles.newsletterDesc}>
              {locale === "ko"
                ? "이메일을 남겨주시면 새 글이 발행될 때 소식을 전달드립니다. 스팸은 절대 없어요!"
                : "Leave your email and I'll notify you when new posts are published. No spam, ever!"}
            </p>

            {/* 구독 폼 */}
            <form className={styles.newsletterForm} action="/api/newsletter" method="POST">
              {/* 현재 locale 전달 */}
              <input type="hidden" name="locale" value={locale} />
              <div className={styles.newsletterInputRow}>
                <input
                  type="email"
                  name="email"
                  required
                  placeholder={locale === "ko" ? "이메일 주소를 입력하세요" : "Enter your email address"}
                  className={styles.newsletterInput}
                  id="newsletter-email"
                />
                <button type="submit" className={`btn-primary ${styles.newsletterBtn}`}>
                  {locale === "ko" ? "구독하기" : "Subscribe"}
                </button>
              </div>
            </form>
          </div>
        </div>
      </section>
    </div>
  );
}
