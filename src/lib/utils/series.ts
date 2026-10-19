// lib/utils/series.ts
// 시리즈 관련 데이터 조회 함수들
// Supabase에서 시리즈 데이터를 가져오는 서버 사이드 함수들

import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────
// 1. 전체 시리즈 목록 조회 (글 수 포함)
// ─────────────────────────────────────────────
export async function getAllSeries(locale: string = "ko") {
  const supabase = await createClient();

  // series 테이블에는 thumbnail_url이 없으므로 기본 필드만 조회
  const { data: seriesList, error } = await supabase
    .from("series")
    .select(`
      id,
      title,
      slug,
      description,
      created_at,
      posts ( id )
    `)
    .eq("posts.status", "published") // 발행된 글만 카운트
    .eq("posts.locale", locale)      // 해당 언어의 글만 카운트
    .order("created_at", { ascending: false });

  if (error) {
    console.error("[getAllSeries] Error:", error.message);
    return [];
  }

  // posts 배열의 길이를 post_count로 변환
  return (seriesList ?? []).map((series) => ({
    id: series.id,
    title: series.title,
    slug: series.slug,
    description: series.description,
    // DB에 컬럼이 없으므로 public/series/<슬러그>.webp 이미지를 사용 (압축본, 약 10~20KB)
    thumbnail_url: `/series/${series.slug}.webp` as string | null,
    created_at: series.created_at,
    post_count: Array.isArray(series.posts) ? series.posts.length : 0,
  }));
}

// ─────────────────────────────────────────────
// 2. 슬러그로 시리즈 상세 조회
// ─────────────────────────────────────────────
export async function getSeriesBySlug(slug: string) {
  const supabase = await createClient();

  // thumbnail_url은 DB에 없으므로 기본 필드만 조회
  const { data: series, error } = await supabase
    .from("series")
    .select("id, title, slug, description, created_at")
    .eq("slug", slug)
    .single();

  if (error) {
    console.error("[getSeriesBySlug] Error:", error.message);
    return null;
  }

  return series
    ? { ...series, thumbnail_url: `/series/${series.slug}.webp` as string | null }
    : null;
}
