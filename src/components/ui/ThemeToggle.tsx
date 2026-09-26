"use client";
// ThemeToggle 컴포넌트: 다크/라이트 모드 전환 버튼
// "use client" 필수 - 브라우저의 localStorage와 DOM에 접근하기 때문

import { useEffect, useState } from "react";
import styles from "./ThemeToggle.module.css";

export default function ThemeToggle() {
  // 현재 테마 상태: "light" 또는 "dark"
  const [theme, setTheme] = useState<"light" | "dark">("light");
  // 컴포넌트가 클라이언트에서 마운트되었는지 확인 (SSR 불일치 방지)
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    // 컴포넌트 마운트 시 저장된 테마 불러오기
    const saved = localStorage.getItem("theme") as "light" | "dark" | null;
    // 저장값 없으면 시스템 다크모드 감지
    const preferred = window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
    const initial = saved ?? preferred;
    setTheme(initial);
    // HTML 태그에 data-theme 속성 적용 (CSS 변수 전환용)
    document.documentElement.setAttribute("data-theme", initial);
    setMounted(true);
  }, []);

  // 테마 전환 함수
  const toggleTheme = () => {
    const next = theme === "light" ? "dark" : "light";
    setTheme(next);
    // localStorage에 저장 (새로고침해도 유지)
    localStorage.setItem("theme", next);
    // HTML 태그에 data-theme 속성 업데이트
    document.documentElement.setAttribute("data-theme", next);
  };

  // 마운트 전에는 아무것도 렌더링하지 않음 (SSR 깜빡임 방지)
  if (!mounted) return null;

  return (
    <button
      className={styles.toggle}
      onClick={toggleTheme}
      aria-label={theme === "light" ? "다크 모드로 전환" : "라이트 모드로 전환"}
      title={theme === "light" ? "다크 모드" : "라이트 모드"}
    >
      {/* 현재 테마에 따라 아이콘 표시 */}
      {theme === "light" ? (
        // 달 아이콘 (다크모드로 전환)
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
        </svg>
      ) : (
        // 태양 아이콘 (라이트모드로 전환)
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <circle cx="12" cy="12" r="5" />
          <line x1="12" y1="1" x2="12" y2="3" />
          <line x1="12" y1="21" x2="12" y2="23" />
          <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
          <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
          <line x1="1" y1="12" x2="3" y2="12" />
          <line x1="21" y1="12" x2="23" y2="12" />
          <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" />
          <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
        </svg>
      )}
    </button>
  );
}
