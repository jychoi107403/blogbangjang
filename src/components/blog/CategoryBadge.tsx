"use client";

// components/blog/CategoryBadge.tsx
// 카테고리를 작은 뱃지 형태로 보여주는 컴포넌트
// DB에 저장된 color 값을 실제 색상으로 적용
// ★ onClick 이벤트 핸들러 사용 → 클라이언트 컴포넌트 필수

import Link from "next/link";
import styles from "./CategoryBadge.module.css";

// CategoryBadge가 받는 props 타입 정의
interface CategoryBadgeProps {
  name: string;         // 카테고리 이름 (예: "개발")
  slug: string;         // URL 슬러그 (예: "development")
  color?: string | null; // DB에서 설정된 색상 코드 (예: "#FF6B6B", 없으면 기본색)
  locale: string;        // 현재 언어 코드
}

export default function CategoryBadge({
  name,
  slug,
  color,
  locale,
}: CategoryBadgeProps) {
  // color가 있으면 인라인 스타일로 적용, 없으면 기본 CSS 클래스 사용
  const style = color
    ? {
        // 배경색은 해당 색에 투명도 20% 적용 (hex + "33" = 20% 투명도)
        backgroundColor: `${color}33`,
        color: color,
        borderColor: `${color}66`,
      }
    : undefined;

  return (
    <Link
      href={`/${locale}/category/${slug}`}
      className={styles.badge}
      style={style} // 카테고리별 커스텀 색상 적용
      onClick={(e) => e.stopPropagation()} // 이벤트 버블링 방지
    >
      {name}
    </Link>
  );
}
