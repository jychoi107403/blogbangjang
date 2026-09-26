// lib/utils/categories.ts
// 카테고리 관련 데이터 조회 함수들
// Supabase에서 카테고리 데이터를 가져오는 서버 사이드 함수들

import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────
// 1. 전체 카테고리 목록 조회 (글 수 포함)
// ─────────────────────────────────────────────
export async function getAllCategories(locale: string = "ko") {
  const supabase = await createClient();

  // 카테고리 목록을 가져오면서, 해당 카테고리의 발행된 글 수도 함께 계산
  const { data: categories, error } = await supabase
    .from("categories")
    .select(`
      id,
      name,
      slug,
      description,
      color,
      posts ( id )
    `)
    .eq("posts.status", "published")  // 발행된 글만 카운트
    .eq("posts.locale", locale)       // 해당 언어의 글만 카운트
    .order("name", { ascending: true });

  if (error) {
    console.error("[getAllCategories] Error:", error.message);
    return [];
  }

  // posts 배열의 길이를 post_count로 변환하여 반환
  return (categories ?? []).map((cat) => ({
    id: cat.id,
    name: cat.name,
    slug: cat.slug,
    description: cat.description as string | null,
    color: cat.color,
    post_count: Array.isArray(cat.posts) ? cat.posts.length : 0,
  }));
}

// ─────────────────────────────────────────────
// 2. 슬러그로 카테고리 상세 조회
// ─────────────────────────────────────────────
export async function getCategoryBySlug(slug: string) {
  const supabase = await createClient();

  const { data: category, error } = await supabase
    .from("categories")
    .select("id, name, slug, description, color")
    .eq("slug", slug)
    .single(); // 하나의 결과만 가져옴

  if (error) {
    console.error("[getCategoryBySlug] Error:", error.message);
    return null;
  }

  return category;
}
