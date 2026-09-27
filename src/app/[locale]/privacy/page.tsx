// app/[locale]/privacy/page.tsx
// 개인정보처리방침 페이지
// ★ 구글 애드센스 승인 필수 페이지
// GDPR 및 한국 개인정보보호법에 맞는 개인정보처리방침을 표시합니다

import type { Metadata } from "next";
import styles from "./page.module.css";

// 페이지 Props 타입
interface PrivacyPageProps {
  params: Promise<{ locale: string }>;
}

// SEO 메타데이터
export async function generateMetadata({
  params,
}: PrivacyPageProps): Promise<Metadata> {
  const { locale } = await params;
  return {
    title: locale === "ko" ? "개인정보처리방침" : "Privacy Policy",
    description:
      locale === "ko"
        ? "방장 블로그의 개인정보처리방침입니다. 수집 정보, 이용 목적, 보유 기간 등을 안내합니다."
        : "Privacy Policy of Bangjang Blog. Learn about data collection, usage, and retention.",
    alternates: {
      canonical: `https://bangjang.net/${locale}/privacy`,
      languages: {
        ko: "https://bangjang.net/ko/privacy",
        en: "https://bangjang.net/en/privacy",
        "x-default": "https://bangjang.net/ko/privacy",
      },
    },
  };
}

