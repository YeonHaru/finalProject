<%--
 Created by IntelliJ IDEA.
 User: user Date: 25. 9. 9.
  Time: 오전 10:21
  To change this template use File | Settings | File Templates.
   --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
%>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">

    <title>추천 도서</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/home.css">

</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>
<div class="page">
    <!-- 추천 도서 배너 -->
    <section class="ad-banner">
        <h2 class="ad-banner-title">편집장의 선택</h2>
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

    <!-- 광고창 아이콘 사이 특별할인 멘트 -->
    <section class="ad-marquee">
        <div class="marquee-content">
            📢 특별 할인! 9월 한정, 인기 도서 최대 30% 할인 중! 🎁 | 신규 회원은 첫 구매 시 추가 쿠폰 지급! ✨ | 이번 주 이벤트: 베스트셀러 1+1!
        </div>
    </section>

    <!-- 아이콘 메뉴 -->
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

    <section class="ad-banner">
        <h2 class="ad-banner-title">이달의 주목도서</h2>
        <div class="ad-banner-books five-books">

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

    <!-- ad-top10 card list -->
    <section class="ad-top10">
        <h2 class="ad-top10-title">어제 베스트셀러 TOP 10</h2>
        <div class="ad-top10-grid">
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
</div>

<!-- === 새로 추가: 전폭 슬라이더 광고 배너 === -->
<div class="slider-ad-container">
    <div class="slider-ad">
        <div class="slider-track">
            <!-- 슬라이드 1: 가을 독서 이벤트 -->
            <div class="slider-item">
                <div class="slider-decoration book1">📚</div>
                <div class="slider-decoration book2">📖</div>
                <div class="slider-content">
                    <h2 class="slider-title">🍂 가을 독서 페스티벌 🍂</h2>
                    <p class="slider-subtitle">9월 한정! 모든 문학도서 25% 할인 + 무료배송</p>
                    <a href="/autumn-event" class="slider-button">지금 구매하기</a>
                </div>
            </div>

            <!-- 슬라이드 2: 멤버십 혜택 -->
            <div class="slider-item">
                <div class="slider-decoration gift">🎁</div>
                <div class="slider-decoration book1">⭐</div>
                <div class="slider-content">
                    <h2 class="slider-title">✨ VIP 멤버십 특가 ✨</h2>
                    <p class="slider-subtitle">프리미엄 회원 가입시 전자책 무제한 이용권 증정!</p>
                    <a href="/membership" class="slider-button">멤버십 가입</a>
                </div>
            </div>

            <!-- 슬라이드 3: 신간 출시 이벤트 -->
            <div class="slider-item">
                <div class="slider-decoration book2">🆕</div>
                <div class="slider-decoration gift">🏆</div>
                <div class="slider-content">
                    <h2 class="slider-title">🔥 이달의 신간 베스트 🔥</h2>
                    <p class="slider-subtitle">화제의 신간도서 예약 주문시 15% 할인 + 굿즈 증정</p>
                    <a href="/new-books" class="slider-button">신간 보러가기</a>
                </div>
            </div>
        </div>

        <!-- 슬라이더 인디케이터 -->
        <div class="slider-indicators">
            <div class="indicator active"></div>
            <div class="indicator"></div>
            <div class="indicator"></div>
        </div>
    </div>
</div>


<script>
    // 슬라이더 인디케이터 업데이트
    const indicators = document.querySelectorAll('.indicator');
    let currentSlide = 0;

    function updateIndicators() {
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === currentSlide);
        });
    }

    // 5초마다 인디케이터 업데이트 (CSS 애니메이션과 동기화)
    setInterval(() => {
        currentSlide = (currentSlide + 1) % 3;
        updateIndicators();
    }, 5000);
</script>
<div class="page">
    <section class="ad-banner">
        <h2 class="ad-banner-title">이달의 주목도서</h2>
        <div class="ad-banner-books five-books">
            <a href="book6.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/60/cover500/k362830605_1.jpg" alt="언어의 온도">
                <div class="ad-book-title">언어의 온도</div>
                <div class="ad-book-author">이기주</div>
            </a>
            <a href="book7.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/55/cover500/k892830605_1.jpg" alt="미드나이트 라이브러리">
                <div class="ad-book-title">미드나이트 라이브러리</div>
                <div class="ad-book-author">매트 헤이그</div>
            </a>
            <a href="book8.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/50/cover500/k712830605_1.jpg" alt="어린왕자">
                <div class="ad-book-title">어린왕자</div>
                <div class="ad-book-author">생텍쥐페리</div>
            </a>
            <a href="book9.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/45/cover500/k622830605_1.jpg" alt="설민석의 한국사 대모험">
                <div class="ad-book-title">설민석의 한국사 대모험</div>
                <div class="ad-book-author">설민석</div>
            </a>
            <a href="book10.jsp" class="ad-book">
                <img src="https://image.aladin.co.kr/product/32659/25/cover500/k512830605_1.jpg" alt="코스모스">
                <div class="ad-book-title">코스모스</div>
                <div class="ad-book-author">칼 세이건</div>
            </a>
        </div>
    </section>
