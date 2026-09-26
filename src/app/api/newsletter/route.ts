// app/api/newsletter/route.ts
// 뉴스레터 구독 신청 API
// POST: 이메일 저장 + 인증 이메일 발송 (Resend API)

import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────
// POST /api/newsletter
// Body: { email, locale }
// 이메일을 DB에 저장하고 인증 이메일 발송
// ─────────────────────────────────────────────
export async function POST(req: NextRequest) {
  // form 데이터 또는 JSON 처리
  let email: string | undefined;
  let locale: string = "ko";

  const contentType = req.headers.get("content-type") ?? "";

  if (contentType.includes("application/json")) {
    const body = await req.json();
    email = body.email;
    locale = body.locale ?? "ko";
  } else {
    // HTML form의 action으로 전송된 경우 (multipart/form-data 또는 application/x-www-form-urlencoded)
    const formData = await req.formData();
    email = formData.get("email") as string;
    locale = (formData.get("locale") as string) ?? "ko";
  }

  // ─── 이메일 유효성 검사 ───
  if (!email || !email.includes("@")) {
    return NextResponse.json({ error: "Invalid email address" }, { status: 400 });
  }

  const emailLower = email.toLowerCase().trim();

  const supabase = await createClient();

  // ─── 중복 이메일 확인 ───
  const { data: existing } = await supabase
    .from("newsletter_subscribers")
    .select("id, is_verified")
    .eq("email", emailLower)
    .single();

  if (existing) {
    if (existing.is_verified) {
      // 이미 인증된 구독자
      return NextResponse.json(
        {
          error: locale === "ko"
            ? "이미 구독 중인 이메일입니다."
            : "This email is already subscribed.",
        },
        { status: 409 }
      );
    } else {
      // 미인증 상태: 인증 이메일 재발송
    }
  } else {
    // ─── 새 구독자 DB에 추가 ───
    const { error: insertError } = await supabase
      .from("newsletter_subscribers")
      .insert({
        email: emailLower,
        is_verified: false,  // 이메일 인증 전까지 false
      });

    if (insertError) {
      console.error("[POST /api/newsletter] Insert error:", insertError.message);
      return NextResponse.json({ error: "Failed to subscribe" }, { status: 500 });
    }
  }

  // ─── Resend API로 인증 이메일 발송 ───
  const resendApiKey = process.env.RESEND_API_KEY;
  const fromEmail = process.env.RESEND_FROM_EMAIL ?? "blog@example.com";
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000";

  if (resendApiKey) {
    // 인증 토큰 생성 (간단한 base64 인코딩)
    const token = Buffer.from(`${emailLower}:${Date.now()}`).toString("base64url");
    const verifyUrl = `${siteUrl}/api/newsletter/verify?token=${token}&email=${encodeURIComponent(emailLower)}`;

    const subject = locale === "ko"
      ? "방장 블로그 구독 인증 이메일"
      : "Confirm your subscription to Bangjang Blog";

    const html = locale === "ko"
      ? `
        <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
          <h2>안녕하세요! 👋</h2>
          <p>방장 블로그 구독 신청을 해주셔서 감사합니다.</p>
          <p>아래 버튼을 클릭하면 구독이 완료됩니다:</p>
          <a href="${verifyUrl}"
            style="display:inline-block;padding:12px 24px;background:#6366f1;color:white;border-radius:8px;text-decoration:none;font-weight:bold;">
            구독 확인하기
          </a>
          <p style="color:#888;font-size:12px;">이 이메일을 요청하지 않으셨다면 무시하셔도 됩니다.</p>
        </div>
      `
      : `
        <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
          <h2>Hello! 👋</h2>
          <p>Thank you for subscribing to Bangjang Blog!</p>
          <p>Click the button below to confirm your subscription:</p>
          <a href="${verifyUrl}"
            style="display:inline-block;padding:12px 24px;background:#6366f1;color:white;border-radius:8px;text-decoration:none;font-weight:bold;">
            Confirm Subscription
          </a>
          <p style="color:#888;font-size:12px;">If you did not request this, please ignore this email.</p>
        </div>
      `;

    // Resend API 호출
    const resendResponse = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${resendApiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: fromEmail,
        to: emailLower,
        subject,
        html,
      }),
    });

    if (!resendResponse.ok) {
      const resendError = await resendResponse.text();
      console.error("[POST /api/newsletter] Resend error:", resendError);
      // 이메일 발송 실패해도 구독 자체는 성공으로 처리
    }
  }

  // ─── HTML form 요청이면 리디렉션, API 요청이면 JSON 반환 ───
  if (!contentType.includes("application/json")) {
    // 성공 페이지로 리디렉션
    return NextResponse.redirect(
      new URL(`/${locale}/blog?subscribed=true`, req.url)
    );
  }

  return NextResponse.json(
    {
      success: true,
      message: locale === "ko"
        ? "구독 신청이 완료되었습니다. 이메일을 확인해주세요!"
        : "Subscription submitted! Please check your email.",
    },
    { status: 201 }
  );
}
