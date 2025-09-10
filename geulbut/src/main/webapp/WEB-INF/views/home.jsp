<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 9. 9.
  Time: 오전 10:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">

    <title>추천 도서</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">

    <!-- 배너 전용 CSS -->
    <style>
        /* 네임스페이스: ad-banner */
        .ad-banner {
            background: var(--color-surface);
            padding: var(--space-4);
            border: 1px solid var(--color-border);
            border-radius: var(--radius);
            box-shadow: var(--shadow-sm);
            margin-top: 40px;
        }

        /* 추천 도서와 같은 글 꾸미는 용도*/
        .ad-banner-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: var(--space-3);
            color: var(--color-accent-dark);
        }

        /* 책 카드 영역 */
        .ad-banner-books {
            display: flex;
            gap: calc(var(--gap-4) * 2);   /* 책 사이 여백 */
            justify-content:  center; /* 책 카드들이 가로로 균등 배치 */
            overflow-x: visible;
            margin-bottom: 10px;
        }

        .ad-book {
            flex: 0 0 180px;
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s var(--ease);
        }

        /*애니메이션 효과*/
        .ad-book:hover {
            transform: translateY(-5px);
        }


        .ad-book img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            box-shadow: var(--shadow-sm);
        }

        .ad-book-title {
            font-size: 0.95rem;
            font-weight: 600;
            margin-top: var(--space-2);
            color: var(--color-text);
        }

        .ad-book-author {
            font-size: 0.8rem;
            color: var(--color-text-light);
        }

        /* 하단에 탭 메뉴 클릭 가능 광고창 */
        .ad-banner-tabs {
            display: flex;
            justify-content: center;
            gap: var(--gap-3);
            border-top: 1px solid var(--color-border);
            padding-top: var(--space-3);
            flex-wrap: wrap;
        }

        .ad-tab {
            font-size: 0.9rem;
            color: var(--color-accent-dark);
            cursor: pointer;
            transition: color 0.2s var(--ease);
        }

        .ad-tab:hover {
            color: var(--color-accent);
        }

        /* 아이콘과 광고창 사이 멘트*/
        .ad-marquee {
            background: var(--color-bg);
            color: var(--color-accent-dark);
            padding: 10px 0;
            overflow: hidden;
            position: relative;
            border-radius: var(--radius-sm);
            margin: var(--space-4) auto;
            max-width: 960px;
        }

        .marquee-content {
            display: inline-block;
            white-space: nowrap;
            animation: marquee 15s linear infinite;
        }

        @keyframes marquee {
            0% { transform: translateX(100%); }
            100% { transform: translateX(-100%); }
        }

        /* === 새로 추가: 아이콘 메뉴 스타일 === */
        .icon-menu {
            background: var(--color-surface);
            padding: var(--space-4);
            border-radius: var(--radius);
            margin-top: var(--space-4);
            box-shadow: var(--shadow-sm);
        }

        .icon-menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: var(--gap-3);
            justify-items: center;
            max-width: 600px;
            margin: 0 auto;
        }

        .icon-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--color-text);
            cursor: pointer;
            transition: all 0.3s var(--ease);
            padding: var(--space-2);
            border-radius: var(--radius-sm);
        }

        .icon-item:hover {
            background: rgba(102, 102, 102, 0.05);
            transform: translateY(-2px);
        }

        .icon-wrapper {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: var(--space-2);
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s var(--ease);
        }

        .icon-item:hover .icon-wrapper {
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
            transform: scale(1.05);
        }

        /* 각 아이콘별 컬러 테마 */
        .icon-item.gift .icon-wrapper { background: linear-gradient(135deg, #fff5f5, #fed7d7); }
        .icon-item.discount .icon-wrapper { background: linear-gradient(135deg, #f0fff4, #c6f6d5); }
        .icon-item.event .icon-wrapper { background: linear-gradient(135deg, #fffaf0, #fbd38d); }
        .icon-item.bestseller .icon-wrapper { background: linear-gradient(135deg, #f7fafc, #bee3f8); }
        .icon-item.review .icon-wrapper { background: linear-gradient(135deg, #faf5ff, #d6bcfa); }

        .icon-label {
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
            line-height: 1.3;
            color: var(--color-text);
        }

        /* 반응형 */
        @media (max-width: 767px) {
            .icon-menu-grid {
                grid-template-columns: repeat(3, 1fr);
                gap: var(--gap-2);
            }

            .icon-wrapper {
                width: 40px;
                height: 40px;
            }

            .icon-label {
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>

<div class="page">



    <!-- 추천 도서 배너 -->
    <section class="ad-banner">
        <h2 class="ad-banner-title">편집장의 선택</h2>


        <!-- 책 카드 영역 -->
        <div class="ad-banner-books">
            <a href="book1.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/90/cover500/k362830604_1.jpg" alt="빼빼 롱스타킹">
                <div class="ad-book-title">빼빼 롱스타킹</div>
                <div class="ad-book-author">아스트리드 린드그렌</div>
            </a>

            <a href="book2.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/95/cover500/k892830604_1.jpg" alt="헬바운드 하트">
                <div class="ad-book-title">헬바운드 하트</div>
                <div class="ad-book-author">클라이브 바커</div>
            </a>

            <a href="book3.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/85/cover500/k712830604_1.jpg" alt="이타미 준 나의 건축">
                <div class="ad-book-title">이타미 준 나의 건축</div>
                <div class="ad-book-author">이타미 준</div>
            </a>

            <a href="book4.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/75/cover500/k622830604_1.jpg" alt="롤랑 바르트가 쓴 롤랑 바르트">
                <div class="ad-book-title">롤랑 바르트가 쓴 롤랑 바르트</div>
                <div class="ad-book-author">롤랑 바르트</div>
            </a>
        </div>

        <!-- 탭 메뉴 -->
        <div class="ad-banner-tabs">
            <div class="ad-tab">편집장의 선택</div>
            <div class="ad-tab">추천 이벤트</div>
            <div class="ad-tab">이 주의 책</div>
            <div class="ad-tab">신간 소개</div>
            <div class="ad-tab">화제의 책</div>
            <div class="ad-tab">이벤트 굿즈</div>
            <div class="ad-tab">지금 핫딜중</div>
        </div>
    </section>
    <!-- // 추천 도서 배너 -->



<%--    광고창 아이콘 사이 특별할인 멘트--%>
    <section class="ad-marquee">
        <div class="marquee-content">
            📢 특별 할인! 9월 한정, 인기 도서 최대 30% 할인 중! 🎁 |
            신규 회원은 첫 구매 시 추가 쿠폰 지급! ✨ |
            이번 주 이벤트: 베스트셀러 1+1!
        </div>
    </section>

    <!-- === 새로 추가: 아이콘 메뉴 === -->
    <section class="icon-menu">
        <div class="icon-menu-grid">
            <a href="/gift" class="icon-item gift">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e53e3e" stroke-width="2">
                        <polyline points="20,12 20,19 4,19 4,12"></polyline>
                        <rect x="2" y="5" width="20" height="7"></rect>
                        <line x1="12" y1="22" x2="12" y2="5"></line>
                        <path d="m9,5 A3,3 0 0,1 6,2 A3,3 0 0,1 9,5 m6,0 A3,3 0 0,0 18,2 A3,3 0 0,0 15,5"></path>
                    </svg>
                </div>
                <span class="icon-label">기프트카드</span>
            </a>

            <a href="/discount" class="icon-item discount">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#38a169" stroke-width="2">
                        <circle cx="8" cy="8" r="6"></circle>
                        <path d="m18.09 10.37 1.51 1.51c.39.39.39 1.02 0 1.41l-8.94 8.94c-.39.39-1.02.39-1.41 0l-1.51-1.51"></path>
                        <path d="m8 8 6 6"></path>
                        <path d="m7 7h.01"></path>
                        <path d="m17 17h.01"></path>
                    </svg>
                </div>
                <span class="icon-label">할인혜택</span>
            </a>

            <a href="/event" class="icon-item event">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#d69e2e" stroke-width="2">
                        <path d="M9 11H3v8h6m11-8h-6v8h6m-7-14v8m-5-5 5 5 5-5"></path>
                    </svg>
                </div>
                <span class="icon-label">이벤트</span>
            </a>

            <a href="/bestseller" class="icon-item bestseller">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3182ce" stroke-width="2">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                    </svg>
                </div>
                <span class="icon-label">베스트셀러</span>
            </a>

            <a href="/review" class="icon-item review">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#805ad5" stroke-width="2">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                        <path d="M8 9h8"></path>
                        <path d="M8 13h6"></path>
                    </svg>
                </div>
                <span class="icon-label">리뷰·추천</span>
            </a>
        </div>
    </section>
    <!-- // 아이콘 메뉴 -->
    <section class="ad-banner">
        <h2 class="ad-banner-title">이달의 주목도서</h2>
        <div class="ad-banner-books">
            <a href="book1.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/90/cover500/k362830604_1.jpg" alt="부모의 태도가 아이의 불안이 되지 않게">
                <div class="ad-book-title">부모의 태도가 아이의 불안이 되지 않게</div>
                <div class="ad-book-author">예슬</div>
            </a>
            <a href="book2.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/95/cover500/k892830604_1.jpg" alt="행운음원">
                <div class="ad-book-title">행운음원</div>
                <div class="ad-book-author">차상동</div>
            </a>
            <a href="book3.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/85/cover500/k712830604_1.jpg" alt="화이트칼라">
                <div class="ad-book-title">화이트칼라</div>
                <div class="ad-book-author">찰스 라이트 밀스</div>
            </a>
            <a href="book4.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/75/cover500/k622830604_1.jpg" alt="AGI, 천사인가 악마인가">
                <div class="ad-book-title">AGI, 천사인가 악마인가</div>
                <div class="ad-book-author">김대식</div>
            </a>
            <a href="book5.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/70/cover500/k512830604_1.jpg" alt="말뚝들">
                <div class="ad-book-title">말뚝들</div>
                <div class="ad-book-author">김홍</div>
            </a>
        </div>
    </section>


</div>

</body>
</html>
