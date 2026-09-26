"use client";

// components/blog/TagBadge.tsx
// 태그를 작은 뱃지 형태로 보여주는 컴포넌트
// 클릭 시 해당 태그의 글 목록 페이지로 이동
// ★ onClick 이벤트 핸들러 사용 → 클라이언트 컴포넌트 필수

import Link from "next/link";
import styles from "./TagBadge.module.css";

// TagBadge가 받는 props 타입 정의
interface TagBadgeProps {
  name: string;    // 태그 이름 (예: "Next.js")
  slug: string;    // URL 슬러그 (예: "nextjs")
  locale: string;  // 현재 언어 코드 (예: "ko")
}

export default function TagBadge({ name, slug, locale }: TagBadgeProps) {
  return (
    // 태그 클릭 시 해당 태그 페이지로 이동
    <Link
      href={`/${locale}/tag/${slug}`}
      className={styles.badge}
      // 이벤트 버블링 방지: PostCard 안에 있을 때 카드 클릭으로 이어지지 않게
      onClick={(e) => e.stopPropagation()}
    >
      # {name}
    </Link>
  );
}
