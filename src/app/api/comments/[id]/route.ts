// app/api/comments/[id]/route.ts
// 특정 댓글 삭제 API
// DELETE /api/comments/[id]: 비밀번호 검증 후 소프트 삭제

import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createHash } from "crypto"; // Node.js 내장 모듈

// 비밀번호 검증 함수 (route.ts와 동일한 방식)
function verifyPassword(password: string, storedHash: string): boolean {
  const [salt, hash] = storedHash.split(":");
  if (!salt || !hash) return false;
  const inputHash = createHash("sha256")
    .update(salt + password)
    .digest("hex");
  return inputHash === hash;
}

// ─────────────────────────────────────────────
// DELETE /api/comments/[id]
// Body: { password: string }
// 비밀번호가 맞으면 is_deleted = true로 업데이트 (소프트 삭제)
// ─────────────────────────────────────────────
export async function DELETE(
  req: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  let body: { password?: string };
  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: "Invalid request body" }, { status: 400 });
  }

  const { password } = body;

  if (!password) {
    return NextResponse.json({ error: "password is required" }, { status: 400 });
  }

  const supabase = await createClient();

  // 1. 댓글 조회 (비밀번호 해시 포함)
  const { data: comment, error: findError } = await supabase
    .from("comments")
    .select("id, password_hash, is_deleted")
    .eq("id", id)
    .single();

  if (findError || !comment) {
    return NextResponse.json({ error: "Comment not found" }, { status: 404 });
  }

  if (comment.is_deleted) {
    return NextResponse.json({ error: "Comment already deleted" }, { status: 400 });
  }

  // 2. 비밀번호 검증 (SHA-256 + salt)
  const isPasswordCorrect = verifyPassword(password, comment.password_hash);

  if (!isPasswordCorrect) {
    return NextResponse.json({ error: "Incorrect password" }, { status: 403 });
  }

  // 3. 소프트 삭제 (is_deleted = true, 내용 마스킹)
  // 실제 데이터는 삭제하지 않고 is_deleted 플래그만 변경
  // → 대댓글 구조 유지, 향후 복구 가능
  const { error: deleteError } = await supabase
    .from("comments")
    .update({ is_deleted: true })
    .eq("id", id);

  if (deleteError) {
    console.error("[DELETE /api/comments/:id] Error:", deleteError.message);
    return NextResponse.json({ error: "Failed to delete comment" }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}
