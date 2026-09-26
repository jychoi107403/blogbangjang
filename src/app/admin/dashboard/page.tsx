// app/admin/dashboard/page.tsx
// 어드민 대시보드 페이지
// 글 수, 조회수 합계, 댓글 수, 구독자 수를 보여주는 통계 페이지

import type { Metadata } from "next";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import styles from "./page.module.css";

export const metadata: Metadata = {
  title: "대시보드",
};

// 통계 데이터 조회 함수
async function getDashboardStats() {
  const supabase = await createClient();

  // 여러 데이터를 병렬로 조회 (속도 최적화)
  const [
    { count: totalPosts },
    { count: publishedPosts },
    { data: viewStats },
    { count: totalComments },
    { count: totalSubscribers },
  ] = await Promise.all([
    // 전체 글 수
    supabase.from("posts").select("*", { count: "exact", head: true }),
    // 발행된 글 수
    supabase.from("posts").select("*", { count: "exact", head: true }).eq("status", "published"),
    // 조회수 합계 (view_count 합산)
    supabase.from("posts").select("view_count"),
    // 전체 댓글 수 (삭제된 것 제외)
    supabase.from("comments").select("*", { count: "exact", head: true }).eq("is_deleted", false),
    // 인증된 구독자 수
    supabase.from("newsletter_subscribers").select("*", { count: "exact", head: true }).eq("is_verified", true),
  ]);

  // 조회수 합계 계산
  const totalViews = viewStats?.reduce((sum, p) => sum + (p.view_count ?? 0), 0) ?? 0;

  return {
    totalPosts: totalPosts ?? 0,
    publishedPosts: publishedPosts ?? 0,
    totalViews,
    totalComments: totalComments ?? 0,
    totalSubscribers: totalSubscribers ?? 0,
  };
}

// 최근 글 5개 조회
async function getRecentPostsForAdmin() {
  const supabase = await createClient();

  const { data: posts } = await supabase
    .from("posts")
    .select("id, title, slug, status, locale, view_count, created_at")
    .order("created_at", { ascending: false })
    .limit(5);

  return posts ?? [];
}

export default async function DashboardPage() {
  const [stats, recentPosts] = await Promise.all([
    getDashboardStats(),
    getRecentPostsForAdmin(),
  ]);

  // 통계 카드 목록
  const statCards = [
    {
      label: "전체 글",
      value: stats.totalPosts,
      sub: `발행됨: ${stats.publishedPosts}`,
      icon: "📝",
      href: "/admin/posts",
    },
    {
      label: "총 조회수",
      value: stats.totalViews.toLocaleString(),
      sub: "모든 글 합산",
      icon: "👁",
      href: null,
    },
    {
      label: "댓글",
      value: stats.totalComments,
      sub: "삭제 제외",
      icon: "💬",
      href: null,
    },
    {
      label: "뉴스레터 구독자",
      value: stats.totalSubscribers,
      sub: "인증 완료",
      icon: "📬",
      href: "/admin/newsletter",
    },
  ];

  return (
    <div className={styles.page}>
      {/* 헤더 */}
      <div className={styles.header}>
        <h1 className={styles.title}>📊 대시보드</h1>
        <Link href="/admin/posts/new" className="btn-primary">
          ✍️ 새 글 작성
        </Link>
      </div>

      {/* 통계 카드 4개 */}
      <div className={styles.statsGrid}>
        {statCards.map((card) => (
          <div key={card.label} className={styles.statCard}>
            <div className={styles.statIcon}>{card.icon}</div>
            <div className={styles.statInfo}>
              <div className={styles.statValue}>{card.value}</div>
              <div className={styles.statLabel}>{card.label}</div>
              <div className={styles.statSub}>{card.sub}</div>
            </div>
            {card.href && (
              <Link href={card.href} className={styles.statLink}>
                →
              </Link>
            )}
          </div>
        ))}
      </div>

      {/* 최근 글 목록 */}
      <div className={styles.recentSection}>
        <div className={styles.sectionHeader}>
          <h2 className={styles.sectionTitle}>최근 글</h2>
          <Link href="/admin/posts" className={styles.seeAll}>
            전체 보기 →
          </Link>
        </div>

        <div className={styles.postsTable}>
          {/* 테이블 헤더 */}
          <div className={styles.tableHeader}>
            <span className={styles.colTitle}>제목</span>
            <span className={styles.colStatus}>상태</span>
            <span className={styles.colLocale}>언어</span>
            <span className={styles.colViews}>조회수</span>
            <span className={styles.colDate}>작성일</span>
            <span className={styles.colAction}>액션</span>
          </div>

          {/* 글 목록 행 */}
          {recentPosts.map((post) => (
            <div key={post.id} className={styles.tableRow}>
              <span className={`${styles.colTitle} ${styles.postTitle}`}>
                {post.title}
              </span>
              {/* 발행 상태 뱃지 */}
              <span className={styles.colStatus}>
                <span
                  className={`${styles.statusBadge} ${
                    post.status === "published"
                      ? styles.statusPublished
                      : styles.statusDraft
                  }`}
                >
                  {post.status === "published" ? "발행됨" : "임시저장"}
                </span>
              </span>
              <span className={styles.colLocale}>
                {post.locale === "ko" ? "🇰🇷" : "🇺🇸"}
              </span>
              <span className={styles.colViews}>
                {(post.view_count ?? 0).toLocaleString()}
              </span>
              <span className={styles.colDate}>
                {new Date(post.created_at).toLocaleDateString("ko-KR")}
              </span>
              <span className={styles.colAction}>
                <Link
                  href={`/ko/blog/${post.slug}`}
                  target="_blank"
                  className={styles.actionBtn}
                >
                  보기
                </Link>
              </span>
            </div>
          ))}

          {recentPosts.length === 0 && (
            <div className={styles.emptyState}>
              <p>아직 작성된 글이 없습니다.</p>
              <Link href="/admin/posts/new" className="btn-primary">
                첫 글 작성하기
              </Link>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
