// app/[locale]/series/page.tsx
// 시리즈 목록 페이지 - 모든 시리즈를 카드 형태로 표시

import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { getAllSeries } from "@/lib/utils/series";
import styles from "./page.module.css";

interface SeriesPageProps {
  params: Promise<{ locale: string }>;
}

export async function generateMetadata({ params }: SeriesPageProps): Promise<Metadata> {
  const { locale } = await params;
  return {
    title: locale === "ko" ? "시리즈" : "Series",
    description: locale === "ko" ? "연재 중인 시리즈 목록입니다." : "List of ongoing series.",
  };
}

export default async function SeriesPage({ params }: SeriesPageProps) {
  const { locale } = await params;
  const seriesList = await getAllSeries(locale);

  return (
    <div className="container">
      <div className={styles.page}>
        {/* 페이지 헤더 */}
        <header className={styles.header}>
          <h1 className={styles.title}>
            {locale === "ko" ? "📚 시리즈" : "📚 Series"}
          </h1>
          <p className={styles.subtitle}>
            {locale === "ko"
              ? "주제별로 연재되는 글 시리즈들입니다."
              : "Collections of posts organized by topic."}
          </p>
        </header>

        {/* 시리즈 카드 그리드 */}
        {seriesList.length > 0 ? (
          <div className={styles.seriesGrid}>
            {seriesList.map((series) => (
              <Link
                key={series.id}
                href={`/${locale}/blog?series=${series.slug}`}
                className={styles.seriesCard}
              >
                {/* 썸네일 */}
                <div className={styles.seriesThumbnail}>
                  {series.thumbnail_url ? (
                    <Image
                      src={series.thumbnail_url}
                      alt={series.title}
                      fill
                      sizes="(max-width: 600px) 100vw, 33vw"
                      className={styles.seriesImage}
                    />
                  ) : (
                    <div className={styles.seriesImagePlaceholder}>
                      <span>📖</span>
                    </div>
                  )}
                  {/* 글 수 배지 */}
                  <div className={styles.postCountBadge}>
                    {series.post_count}{locale === "ko" ? "편" : " posts"}
                  </div>
                </div>

                {/* 시리즈 정보 */}
                <div className={styles.seriesInfo}>
                  <h2 className={styles.seriesTitle}>{series.title}</h2>
                  {series.description && (
                    <p className={styles.seriesDesc}>{series.description}</p>
                  )}
                  <span className={styles.seriesReadMore}>
                    {locale === "ko" ? "시리즈 보기 →" : "View Series →"}
                  </span>
                </div>
              </Link>
            ))}
          </div>
        ) : (
          <div className={styles.emptyState}>
            <span>📚</span>
            <p>{locale === "ko" ? "아직 시리즈가 없습니다." : "No series yet."}</p>
          </div>
        )}
      </div>
    </div>
  );
}