</div>
<!-- 화제의 책 소식 섹션 -->
<div class="page">
    <section class="book-news-section">
        <h2 class="section-title">화제의 책 소식</h2>

        <div class="slider-wrapper">
            <div class="books-slider">
                <!-- 첫 번째 슬라이드 (3권) -->
                <div class="slide-group">
                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/90/cover500/k362830604_1.jpg" alt="수확이 사랑하는 살간형">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">수확이 사랑하는 살간형</h3>
                                <p class="book-description">
                                    앨기구에세 게임, 주호, DNA까지 거리와 작동의 농지를 추적
                                </p>
                                <div class="book-meta">
                                    <span class="category">소설</span>
                                    <span class="rating">★★★★☆</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/95/cover500/k892830604_1.jpg" alt="아버지의 레시피">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">아버지의 레시피</h3>
                                <p class="book-description">
                                    나가가와 히데코, 예세이와 레시피로 완성한 인생 이야기 아름의 요리책
                                </p>
                                <div class="book-meta">
                                    <span class="category">요리/에세이</span>
                                    <span class="rating">★★★★★</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/85/cover500/k712830604_1.jpg" alt="아이스크림 탐정">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">아이스크림 탐정</h3>
                                <p class="book-description">
                                    아이스크림이 녹기 전에 사건을 해결해 주는 아이스크림 탐정의 첫 컵
                                </p>
                                <div class="book-meta">
                                    <span class="category">추리/아동</span>
                                    <span class="rating">★★★★☆</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 두 번째 슬라이드 (3권) -->
                <div class="slide-group">
                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/75/cover500/k622830604_1.jpg" alt="봄날의 서점">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">봄날의 서점</h3>
                                <p class="book-description">
                                    작은 서점에서 펼쳐지는 따뜻한 이야기들과 책을 사랑하는 사람들의 만남
                                </p>
                                <div class="book-meta">
                                    <span class="category">힐링/에세이</span>
                                    <span class="rating">★★★★★</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/60/cover500/k362830605_1.jpg" alt="숲속의 도서관">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">숲속의 도서관</h3>
                                <p class="book-description">
                                    자연과 책이 어우러진 신비로운 공간에서 벌어지는 마법 같은 이야기
                                </p>
                                <div class="book-meta">
                                    <span class="category">판타지</span>
                                    <span class="rating">★★★★☆</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/55/cover500/k892830605_1.jpg" alt="달빛 카페의 비밀">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">달빛 카페의 비밀</h3>
                                <p class="book-description">
                                    밤에만 문을 여는 신비한 카페에서 일어나는 따뜻하고 신비로운 이야기들
                                </p>
                                <div class="book-meta">
                                    <span class="category">로맨스/판타지</span>
                                    <span class="rating">★★★★★</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 세 번째 슬라이드 (3권) -->
                <div class="slide-group">
                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/50/cover500/k712830605_1.jpg" alt="미드나이트 라이브러리">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">미드나이트 라이브러리</h3>
                                <p class="book-description">
                                    인생의 다른 선택들을 경험해볼 수 있는 신비한 도서관 이야기
                                </p>
                                <div class="book-meta">
                                    <span class="category">현대문학</span>
                                    <span class="rating">★★★★★</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/45/cover500/k622830605_1.jpg" alt="언어의 온도">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">언어의 온도</h3>
                                <p class="book-description">
                                    말과 글에 숨겨진 따뜻함과 차가움에 대한 아름다운 에세이
                                </p>
                                <div class="book-meta">
                                    <span class="category">에세이</span>
                                    <span class="rating">★★★★☆</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="book-card">
                        <div class="book-content">
                            <div class="book-image">
                                <img src="https://image.aladin.co.kr/product/32659/25/cover500/k512830605_1.jpg" alt="코스모스">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title">코스모스</h3>
                                <p class="book-description">
                                    우주에 대한 경이로움과 과학적 탐구 정신을 담은 클래식한 명저
                                </p>
                                <div class="book-meta">
                                    <span class="category">과학</span>
                                    <span class="rating">★★★★★</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 네비게이션 -->
        <div class="navigation">
            <button class="nav-btn prev-btn" onclick="prevSlide()">‹ 이전</button>
            <div class="page-indicator">
                <span class="dot active" onclick="currentSlide(1)"></span>
                <span class="dot" onclick="currentSlide(2)"></span>
                <span class="dot" onclick="currentSlide(3)"></span>
            </div>
            <button class="nav-btn next-btn" onclick="nextSlide()">다음 ›</button>
        </div>
    </section>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const slider = document.querySelector('.books-slider');
        const slides = document.querySelectorAll('.books-slider .slide-group');
        const dots = document.querySelectorAll('.dot');
        let slideIndex = 0;

        function showSlide(n) {
            if (n >= slides.length) slideIndex = 0;
            else if (n < 0) slideIndex = slides.length - 1;
            else slideIndex = n;

            slider.style.transform = `translateX(-${slideIndex * 100}%)`;

            dots.forEach((dot, idx) => dot.classList.toggle('active', idx === slideIndex));
        }

        // 버튼 이벤트
        document.querySelector('.prev-btn').addEventListener('click', () => showSlide(slideIndex - 1));
        document.querySelector('.next-btn').addEventListener('click', () => showSlide(slideIndex + 1));

        // 초기 표시
        showSlide(slideIndex);
    });



</script>
</body>
</html>