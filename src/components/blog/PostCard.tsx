// components/blog/PostCard.tsx
// 블로그 글 목록에서 각 글을 카드 형태로 보여주는 컴포넌트
// 썸네일, 카테고리, 제목, 요약, 태그, 날짜를 포함

import Link from "next/link";
import Image from "next/image";
import CategoryBadge from "./CategoryBadge";
import TagBadge from "./TagBadge";
import styles from "./PostCard.module.css";

// PostCard가 받는 props 타입 정의
interface PostCardProps {
  post: {
    id: string;
    title: string;
    slug: string;
    excerpt?: string | null;         // 글 요약 (없으면 null)
    thumbnail_url?: string | null;    // 썸네일 이미지 URL
    created_at: string;               // 작성 날짜 (ISO 문자열)
    view_count?: number | null;       // 조회수
    categories?: {                    // 카테고리 (없을 수 있음)
      id: string;
      name: string;
      slug: string;
      color?: string | null;
    } | null;
    tags?: {                          // 태그 목록 (없을 수 있음)
      id: string;
      name: string;
      slug: string;
    }[];
  };
  locale: string; // 현재 언어 코드
}

// 날짜를 "YYYY. MM. DD" 형식으로 변환하는 헬퍼 함수
function formatDate(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString("ko-KR", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
}

export default function PostCard({ post, locale }: PostCardProps) {
  // 글 상세 페이지 URL
  const postUrl = `/${locale}/blog/${post.slug}`;

  return (
    // 카드 전체를 클릭하면 글 상세 페이지로 이동
    <Link href={postUrl} className={styles.card}>
      {/* ─── 썸네일 이미지 영역 ─── */}
      <div className={styles.thumbnail}>
        {post.thumbnail_url ? (
          // 썸네일이 있으면 Next.js Image 컴포넌트로 최적화된 이미지 표시
          <Image
            src={post.thumbnail_url}
            alt={post.title}
            fill
            sizes="(max-width: 768px) 100vw, 33vw"
            className={styles.image}
            priority={false}
          />
        ) : (
          // 썸네일이 없으면 그라디언트 플레이스홀더 표시
          <div className={styles.imagePlaceholder}>
            <span className={styles.placeholderIcon}>📝</span>
          </div>
        )}
      </div>

      {/* ─── 텍스트 콘텐츠 영역 ─── */}
      <div className={styles.content}>
        {/* 카테고리 뱃지 */}
        {post.categories && (
          <CategoryBadge
            name={post.categories.name}
            slug={post.categories.slug}
            color={post.categories.color}
            locale={locale}
          />
        )}

        {/* 글 제목 */}
        <h2 className={styles.title}>{post.title}</h2>

        {/* 글 요약 (최대 2줄) */}
        {post.excerpt && (
          <p className={styles.excerpt}>{post.excerpt}</p>
        )}

        {/* 태그 목록 (최대 3개만 표시) */}
        {post.tags && post.tags.length > 0 && (
          <div className={styles.tags}>
            {post.tags.slice(0, 3).map((tag) => (
              <TagBadge
                key={tag.id}
                name={tag.name}
                slug={tag.slug}
                locale={locale}
              />
            ))}
          </div>
        )}

        {/* 하단 메타 정보: 날짜, 조회수 */}
        <div className={styles.meta}>
          <time className={styles.date} dateTime={post.created_at}>
            {formatDate(post.created_at)}
          </time>
          {post.view_count !== null && post.view_count !== undefined && (
            <span className={styles.views}>
              👁 {post.view_count.toLocaleString()}
            </span>
          )}
        </div>
      </div>
    </Link>
  );
}
