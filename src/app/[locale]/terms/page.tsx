// app/[locale]/terms/page.tsx
// 이용약관(Terms of Service) 페이지
// ★ 구글 애드센스 승인 필수/권장 법적 고지 페이지
// 서비스 이용 조건, 권리 및 의무, 저작권, 광고 게재에 관한 정책을 안내합니다

import type { Metadata } from "next";
import styles from "./page.module.css";

// 페이지 Props 타입
interface TermsPageProps {
  params: Promise<{ locale: string }>;
}

// SEO 메타데이터
export async function generateMetadata({
  params,
}: TermsPageProps): Promise<Metadata> {
  const { locale } = await params;
  return {
    title: locale === "ko" ? "이용약관" : "Terms of Service",
    description:
      locale === "ko"
        ? "방장 블로그의 서비스 이용약관입니다. 저작권, 콘텐츠 이용, 면책 조항 등을 안내합니다."
        : "Terms of Service of Bangjang Blog. Learn about content usage, copyright, and disclaimer.",
    alternates: {
      canonical: `https://bangjang.net/${locale}/terms`,
      languages: {
        ko: "https://bangjang.net/ko/terms",
        en: "https://bangjang.net/en/terms",
        "x-default": "https://bangjang.net/ko/terms",
      },
    },
  };
}

