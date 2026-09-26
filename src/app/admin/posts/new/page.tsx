"use client"; // 에디터 상태 관리가 필요하므로 클라이언트 컴포넌트

// app/admin/posts/new/page.tsx
// 새 글 작성 페이지 (어드민)
// TipTap 에디터 + 메타 정보 입력 폼

import { useState } from "react";
import { useRouter } from "next/navigation";
import TipTapEditor from "@/components/editor/TipTapEditor";
import styles from "./page.module.css";

// 슬러그 자동 생성 함수 (제목 → URL 슬러그)
function generateSlug(title: string): string {
  return title
    .toLowerCase()
    .trim()
    .replace(/[^\w\s가-힣]/g, "") // 특수문자 제거
    .replace(/\s+/g, "-")         // 공백 → 하이픈
    .replace(/-+/g, "-")           // 연속 하이픈 → 단일 하이픈
    .slice(0, 80);                 // 최대 80자
}

export default function NewPostPage() {
  const router = useRouter();

  // 폼 상태 관리
  const [formData, setFormData] = useState({
    title: "",
    slug: "",
    excerpt: "",
    content: "",
    locale: "ko",
    status: "draft" as "draft" | "published",
    thumbnail_url: "",
    category_id: "",
    series_id: "",
  });

  // 저장 중 상태
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // 제목 변경 시 슬러그 자동 생성
  const handleTitleChange = (title: string) => {
    setFormData((prev) => ({
      ...prev,
      title,
      // 슬러그가 비어있거나 자동 생성된 상태일 때만 자동 업데이트
      slug: prev.slug === generateSlug(prev.title) || prev.slug === ""
        ? generateSlug(title)
        : prev.slug,
    }));
  };

  // 글 저장 (Supabase API 호출)
  const handleSave = async (status: "draft" | "published") => {
    if (!formData.title.trim()) {
      setError("제목을 입력해주세요.");
      return;
    }
    if (!formData.slug.trim()) {
      setError("슬러그를 입력해주세요.");
      return;
    }
    if (!formData.content || formData.content === "<p></p>") {
      setError("본문 내용을 입력해주세요.");
      return;
    }

    setIsSaving(true);
    setError(null);

    try {
      const response = await fetch("/api/admin/posts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...formData,
          status,
          published_at: status === "published" ? new Date().toISOString() : null,
        }),
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.error ?? "글 저장에 실패했습니다.");
      }

      // 저장 성공 시 대시보드로 이동
      router.push("/admin/dashboard");
    } catch (err) {
      setError(err instanceof Error ? err.message : "알 수 없는 오류가 발생했습니다.");
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className={styles.page}>
      {/* 페이지 헤더 */}
      <div className={styles.header}>
        <h1 className={styles.title}>✍️ 새 글 작성</h1>

        {/* 액션 버튼 그룹 */}
        <div className={styles.actions}>
          <button
            type="button"
            onClick={() => handleSave("draft")}
            className={styles.draftBtn}
            disabled={isSaving}
          >
            {isSaving ? "저장 중..." : "💾 임시저장"}
          </button>
          <button
            type="button"
            onClick={() => handleSave("published")}
            className="btn-primary"
            disabled={isSaving}
          >
            {isSaving ? "저장 중..." : "🚀 발행하기"}
          </button>
        </div>
      </div>

      {/* 오류 메시지 */}
      {error && (
        <div className={styles.errorMsg} role="alert">
          ⚠️ {error}
        </div>
      )}

      {/* 2열 레이아웃: 메인(에디터) + 우측(메타) */}
      <div className={styles.layout}>
        {/* ─── 왼쪽: 제목 + 에디터 ─── */}
        <div className={styles.editorSection}>
          {/* 제목 입력 */}
          <input
            id="post-title"
            type="text"
            value={formData.title}
            onChange={(e) => handleTitleChange(e.target.value)}
            placeholder="제목을 입력하세요"
            className={styles.titleInput}
            maxLength={200}
          />

          {/* 요약 입력 */}
          <textarea
            id="post-excerpt"
            value={formData.excerpt}
            onChange={(e) => setFormData((p) => ({ ...p, excerpt: e.target.value }))}
            placeholder="글 요약 (목록 페이지에 표시됩니다)"
            className={styles.excerptInput}
            maxLength={300}
            rows={2}
          />

          {/* TipTap 에디터 */}
          <TipTapEditor
            content={formData.content}
            onChange={(html) => setFormData((p) => ({ ...p, content: html }))}
            placeholder="여기에 글을 작성하세요..."
          />
        </div>

        {/* ─── 오른쪽: 메타 정보 패널 ─── */}
        <aside className={styles.metaPanel}>
          {/* 슬러그 */}
          <div className={styles.metaGroup}>
            <label htmlFor="post-slug" className={styles.metaLabel}>
              🔗 슬러그 (URL)
            </label>
            <input
              id="post-slug"
              type="text"
              value={formData.slug}
              onChange={(e) => setFormData((p) => ({ ...p, slug: e.target.value }))}
              placeholder="my-post-url"
              className={styles.metaInput}
            />
            <span className={styles.metaHint}>
              /{formData.locale}/blog/<strong>{formData.slug || "슬러그"}</strong>
            </span>
          </div>

          {/* 언어 선택 */}
          <div className={styles.metaGroup}>
            <label htmlFor="post-locale" className={styles.metaLabel}>
              🌍 언어
            </label>
            <select
              id="post-locale"
              value={formData.locale}
              onChange={(e) => setFormData((p) => ({ ...p, locale: e.target.value }))}
              className={styles.metaSelect}
            >
              <option value="ko">🇰🇷 한국어</option>
              <option value="en">🇺🇸 English</option>
            </select>
          </div>

          {/* 썸네일 URL */}
          <div className={styles.metaGroup}>
            <label htmlFor="post-thumbnail" className={styles.metaLabel}>
              🖼️ 썸네일 URL
            </label>
            <input
              id="post-thumbnail"
              type="url"
              value={formData.thumbnail_url}
              onChange={(e) => setFormData((p) => ({ ...p, thumbnail_url: e.target.value }))}
              placeholder="https://..."
              className={styles.metaInput}
            />
          </div>

          {/* 상태 안내 */}
          <div className={styles.statusInfo}>
            <span className={styles.statusLabel}>현재 상태:</span>
            <span className={`${styles.statusBadge} ${formData.status === "published" ? styles.statusPublished : styles.statusDraft}`}>
              {formData.status === "published" ? "✅ 발행됨" : "📝 임시저장"}
            </span>
          </div>
        </aside>
      </div>
    </div>
  );
}