export default async function PrivacyPage({ params }: PrivacyPageProps) {
  const { locale } = await params;

  return (
    <div className={styles.page}>
      <div className="container">
        {/* ═══════════════════════════ */}
        {/* 페이지 헤더 */}
        {/* ═══════════════════════════ */}
        <header className={styles.header}>
          <h1 className={styles.title}>
            {locale === "ko" ? "개인정보처리방침" : "Privacy Policy"}
          </h1>
          <p className={styles.subtitle}>
            {locale === "ko"
              ? "최종 수정일: 2026년 9월 1일"
              : "Last updated: September 1, 2026"}
          </p>
        </header>

        {/* ═══════════════════════════ */}
        {/* 본문 */}
        {/* ═══════════════════════════ */}
        <div className={styles.content}>
          {locale === "ko" ? (
            <>
              <section className={styles.section}>
                <h2>1. 개인정보의 수집 및 이용 목적</h2>
                <p>
                  방장 블로그(이하 &quot;본 사이트&quot;)는 다음과 같은 목적으로
                  최소한의 개인정보를 수집하고 이용합니다.
                </p>
                <ul>
                  <li>
                    <strong>뉴스레터 서비스</strong>: 새 글 발행 시 이메일 알림
                    발송을 위해 이메일 주소를 수집합니다.
                  </li>
                  <li>
                    <strong>댓글 서비스</strong>: 댓글 작성 시 닉네임과 비밀번호
                    (댓글 삭제용)를 수집합니다.
                  </li>
                  <li>
                    <strong>방문 분석</strong>: 서비스 개선을 위해 Google
                    Analytics를 통해 익명의 방문 통계를 수집합니다.
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>2. 수집하는 개인정보의 항목</h2>
                <ul>
                  <li>
                    <strong>필수 항목</strong>: 이메일 주소 (뉴스레터 구독 시)
                  </li>
                  <li>
                    <strong>선택 항목</strong>: 닉네임, 비밀번호 (댓글 작성 시)
                  </li>
                  <li>
                    <strong>자동 수집 항목</strong>: IP 주소, 브라우저 정보,
                    방문 페이지, 접속 시간 (Google Analytics를 통해 익명으로
                    수집)
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>3. 개인정보의 보유 및 이용 기간</h2>
                <p>
                  본 사이트는 개인정보 수집 및 이용 목적이 달성된 후에는 해당
                  정보를 즉시 파기합니다.
                </p>
                <ul>
                  <li>
                    <strong>뉴스레터 이메일</strong>: 구독 해지 시까지 보유 후
                    즉시 삭제
                  </li>
                  <li>
                    <strong>댓글 정보</strong>: 댓글 삭제 시까지 보유 후 즉시
                    삭제
                  </li>
                  <li>
                    <strong>방문 통계</strong>: Google Analytics 정책에 따라
                    익명으로 보관
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>4. 개인정보의 제3자 제공</h2>
                <p>
                  본 사이트는 이용자의 개인정보를 원칙적으로 외부에 제공하지
                  않습니다. 다만, 다음의 경우에는 예외로 합니다.
                </p>
                <ul>
                  <li>이용자가 사전에 동의한 경우</li>
                  <li>
                    법률의 규정에 의하거나, 수사 목적으로 법령에 정해진 절차와
                    방법에 따라 수사기관의 요구가 있는 경우
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>5. 쿠키(Cookie) 사용</h2>
                <p>
                  본 사이트는 사용자 경험 개선 및 방문 분석을 위해 쿠키를
                  사용합니다. 쿠키는 웹사이트가 사용자의 브라우저에 저장하는
                  작은 텍스트 파일입니다.
                </p>
                <ul>
                  <li>
                    <strong>필수 쿠키</strong>: 다크 모드 설정, 언어 설정 등
                    사이트 기능을 위한 쿠키
                  </li>
                  <li>
                    <strong>분석 쿠키</strong>: Google Analytics를 통한 방문
                    통계 수집
                  </li>
                  <li>
                    <strong>광고 쿠키</strong>: Google AdSense를 통한 맞춤형
                    광고 제공
                  </li>
                </ul>
                <p>
                  브라우저 설정에서 쿠키를 차단할 수 있으나, 일부 서비스
                  이용에 제한이 있을 수 있습니다.
                </p>
              </section>

              <section className={styles.section}>
                <h2>6. 광고 (Google AdSense)</h2>
                <p>
                  본 사이트는 Google AdSense를 사용하여 광고를 게재합니다.
                  Google은 사용자의 관심사에 기반한 광고를 표시하기 위해 쿠키를
                  사용할 수 있습니다.
                </p>
                <p>
                  사용자는 Google의{" "}
                  <a
                    href="https://adssettings.google.com"
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    광고 설정
                  </a>
                  에서 맞춤 광고를 비활성화할 수 있습니다.
                </p>
              </section>

              <section className={styles.section}>
                <h2>7. 이용자의 권리</h2>
                <p>이용자는 언제든지 다음의 권리를 행사할 수 있습니다.</p>
                <ul>
                  <li>개인정보 열람, 수정, 삭제 요청</li>
                  <li>뉴스레터 구독 해지</li>
                  <li>댓글 삭제 요청</li>
                </ul>
                <p>
                  위 권리 행사는 이메일(blog@bangjang.net)로 요청해 주시면
                  신속하게 처리하겠습니다.
                </p>
              </section>

              <section className={styles.section}>
                <h2>8. 개인정보보호 책임자</h2>
                <ul>
                  <li>
                    <strong>담당자</strong>: 방장 (블로그 운영자)
                  </li>
                  <li>
                    <strong>이메일</strong>: blog@bangjang.net
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>9. 방침 변경에 대한 고지</h2>
                <p>
                  이 개인정보처리방침이 변경되는 경우, 변경 사항을 블로그
                  공지사항을 통해 안내하겠습니다. 변경된 방침은 게시한
                  날로부터 7일 후에 효력이 발생합니다.
                </p>
              </section>
            </>
          ) : (
            <>
              <section className={styles.section}>
                <h2>1. Information We Collect</h2>
                <p>
                  Bangjang Blog (hereinafter &quot;this site&quot;) collects
                  minimal personal information for the following purposes:
                </p>
                <ul>
                  <li>
                    <strong>Newsletter Service</strong>: Email address for
                    sending notifications about new posts.
                  </li>
                  <li>
                    <strong>Comments</strong>: Nickname and password (for
                    comment deletion) when posting comments.
                  </li>
                  <li>
                    <strong>Analytics</strong>: Anonymous visit statistics
                    through Google Analytics.
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>2. Cookies</h2>
                <p>This site uses cookies for:</p>
                <ul>
                  <li>
                    <strong>Essential Cookies</strong>: Dark mode and language
                    preferences.
                  </li>
                  <li>
                    <strong>Analytics Cookies</strong>: Google Analytics for
                    visitor statistics.
                  </li>
                  <li>
                    <strong>Advertising Cookies</strong>: Google AdSense for
                    personalized ads.
                  </li>
                </ul>
                <p>
                  You can block cookies through your browser settings, but some
                  features may be limited.
                </p>
              </section>

              <section className={styles.section}>
                <h2>3. Google AdSense</h2>
                <p>
                  This site uses Google AdSense to display advertisements.
                  Google may use cookies to show ads based on your interests.
                  You can opt out of personalized advertising at{" "}
                  <a
                    href="https://adssettings.google.com"
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    Google Ads Settings
                  </a>
                  .
                </p>
              </section>

              <section className={styles.section}>
                <h2>4. Your Rights</h2>
                <p>You may exercise the following rights at any time:</p>
                <ul>
                  <li>Request access, correction, or deletion of personal data</li>
                  <li>Unsubscribe from the newsletter</li>
                  <li>Request comment deletion</li>
                </ul>
                <p>
                  Please contact us at blog@bangjang.net for any requests.
                </p>
              </section>

              <section className={styles.section}>
                <h2>5. Contact</h2>
                <ul>
                  <li>
                    <strong>Responsible Person</strong>: Bangjang (Blog
                    Operator)
                  </li>
                  <li>
                    <strong>Email</strong>: blog@bangjang.net
                  </li>
                </ul>
              </section>

              <section className={styles.section}>
                <h2>6. Changes to This Policy</h2>
                <p>
                  Any changes to this privacy policy will be announced on the
                  blog. Changes will take effect 7 days after posting.
                </p>
              </section>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
