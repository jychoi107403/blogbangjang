// app/[locale]/layout.tsx
// 언어별 공통 레이아웃: Header + Footer를 모든 페이지에 공통으로 감싸는 역할
// next-intl의 NextIntlClientProvider로 클라이언트 컴포넌트에도 번역 제공
// 구글 서치콘솔 중복 페이지 방지를 위한 동적 Canonical 및 hreflang 메타데이터 탑재

import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { NextIntlClientProvider, hasLocale } from "next-intl";
import { getMessages } from "next-intl/server";
import { routing } from "@/i18n/routing";
import Header from "@/components/layout/Header";
import Footer from "@/components/layout/Footer";

// 레이아웃 Props 타입 정의
interface LocaleLayoutProps {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
}

// 언어별 동적 SEO 메타데이터 (Canonical 및 다국어 hreflang 지정)
export async function generateMetadata({ params }: LocaleLayoutProps): Promise<Metadata> {
  const { locale } = await params;
  const isKo = locale === "ko";

  return {
    title: {
      // 각 페이지 제목 뒤에 블로그 이름 추가 (예: "Next.js 배우기 | 방장 블로그")
      template: isKo ? "%s | 방장 블로그" : "%s | Bangjang Blog",
      default: isKo ? "방장 블로그 — 개발, 기술, 그리고 배움의 기록" : "Bangjang Blog — Tech & Learning",
    },
    description: isKo
      ? "개발, 기술, 그리고 배움의 기록. Next.js, TypeScript, 웹 개발 등 다양한 주제의 글을 공유합니다."
      : "Records of development, technology, and learning. Sharing articles on Next.js, TypeScript, and web development.",
    keywords: ["방장 블로그", "웹 개발", "Next.js", "TypeScript", "React", "AI 활용"],
    authors: [{ name: "방장" }],
    // 구글 검색로봇이 중복 페이지로 보지 않도록 정확한 대표 URL(Canonical)과 언어별 대체 URL 명시
    alternates: {
      canonical: `https://bangjang.net/${locale}`,
      languages: {
        "ko": "https://bangjang.net/ko",
        "en": "https://bangjang.net/en",
        "x-default": "https://bangjang.net/ko",
      },
    },
    openGraph: {
      type: "website",
      locale: isKo ? "ko_KR" : "en_US",
      siteName: "방장 블로그",
    },
    other: {
      "google-adsense-account": "ca-pub-1774804957511077",
    },
  };
}

// 지원 언어 목록에서 정적 경로 생성 (빌드 최적화)
export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({
  children,
  params,
}: LocaleLayoutProps) {
  // URL에서 locale 파라미터 추출 (예: /ko/blog → "ko")
  const { locale } = await params;

  // 지원하지 않는 언어 코드면 404 처리
  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }

  // 서버에서 현재 언어의 번역 메시지 로드
  const messages = await getMessages();

  return (
    // NextIntlClientProvider: 클라이언트 컴포넌트에서도 useTranslations() 사용 가능하게 함
    <NextIntlClientProvider locale={locale} messages={messages}>
      {/* 전체 페이지 구조: Header → 본문 → Footer */}
      <Header />
      <main className="main-content">
        {children}
      </main>
      <Footer />
    </NextIntlClientProvider>
  );
}
