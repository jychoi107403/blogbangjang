// 데이터베이스 테이블 타입 정의
// Supabase의 각 테이블 구조를 TypeScript 타입으로 정의합니다

export type PostStatus = "draft" | "published"; // 임시저장 | 발행됨

export interface Post {
  id: string;
  title: string;           // 글 제목
  slug: string;            // URL 슬러그 (예: /blog/my-first-post)
  content: string;         // 글 본문 (HTML)
  excerpt: string;         // 요약문
  thumbnail_url?: string;  // 썸네일 이미지 URL
  category_id?: string;    // 카테고리 ID
  series_id?: string;      // 시리즈 ID
  tags?: string[];         // 태그 목록
  status: PostStatus;      // 발행 상태
  locale: string;          // 언어 (ko, en)
  view_count: number;      // 조회수
  created_at: string;
  updated_at: string;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  color: string;           // 카테고리 색상 (hex)
  created_at: string;
}

export interface Tag {
  id: string;
  name: string;
  slug: string;
  created_at: string;
}

export interface Series {
  id: string;
  title: string;
  description: string;
  slug: string;
  created_at: string;
}

export interface Comment {
  id: string;
  post_id: string;
  parent_id?: string;      // 부모 댓글 ID (대댓글인 경우)
  nickname: string;
  password_hash: string;   // 비밀번호 해시 (삭제 시 검증용)
  content: string;
  is_secret: boolean;      // 비밀 댓글 여부
  is_deleted: boolean;     // 삭제 여부 (소프트 삭제)
  created_at: string;
}

export interface NewsletterSubscriber {
  id: string;
  email: string;
  is_verified: boolean;    // 이메일 인증 여부
  created_at: string;
}
