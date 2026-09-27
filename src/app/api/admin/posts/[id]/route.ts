// app/api/admin/posts/[id]/route.ts
// 어드민 특정 글 단건 조회, 수정, 삭제 API
// GET: 특정 글의 상세 정보 조회 (수정 에디터용)
// PUT: 특정 글 정보 수정 (임시저장 갱신 또는 발행)
// DELETE: 글 삭제

import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/server";

interface RouteParams {
  params: Promise<{ id: string }>;
}

// ─────────────────────────────────────────────
// 1. GET /api/admin/posts/[id]
// 특정 글 상세 정보 조회
// ─────────────────────────────────────────────
export async function GET(req: NextRequest, { params }: RouteParams) {
  const { id } = await params;

  if (!id) {
    return NextResponse.json({ error: "Post ID is required" }, { status: 400 });
  }

  const supabase = createAdminClient();

  const { data: post, error } = await supabase
    .from("posts")
    .select(`
      id,
      title,
      slug,
      excerpt,
      content,
      locale,
      status,
      thumbnail_url,
      category_id,
      series_id,
      published_at,
      created_at,
      updated_at
    `)
    .eq("id", id)
    .single();

  if (error || !post) {
    console.error("[GET /api/admin/posts/[id]] Error:", error?.message);
    return NextResponse.json({ error: "글을 찾을 수 없습니다." }, { status: 404 });
  }

  return NextResponse.json({ post });
}

// ─────────────────────────────────────────────
// 2. PUT /api/admin/posts/[id]
// 글 정보 수정 (임시저장 갱신 or 발행 전환)
// ─────────────────────────────────────────────
export async function PUT(req: NextRequest, { params }: RouteParams) {
  const { id } = await params;

  if (!id) {
    return NextResponse.json({ error: "Post ID is required" }, { status: 400 });
  }

  let body: {
    title?: string;
    slug?: string;
    excerpt?: string;
    content?: string;
    locale?: string;
    status?: "draft" | "published";
    thumbnail_url?: string;
    category_id?: string;
    series_id?: string;
    published_at?: string | null;
  };

  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: "잘못된 JSON 데이터입니다." }, { status: 400 });
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
  } = body;

  if (!title?.trim() || !slug?.trim()) {
    return NextResponse.json(
      { error: "제목과 슬러그는 필수 입력 항목입니다." },
      { status: 400 }
    );
  }

  if (!["draft", "published"].includes(status)) {
    return NextResponse.json(
      { error: "status는 'draft' 또는 'published'여야 합니다." },
      { status: 400 }
    );
  }

  const supabase = createAdminClient();

  // 기존 글 정보 조회하여 published_at 유지 또는 신규 설정
  const { data: existingPost } = await supabase
    .from("posts")
    .select("status, published_at")
    .eq("id", id)
    .single();

  let newPublishedAt = existingPost?.published_at;
  if (status === "published" && !newPublishedAt) {
    newPublishedAt = new Date().toISOString();
  }

  const { data: updatedPost, error } = await supabase
    .from("posts")
    .update({
      title: title.trim(),
      slug: slug.trim(),
      excerpt: excerpt.trim(),
      content,
      locale,
      status,
      thumbnail_url: thumbnail_url || null,
      category_id: category_id || null,
      series_id: series_id || null,
      published_at: newPublishedAt,
      updated_at: new Date().toISOString(),
    })
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("[PUT /api/admin/posts/[id]] Error:", error.message);
    if (error.code === "23505") {
      return NextResponse.json(
        { error: `'${slug}' 슬러그는 이미 사용 중입니다. 다른 슬러그를 사용해주세요.` },
        { status: 409 }
      );
    }
    return NextResponse.json({ error: `글 수정 실패: ${error.message}` }, { status: 500 });
  }

  return NextResponse.json({ post: updatedPost });
}

// ─────────────────────────────────────────────
// 3. DELETE /api/admin/posts/[id]
// 글 삭제
// ─────────────────────────────────────────────
export async function DELETE(req: NextRequest, { params }: RouteParams) {
  const { id } = await params;

  if (!id) {
    return NextResponse.json({ error: "Post ID is required" }, { status: 400 });
  }

  const supabase = createAdminClient();

  const { error } = await supabase
    .from("posts")
    .delete()
    .eq("id", id);

  if (error) {
    console.error("[DELETE /api/admin/posts/[id]] Error:", error.message);
    return NextResponse.json({ error: `글 삭제 실패: ${error.message}` }, { status: 500 });
  }

  return NextResponse.json({ success: true, message: "글이 삭제되었습니다." });
}
