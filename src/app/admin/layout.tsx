// app/admin/layout.tsx
// 어드민 공통 레이아웃: 사이드바 + 메인 콘텐츠
// 주의: 어드민 페이지는 /ko, /en 같은 locale 없이 /admin 경로 사용

import type { Metadata } from "next";
import Link from "next/link";
import { headers } from "next/headers";
import styles from "./layout.module.css";

export const metadata: Metadata = {
  title: {
    template: "%s | 방장 블로그 관리자",
    default: "관리자 대시보드",
  },
  // 검색 엔진에 어드민 페이지가 노출되지 않도록 설정
  robots: { index: false, follow: false },
};

interface AdminLayoutProps {
  children: React.ReactNode;
}

export default async function AdminLayout({ children }: AdminLayoutProps) {
  // 현재 경로를 읽어서 활성 메뉴 표시에 사용
  const headersList = await headers();
  const pathname = headersList.get("x-pathname") ?? "";

  // 어드민 사이드바 메뉴 목록
  const menuItems = [
    { href: "/admin/dashboard", label: "📊 대시보드", icon: "📊" },
    { href: "/admin/posts/new", label: "✍️ 글 작성", icon: "✍️" },
    { href: "/admin/posts", label: "📋 글 목록", icon: "📋" },
    { href: "/admin/newsletter", label: "📬 뉴스레터", icon: "📬" },
  ];

  return (
    <div className={styles.adminLayout}>
      {/* ─── 어드민 사이드바 ─── */}
      <aside className={styles.sidebar}>
        {/* 로고 */}
        <div className={styles.sidebarLogo}>
          <Link href="/admin/dashboard" className={styles.logoLink}>
            <span className={styles.logoIcon}>⚡</span>
            <span className={styles.logoText}>관리자</span>
          </Link>
        </div>

        {/* 메뉴 */}
        <nav className={styles.sidebarNav}>
          {menuItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={`${styles.menuItem} ${pathname.startsWith(item.href) ? styles.menuItemActive : ""}`}
            >
              <span className={styles.menuIcon}>{item.icon}</span>
              <span>{item.label.replace(item.icon + " ", "")}</span>
            </Link>
          ))}
        </nav>

        {/* 하단: 블로그로 돌아가기 */}
        <div className={styles.sidebarFooter}>
          <Link href="/ko" className={styles.backToSite}>
            ← 사이트로 돌아가기
          </Link>
        </div>
      </aside>

      {/* ─── 메인 콘텐츠 영역 ─── */}
      <main className={styles.main}>
        {children}
      </main>
    </div>
  );
}
