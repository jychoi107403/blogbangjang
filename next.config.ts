import type { NextConfig } from "next";
import createNextIntlPlugin from "next-intl/plugin";

// next-intl 플러그인 초기화 (i18n 요청 설정 파일 경로 지정)
const withNextIntl = createNextIntlPlugin("./src/i18n/request.ts");

const nextConfig: NextConfig = {
  // 이미지 최적화: Supabase Storage 도메인 허용
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "efbzpaaulnpbwghzytuq.supabase.co",
        pathname: "/storage/v1/object/public/**",
      },
    ],
  },
  // 실험적 기능: 서버 컴포넌트에서 외부 패키지 허용
  serverExternalPackages: ["@node-rs/argon2"],
};

export default withNextIntl(nextConfig);
