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

    <head>
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

            .ad-banner-title {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: var(--space-3);
                color: var(--color-accent-dark);
            }

            /* 책 카드 영역 */
            .ad-banner-books {
                display: flex;
                gap: var(--gap-4);
                overflow-x: auto;
                padding-bottom: var(--space-3);
            }

            .ad-book {
                flex: 0 0 160px;
                text-align: center;
                cursor: pointer;
                transition: transform 0.2s var(--ease);
            }

            .ad-book:hover {
                transform: translateY(-5px);
            }

            .ad-book img {
                width: 100%;
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

            /* 하단 탭 메뉴 */
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
        </style>
    </head>
</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>

<div class="page">

    <!-- 추천 도서 배너 -->
    <section class="ad-banner">
        <h2 class="ad-banner-title">추천 도서</h2>

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

</div>

</body>
</html>
