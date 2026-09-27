// app/robots.ts
// robots.txt 동적 생성
// ★ SEO 필수 파일 — 검색엔진 크롤러에게 사이트 탐색 규칙을 알려줍니다
// 관리자 페이지와 API 경로는 크롤링 차단합니다

import type { MetadataRoute } from "next";

// 사이트 기본 URL (bangjang.net 루트 도메인 기준)
const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://bangjang.net";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        // 모든 검색엔진 크롤러에게 적용
        userAgent: "*",
        // 허용할 경로: 전체 사이트
        allow: "/",
        // 차단할 경로: 관리자 페이지, API 엔드포인트
        disallow: ["/admin/", "/api/"],
      },
    ],
    // 사이트맵 위치 알려주기
    sitemap: `${SITE_URL}/sitemap.xml`,
  };
}
