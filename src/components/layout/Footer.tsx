"use client";
// Footer 컴포넌트: 블로그 하단 영역
// 뉴스레터 구독 폼과 블로그 정보 포함

import { useState } from "react";
import Link from "next/link";
import { useLocale, useTranslations } from "next-intl";
import styles from "./Footer.module.css";

export default function Footer() {
  const locale = useLocale();
  const tHome = useTranslations("home.newsletter");
  const tNav = useTranslations("nav");

  // 뉴스레터 이메일 입력값
  const [email, setEmail] = useState("");
  // 구독 처리 상태: idle | loading | success | error
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle");
  // 서버 피드백 메시지
  const [feedbackMsg, setFeedbackMsg] = useState("");

  // 뉴스레터 구독 제출 함수
  const handleSubscribe = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim()) return;

    setStatus("loading");
    setFeedbackMsg("");
    try {
      // /api/newsletter 엔드포인트로 POST 요청
      const res = await fetch("/api/newsletter", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });

      const data = await res.json().catch(() => null);

      if (res.ok) {
        setStatus("success");
        setFeedbackMsg(data?.message || tHome("success"));
        setEmail(""); // 입력 초기화
      } else {
        setStatus("error");
        setFeedbackMsg(data?.error || tHome("error"));
      }
    } catch {
      setStatus("error");
      setFeedbackMsg(tHome("error"));
    }

    // 4초 후 상태 초기화
    setTimeout(() => setStatus("idle"), 4000);
  };

  const currentYear = new Date().getFullYear();

  return (
    <footer className={styles.footer} role="contentinfo">
      <div className={`container ${styles.inner}`}>
        {/* ─── 상단: 뉴스레터 구독 폼 ─── */}
        <div className={styles.newsletter}>
          <div className={styles.newsletterText}>
            <h2 className={styles.newsletterTitle}>{tHome("title")}</h2>
            <p className={styles.newsletterDesc}>{tHome("description")}</p>
          </div>

          <form
            className={styles.newsletterForm}
            onSubmit={handleSubscribe}
            noValidate
          >
            <input
              type="email"
              id="newsletter-email"
              className={styles.emailInput}
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder={tHome("placeholder")}
              aria-label={tHome("placeholder")}
              disabled={status === "loading" || status === "success"}
              required
            />
            <button
              type="submit"
              className={`btn-primary ${styles.subscribeBtn}`}
              disabled={status === "loading" || status === "success"}
              aria-live="polite"
            >
              {/* 상태에 따라 버튼 텍스트 변경 */}
              {status === "loading" ? (
                <span className={`${styles.spinner} animate-spin`} aria-hidden="true" />
              ) : (
                tHome("button")
              )}
            </button>
          </form>

          {/* 구독 성공/실패 메시지 */}
          {status === "success" && (
            <p className={styles.successMsg} role="alert">
              ✅ {feedbackMsg || tHome("success")}
            </p>
          )}
          {status === "error" && (
            <p className={styles.errorMsg} role="alert">
              ❌ {feedbackMsg || tHome("error")}
            </p>
          )}
        </div>

        {/* ─── 구분선 ─── */}
        <hr className={styles.divider} />

        {/* ─── 하단: 로고 + 링크 + 저작권 ─── */}
        <div className={styles.bottom}>
          {/* 로고 + 소개 */}
          <div className={styles.brand}>
            <Link href={`/${locale}`} className={styles.brandLogo}>
              <span className={styles.brandIcon} aria-hidden="true">✦</span>
              <span>방장 블로그</span>
            </Link>
            <p className={styles.brandDesc}>개발, 기술, 그리고 배움의 기록</p>
          </div>

          {/* 하단 네비게이션 링크 */}
          <nav className={styles.footerNav} aria-label="푸터 네비게이션">
            <Link href={`/${locale}/blog`} className={styles.footerLink}>
              {tNav("blog")}
            </Link>
            <Link href={`/${locale}/series`} className={styles.footerLink}>
              {tNav("series")}
            </Link>
            <Link href={`/${locale}/search`} className={styles.footerLink}>
              {tNav("search")}
            </Link>
            <Link href={`/${locale}/privacy`} className={styles.footerLink}>
              {tNav("privacy")}
            </Link>
            <Link href={`/${locale}/terms`} className={styles.footerLink}>
              {tNav("terms")}
            </Link>
          </nav>

          {/* 저작권 */}
          <p className={styles.copyright}>
            © {currentYear} 방장. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
