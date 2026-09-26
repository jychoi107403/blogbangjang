// app/api/comments/route.ts
// 댓글 API
// GET: 특정 글의 댓글 목록 조회
// POST: 새 댓글 작성 (비밀번호 SHA-256 + salt 해시화 후 저장)

import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createHash, randomBytes } from "crypto"; // Node.js 내장 모듈 (외부 패키지 불필요!)

// ─────────────────────────────────────────────
// 비밀번호 해시 유틸리티 (Node.js crypto 사용)
// ─────────────────────────────────────────────

// 비밀번호 해시 생성: "salt:SHA256(salt+password)" 형식으로 저장
function hashPassword(password: string): string {
  const salt = randomBytes(16).toString("hex"); // 랜덤 salt (32자 hex)
  const hash = createHash("sha256")
    .update(salt + password)       // salt를 앞에 붙여서 해시
    .digest("hex");
  return `${salt}:${hash}`;         // "salt:hash" 형식으로 저장
}

// 비밀번호 검증: 입력값과 저장된 해시 비교
function verifyPassword(password: string, storedHash: string): boolean {
  const [salt, hash] = storedHash.split(":");
  if (!salt || !hash) return false;
  const inputHash = createHash("sha256")
    .update(salt + password)
    .digest("hex");
  return inputHash === hash; // 해시값이 일치하면 비밀번호가 맞음
}

// ─────────────────────────────────────────────
// GET /api/comments?post_id=xxx
// 특정 글의 댓글 목록 반환 (삭제된 댓글 제외)
// ─────────────────────────────────────────────
export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const postId = searchParams.get("post_id");

  if (!postId) {
    return NextResponse.json({ error: "post_id is required" }, { status: 400 });
  }

  const supabase = await createClient();

  const { data: comments, error } = await supabase
    .from("comments")
    .select("id, post_id, parent_id, nickname, content, is_deleted, created_at")
    // 비밀번호 해시는 절대 클라이언트에 내려보내지 않음!
    .eq("post_id", postId)
    .order("created_at", { ascending: true });

  if (error) {
    console.error("[GET /api/comments] Error:", error.message);
    return NextResponse.json({ error: "Failed to fetch comments" }, { status: 500 });
  }

  // 삭제된 댓글은 내용만 가림 (댓글 구조는 유지)
  const processedComments = (comments ?? []).map((c) => ({
    ...c,
    content: c.is_deleted ? "[삭제된 댓글입니다]" : c.content,
    nickname: c.is_deleted ? "익명" : c.nickname,
  }));

  return NextResponse.json({ comments: processedComments });
}

// ─────────────────────────────────────────────
// POST /api/comments
// 새 댓글 작성 (보안: 비밀번호를 SHA-256+salt로 해시화하여 저장)
// ─────────────────────────────────────────────
export async function POST(req: NextRequest) {
  let body: {
    post_id?: string;
    nickname?: string;       // DB 컬럼명
    content?: string;
    password?: string;
    parent_id?: string;
    locale?: string;
  };

  try {
    body = await req.json();
  } catch {
    // form 데이터로 전송된 경우 처리
    const formData = await req.formData().catch(() => null);
    if (!formData) {
      return NextResponse.json({ error: "Invalid request body" }, { status: 400 });
    }
    body = {
      post_id: formData.get("post_id") as string,
      nickname: formData.get("nickname") as string,
      content: formData.get("content") as string,
      password: formData.get("password") as string,
      locale: formData.get("locale") as string,
    };
  }

  const { post_id, nickname, content, password, parent_id } = body;

  // ─── 입력값 검증 ───
  if (!post_id || !nickname || !content || !password) {
    return NextResponse.json(
      { error: "post_id, nickname, content, password are all required" },
      { status: 400 }
    );
  }

  if (nickname.length > 30) {
    return NextResponse.json({ error: "nickname must be 30 chars or less" }, { status: 400 });
  }

  if (content.length > 500) {
    return NextResponse.json({ error: "content must be 500 chars or less" }, { status: 400 });
  }

  if (password.length < 4 || password.length > 20) {
    return NextResponse.json({ error: "password must be 4-20 chars" }, { status: 400 });
  }

  // ─── 비밀번호 해시화 (SHA-256 + random salt) ───
  // 평문 비밀번호를 절대 DB에 저장하지 않음!
  const passwordHash = hashPassword(password);

  const supabase = await createClient();

  // ─── 댓글 저장 ───
  const { data: newComment, error } = await supabase
    .from("comments")
    .insert({
      post_id,
      parent_id: parent_id ?? null,
      nickname: nickname.trim(),      // DB 컬럼명은 nickname
      password_hash: passwordHash,    // 해시된 비밀번호만 저장
      content: content.trim(),
      is_deleted: false,
    })
    .select("id, post_id, parent_id, nickname, content, created_at")
    .single();

  if (error) {
    console.error("[POST /api/comments] Error:", error.message);
    return NextResponse.json({ error: "Failed to create comment" }, { status: 500 });
  }

  return NextResponse.json({ comment: newComment }, { status: 201 });
}

// verifyPassword를 다른 파일에서 사용하기 위해 export
export { verifyPassword };
