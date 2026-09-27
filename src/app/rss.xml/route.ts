// app/rss.xml/route.ts
// 블로그 RSS 2.0 피드 생성기
// ★ 네이버 서치어드바이저(Webmaster) 및 구글 검색엔진 수집 필수 항목
// Supabase에서 최근 발행된 글 50편을 가져와 표준 RSS XML을 반환합니다

import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

// 사이트 기본 도메인
const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://bangjang.net";

export async function GET() {
  // Supabase 공개 클라이언트 생성 (발행된 글은 공개 데이터)
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  // 최근 발행된 글 50편 조회
  const { data: posts, error } = await supabase
    .from("posts")
    .select(`
      id,
      title,
      slug,
      excerpt,
      locale,
      created_at,
      published_at,
      categories ( name )
    `)
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .limit(50);

  if (error) {
    console.error("[RSS Feed] Error fetching posts:", error.message);
  }

  // XML 특수문자 안전 이스케이프 함수
  const escapeXml = (unsafe: string) => {
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&apos;");
  };

  // 각 게시글을 RSS <item> 형식으로 변환
  const itemsXml = (posts ?? [])
    .map((post) => {
      const pubDate = new Date(post.published_at || post.created_at).toUTCString();
      const postUrl = `${SITE_URL}/${post.locale}/blog/${post.slug}`;

      let categoryName = "일반";
      if (post.categories) {
        if (Array.isArray(post.categories) && post.categories.length > 0) {
          categoryName = (post.categories[0] as unknown as { name?: string })?.name || "일반";
        } else if (typeof post.categories === "object" && post.categories !== null) {
          categoryName = (post.categories as unknown as { name?: string })?.name || "일반";
        }
      }

      return `
    <item>
      <title>${escapeXml(post.title)}</title>
      <link>${postUrl}</link>
      <guid isPermaLink="true">${postUrl}</guid>
      <description><![CDATA[${post.excerpt || post.title}]]></description>
      <category>${escapeXml(categoryName)}</category>
      <pubDate>${pubDate}</pubDate>
    </item>`;
    })
    .join("");

  // 전체 RSS 2.0 XML 문서 조립
  const rssXml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>방장 블로그</title>
    <link>${SITE_URL}</link>
    <description>개발, 기술, 그리고 배움의 기록. Next.js, TypeScript, 웹 개발 등 다양한 주제의 글을 공유합니다.</description>
    <language>ko</language>
    <lastBuildDate>${new Date().toUTCString()}</lastBuildDate>
    <atom:link href="${SITE_URL}/rss.xml" rel="self" type="application/rss+xml"/>
    ${itemsXml}
  </channel>
</rss>`;

  // XML 헤더 및 캐시 헤더(1시간) 설정하여 반환
  return new NextResponse(rssXml, {
    headers: {
      "Content-Type": "application/xml; charset=utf-8",
      "Cache-Control": "public, max-age=3600, s-maxage=3600",
    },
  });
}