export default async function TermsPage({ params }: TermsPageProps) {
  const { locale } = await params;

  return (
    <div className={styles.page}>
      <div className="container">
        {/* 페이지 헤더 */}
        <header className={styles.header}>
          <h1 className={styles.title}>
            {locale === "ko" ? "이용약관" : "Terms of Service"}
          </h1>
          <p className={styles.subtitle}>
            {locale === "ko"
              ? "최종 수정일: 2026년 10월 1일"
              : "Last updated: October 1, 2026"}
          </p>
        </header>

        {/* 본문 콘텐츠 */}
        <div className={styles.content}>
          {locale === "ko" ? (
            /* ═══════════════════════════ */
            /* 한국어 이용약관 */
            /* ═══════════════════════════ */
            <>
              <div className={styles.infoBox}>
                <p>
                  본 약관은 <strong>방장 블로그(bangjang.net)</strong>(이하
                  &quot;블로그&quot;)가 제공하는 모든 웹 서비스의 이용 조건 및 절차,
                  이용자와 블로그 간의 권리, 의무 및 책임사항을 규정함을 목적으로
                  합니다.
                </p>
              </div>

              {/* 제1조: 목적 */}
              <section className={styles.section}>
                <h2>제1조 (목적)</h2>
                <p>
                  본 이용약관은 방장 블로그(이하 &quot;운영자&quot;)가 운영하는
                  웹사이트(bangjang.net)에서 제공하는 콘텐츠, 댓글, 뉴스레터 및 제반
                  서비스의 이용과 관련하여 운영자와 이용자 간의 권리, 의무 및 책임
                  사항을 규정함을 목적으로 합니다.
                </p>
              </section>

              {/* 제2조: 약관의 효력 및 변경 */}
              <section className={styles.section}>
                <h2>제2조 (약관의 효력 및 변경)</h2>
                <ol>
                  <li>
                    본 약관은 웹사이트 하단(Footer)에 상시 게시함으로써 효력이
                    발생합니다.
                  </li>
                  <li>
                    운영자는 관련 법령(약관의 규제에 관한 법률, 정보통신망 이용촉진
                    및 정보보호 등에 관한 법률 등)을 위배하지 않는 범위 내에서 본
                    약관을 개정할 수 있습니다.
                  </li>
                  <li>
                    약관이 변경되는 경우, 적용 일자 및 변경 사유를 명시하여 적용일
                    7일 전부터 웹사이트에 공지합니다.
                  </li>
                </ol>
              </section>

              {/* 제3조: 서비스의 제공 및 변경 */}
              <section className={styles.section}>
                <h2>제3조 (서비스의 제공 및 변경)</h2>
                <p>운영자는 다음과 같은 서비스를 제공합니다:</p>
                <ul>
                  <li>웹 개발, AI 활용, 도구 리뷰, 프로그래밍 기술 관련 정보 제공</li>
                  <li>게시글에 대한 댓글 및 피드백 작성 기능</li>
                  <li>최신 글 알림 뉴스레터 발송 서비스</li>
                  <li>기타 운영자가 자체 개발하거나 다른 기관과의 협력 등을 통해 제공하는 서비스</li>
                </ul>
                <p>
                  운영자는 시스템 유지보수, 서버 점검 등의 필요에 의해 사전 공지 후
                  서비스 제공을 일시 중단할 수 있으며, 불가피한 사유가 있는 경우
                  사후에 공지할 수 있습니다.
                </p>
              </section>

              {/* 제4조: 저작권의 귀속 및 콘텐츠 이용 */}
              <section className={styles.section}>
                <h2>제4조 (저작권의 귀속 및 콘텐츠 이용)</h2>
                <ol>
                  <li>
                    블로그에 게시된 모든 텍스트, 코드 예제, 디자인, 로고 등 창작물의
                    저작권 및 지적재산권은 운영자에게 귀속됩니다. (단, 인용된 오픈소스
                    및 공식 인용 자료는 해당 원저작자에게 귀속)
                  </li>
                  <li>
                    이용자는 운영자의 명시적인 사전 서면 동의 없이 블로그의 콘텐츠를
                    무단 복제, 전재, 배포, 2차적 저작물 작성 및 상업적 목적으로 이용할
                    수 없습니다.
                  </li>
                  <li>
                    개인적인 학습 및 비상업적 목적의 공유인 경우, 반드시 출처(URL 및
                    &quot;방장 블로그&quot; 표기)를 명확히 기재하는 조건으로 일부 인용이
                    가능합니다.
                  </li>
                </ol>
              </section>

              {/* 제5조: 이용자의 의무 및 댓글 관리 */}
              <section className={styles.section}>
                <h2>제5조 (이용자의 의무 및 댓글 정책)</h2>
                <p>
                  이용자는 건전한 인터넷 환경 조성을 위해 다음 행위를 하여서는 안
                  됩니다:
                </p>
                <ul>
                  <li>타인의 명예를 훼손하거나 모욕, 음해하는 글 또는 댓글 작성</li>
                  <li>욕설, 비속어, 외설적이거나 폭력적인 메시지 게시</li>
                  <li>영리 목적의 상업 광고, 도배, 스팸 링크 게시</li>
                  <li>바이러스, 악성코드 등을 유포하거나 시스템의 정상 작동을 방해하는 행위</li>
                </ul>
                <p>
                  위 사항을 위반한 댓글은 사전 통보 없이 운영자에 의해 삭제되거나 IP
                  차단 조치가 취해질 수 있습니다.
                </p>
              </section>

              {/* 제6조: 광고 게재 및 제3자 제휴 */}
              <section className={styles.section}>
                <h2>제6조 (광고 게재 및 제3자 제휴)</h2>
                <ol>
                  <li>
                    운영자는 블로그의 지속적인 유지와 양질의 무료 콘텐츠 제공을 위해
                    Google AdSense 등 제3자 광고 사업자의 광고를 웹사이트 내에 게재할
                    수 있습니다.
                  </li>
                  <li>
                    이용자가 블로그 내 게재된 광고를 클릭하거나 외부 링크를 통해
                    연결되는 제3자 사이트에서 발생하는 거래 및 상호작용은 이용자와
                    해당 광고주/제3자 간의 문제이며, 운영자는 이에 대해 일체의 책임을
                    지지 않습니다.
                  </li>
                </ol>
              </section>

              {/* 제7조: 면책 조항 (Disclaimer) */}
              <section className={styles.section}>
                <h2>제7조 (면책 조항)</h2>
                <ol>
                  <li>
                    블로그에 게시된 기술 가이드, 튜토리얼, 코드 예제는 작성 당시의
                    지식과 경험을 바탕으로 성실히 작성되었으나, 소프트웨어 업데이트,
                    버전 변경, 실행 환경에 따라 결과가 다를 수 있습니다.
                  </li>
                  <li>
                    이용자가 블로그의 정보를 활용하여 발생한 직·간접적인 손실이나
                    시스템 장애에 대해 운영자는 법적 책임을 부담하지 않으므로, 중요한
                    프로젝트 적용 전에는 반드시 테스트 및 백업을 수행하시기
                    바랍니다.
                  </li>
                </ol>
              </section>

              {/* 제8조: 문의 및 분쟁 해결 */}
              <section className={styles.section}>
                <h2>제8조 (문의 및 분쟁 해결)</h2>
                <p>
                  본 약관 및 블로그 서비스 이용과 관련한 문의사항이나 제안은 아래
                  이메일로 접수해 주시면 성실히 답변해 드리겠습니다.
                </p>
                <ul>
                  <li>이메일: <strong>bangjang.dev@gmail.com</strong></li>
                </ul>
              </section>
            </>
          ) : (
            /* ═══════════════════════════ */
            /* 영어 이용약관 (English) */
            /* ═══════════════════════════ */
            <>
              <div className={styles.infoBox}>
                <p>
                  These Terms of Service govern your use of the website{" "}
                  <strong>bangjang.net</strong> (referred to as the
                  &quot;Blog&quot;). By accessing this site, you agree to these
                  terms.
                </p>
              </div>

              <section className={styles.section}>
                <h2>1. Acceptance of Terms</h2>
                <p>
                  By accessing and using Bangjang Blog, you agree to be bound by
                  these Terms of Service and all applicable laws and regulations.
                  If you disagree with any part of these terms, you are prohibited
                  from using or accessing this site.
                </p>
              </section>

              <section className={styles.section}>
                <h2>2. Intellectual Property Rights</h2>
                <p>
                  All content, code snippets, graphics, and articles published on
                  this Blog are the intellectual property of Bangjang Blog unless
                  otherwise credited. You may not reproduce, redistribute, or use
                  any materials for commercial purposes without prior written
                  consent.
                </p>
              </section>

              <section className={styles.section}>
                <h2>3. User Conduct &amp; Comments</h2>
                <p>
                  Users agree not to post defamatory, offensive, unlawful, or
                  promotional spam comments. We reserve the right to remove any
                  content that violates our community standards without prior
                  notice.
                </p>
              </section>

              <section className={styles.section}>
                <h2>4. Advertising &amp; Third-Party Services</h2>
                <p>
                  This site displays third-party advertisements (such as Google
                  AdSense). We are not responsible for any transactions,
                  agreements, or damages resulting from interactions with third-party
                  advertisers or external links.
                </p>
              </section>

              <section className={styles.section}>
                <h2>5. Disclaimer</h2>
                <p>
                  The information provided on this Blog is for educational and
                  informational purposes only. While we strive to keep technical
                  tutorials up to date, we make no warranties about the completeness
                  or accuracy of the material.
                </p>
              </section>

              <section className={styles.section}>
                <h2>6. Contact Us</h2>
                <p>
                  For any questions regarding these Terms, please contact us at:{" "}
                  <strong>bangjang.dev@gmail.com</strong>
                </p>
              </section>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
