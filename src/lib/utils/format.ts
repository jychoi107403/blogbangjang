import { format, formatDistanceToNow } from "date-fns";
import { ko, enUS } from "date-fns/locale";

// 날짜를 읽기 좋은 형식으로 변환
// 예: 2024-01-15 → 2024년 1월 15일
export function formatDate(dateStr: string, locale: string = "ko"): string {
  const date = new Date(dateStr);
  const dateLocale = locale === "ko" ? ko : enUS;
  return format(date, "PPP", { locale: dateLocale });
}

// 상대 시간 표시 (예: "3일 전", "2 hours ago")
export function formatRelativeDate(dateStr: string, locale: string = "ko"): string {
  const date = new Date(dateStr);
  const dateLocale = locale === "ko" ? ko : enUS;
  return formatDistanceToNow(date, { addSuffix: true, locale: dateLocale });
}

// 숫자에 천 단위 콤마 추가 (예: 1234 → 1,234)
export function formatCount(count: number): string {
  return count.toLocaleString();
}

// 문자열을 URL 슬러그로 변환
// 예: "My First Post!" → "my-first-post"
export function toSlug(str: string): string {
  return str
    .toLowerCase()
    .replace(/[^a-z0-9가-힣\s-]/g, "")
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-")
    .trim();
}
