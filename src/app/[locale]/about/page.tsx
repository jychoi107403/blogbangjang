// app/[locale]/about/page.tsx
// 블로그 소개 페이지
// ★ 구글 애드센스 승인 필수 페이지
// 운영자 정보, 블로그 목적, 기술 스택, 연락처를 표시합니다

import type { Metadata } from "next";
import styles from "./page.module.css";

// 페이지 Props 타입
interface AboutPageProps {
  params: Promise<{ locale: string }>;
}

// SEO 메타데이터
export async function generateMetadata({
  params,
}: AboutPageProps): Promise<Metadata> {
  const { locale } = await params;
  return {
    title: locale === "ko" ? "소개" : "About",
    description:
      locale === "ko"
        ? "방장 블로그를 운영하는 방장에 대해 소개합니다. 블로그의 목적, 기술 스택, 연락처 정보를 확인하세요."
        : "Learn about Bangjang Blog. Discover the purpose, tech stack, and contact information.",
    alternates: {
      canonical: `https://bangjang.net/${locale}/about`,
      languages: {
        ko: "https://bangjang.net/ko/about",
        en: "https://bangjang.net/en/about",
        "x-default": "https://bangjang.net/ko/about",
      },
    },
  };
}

export default async function AboutPage({ params }: AboutPageProps) {
  const { locale } = await params;

  return (
    <div className={styles.page}>
      <div className="container">
        {/* ═══════════════════════════ */}
        {/* 페이지 헤더 */}
        {/* ═══════════════════════════ */}
        <header className={styles.header}>
          <h1 className={styles.title}>
            {locale === "ko" ? "소개" : "About"}
          </h1>
          <p className={styles.subtitle}>
            {locale === "ko"
              ? "안녕하세요! 방장 블로그를 운영하는 방장입니다. 개발과 배움의 과정을 기록하고 공유하고 있습니다."
              : "Hi! I'm Bangjang, the creator of this blog. I document and share my journey of development and learning."}
          </p>
        </header>

        {/* ═══════════════════════════ */}
        {/* 프로필 카드 */}
        {/* ═══════════════════════════ */}
        <div className={styles.profileCard}>
          <div className={styles.profileHeader}>
            {/* 아바타 */}
            <div className={styles.avatar}>👨‍💻</div>
            <div className={styles.profileInfo}>
              <h2>{locale === "ko" ? "방장" : "Bangjang"}</h2>
              <p>
                {locale === "ko"
                  ? "웹 개발자 & 블로거"
                  : "Web Developer & Blogger"}
              </p>
            </div>
          </div>

          {/* 자기소개 */}
          <div className={styles.profileBio}>
            {locale === "ko" ? (
              <>
                <p>
                  안녕하세요, 저는 비전공자로 시작하여 독학으로 웹 개발을 배우고
                  있는 직장인입니다. 이 블로그는 제가 개발을 배워가면서 경험한
                  것들을 솔직하게 기록하기 위해 만들었습니다.
                </p>
                <p>
                  Next.js, TypeScript, Supabase 등 최신 웹 기술을 활용하여 이
                  블로그를 직접 설계하고 구축했습니다. 코딩뿐만 아니라 AI 도구
                  활용, 업무 자동화, 생산성 향상 등 직장인에게 실질적으로 도움이
                  되는 콘텐츠를 공유하고 있습니다.
                </p>
                <p>
                  &quot;완벽하지 않아도 괜찮다. 어제보다 한 줄이라도 더 이해하면
                  충분하다.&quot; — 이것이 제 코딩 철학입니다. 여러분도 함께
                  성장해 나갔으면 좋겠습니다.
                </p>
              </>
            ) : (
              <>
                <p>
                  Hi, I&apos;m a self-taught web developer who started from a
                  non-technical background. I created this blog to honestly
                  document my journey of learning web development.
                </p>
                <p>
                  This blog is designed and built from scratch using modern web
                  technologies like Next.js, TypeScript, and Supabase. I share
                  content about coding, AI tools, workflow automation, and
                  productivity tips for office workers.
                </p>
                <p>
                  &quot;It&apos;s okay not to be perfect. Understanding one more
                  line than yesterday is enough.&quot; — This is my coding
                  philosophy. I hope we can grow together.
                </p>
              </>
            )}
          </div>
        </div>

        {/* ═══════════════════════════ */}
        {/* 정보 그리드 */}
        {/* ═══════════════════════════ */}
        <div className={styles.infoGrid}>
          {/* 기술 스택 카드 */}
          <div className={styles.infoCard}>
            <h3>
              🛠️{" "}
              {locale === "ko"
                ? "블로그 기술 스택"
                : "Blog Tech Stack"}
            </h3>
            <div className={styles.tagList}>
              <span className={styles.tag}>Next.js 15</span>
              <span className={styles.tag}>TypeScript</span>
              <span className={styles.tag}>React 19</span>
              <span className={styles.tag}>Supabase</span>
              <span className={styles.tag}>Vercel</span>
              <span className={styles.tag}>CSS Modules</span>
              <span className={styles.tag}>next-intl</span>
            </div>
          </div>

          {/* 블로그 주제 카드 */}
          <div className={styles.infoCard}>
            <h3>
              📚{" "}
              {locale === "ko"
                ? "주요 콘텐츠"
                : "Main Topics"}
            </h3>
            <div className={styles.tagList}>
              <span className={styles.tag}>
                {locale === "ko" ? "웹 개발" : "Web Dev"}
              </span>
              <span className={styles.tag}>
                {locale === "ko" ? "AI 활용" : "AI Tools"}
              </span>
              <span className={styles.tag}>
                {locale === "ko" ? "도구 리뷰" : "Tool Reviews"}
              </span>
              <span className={styles.tag}>
                {locale === "ko" ? "생산성" : "Productivity"}
              </span>
              <span className={styles.tag}>
                {locale === "ko" ? "코딩 입문" : "Coding Basics"}
              </span>
            </div>
          </div>

          {/* 연락처 카드 */}
          <div className={styles.infoCard}>
            <h3>
              📬{" "}
              {locale === "ko" ? "연락처" : "Contact"}
            </h3>
            <div className={styles.contactList}>
              <div className={styles.contactItem}>
                <span>✉️</span>
                <a href="mailto:blog@bangjang.net">blog@bangjang.net</a>
              </div>
              <div className={styles.contactItem}>
                <span>🌐</span>
                <a
                  href="https://bangjang.net"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  bangjang.net
                </a>
              </div>
            </div>
          </div>

          {/* 저작권 안내 카드 */}
          <div className={styles.infoCard}>
            <h3>
              ©️{" "}
              {locale === "ko" ? "저작권 안내" : "Copyright"}
            </h3>
            <div className={styles.profileBio}>
              <p>
                {locale === "ko"
                  ? "이 블로그의 모든 글과 이미지는 저작권법에 의해 보호됩니다. 개인적인 학습 목적의 인용은 출처를 밝혀주시면 환영합니다. 상업적 이용은 사전 동의가 필요합니다."
                  : "All content and images on this blog are protected by copyright law. Quotations for personal learning purposes are welcome with proper attribution. Commercial use requires prior consent."}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
