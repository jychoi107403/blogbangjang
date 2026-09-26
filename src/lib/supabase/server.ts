import { createServerClient } from "@supabase/ssr";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { cookies } from "next/headers";

// 서버 컴포넌트, Server Actions, Route Handlers에서 사용하는 Supabase 클라이언트
// 쿠키를 통해 세션 관리 (RLS 정책 적용됨)
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) => {
              cookieStore.set(name, value, options);
            });
          } catch {
            // 서버 컴포넌트에서는 쿠키 설정이 무시될 수 있음 (정상 동작)
          }
        },
      },
    }
  );
}

// ─────────────────────────────────────────────
// 어드민 전용 클라이언트 (service_role 키 사용)
// RLS 정책을 우회하여 INSERT/UPDATE/DELETE 가능
// ⚠️ 반드시 서버 사이드(API Route)에서만 사용할 것!
//    클라이언트 컴포넌트에서 절대 사용 금지!
// ─────────────────────────────────────────────
export function createAdminClient() {
  return createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,  // service_role 키 (RLS 우회)
    {
      auth: {
        // 서버에서만 쓰므로 자동 갱신 불필요
        autoRefreshToken: false,
        persistSession: false,
      },
    }
  );
}
