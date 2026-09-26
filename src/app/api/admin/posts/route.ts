// app/api/admin/posts/route.ts
// 어드민 글 CRUD API
// POST: 새 글 저장 (어드민 전용)
// 주의: 실제 운영 시 인증 미들웨어 추가 필요

import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/server"; // service_role 키로 RLS 우회

// ─────────────────────────────────────────────
// POST /api/admin/posts
// 새 글 저장 (draft 또는 published)
// ─────────────────────────────────────────────
export async function POST(req: NextRequest) {
  let body: {
    title?: string;
    slug?: string;
    excerpt?: string;
    content?: string;
    locale?: string;
    status?: string;
    thumbnail_url?: string;
    category_id?: string;
    series_id?: string;
    published_at?: string | null;
  };

  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const {
    title,
    slug,
    excerpt = "",
    content = "",
    locale = "ko",
    status = "draft",
    thumbnail_url,
    category_id,
    series_id,
    published_at,
  } = body;

  // ─── 필수 필드 검증 ───
  if (!title || !slug) {
    return NextResponse.json(
      { error: "title and slug are required" },
      { status: 400 }
    );
  }

  if (!["draft", "published"].includes(status)) {
    return NextResponse.json(
      { error: "status must be 'draft' or 'published'" },
      { status: 400 }
    );
  }

  const supabase = createAdminClient();

  // ─── 글 저장 ───
  const { data: newPost, error } = await supabase
    .from("posts")
    .insert({
      title: title.trim(),
      slug: slug.trim(),
      excerpt: excerpt.trim(),
      content,
      locale,
      status,
      thumbnail_url: thumbnail_url || null,
      // 빈 문자열은 null로 처리 (외래키 제약 때문에)
      category_id: category_id || null,
      series_id: series_id || null,
      published_at: published_at ?? null,
    })
    .select("id, title, slug, status, locale")
    .single();

  if (error) {
    console.error("[POST /api/admin/posts] Error:", error.message);
    // 슬러그 중복 오류 특별 처리
    if (error.code === "23505") {
      return NextResponse.json(
        { error: `'${slug}' 슬러그는 이미 사용 중입니다. 다른 슬러그를 사용해주세요.` },
        { status: 409 }
      );
    }
    return NextResponse.json({ error: "글 저장에 실패했습니다." }, { status: 500 });
  }

  return NextResponse.json({ post: newPost }, { status: 201 });
}

// ─────────────────────────────────────────────
// GET /api/admin/posts
// 전체 글 목록 조회 (어드민용, 상태 무관)
// ─────────────────────────────────────────────
export async function GET() {
  const supabase = createAdminClient();

  const { data: posts, error } = await supabase
    .from("posts")
    .select("id, title, slug, status, locale, view_count, created_at")
    .order("created_at", { ascending: false });

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ posts: posts ?? [] });
}
