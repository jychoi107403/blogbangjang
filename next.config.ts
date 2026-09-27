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
};

export default withNextIntl(nextConfig);

import('@opennextjs/cloudflare').then(m => m.initOpenNextCloudflareForDev());
