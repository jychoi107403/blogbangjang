import { defineRouting } from "next-intl/routing";

// 지원 언어 목록과 기본 언어 정의
export const routing = defineRouting({
  locales: ["ko", "en"],   // 한국어, 영어
  defaultLocale: "ko",     // 기본값: 한국어
  pathnames: {
    "/": "/",
    "/blog": "/blog",
    "/category": "/category",
    "/tag": "/tag",
    "/series": "/series",
    "/search": "/search",
  },
});
