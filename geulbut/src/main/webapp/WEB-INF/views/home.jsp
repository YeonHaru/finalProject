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
    <link rel="stylesheet" href="/css/home.css">


    <style>
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
    <!-- ad-top10 card list (미니멀 · 반응형) -->
    <section class="ad-top10">
        <h2 class="ad-top10-title">어제 베스트셀러 TOP 10</h2>

        <div class="ad-top10-grid">
            <!-- 반복 아이템: 순위 1~10 -->
            <!-- 1위 (특별 강조: gold) -->
            <article class="ad-top10-card top-1">
                <div class="ad-top10-rank">1</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/90/cover500/k362830604_1.jpg" alt="혼한남매 20 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">혼한남매 20</div>
                        <span class="ad-top10-chip new">NEW</span>
                    </div>
                    <div class="ad-top10-author">글 • 그림</div>
                </div>
            </article>

            <!-- 2위 (silver) -->
            <article class="ad-top10-card top-2">
                <div class="ad-top10-rank">2</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/95/cover500/k892830604_1.jpg" alt="절창 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">절창</div>
                        <span class="ad-top10-chip down">▼1</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <!-- 3위 (bronze) -->
            <article class="ad-top10-card top-3">
                <div class="ad-top10-rank">3</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/85/cover500/k712830604_1.jpg" alt="호의에 대하여 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">호의에 대하여</div>
                        <span class="ad-top10-chip up">▲2</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <!-- 4~10위: 동일한 카드 스타일로 계속 -->
            <article class="ad-top10-card">
                <div class="ad-top10-rank">4</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/75/cover500/k622830604_1.jpg" alt="텍스트 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">텟템 이론</div>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <article class="ad-top10-card">
                <div class="ad-top10-rank">5</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/70/cover500/k512830604_1.jpg" alt="혼모노 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">혼모노</div>
                        <span class="ad-top10-chip up">▲1</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <article class="ad-top10-card">
                <div class="ad-top10-rank">6</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/64/cover500/k412830604_1.jpg" alt="천국대마경 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">천국대마경 11</div>
                        <span class="ad-top10-chip new">NEW</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <article class="ad-top10-card">
                <div class="ad-top10-rank">7</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/56/cover500/k312830604_1.jpg" alt="코믹 가이드 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">천국대마경 공식 코믹 가이드</div>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <article class="ad-top10-card">
                <div class="ad-top10-rank">8</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/48/cover500/k212830604_1.jpg" alt="노인과 바다 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">노인과 바다 (멘슬리 클래식)</div>
                        <span class="ad-top10-chip down">▼5</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <article class="ad-top10-card">
                <div class="ad-top10-rank">9</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/40/cover500/k112830604_1.jpg" alt="양명의 조개껍데기 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">양명의 조개껍데기</div>
                        <span class="ad-top10-chip up">▲4</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>

            <article class="ad-top10-card">
                <div class="ad-top10-rank">10</div>
                <img class="ad-top10-thumb" src="https://image.aladin.co.kr/product/32659/35/cover500/k062830604_1.jpg" alt="큰별쌤 표지">
                <div class="ad-top10-body">
                    <div class="ad-top10-titleline">
                        <div class="ad-top10-name">2025 큰별쌤 최태성의 별★…</div>
                        <span class="ad-top10-chip down">▼8</span>
                    </div>
                    <div class="ad-top10-author">저자 예시</div>
                </div>
            </article>
        </div>
    </section>
    <section class="ad-banner-slider">
        <div class="swiper">
            <div class="swiper-wrapper">
                <!-- 광고 1 -->
                <div class="swiper-slide">
                    <div class="ad-banner-item">
                        <img src="https://image.aladin.co.kr/product/32659/90/cover500/k362830604_1.jpg"
                             alt="광고 도서" class="ad-banner-thumb">
                        <div class="ad-banner-text">
                            <p class="ad-banner-desc">가짜 뉴스 시대, 진실의 탈을 쓴 정치 언어의 기만에 속지 않는 법</p>
                            <span class="ad-banner-label">AD</span>
                        </div>
                    </div>
                </div>
                <!-- 광고 2 -->
                <div class="swiper-slide">
                    <div class="ad-banner-item">
                        <img src="https://image.aladin.co.kr/product/32659/85/cover500/k712830604_1.jpg"
                             alt="광고 도서" class="ad-banner-thumb">
                        <div class="ad-banner-text">
                            <p class="ad-banner-desc">지금 주목해야 할 베스트셀러를 만나보세요</p>
                            <span class="ad-banner-label">AD</span>
                        </div>
                    </div>
                </div>
                <!-- 광고 3 -->
                <div class="swiper-slide">
                    <div class="ad-banner-item">
                        <img src="https://image.aladin.co.kr/product/32659/70/cover500/k512830604_1.jpg"
                             alt="광고 도서" class="ad-banner-thumb">
                        <div class="ad-banner-text">
                            <p class="ad-banner-desc">신간 도서 특별 이벤트 진행 중!</p>
                            <span class="ad-banner-label">AD</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 좌우 버튼 -->
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>

            <!-- 페이지 표시 -->
            <div class="swiper-pagination"></div>
        </div>
    </section>

    <!-- Swiper 라이브러리 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

    <script>
        const adSwiper = new Swiper('.ad-banner-slider .swiper', {
            loop: true,
            navigation: {
                nextEl: '.ad-banner-slider .swiper-button-next',
                prevEl: '.ad-banner-slider .swiper-button-prev',
            },
            pagination: {
                el: '.ad-banner-slider .swiper-pagination',
                type: 'fraction',
            },
        });
    </script>


</div>

</body>
</html>
