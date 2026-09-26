// app/api/views/[slug]/route.ts
// 조회수 API
// GET: 특정 글의 조회수 조회
// POST: 조회수 1 증가

import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────
// GET /api/views/[slug]
// 특정 슬러그의 글 조회수 반환
// ─────────────────────────────────────────────
export async function GET(
  _req: NextRequest,
  { params }: { params: Promise<{ slug: string }> }
) {
  const { slug } = await params;
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("posts")
    .select("view_count")
    .eq("slug", slug)
    .single();

  if (error || !data) {
    return NextResponse.json({ error: "Post not found" }, { status: 404 });
  }

  return NextResponse.json({ view_count: data.view_count });
}

// ─────────────────────────────────────────────
// POST /api/views/[slug]
// 조회수 1 증가 (RPC 함수 사용으로 원자적 업데이트)
// ─────────────────────────────────────────────
export async function POST(
  _req: NextRequest,
  { params }: { params: Promise<{ slug: string }> }
) {
  const { slug } = await params;
  const supabase = await createClient();

  // 먼저 slug로 post_id 조회
  const { data: post, error: findError } = await supabase
    .from("posts")
    .select("id")
    .eq("slug", slug)
    .single();

  if (findError || !post) {
    return NextResponse.json({ error: "Post not found" }, { status: 404 });
  }

  // RPC 함수로 원자적 조회수 증가 (동시 접속해도 안전)
  const { error } = await supabase.rpc("increment_view_count", {
    post_id: post.id,
  });

  if (error) {
    console.error("[POST /api/views] Error:", error.message);
    return NextResponse.json({ error: "Failed to increment view count" }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}
