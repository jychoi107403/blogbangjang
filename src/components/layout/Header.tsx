"use client";
// Header 컴포넌트: 블로그 상단 네비게이션 바
// "use client" - 모바일 메뉴 상태, 언어 전환, 스크롤 감지 등 인터랙션 처리

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useLocale, useTranslations } from "next-intl";
import ThemeToggle from "@/components/ui/ThemeToggle";
import styles from "./Header.module.css";

export default function Header() {
  // 현재 URL 경로 (네비게이션 활성 상태 표시용)
  const pathname = usePathname();
  const router = useRouter();
  // 현재 언어 코드 ('ko' 또는 'en')
  const locale = useLocale();
  // 다국어 번역 함수
  const t = useTranslations("nav");

  // 모바일 메뉴 열림/닫힘 상태
  const [menuOpen, setMenuOpen] = useState(false);
  // 스크롤 시 헤더 배경 변경 상태
  const [scrolled, setScrolled] = useState(false);

  // 스크롤 감지: 50px 이상 스크롤하면 배경 적용
  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 50);
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // 라우트 변경 시 모바일 메뉴 닫기
  useEffect(() => {
    setMenuOpen(false);
  }, [pathname]);

  // 언어 전환 함수: 현재 경로에서 언어 코드만 교체
  const switchLanguage = () => {
    const nextLocale = locale === "ko" ? "en" : "ko";
    let purePath = pathname;
    if (purePath.startsWith(`/${locale}/`)) {
      purePath = purePath.slice(locale.length + 1);
    } else if (purePath === `/${locale}`) {
      purePath = "";
    }
    const cleanPath = purePath.startsWith("/") ? purePath : `/${purePath}`;
    router.push(`/${nextLocale}${cleanPath === "/" ? "" : cleanPath}`);
  };

  // 네비게이션 메뉴 항목 정의
  const navItems = [
    { href: `/${locale}`, label: t("home") },
    { href: `/${locale}/blog`, label: t("blog") },
    { href: `/${locale}/series`, label: t("series") },
    { href: `/${locale}/search`, label: t("search") },
  ];

  // 현재 경로가 해당 메뉴 항목에 해당하는지 확인
  const isActive = (href: string) => {
    if (href === `/${locale}`) return pathname === href;
    return pathname.startsWith(href);
  };

  return (
    <header
      className={`${styles.header} ${scrolled ? styles.scrolled : ""}`}
      role="banner"
    >
      <div className={`container ${styles.inner}`}>
        {/* ─── 로고 ─── */}
        <Link href={`/${locale}`} className={styles.logo} aria-label="방장 블로그 홈">
          {/* 그라디언트 아이콘 */}
          <span className={styles.logoIcon} aria-hidden="true">✦</span>
          <span className={styles.logoText}>방장</span>
        </Link>

        {/* ─── 데스크탑 네비게이션 ─── */}
        <nav className={styles.nav} aria-label="주 네비게이션">
          <ul className={styles.navList}>
            {navItems.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={`${styles.navLink} ${isActive(item.href) ? styles.navLinkActive : ""}`}
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        {/* ─── 우측 액션 버튼들 ─── */}
        <div className={styles.actions}>
          {/* 언어 전환 버튼 */}
          <button
            className={styles.langBtn}
            onClick={switchLanguage}
            aria-label={`언어 전환: ${locale === "ko" ? "영어" : "한국어"}`}
            title={locale === "ko" ? "Switch to English" : "한국어로 전환"}
          >
            {locale === "ko" ? "EN" : "KO"}
          </button>

          {/* 다크모드 토글 */}
          <ThemeToggle />

          {/* 모바일 햄버거 버튼 */}
          <button
            className={`${styles.hamburger} ${menuOpen ? styles.hamburgerOpen : ""}`}
            onClick={() => setMenuOpen(!menuOpen)}
            aria-label={menuOpen ? "메뉴 닫기" : "메뉴 열기"}
            aria-expanded={menuOpen}
            aria-controls="mobile-menu"
          >
            <span className={styles.hamburgerLine} />
            <span className={styles.hamburgerLine} />
            <span className={styles.hamburgerLine} />
          </button>
        </div>
      </div>

      {/* ─── 모바일 드롭다운 메뉴 ─── */}
      <div
        id="mobile-menu"
        className={`${styles.mobileMenu} ${menuOpen ? styles.mobileMenuOpen : ""}`}
        aria-hidden={!menuOpen}
      >
        <nav aria-label="모바일 네비게이션">
          <ul className={styles.mobileNavList}>
            {navItems.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={`${styles.mobileNavLink} ${isActive(item.href) ? styles.mobileNavLinkActive : ""}`}
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
}
