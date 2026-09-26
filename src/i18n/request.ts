import { getRequestConfig } from "next-intl/server";
import { routing } from "./routing";

export default getRequestConfig(async ({ requestLocale }) => {
  // 현재 요청의 언어 코드 가져오기
  let locale = await requestLocale;

  // 지원하지 않는 언어는 기본(한국어)으로 대체
  if (!locale || !routing.locales.includes(locale as "ko" | "en")) {
    locale = routing.defaultLocale;
  }

  return {
    locale,
    // 해당 언어의 메시지 JSON 동적 로드
    messages: (await import(`../../messages/${locale}.json`)).default,
  };
});
