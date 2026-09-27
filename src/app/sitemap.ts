// app/sitemap.ts
// 동적 사이트맵 생성
// ★ 구글 SEO 및 애드센스 승인 필수 요소
// Supabase에서 발행된 글 목록을 가져와 자동으로 sitemap.xml을 생성합니다

import type { MetadataRoute } from "next";
import { createAdminClient } from "@/lib/supabase/server";

// 사이트 기본 URL (bangjang.net 루트 도메인 기준)
const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://bangjang.net";

// 지원 언어 목록
const LOCALES = ["ko", "en"];

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const supabase = createAdminClient();

  // ─── 1) 발행된 모든 글 가져오기 ───
  const { data: posts } = await supabase
    .from("posts")
    .select("slug, locale, updated_at")
    .eq("status", "published")
    .order("published_at", { ascending: false });

  // ─── 2) 모든 카테고리 가져오기 ───
  const { data: categories } = await supabase
    .from("categories")
    .select("slug");

  // ─── 3) 모든 태그 가져오기 ───
  const { data: tags } = await supabase
    .from("tags")
    .select("slug");

  // ─── 4) 모든 시리즈 가져오기 ───
  const { data: series } = await supabase
    .from("series")
    .select("slug");

  // ─── 정적 페이지 URL 생성 ───
  // 각 언어별로 홈, 블로그, 소개, 개인정보방침 등 고정 페이지 생성
  const staticPages: MetadataRoute.Sitemap = LOCALES.flatMap((locale) => [
    {
      url: `${SITE_URL}/${locale}`,
      lastModified: new Date(),
      changeFrequency: "daily" as const,
      priority: 1.0,
    },
    {
      url: `${SITE_URL}/${locale}/blog`,
      lastModified: new Date(),
      changeFrequency: "daily" as const,
      priority: 0.9,
    },
    {
      url: `${SITE_URL}/${locale}/about`,
      lastModified: new Date(),
      changeFrequency: "monthly" as const,
      priority: 0.7,
    },
    {
      url: `${SITE_URL}/${locale}/privacy`,
      lastModified: new Date(),
      changeFrequency: "yearly" as const,
      priority: 0.3,
    },
    {
      url: `${SITE_URL}/${locale}/series`,
      lastModified: new Date(),
      changeFrequency: "weekly" as const,
      priority: 0.7,
    },
  ]);

  // ─── 블로그 글 URL 생성 ───
  const postPages: MetadataRoute.Sitemap = (posts ?? []).map((post) => ({
    url: `${SITE_URL}/${post.locale}/blog/${post.slug}`,
    lastModified: new Date(post.updated_at),
    changeFrequency: "weekly" as const,
    priority: 0.8,
  }));

  // ─── 카테고리 URL 생성 ───
  const categoryPages: MetadataRoute.Sitemap = LOCALES.flatMap((locale) =>
    (categories ?? []).map((cat) => ({
      url: `${SITE_URL}/${locale}/category/${cat.slug}`,
      lastModified: new Date(),
      changeFrequency: "weekly" as const,
      priority: 0.6,
    }))
  );

  // ─── 태그 URL 생성 ───
  const tagPages: MetadataRoute.Sitemap = LOCALES.flatMap((locale) =>
    (tags ?? []).map((tag) => ({
      url: `${SITE_URL}/${locale}/tag/${tag.slug}`,
      lastModified: new Date(),
      changeFrequency: "weekly" as const,
      priority: 0.5,
    }))
  );

  // ─── 시리즈 URL 생성 ───
  const seriesPages: MetadataRoute.Sitemap = LOCALES.flatMap((locale) =>
    (series ?? []).map((s) => ({
      url: `${SITE_URL}/${locale}/series/${s.slug}`,
      lastModified: new Date(),
      changeFrequency: "weekly" as const,
      priority: 0.6,
    }))
  );

  // 모든 URL 합쳐서 반환
  return [
    ...staticPages,
    ...postPages,
    ...categoryPages,
    ...tagPages,
    ...seriesPages,
  ];
}
