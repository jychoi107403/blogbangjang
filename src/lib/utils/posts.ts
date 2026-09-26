// lib/utils/posts.ts
// 게시글 관련 데이터 조회 함수들
// Supabase에서 게시글 데이터를 가져오는 서버 사이드 함수들

import { createClient } from "@/lib/supabase/server";
import type { Post } from "@/lib/supabase/types";

// ─────────────────────────────────────────────
// 1. 발행된 글 목록 조회 (페이지네이션 지원)
// ─────────────────────────────────────────────
export async function getPublishedPosts({
  locale = "ko",      // 언어 코드
  page = 1,           // 페이지 번호 (1부터 시작)
  limit = 10,         // 페이지당 글 수
  categoryId,         // 카테고리 필터 (선택)
  tagId,              // 태그 필터 (선택)
  seriesId,           // 시리즈 필터 (선택)
}: {
  locale?: string;
  page?: number;
  limit?: number;
  categoryId?: string;
  tagId?: string;
  seriesId?: string;
} = {}) {
  // 서버 Supabase 클라이언트 생성
  const supabase = await createClient();

  // 기본 쿼리: 발행된 글만, 해당 언어만, 최신 순
  let query = supabase
    .from("posts")
    .select(`
      *,
      categories ( id, name, slug, color ),
      series ( id, title, slug )
    `)
    .eq("status", "published")
    .eq("locale", locale)
    .order("created_at", { ascending: false });

  // 카테고리 필터 적용
  if (categoryId) query = query.eq("category_id", categoryId);

  // 시리즈 필터 적용
  if (seriesId) query = query.eq("series_id", seriesId);

  // 태그 필터 적용 (post_tags 중간 테이블을 통해 조회)
  if (tagId) {
    const { data: postTagRows } = await supabase
      .from("post_tags")
      .select("post_id")
      .eq("tag_id", tagId);

    const postIds = postTagRows?.map((r) => r.post_id) ?? [];
    if (postIds.length === 0) {
      // 해당 태그의 글이 없으면 빈 배열 반환
      return { posts: [], total: 0 };
    }
    query = query.in("id", postIds);
  }

  // 페이지네이션 적용
  const from = (page - 1) * limit;
  const to = from + limit - 1;
  query = query.range(from, to);

  const { data: posts, error, count } = await query;

  if (error) {
    console.error("[getPublishedPosts] Error:", error.message);
    return { posts: [], total: 0 };
  }

  return {
    posts: posts ?? [],
    total: count ?? 0,
  };
}

// ─────────────────────────────────────────────
// 2. 슬러그로 글 상세 조회
// ─────────────────────────────────────────────
export async function getPostBySlug(slug: string, locale: string = "ko") {
  const supabase = await createClient();

  const { data: post, error } = await supabase
    .from("posts")
    .select(`
      *,
      categories ( id, name, slug, color ),
      series ( id, title, slug )
    `)
    .eq("slug", slug)
    .eq("locale", locale)
    .eq("status", "published")
    .single(); // 하나의 결과만 가져옴

  if (error) {
    console.error("[getPostBySlug] Error:", error.message);
    return null;
  }

  // 해당 글의 태그 목록도 함께 조회
  const { data: tagRows } = await supabase
    .from("post_tags")
    .select("tags ( id, name, slug )")
    .eq("post_id", post.id);

  // 태그 데이터를 평탄화
  const tags = tagRows?.flatMap((r) => r.tags ?? []) ?? [];

  return { ...post, tags };
}

// ─────────────────────────────────────────────
// 3. 최신 글 N개 조회 (홈 페이지 최신 글 섹션용)
// ─────────────────────────────────────────────
export async function getRecentPosts(locale: string = "ko", limit: number = 6) {
  const supabase = await createClient();

  const { data: posts, error } = await supabase
    .from("posts")
    .select(`
      id, title, slug, excerpt, thumbnail_url,
      created_at, view_count,
      categories ( id, name, slug, color )
    `)
    .eq("status", "published")
    .eq("locale", locale)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) {
    console.error("[getRecentPosts] Error:", error.message);
    return [];
  }

  return posts ?? [];
}

// ─────────────────────────────────────────────
// 4. 전체 텍스트 검색
// ─────────────────────────────────────────────
export async function searchPosts(query: string, locale: string = "ko") {
  const supabase = await createClient();

  const { data: posts, error } = await supabase
    .from("posts")
    .select(`
      id, title, slug, excerpt, thumbnail_url,
      created_at, view_count,
      categories ( id, name, slug, color )
    `)
    .eq("status", "published")
    .eq("locale", locale)
    // ilike: 대소문자 무시 검색 / or: 제목 OR 본문에서 검색
    .or(`title.ilike.%${query}%,content.ilike.%${query}%,excerpt.ilike.%${query}%`)
    .order("created_at", { ascending: false })
    .limit(20);

  if (error) {
    console.error("[searchPosts] Error:", error.message);
    return [];
  }

  return posts ?? [];
}

// ─────────────────────────────────────────────
// 5. 조회수 증가 (글 상세 페이지 진입 시 호출)
// ─────────────────────────────────────────────
export async function incrementViewCount(postId: string) {
  const supabase = await createClient();

  // Supabase RPC 함수로 원자적 증가 (동시 접속 시 안전)
  const { error } = await supabase.rpc("increment_view_count", {
    post_id: postId,
  });

  if (error) {
    console.error("[incrementViewCount] Error:", error.message);
  }
}

// ─────────────────────────────────────────────
// 6. 관련 글 조회 (같은 카테고리 + 현재 글 제외)
// ─────────────────────────────────────────────
export async function getRelatedPosts(
  postId: string,
  categoryId: string | null,
  locale: string = "ko",
  limit: number = 3
) {
  const supabase = await createClient();

  let query = supabase
    .from("posts")
    .select(`id, title, slug, excerpt, thumbnail_url, created_at`)
    .eq("status", "published")
    .eq("locale", locale)
    .neq("id", postId) // 현재 글 제외
    .limit(limit);

  // 같은 카테고리 글 우선 (카테고리가 있으면)
  if (categoryId) {
    query = query.eq("category_id", categoryId);
  }

  const { data: posts, error } = await query.order("created_at", { ascending: false });

  if (error) {
    console.error("[getRelatedPosts] Error:", error.message);
    return [];
  }

  return posts ?? [];
}

// ─────────────────────────────────────────────
// 7. 시리즈의 글 목록 조회 (시리즈 네비게이션용)
// ─────────────────────────────────────────────
export async function getSeriesPosts(seriesId: string, locale: string = "ko") {
  const supabase = await createClient();

  const { data: posts, error } = await supabase
    .from("posts")
    .select("id, title, slug, series_order")
    .eq("series_id", seriesId)
    .eq("status", "published")
    .eq("locale", locale)
    .order("series_order", { ascending: true });

  if (error) {
    console.error("[getSeriesPosts] Error:", error.message);
    return [];
  }

  return posts ?? [];
}
