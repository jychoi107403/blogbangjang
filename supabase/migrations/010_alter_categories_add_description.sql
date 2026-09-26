-- 010_alter_categories_add_description.sql
-- categories 테이블에 description(설명) 컬럼 추가
-- 카테고리 페이지에서 카테고리 설명을 표시하기 위해 필요

ALTER TABLE categories
ADD COLUMN IF NOT EXISTS description TEXT;

COMMENT ON COLUMN categories.description IS '카테고리 설명 (선택 사항)';
