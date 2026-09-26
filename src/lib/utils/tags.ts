// lib/utils/tags.ts
// 태그 관련 데이터 조회 함수들
// Supabase에서 태그 데이터를 가져오는 서버 사이드 함수들

import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────
// 1. 전체 태그 목록 조회 (글 수 포함)
// ─────────────────────────────────────────────
export async function getAllTags(locale: string = "ko") {
  const supabase = await createClient();

  // 태그 목록 조회 (post_tags 중간 테이블을 통해 글 수 파악)
  const { data: tags, error } = await supabase
    .from("tags")
    .select(`
      id,
      name,
      slug,
      post_tags (
        posts ( id, status, locale )
      )
    `)
    .order("name", { ascending: true });

  if (error) {
    console.error("[getAllTags] Error:", error.message);
    return [];
  }

  // 각 태그의 발행된 글 수를 계산하여 반환
  return (tags ?? [])
    .map((tag) => {
      // post_tags → posts 중에서 published + 해당 locale만 카운트
      // Supabase join은 배열을 반환하므로 any 타입으로 처리
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const publishedCount = tag.post_tags?.filter((pt: any) => {
        // posts가 배열이면 첫 번째 요소를, 단일 객체면 그대로 사용
        const post = Array.isArray(pt.posts) ? pt.posts[0] : pt.posts;
        return post && post.status === "published" && post.locale === locale;
      }).length ?? 0;

      return {
        id: tag.id,
        name: tag.name,
        slug: tag.slug,
        post_count: publishedCount,
      };
    })
    // 글이 없는 태그는 제외하고 많은 순으로 정렬
    .filter((tag) => tag.post_count > 0)
    .sort((a, b) => b.post_count - a.post_count);
}

// ─────────────────────────────────────────────
// 2. 슬러그로 태그 상세 조회
// ─────────────────────────────────────────────
export async function getTagBySlug(slug: string) {
  const supabase = await createClient();

  const { data: tag, error } = await supabase
    .from("tags")
    .select("id, name, slug")
    .eq("slug", slug)
    .single();

  if (error) {
    console.error("[getTagBySlug] Error:", error.message);
    return null;
  }

  return tag;
}
