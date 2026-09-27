// app/admin/posts/page.tsx
// 어드민 전체 글 목록 관리 페이지
// 등록된 모든 글(발행됨/임시저장)을 조회하고 수정/발행/관리하는 화면

import type { Metadata } from "next";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import styles from "./page.module.css";

export const metadata: Metadata = {
  title: "글 목록",
};

// 날짜 포맷 헬퍼 함수
function formatDate(dateStr: string): string {
  const d = new Date(dateStr);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}. ${month}. ${day}.`;
}

// 전체 글 목록 조회 함수 (최신순)
async function getAllPostsForAdmin() {
  const supabase = await createClient();

  const { data: posts, error } = await supabase
    .from("posts")
    .select("id, title, slug, status, locale, view_count, created_at, published_at")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Failed to fetch admin posts:", error.message);
    return [];
  }

  return posts ?? [];
}

export default async function AdminPostsPage() {
  const posts = await getAllPostsForAdmin();

  return (
    <div className={styles.page}>
      {/* ─── 페이지 헤더 ─── */}
      <div className={styles.header}>
        <div className={styles.titleArea}>
          <h1 className={styles.title}>📋 글 목록</h1>
          <span className={styles.postCount}>총 {posts.length}개</span>
        </div>
        <Link href="/admin/posts/new" className="btn-primary">
          ✍️ 새 글 작성
        </Link>
      </div>

      {/* ─── 전체 글 테이블 ─── */}
      <div className={styles.postsSection}>
        <div className={styles.postsTable}>
          {/* 테이블 헤더 */}
          <div className={styles.tableHeader}>
            <div className={styles.colTitle}>제목</div>
            <div className={styles.colStatus}>상태</div>
            <div className={styles.colLocale}>언어</div>
            <div className={styles.colViews}>조회수</div>
            <div className={styles.colDate}>작성일</div>
            <div className={styles.colAction}>관리</div>
          </div>

          {/* 글 목록 행들 */}
          {posts.length === 0 ? (
            <div className={styles.emptyState}>
              <span className={styles.emptyIcon}>📝</span>
              <p>작성된 글이 없습니다. 첫 글을 작성해보세요!</p>
              <Link href="/admin/posts/new" className="btn-primary">
                ✍️ 새 글 작성
              </Link>
            </div>
          ) : (
            posts.map((post) => (
              <div key={post.id} className={styles.tableRow}>
                {/* 글 제목 (클릭 시 바로 수정 에디터로 이동) */}
                <div className={styles.colTitle}>
                  <Link
                    href={`/admin/posts/${post.id}/edit`}
                    className={styles.postTitle}
                    title="클릭하여 글 수정/편집"
                  >
                    {post.title}
                  </Link>
                </div>

                {/* 상태 (발행됨 / 임시저장) */}
                <div className={styles.colStatus}>
                  <span
                    className={`${styles.statusBadge} ${
                      post.status === "published"
                        ? styles.statusPublished
                        : styles.statusDraft
                    }`}
                  >
                    {post.status === "published" ? "✅ 발행됨" : "📝 임시저장"}
                  </span>
                </div>

                {/* 언어 */}
                <div className={styles.colLocale}>
                  {post.locale.toUpperCase()}
                </div>

                {/* 조회수 */}
                <div className={styles.colViews}>
                  {post.view_count ?? 0}
                </div>

                {/* 작성일 */}
                <div className={styles.colDate}>
                  {formatDate(post.created_at)}
                </div>

                {/* 액션 (임시저장이면 '이어서 작성', 발행됨이면 '수정' + '보기') */}
                <div className={styles.colAction}>
                  <div className={styles.actionGroup}>
                    {post.status === "draft" ? (
                      <Link
                        href={`/admin/posts/${post.id}/edit`}
                        className={styles.actionDraftBtn}
                        title="임시저장 글 불러와서 계속 작성"
                      >
                        ✏️ 이어서 작성
                      </Link>
                    ) : (
                      <>
                        <Link
                          href={`/admin/posts/${post.id}/edit`}
                          className={styles.actionEditBtn}
                          title="글 내용 수정"
                        >
                          ✏️ 수정
                        </Link>
                        <Link
                          href={`/${post.locale}/blog/${post.slug}`}
                          target="_blank"
                          className={styles.actionBtn}
                          title="블로그에서 실제 글 보기"
                        >
                          🌐 보기
                        </Link>
                      </>
                    )}
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
