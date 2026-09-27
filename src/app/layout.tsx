// app/layout.tsx
// 최상위 레이아웃: HTML 기본 구조, SEO 메타태그, 검색엔진 인증 및 외부 스크립트 설정
// 실제 페이지 콘텐츠 레이아웃은 app/[locale]/layout.tsx에서 처리

import type { Metadata } from "next";
import "./globals.css";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://bangjang.net";
// 네이버 서치어드바이저 웹마스터도구 소유권 인증 키
const NAVER_VERIFICATION = process.env.NEXT_PUBLIC_NAVER_SITE_VERIFICATION || "da92228f4c7114128a2f9e9beaa474d7021db914";
const GOOGLE_VERIFICATION = process.env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION || "";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    template: "%s | 방장 블로그",
    default: "방장 블로그 — 개발, 기술, 그리고 배움의 기록",
  },
  description: "개발, 기술, 그리고 배움의 기록. Next.js, TypeScript, 웹 개발, AI 활용 등 다양한 주제의 글을 공유합니다.",
  keywords: ["방장 블로그", "웹 개발", "Next.js", "TypeScript", "React", "AI 활용", "개발자 블로그"],
  authors: [{ name: "방장" }],
  creator: "방장",
  publisher: "방장 블로그",
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  // Open Graph (네이버 및 카카오톡, 페이스북 링크 미리보기)
  openGraph: {
    type: "website",
    locale: "ko_KR",
    url: SITE_URL,
    siteName: "방장 블로그",
    title: "방장 블로그 — 개발, 기술, 그리고 배움의 기록",
    description: "개발, 기술, 그리고 배움의 기록. Next.js, TypeScript, 웹 개발, AI 활용 등 다양한 주제의 글을 공유합니다.",
  },
  // 트위터 카드
  twitter: {
    card: "summary_large_image",
    title: "방장 블로그",
    description: "개발, 기술, 그리고 배움의 기록",
  },
  // 사이트맵 및 RSS 피드 링크
  alternates: {
    canonical: SITE_URL,
    types: {
      "application/rss+xml": `${SITE_URL}/rss.xml`,
    },
  },
  // 검색엔진 및 외부 서비스 소유권 인증 태그
  other: {
    "google-adsense-account": "ca-pub-1774804957511077",
    "naver-site-verification": NAVER_VERIFICATION,
    ...(GOOGLE_VERIFICATION ? { "google-site-verification": GOOGLE_VERIFICATION } : {}),
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    // suppressHydrationWarning: 다크모드 초기화 시 발생하는 hydration 경고 억제
    <html lang="ko" suppressHydrationWarning>
      <head>
        {/* 구글 애드센스 공식 메타태그 */}
        <meta name="google-adsense-account" content="ca-pub-1774804957511077" />

        {/* 네이버 서치어드바이저 소유권 확인 공식 메타태그 */}
        <meta name="naver-site-verification" content={NAVER_VERIFICATION} />

        {/* 구글 서치콘솔 소유권 확인 메타태그 */}
        {GOOGLE_VERIFICATION && (
          <meta name="google-site-verification" content={GOOGLE_VERIFICATION} />
        )}

        {/* RSS 피드 자동 검색 링크 */}
        <link
          rel="alternate"
          type="application/rss+xml"
          title="방장 블로그 RSS Feed"
          href="/rss.xml"
        />

        {/* 구글 애드센스 공식 광고 스크립트 */}
        <script
          async
          src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1774804957511077"
          crossOrigin="anonymous"
        />

        {/* 구글 애널리틱스 4 (GA4) */}
        <script
          async
          src="https://www.googletagmanager.com/gtag/js?id=G-09EQ8TWS60"
        />
        <script
          dangerouslySetInnerHTML={{
            __html: `
              window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());
              gtag('config', 'G-09EQ8TWS60');
            `,
          }}
        />

        {/* 
          다크모드 깜빡임 방지 스크립트 (인라인)
          페이지 렌더링 전에 실행되어 올바른 테마를 즉시 적용
        */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                try {
                  var saved = localStorage.getItem('theme');
                  var preferred = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
                  document.documentElement.setAttribute('data-theme', saved || preferred);
                } catch(e) {}
              })();
            `,
          }}
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
