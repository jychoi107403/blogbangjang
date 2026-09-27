// lib/utils/posts.ts
// 게시글 관련 데이터 조회 함수들
// Supabase에서 게시글 데이터를 가져오는 서버 사이드 함수들
// 다국어 지원: 요청된 언어의 글이 없을 경우 한국어 원문으로 자연스럽게 Fallback 처리

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

  // 태그 필터 적용 여부 확인
  let postIdsFromTag: string[] | null = null;
  if (tagId) {
    const { data: postTagRows } = await supabase
      .from("post_tags")
      .select("post_id")
      .eq("tag_id", tagId);

    postIdsFromTag = postTagRows?.map((r) => r.post_id) ?? [];
    if (postIdsFromTag.length === 0) {
      return { posts: [], total: 0 };
    }
  }

  // 1차 쿼리: 요청된 locale로 검색
  const buildQuery = (queryLocale?: string) => {
    let q = supabase
      .from("posts")
      .select(`
        *,
        categories ( id, name, slug, color ),
        series ( id, title, slug )
      `, { count: "exact" })
      .eq("status", "published")
      .order("created_at", { ascending: false });

    if (queryLocale) {
      q = q.eq("locale", queryLocale);
    }
    if (categoryId) q = q.eq("category_id", categoryId);
    if (seriesId) q = q.eq("series_id", seriesId);
    if (postIdsFromTag && postIdsFromTag.length > 0) {
      q = q.in("id", postIdsFromTag);
    }

    const from = (page - 1) * limit;
    const to = from + limit - 1;
    return q.range(from, to);
  };

  const { data: posts, error, count } = await buildQuery(locale);

  if (error) {
    console.error("[getPublishedPosts] Error:", error.message);
    return { posts: [], total: 0 };
  }

  // Fallback: 만약 해당 언어(예: en)로 된 글이 하나도 없다면 한국어(ko) 글들을 표시
  if ((!posts || posts.length === 0) && locale !== "ko") {
    const fallbackRes = await buildQuery("ko");
    if (!fallbackRes.error && fallbackRes.data && fallbackRes.data.length > 0) {
      return {
        posts: fallbackRes.data,
        total: fallbackRes.count ?? fallbackRes.data.length,
      };
    }
  }

  return {
    posts: posts ?? [],
    total: count ?? 0,
  };
}

// ─────────────────────────────────────────────
// 2. 슬러그로 글 상세 조회 (Fallback 포함)
// ─────────────────────────────────────────────
export async function getPostBySlug(slug: string, locale: string = "ko") {
  const supabase = await createClient();

  // 1차: 요청된 언어(locale)로 발행된 글 검색
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
    .maybeSingle();

  if (error) {
    console.error("[getPostBySlug] Error:", error.message);
  }

  let finalPost = post;
  let isFallback = false;

  // 2차 Fallback: 해당 언어의 글이 없으면(예: 영문 번역본이 아직 없을 때),
  // 기본 언어인 한국어(ko) 또는 해당 slug의 발행된 원본 글 검색
  if (!finalPost) {
    const { data: fallbackPost, error: fallbackError } = await supabase
      .from("posts")
      .select(`
        *,
        categories ( id, name, slug, color ),
        series ( id, title, slug )
      `)
      .eq("slug", slug)
      .eq("status", "published")
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (!fallbackError && fallbackPost) {
      finalPost = fallbackPost;
      isFallback = true;
    }
  }

  if (!finalPost) {
    return null;
  }

  // 해당 글의 태그 목록 조회
  const { data: tagRows } = await supabase
    .from("post_tags")
    .select("tags ( id, name, slug )")
    .eq("post_id", finalPost.id);

  // 태그 데이터 평탄화
  const tags = tagRows?.flatMap((r) => r.tags ?? []) ?? [];

  return { ...finalPost, tags, isFallback };
}

// ─────────────────────────────────────────────
// 3. 최신 글 N개 조회 (홈 페이지 최신 글 섹션용 - Fallback 지원)
// ─────────────────────────────────────────────
export async function getRecentPosts(locale: string = "ko", limit: number = 6) {
  const supabase = await createClient();

  const fetchRecent = async (queryLocale: string) => {
    return await supabase
      .from("posts")
      .select(`
        id, title, slug, excerpt, thumbnail_url,
        created_at, view_count,
        categories ( id, name, slug, color )
      `)
      .eq("status", "published")
      .eq("locale", queryLocale)
      .order("created_at", { ascending: false })
      .limit(limit);
  };

  const { data: posts, error } = await fetchRecent(locale);

  if (error) {
    console.error("[getRecentPosts] Error:", error.message);
    return [];
  }

  // 요청 언어 글이 없고 locale이 ko가 아니면 한국어 글을 Fallback으로 제공
  if ((!posts || posts.length === 0) && locale !== "ko") {
    const { data: fallbackPosts } = await fetchRecent("ko");
    return fallbackPosts ?? [];
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

  // 검색 결과가 없고 locale !== 'ko'이면 한국어 글도 검색해줌
  if ((!posts || posts.length === 0) && locale !== "ko") {
    const { data: fallbackPosts } = await supabase
      .from("posts")
      .select(`
        id, title, slug, excerpt, thumbnail_url,
        created_at, view_count,
        categories ( id, name, slug, color )
      `)
      .eq("status", "published")
      .or(`title.ilike.%${query}%,content.ilike.%${query}%,excerpt.ilike.%${query}%`)
      .order("created_at", { ascending: false })
      .limit(20);

    return fallbackPosts ?? [];
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
// 6. 관련 글 조회 (Fallback 지원)
// ─────────────────────────────────────────────
export async function getRelatedPosts(
  postId: string,
  categoryId: string | null,
  locale: string = "ko",
  limit: number = 3
) {
  const supabase = await createClient();

  const fetchRelated = async (queryLocale: string) => {
    let query = supabase
      .from("posts")
      .select(`id, title, slug, excerpt, thumbnail_url, created_at`)
      .eq("status", "published")
      .eq("locale", queryLocale)
      .neq("id", postId) // 현재 글 제외
      .limit(limit);

    if (categoryId) {
      query = query.eq("category_id", categoryId);
    }
    return await query.order("created_at", { ascending: false });
  };

  const { data: posts, error } = await fetchRelated(locale);

  if (error) {
    console.error("[getRelatedPosts] Error:", error.message);
    return [];
  }

  if ((!posts || posts.length === 0) && locale !== "ko") {
    const { data: fallbackPosts } = await fetchRelated("ko");
    return fallbackPosts ?? [];
  }

  return posts ?? [];
}

// ─────────────────────────────────────────────
// 7. 시리즈의 글 목록 조회 (Fallback 지원)
// ─────────────────────────────────────────────
export async function getSeriesPosts(seriesId: string, locale: string = "ko") {
  const supabase = await createClient();

  const fetchSeries = async (queryLocale: string) => {
    return await supabase
      .from("posts")
      .select("id, title, slug, series_order")
      .eq("series_id", seriesId)
      .eq("status", "published")
      .eq("locale", queryLocale)
      .order("series_order", { ascending: true });
  };

  const { data: posts, error } = await fetchSeries(locale);

  if (error) {
    console.error("[getSeriesPosts] Error:", error.message);
    return [];
  }

  if ((!posts || posts.length === 0) && locale !== "ko") {
    const { data: fallbackPosts } = await fetchSeries("ko");
    return fallbackPosts ?? [];
  }

  return posts ?? [];
}
