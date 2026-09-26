// app/api/newsletter/verify/route.ts
// 뉴스레터 이메일 인증 API
// GET: 인증 토큰 검증 후 is_verified = true 업데이트

import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────
// GET /api/newsletter/verify?token=xxx&email=xxx
// 이메일 인증 링크 클릭 시 호출되는 엔드포인트
// ─────────────────────────────────────────────
export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const token = searchParams.get("token");
  const email = searchParams.get("email");

  if (!token || !email) {
    return NextResponse.redirect(
      new URL("/ko/blog?verified=false", req.url)
    );
  }

  // ─── 토큰 유효성 검사 ───
  // 토큰은 base64url(email:timestamp) 형식
  // 24시간 이내 발급된 토큰만 유효
  let isTokenValid = false;
  try {
    const decoded = Buffer.from(token, "base64url").toString("utf-8");
    const [tokenEmail, timestampStr] = decoded.split(":");
    const timestamp = parseInt(timestampStr, 10);
    const ageMs = Date.now() - timestamp;
    const maxAgeMs = 24 * 60 * 60 * 1000; // 24시간

    // 이메일 일치 + 24시간 이내 발급 확인
    isTokenValid = tokenEmail === email.toLowerCase() && ageMs <= maxAgeMs;
  } catch {
    isTokenValid = false;
  }

  if (!isTokenValid) {
    const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000";
    return NextResponse.redirect(new URL("/ko/blog?verified=false", siteUrl));
  }

  const supabase = await createClient();

  // ─── DB에서 is_verified를 true로 업데이트 ───
  const { error } = await supabase
    .from("newsletter_subscribers")
    .update({ is_verified: true })
    .eq("email", email.toLowerCase())
    .eq("is_verified", false); // 이미 인증된 경우 중복 업데이트 방지

  if (error) {
    console.error("[GET /api/newsletter/verify] Error:", error.message);
  }

  // ─── 인증 완료 후 홈으로 리디렉션 ───
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000";
  return NextResponse.redirect(new URL("/ko/blog?verified=true", siteUrl));
}
