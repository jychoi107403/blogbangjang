"use client"; // TipTap은 브라우저에서 실행되는 클라이언트 컴포넌트

// components/editor/TipTapEditor.tsx
// 풍부한 텍스트 에디터 컴포넌트
// TipTap 라이브러리 기반으로 블로그 글 작성 UI 제공

import { useEditor, EditorContent } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import Image from "@tiptap/extension-image";
import Placeholder from "@tiptap/extension-placeholder";
import CodeBlockLowlight from "@tiptap/extension-code-block-lowlight";
import CharacterCount from "@tiptap/extension-character-count";
import { createLowlight, common } from "lowlight"; // 코드 구문 강조 라이브러리
import styles from "./TipTapEditor.module.css";

// lowlight 초기화 (일반적인 프로그래밍 언어 구문 강조 지원)
const lowlight = createLowlight(common);

// TipTapEditor가 받는 props 타입
interface TipTapEditorProps {
  content: string;         // 초기 HTML 콘텐츠
  onChange: (html: string) => void; // 내용 변경 시 호출되는 콜백
  placeholder?: string;    // 빈 에디터에 표시되는 안내 문구
}

export default function TipTapEditor({
  content,
  onChange,
  placeholder = "여기에 글을 작성하세요...",
}: TipTapEditorProps) {
  // TipTap 에디터 인스턴스 생성
  const editor = useEditor({
    extensions: [
      // StarterKit: 기본 서식 모음 (Bold, Italic, Heading, List, Quote, Code, ...)
      StarterKit.configure({
        // 기본 코드 블록 대신 lowlight 코드 블록 사용
        codeBlock: false,
      }),
      // 이미지 삽입 확장
      Image.configure({
        HTMLAttributes: {
          class: "editor-image", // CSS 클래스 추가
        },
      }),
      // 구문 강조된 코드 블록
      CodeBlockLowlight.configure({
        lowlight,
      }),
      // 빈 에디터 플레이스홀더
      Placeholder.configure({
        placeholder,
      }),
      // 글자 수 카운터
      CharacterCount,
    ],
    // 초기 HTML 콘텐츠
    content,
    // 내용이 바뀔 때마다 HTML로 변환해서 onChange 콜백 호출
    onUpdate: ({ editor }) => {
      onChange(editor.getHTML());
    },
    // 서버/클라이언트 렌더링 불일치 방지
    immediatelyRender: false,
  });

  if (!editor) return null;

  // ─── 툴바 버튼 액션들 ───
  const toolbarActions = [
    {
      label: "B",
      title: "굵게 (Ctrl+B)",
      action: () => editor.chain().focus().toggleBold().run(),
      isActive: editor.isActive("bold"),
      style: { fontWeight: "bold" },
    },
    {
      label: "I",
      title: "기울임 (Ctrl+I)",
      action: () => editor.chain().focus().toggleItalic().run(),
      isActive: editor.isActive("italic"),
      style: { fontStyle: "italic" },
    },
    {
      label: "S",
      title: "취소선",
      action: () => editor.chain().focus().toggleStrike().run(),
      isActive: editor.isActive("strike"),
      style: { textDecoration: "line-through" },
    },
    { label: "|", title: "", action: () => {}, isActive: false, isSeparator: true },
    {
      label: "H1",
      title: "제목 1",
      action: () => editor.chain().focus().toggleHeading({ level: 1 }).run(),
      isActive: editor.isActive("heading", { level: 1 }),
    },
    {
      label: "H2",
      title: "제목 2",
      action: () => editor.chain().focus().toggleHeading({ level: 2 }).run(),
      isActive: editor.isActive("heading", { level: 2 }),
    },
    {
      label: "H3",
      title: "제목 3",
      action: () => editor.chain().focus().toggleHeading({ level: 3 }).run(),
      isActive: editor.isActive("heading", { level: 3 }),
    },
    { label: "|", title: "", action: () => {}, isActive: false, isSeparator: true },
    {
      label: "• 목록",
      title: "목록",
      action: () => editor.chain().focus().toggleBulletList().run(),
      isActive: editor.isActive("bulletList"),
    },
    {
      label: "1. 번호",
      title: "번호 목록",
      action: () => editor.chain().focus().toggleOrderedList().run(),
      isActive: editor.isActive("orderedList"),
    },
    { label: "|", title: "", action: () => {}, isSeparator: true, isActive: false },
    {
      label: "❝",
      title: "인용문",
      action: () => editor.chain().focus().toggleBlockquote().run(),
      isActive: editor.isActive("blockquote"),
    },
    {
      label: "</>",
      title: "코드 블록",
      action: () => editor.chain().focus().toggleCodeBlock().run(),
      isActive: editor.isActive("codeBlock"),
      style: { fontFamily: "monospace", fontSize: "0.85em" },
    },
    {
      label: "`code`",
      title: "인라인 코드",
      action: () => editor.chain().focus().toggleCode().run(),
      isActive: editor.isActive("code"),
      style: { fontFamily: "monospace", fontSize: "0.85em" },
    },
    { label: "|", title: "", action: () => {}, isSeparator: true, isActive: false },
    {
      label: "↩",
      title: "실행 취소 (Ctrl+Z)",
      action: () => editor.chain().focus().undo().run(),
      isActive: false,
    },
    {
      label: "↪",
      title: "다시 실행 (Ctrl+Y)",
      action: () => editor.chain().focus().redo().run(),
      isActive: false,
    },
  ] as const;

  // 총 글자 수
  const charCount = editor.storage.characterCount?.characters() ?? 0;

  return (
    <div className={styles.editorWrapper}>
      {/* ─── 서식 툴바 ─── */}
      <div className={styles.toolbar} role="toolbar" aria-label="텍스트 서식">
        {toolbarActions.map((btn, idx) => {
          if ("isSeparator" in btn && btn.isSeparator) {
            return <span key={idx} className={styles.separator} aria-hidden="true" />;
          }
          return (
            <button
              key={idx}
              type="button"
              title={btn.title}
              onClick={btn.action}
              className={`${styles.toolbarBtn} ${btn.isActive ? styles.toolbarBtnActive : ""}`}
              style={"style" in btn ? btn.style : undefined}
            >
              {btn.label}
            </button>
          );
        })}
      </div>

      {/* ─── 에디터 본문 ─── */}
      <EditorContent
        editor={editor}
        className={styles.editor}
      />

      {/* ─── 하단: 글자 수 ─── */}
      <div className={styles.editorFooter}>
        <span className={styles.charCount}>
          {charCount.toLocaleString()}자
        </span>
      </div>
    </div>
  );
}
