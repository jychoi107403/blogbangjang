// app/layout.tsx
// 최상위 레이아웃: HTML 기본 구조만 설정
// 실제 페이지 레이아웃은 app/[locale]/layout.tsx에서 처리

import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "방장 블로그",
  description: "개발, 기술, 그리고 배움의 기록",
  // 구글 애드센스 소유권 인증 메타태그
  other: {
    "google-adsense-account": "ca-pub-1774804957511077",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    // suppressHydrationWarning: 다크모드 초기화 시 발생하는 hydration 경고 억제
    // (ThemeToggle이 클라이언트에서 data-theme을 설정하기 때문)
    <html lang="ko" suppressHydrationWarning>
      <head>
        {/* 구글 애드센스 인증 메타태그 */}
        <meta name="google-adsense-account" content="ca-pub-1774804957511077" />

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
