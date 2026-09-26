import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";

// 언어별 URL 자동 리다이렉트 미들웨어
// 예: /blog → /ko/blog (한국어 기본)
//     /en/blog → 영어 페이지
export default createMiddleware(routing);

export const config = {
  // 미들웨어가 적용될 경로 패턴
  // _next, api, public 파일, admin 페이지는 제외
  // admin은 locale 없이 /admin/... 경로로 접근하므로 제외
  matcher: ["/((?!_next|api|admin|favicon.ico|.*\\..*).*)"],
};
