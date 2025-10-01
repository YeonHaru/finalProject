<%--
 Created by IntelliJ IDEA.
 User: user Date: 25. 9. 9.
  Time: 오전 10:21
  To change this template use File | Settings | File Templates.
   --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>추천 도서</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/footer.css">
    <link rel="stylesheet" href="/css/home.css">

</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>
<div class="page">
    <!-- 편집장의 선택 섹션 -->
    <section class="editor-choice-section">
        <div class="section-header">
            <h2 class="section-title" id="section-title">편집장의 선택</h2>
            <button class="play-button playing" aria-label="재생/정지"></button>
        </div>

        <!-- 편집장의 선택 컨텐츠 -->
        <div class="tab-content editor-choice active" id="editor-choice-content">
            <div class="books-grid">

                <c:forEach var="data" items="${choice}">

                <a href="${pageContext.request.contextPath}/book/${data.bookId}" class="weekly-info-link">
                    <!-- 책 카드 1 -->
                    <div class="book-card">
                            <%--                    <div class="book-badge recommend">추천</div>--%>
                        <div class="book-image">
                            <img src="${data.imgUrl}" alt="${data.title}">
                            <div class="book-number">1</div>
                        </div>
                        <h3 class="book-title"><c:out value="${data.title}"/></h3>
                        <p class="book-author"><c:out value="${data.name}"/></p>
                        <div class="editor-comment">


                            <h4 class="new-book-description"><c:out value="${data.description}"/></h4>

                        </div>

                        <div class="book-rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                        </div>
                    </div>
                    </c:forEach>
                </a>

            </div>

        </div>

        <!-- 신간 소개 컨텐츠 -->
        <div class="tab-content" id="new-books-content">

            <div class="new-books-grid">
                <c:forEach var="data" items="${introductions}">
                    <div class="new-book-card">
                        <div class="new-book-badge">NEW</div>

                        <!-- 책 이미지를 눌렀을 때 bookId 기반 디테일 페이지 -->
                        <a href="${pageContext.request.contextPath}/book/${data.bookId}" class="new-book-link">
                            <div class="new-book-image">
                                <img src="${data.imgUrl}" alt="${data.title}">
                            </div>
                        </a>

                        <h3 class="new-book-title"><c:out value="${data.title}"/></h3>
                        <p class="new-book-author"><c:out value="${data.name}"/></p>
                        <div class="new-book-date"><c:out value="${data.publishedDate}"/></div>
                        <p class="new-book-description"><c:out value="${data.description}"/></p>

                        <button class="new-book-button">예약구매</button>
                    </div>
                </c:forEach>
            </div>
        </div>


        <!-- 화제의 책 컨텐츠 -->
        <div class="tab-content" id="trending-content">
            <div class="trending-grid">
                <!-- 화제의 책 카드 1 -->
                <div class="trending-card">
                    <div class="trending-badge hot">HOT</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/ff6b6b/ffffff?text=Trending1" alt="지금 뜨는 소설">
                        <div class="trending-rank">1</div>
                    </div>
                    <h3 class="trending-title">지금 뜨는 소설</h3>
                    <p class="trending-author">인기작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">🔥 15.2K 언급</div>
                            <div class="stats-trend">↗ 250%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.7)</span>
                    </div>
                </div>

                <!-- 화제의 책 카드 2 -->
                <div class="trending-card">
                    <div class="trending-badge viral">VIRAL</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/764ba2/ffffff?text=Trending2" alt="SNS 화제작">
                        <div class="trending-rank">2</div>
                    </div>
                    <h3 class="trending-title">SNS 화제작</h3>
                    <p class="trending-author">바이럴 작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">📱 12.8K 공유</div>
                            <div class="stats-trend">↗ 320%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.6)</span>
                    </div>
                </div>

                <!-- 화제의 책 카드 3 -->
                <div class="trending-card">
                    <div class="trending-badge rising">상승</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/f093fb/ffffff?text=Trending3" alt="급상승 에세이">
                        <div class="trending-rank">3</div>
                    </div>
                    <h3 class="trending-title">급상승 에세이</h3>
                    <p class="trending-author">트렌드 작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">💬 9.5K 댓글</div>
                            <div class="stats-trend">↗ 180%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.8)</span>
                    </div>
                </div>

                <!-- 화제의 책 카드 4 -->
                <div class="trending-card">
                    <div class="trending-badge hot">인기</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/4facfe/ffffff?text=Trending4" alt="논란의 작품">
                        <div class="trending-rank">4</div>
                    </div>
                    <h3 class="trending-title">논란의 작품</h3>
                    <p class="trending-author">논쟁 작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">⚡ 18.7K 토론</div>
                            <div class="stats-trend">↗ 400%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.5)</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 지금 핫딜중 컨텐츠 -->
        <div class="tab-content" id="hotdeal-content">
            <div class="hotdeal-grid">
                <!-- 핫딜 카드 1 -->
                <div class="hotdeal-card">
                    <div class="hotdeal-badge discount-30">30% OFF</div>
                    <div class="hotdeal-image">
                        <img src="https://via.placeholder.com/200x180/4facfe/ffffff?text=설민석의+조선왕조실록" alt="설민석의 조선왕조실록">
                    </div>
                    <h3 class="hotdeal-title">설민석의 조선왕조실록</h3>
                    <p class="hotdeal-author">설민석</p>
                    <div class="hotdeal-prices">
                        <span class="original-price">22,000원</span>
                        <span class="sale-price">15,400원</span>
                    </div>

                    <div class="hotdeal-time">장바구니🛒</div>

                    <button class="hotdeal-button">구매하기</button>
                </div>
            </div>
        </div>

        <!-- 추천 이벤트 컨텐츠 -->
        <div class="tab-content" id="event-content">
            <div class="event-grid">
                <!-- 이벤트 카드 1 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/667eea/ffffff?text=Event1" alt="감영하 작가 싸인회">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">감영하 작가 싸인회</h3>
                        <div class="event-info">
                            <div class="event-date">📅 2024년 9월 21일</div>
                            <div class="event-location">📍 고복문고 광화문점</div>
                            <div class="event-time">🕐 오후 2시</div>
                        </div>
                    </div>
                </div>

                <!-- 이벤트 카드 2 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/764ba2/ffffff?text=Event2" alt="독서모임 '책과 함께'">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">독서모임 '책과 함께'</h3>
                        <div class="event-info">
                            <div class="event-date">📅 매주 토요일</div>
                            <div class="event-location">📍 양라단 서점 홍대점</div>
                            <div class="event-time">🕐 오후 7시</div>
                        </div>
                    </div>
                </div>

                <!-- 이벤트 카드 3 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/f093fb/ffffff?text=Event3" alt="신간 출간기념 북토크">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">신간 출간기념 북토크</h3>
                        <div class="event-info">
                            <div class="event-date">📅 2024년 9월 25일</div>
                            <div class="event-location">📍 온라인 라이브</div>
                            <div class="event-time">🕐 오후 8시</div>
                        </div>
                    </div>
                </div>

                <!-- 이벤트 카드 4 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/4facfe/ffffff?text=Event4" alt="출리소설 토론회">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">출리소설 토론회</h3>
                        <div class="event-info">
                            <div class="event-date">📅 2024년 9월 30일</div>
                            <div class="event-location">📍 YES24 강남점</div>
                            <div class="event-time">🕐 오후 3시</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 이벤트 굿즈 컨텐츠 -->
        <div class="tab-content" id="goods-content">
            <div class="goods-grid">
                <!-- 굿즈 카드 1 -->
                <div class="goods-card">
                    <div class="goods-badge special">한정</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/ff6b6b/ffffff?text=Goods1" alt="북페딘 감성우산">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">북페딘 감성우산</h3>
                        <div class="goods-period">📅 2025.01.15 ~ 2025.02.28</div>
                        <div class="goods-publisher">지금출간: 첫 구매</div>
                        <div class="goods-author">분야: 패션</div>
                        <div class="goods-price">
                            <span class="current-price">29,000원</span>
                            <span class="discount">35% 할인</span>
                        </div>
                    </div>
                </div>

                <!-- 굿즈 카드 2 -->
                <div class="goods-card">
                    <div class="goods-badge new">NEW</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/764ba2/ffffff?text=Goods2" alt="달빛 무드등">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">달빛 무드등</h3>
                        <div class="goods-period">📅 2025.01.20 ~ 2025.03.15</div>
                        <div class="goods-publisher">지금출간: 회독가입</div>
                        <div class="goods-author">분야: 인테리어</div>
                        <div class="goods-price">
                            <span class="current-price">42,000원</span>
                            <span class="discount">30% 할인</span>
                        </div>
                    </div>
                </div>

                <!-- 굿즈 카드 3 -->
                <div class="goods-card">
                    <div class="goods-badge hot">HOT</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/4facfe/ffffff?text=Goods3" alt="도서관 향 캔들">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">도서관 향 캔들</h3>
                        <div class="goods-period">📅 2025.01.10 ~ 2025.02.20</div>
                        <div class="goods-publisher">지금출간: 리뷰작성</div>
                        <div class="goods-author">분야: 라이프</div>
                        <div class="goods-price">
                            <span class="current-price">18,000원</span>
                            <span class="discount">25% 할인</span>
                        </div>
                    </div>
                </div>

                <!-- 굿즈 카드 4 -->
                <div class="goods-card">
                    <div class="goods-badge best">BEST</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/f093fb/ffffff?text=Goods4" alt="독서 블루라이트 안경">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">독서 블루라이트 안경</h3>
                        <div class="goods-period">📅 2025.01.25 ~ 2025.03.10</div>
                        <div class="goods-publisher">지금출간: 멤십자</div>
                        <div class="goods-author">분야: 헬스케어</div>
                        <div class="goods-price">
                            <span class="current-price">33,000원</span>
                            <span class="discount">40% 할인</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 이 주의 책 컨텐츠 -->
        <div class="tab-content" id="weekly-content">
            <div class="weekly-grid">
                <c:forEach var="book" items="${weeklyBooks}">
                    <div class="weekly-card">
                        <div class="weekly-badge">이주의책</div>


                        <!-- 이미지 영역 클릭 시 책 디테일 페이지로 이동 -->
                        <a href="${pageContext.request.contextPath}/book/${book.bookId}" class="weekly-image-link">
                            <div class="weekly-image">
                                <img src="${book.imgUrl}" alt="${book.title}"/>
                            </div>
                        </a>

                        <!-- 정보 영역 클릭 시 책 디테일 페이지로 이동 -->
                        <a href="${pageContext.request.contextPath}/book/${book.bookId}" class="weekly-info-link">
                            <div class="weekly-info">
                                <h3 class="weekly-title">
                                    <c:choose>
                                        <c:when test="${fn:length(book.title) > 30}">
                                            ${fn:substring(book.title, 0, 30)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${book.title}
                                        </c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="weekly-author"><c:out value="${book.authorName}"/></p>
                                <div class="weekly-rating">
                                    <span class="star">⭐</span>
                                    <span class="rating-score">4.5</span>
                                    <span class="rating-text">평점</span>
                                </div>
                                <div class="weekly-comment">
                                    <p class="comment-text"><c:out value="${book.description}"/></p>
                                </div>

                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>


        <!-- 탭 메뉴 -->
        <div class="tab-menu">
            <button class="tab-item active" onclick="showTab('editor-choice-content', '편집장의 선택')">편집장의 선택</button>
            <button class="tab-item" onclick="showTab('new-books-content', '추천 이벤트')">추천 이벤트</button>
            <button class="tab-item" onclick="showTab('trending-content', '이 주의 책')">이 주의 책</button>
            <button class="tab-item" onclick="showTab('hotdeal-content', '신간 소개')">신간 소개</button>
            <button class="tab-item" onclick="showTab('event-content', '화제의 책')">화제의 책</button>
            <button class="tab-item" onclick="showTab('goods-content', '이벤트 굿즈')">이벤트 굿즈</button>
            <button class="tab-item" onclick="showTab('weekly-content', '지금 핫딜중')">지금 핫딜중</button>
        </div>
    </section>

    <!-- 광고창 -->
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

    <!-- 이달의 주목도서 -->

    <section class="featured-books">
        <div class="featured-header">
            <div class="featured-title-area">
                <div class="bookmark-icon">📑</div>
                <div class="featured-title-text">
                    <h2 class="featured-main-title">이달의 주목도서</h2>
                    <p class="featured-subtitle">
                        <c:choose>
                            <c:when test="${not empty featuredBooks}">
                                편집부가 엄선한 ${fn:length(featuredBooks)}권
                            </c:when>
                            <c:otherwise>데이터 준비 중</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
            <div class="hot-indicator">🔥 Hot 5</div>
        </div>

        <c:if test="${empty featuredBooks}">
            <div class="featured-empty">등록된 주목도서가 없습니다. 곧 업데이트됩니다.</div>
        </c:if>

        <c:if test="${not empty featuredBooks}">
            <div class="featured-books-grid">
                <c:forEach var="b" items="${featuredBooks}">
                    <div class="featured-book-card">
                        <div class="book-info-top">
                            <!-- 외부 API에는 할인/카테고리 정보가 없으니 뱃지는 숨기거나 고정 텍스트로 처리 -->
                            <!-- <div class="discount-badge">10%</div> -->
                            <!-- <div class="category-tag">화제의 신간</div> -->
                        </div>

                        <a href="${pageContext.request.contextPath}/book/${b.bookId}" class="featured-book-link">
                            <div class="featured-book-image">
                                <img
                                        src="${empty b.imgUrl ? 'https://via.placeholder.com/160x220/cccccc/000000?text=No+Image' : b.imgUrl}"
                                        alt="${b.title}"
                                        onerror="this.src='https://via.placeholder.com/160x220/cccccc/000000?text=No+Image'"/>
                            </div>
                        </a>

                        <div class="featured-book-info">
                            <h3 class="featured-book-title"><c:out value="${b.title}"/></h3>

                            <p class="featured-book-author">
                                <c:out value="${b.authorName}"/>
                            </p>

                            <div class="book-rating">
                                <!-- 외부 API에 평점/리뷰 없음 → UI 유지 위해 임시 숨김 -->
                                <!-- <span class="stars">★ 4.8</span><span class="review-count">(115)</span> -->
                            </div>

                            <div class="book-price">
                                <!-- 외부 API에 가격 없음 → 숨김 -->
                                <!-- <span class="current-price">14,400원</span>
                                     <span class="original-price">16,000원</span> -->
                            </div>

                            <p class="book-description">
                                <c:out value="${b.description}"/>
                            </p>

                            <!-- 상세 링크가 없으니 버튼도 숨김 또는 검색 링크로 대체 -->
                            <!-- <a class="detail-button" href="/search?kwd=${fn:escapeXml(b.title)}">자세히 보기</a> -->
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="view-all-link">
                <a href="/featured-books">⏰ 이달의 추천도서 전체보기</a>
            </div>
        </c:if>
    </section>


    <!-- 어제 베스트셀러 TOP 10 -->
    <section class="bestseller-section">
        <h2 class="bestseller-title">
            어제 베스트셀러 TOP 10
            <small style="font-size:12px;color:#888;">(누적 판매 기준 v1)</small>
        </h2>

        <c:if test="${empty bestSellers}">
            <div class="featured-empty">데이터 준비 중</div>
        </c:if>

        <c:if test="${not empty bestSellers}">
            <div class="bestseller-grid">
                <c:forEach var="b" items="${bestSellers}" varStatus="s">
                    <c:url var="detailUrl" value="/book/${b.bookId}"/>

                    <a class="bestseller-item" href="${detailUrl}">
                        <div class="rank-number ${s.index lt 3 ? ('rank-' += (s.index + 1)) : ''}">
                                ${s.index + 1}
                        </div>

                        <img class="bestseller-thumb"
                             src="${empty b.imgUrl ? 'https://via.placeholder.com/60x80/cccccc/000000?text=No+Image' : b.imgUrl}"
                             alt="${fn:escapeXml(b.title)}"
                             onerror="this.src='https://via.placeholder.com/60x80/cccccc/000000?text=No+Image'"/>

                        <div class="bestseller-info">
                            <div class="bestseller-title-line">
                                <h3 class="bestseller-book-title">${b.title}</h3>
                            </div>
                            <p class="bestseller-author">${b.authorName}</p>
                            <div class="count">판매: ${b.orderCount}권</div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>
    </section>

    <!-- 전폭 슬라이더 광고 배너 -->
    <!-- 큰 도서 광고창 -->
    <section class="slider-ad-container">
        <div class="slider-ad">
            <button class="slider-nav prev" onclick="prevBanner()">‹</button>
            <button class="slider-nav next" onclick="nextBanner()">›</button>
            <div class="slider-track" id="sliderTrack">
                <div class="slider-item">
                    <div class="slider-content">
                        <h2 class="slider-title">🍂 가을 독서 페스티벌 🍂</h2>
                        <p class="slider-subtitle">9월 한정! 모든 문학도서 25% 할인 + 무료배송</p>
                        <a href="/autumn-event" class="slider-button">지금 구매하기</a>
                    </div>
                </div>
                <div class="slider-item">
                    <div class="slider-content">
                        <h2 class="slider-title">✨ VIP 멤버십 특가 ✨</h2>
                        <p class="slider-subtitle">프리미엄 회원 가입시 전자책 무제한 이용권 증정!</p>
                        <a href="/membership" class="slider-button">멤버십 가입</a>
                    </div>
                </div>
                <div class="slider-item">
                    <div class="slider-content">
                        <h2 class="slider-title">🔥 이달의 신간 베스트 🔥</h2>
                        <p class="slider-subtitle">화제의 신간도서 예약 주문시 15% 할인 + 굿즈 증정</p>
                        <a href="/new-books" class="slider-button">신간 보러가기</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 화제의 책 소식 섹션 -->
    <section class="hot-news-section">
        <h2 class="hot-news-title">화제의 책 소식</h2>

        <c:choose>
            <c:when test="${empty hotNews}">
                <div class="featured-empty">데이터 준비 중</div>
            </c:when>


            <c:otherwise>
                <div class="hot-news-slider">
                    <div class="hot-news-container">
                        <div class="hot-news-page active">
                            <div class="hot-news-grid">
                                <c:forEach var="b" items="${hotNews}" varStatus="s">
                                    <c:url var="detailUrl" value="/book/${b.bookId}"/>

                                    <div class="hot-news-card">
                                        <div class="card-header">
                                            <span class="rank-badge rank-${s.index + 1}">#${s.index + 1}</span>
                                            <span class="status-badge ${s.index==0 ? 'hot' : (s.index==1 ? 'best' : 'new')}">
                                                    ${s.index==0 ? 'HOT' : (s.index==1 ? 'BEST' : 'NEW')}
                                            </span>
                                        </div>

                                        <div class="book-cover">
                                            <a href="${detailUrl}" aria-label="${fn:escapeXml(b.title)} 상세보기">
                                                <img
                                                        src="${empty b.imgUrl ? 'https://via.placeholder.com/200x280/cccccc/000000?text=No+Image' : b.imgUrl}"
                                                        alt="<c:out value='${b.title}'/>"
                                                        onerror="this.src='https://via.placeholder.com/200x280/cccccc/000000?text=No+Image'">
                                            </a>
                                        </div>

                                        <div class="book-content">
                                            <h3 class="book-title">
                                                <a href="${detailUrl}"><c:out value="${b.title}"/></a>
                                            </h3>
                                            <p class="book-author"><c:out value="${b.authorName}"/></p>

                                            <p class="book-description"><c:out value="${b.description}"/></p>

                                            <div class="book-meta">
                                                <span class="meta-order">판매 ${b.orderCount}권</span>
                                                <span class="meta-wish">위시 ${b.wishCount}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </section>


    <!-- 프로모션 세션 2칸씩 있는 도서 광고창 -->
    <section class="promotion-section">
        <div class="promotion-slider">
            <!-- 슬라이더 화살표 -->
            <button class="promo-slider-btn prev" id="promoPrevBtn"><</button>
            <button class="promo-slider-btn next" id="promoNextBtn">></button>

            <div class="promotion-container">
                <!-- 첫 번째 페이지 -->
                <div class="promotion-page active">
                    <div class="promotion-grid">
                        <!-- 베스트셀러 프로모션 -->
                        <div class="promotion-card bestseller-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                     stroke-width="2">
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                </svg>
                                <span>선간</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">베스트셀러 1위</h3>
                                <h4 class="promo-subtitle">「달러구트 꿈의 서점」, 신작 출간</h4>
                                <p class="promo-description">전국 서점가 화제! 특별 예약판매 30% 할인</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/667eea/ffffff?text=달러구트+꿈의+서점"
                                     alt="달러구트 꿈의 서점">
                            </div>
                        </div>

                        <!-- MD 추천 프로모션 -->
                        <div class="promotion-card md-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                     stroke-width="2">
                                    <path d="M9 11H3v8h6m11-8h-6v8h6m-7-14v8m-5-5 5 5 5-5"></path>
                                </svg>
                                <span>MD추천</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">자기계발 MD 추천</h3>
                                <h4 class="promo-subtitle">「아주 작은 습관의 힘」</h4>
                                <p class="promo-description">올해 가장 많이 읽힌 자기계발서, 리뷰 이벤트 진행 중</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/f97316/ffffff?text=아주+작은+습관의+힘"
                                     alt="아주 작은 습관의 힘">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 두 번째 페이지 -->
                <div class="promotion-page">
                    <div class="promotion-grid">
                        <!-- 신간 프로모션 -->
                        <div class="promotion-card new-book-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                     stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14,2 14,8 20,8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                    <polyline points="10,9 9,9 8,9"></polyline>
                                </svg>
                                <span>신간</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">9월 화제의 신간</h3>
                                <h4 class="promo-subtitle">「미드나잇 라이브러리」</h4>
                                <p class="promo-description">전 세계 독자들의 찬사! 선주문 시 한정 굿즈 증정</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/10b981/ffffff?text=미드나잇+라이브러리"
                                     alt="미드나잇 라이브러리">
                            </div>
                        </div>

                        <!-- 오디오북 프로모션 -->
                        <div class="promotion-card audiobook-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                     stroke-width="2">
                                    <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                                    <path d="m19.07 4.93-1.4 1.4A6.5 6.5 0 0 1 19.5 12a6.5 6.5 0 0 1-1.83 5.67l1.4 1.4A8.5 8.5 0 0 0 21.5 12a8.5 8.5 0 0 0-2.43-7.07z"></path>
                                    <path d="m15.54 8.46-1.4 1.4A2.5 2.5 0 0 1 15.5 12a2.5 2.5 0 0 1-1.36 2.14l1.4 1.4A4.5 4.5 0 0 0 17.5 12a4.5 4.5 0 0 0-1.96-4.54z"></path>
                                </svg>
                                <span>오디오</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">오디오북 특가</h3>
                                <h4 class="promo-subtitle">「사피엔스」 오디오북</h4>
                                <p class="promo-description">성우 김영철 낭독! 첫 구매 고객 50% 할인 혜택</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/6366f1/ffffff?text=사피엔스+오디오북"
                                     alt="사피엔스 오디오북">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="promotion-footer">
            <p class="promotion-notice">
                <span class="notice-dot">●</span>
                매주 새로운 책 프로모션, 독자 여러분을 위한 특별한 혜택
            </p>
        </div>
    </section>

    <!-- 이 주의 특가 섹션 -->
    <section class="weekly-special-section">
        <div class="special-header">
            <div class="special-title-area">
                <span class="special-icon">🏷️</span>
                <div class="special-title-text">
                    <h2 class="special-main-title">이 주의 특가</h2>
                    <p class="special-subtitle">최대 80% 할인</p>
                </div>
            </div>
        </div>

        <div class="special-books-grid">
            <!-- 특가 도서 카드 1 -->
            <c:forEach var="b" items="${weeklySpecials}">
                <c:set var="rate" value="${(b.price - b.discountedPrice) * 100.0 / b.price}"/>
                <c:url var="detailUrl" value="/book/${b.bookId}"/>

                <div class="special-book-card">
                    <div class="special-badges">
                        <div class="discount-percent">% 70%</div>
                        <div class="days-left">2일 남음</div>
                    </div>

                    <div class="special-book-image">
                        <a href="${detailUrl}">
                            <img src="${b.imgUrl}" alt="${fn:escapeXml(b.title)}">
                        </a>
                    </div>

                    <div class="special-book-info">
                        <div class="book-category">${fn:escapeXml(b.categoryName)}</div>
                        <h3 class="special-book-title">
                            <a href="${detailUrl}"> ${fn:escapeXml(b.title)}</a>
                        </h3>
                        <p class="special-book-author">${fn:escapeXml(b.authorName)}</p>
                        <div class="special-price-info">
                            <span class="original-price"><fmt:formatNumber value="${b.price}" pattern="#,##0"/>원</span>
                            <span class="special-price"><fmt:formatNumber value="${b.discountedPrice}" pattern="#,##0"/>원</span>
                            <span class="price-label">적립</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="special-notice">
            <div class="notice-text">
                <span class="notice-icon">⚠️</span>
                특가 할인은 매주 일요일 자정에 종료됩니다
            </div>
            <button class="view-all-special-btn">전체 특가 보기</button>
        </div>
    </section>

    <!-- 오디오북 섹션 -->
    <section class="audiobook-section">
        <div class="audiobook-header">
            <div class="audiobook-title-area">
                <div class="audiobook-icon">🎧</div>
                <div class="audiobook-title-text">
                    <h2 class="audiobook-main-title">글벗 오디오북</h2>
                    <p class="audiobook-subtitle">언제 어디서나 듣는 독서의 새로운 경험</p>
                </div>
            </div>
            <div class="audiobook-actions">
                <button class="free-trial-btn">▶ 무료 체험 가능</button>
                <a href="/audiobooks" class="audiobook-more-link">전체보기 ></a>
            </div>
        </div>

        <div class="audiobook-grid">
            <!-- 오디오북 카드 1 -->
            <div class="audiobook-card">
                <div class="audiobook-badge new">NEW</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/667eea/ffffff?text=미스터리+카페의+비밀" alt="미스터리 카페의 비밀">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">7시간 32분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.8</span>
                        <span class="audiobook-category">스릴러</span>
                    </div>
                    <h3 class="audiobook-title">미스터리 카페의 비밀</h3>
                    <p class="audiobook-author">저자: 김수진</p>
                    <p class="audiobook-narrator">낭독: 박지혜</p>
                </div>
            </div>

            <!-- 오디오북 카드 2 -->
            <div class="audiobook-card">
                <div class="audiobook-badge popular">인기</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/2d3748/ffffff?text=심야+추리소설" alt="심야 추리소설">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">9시간 15분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.6</span>
                        <span class="audiobook-category">미스터리</span>
                    </div>
                    <h3 class="audiobook-title">심야 추리소설</h3>
                    <p class="audiobook-author">저자: 이정민</p>
                    <p class="audiobook-narrator">낭독: 김동원</p>
                </div>
            </div>

            <!-- 오디오북 카드 3 -->
            <div class="audiobook-card">
                <div class="audiobook-badge new">NEW</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/4ecdc4/ffffff?text=라자+센빌리티" alt="라자 센빌리티">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">6시간 48분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.9</span>
                        <span class="audiobook-category">로맨스</span>
                    </div>
                    <h3 class="audiobook-title">라자 센빌리티</h3>
                    <p class="audiobook-author">저자: 박소영</p>
                    <p class="audiobook-narrator">낭독: 최향울</p>
                </div>
            </div>

            <!-- 오디오북 카드 4 -->
            <div class="audiobook-card">
                <div class="audiobook-badge popular">인기</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/f9ca24/ffffff?text=창업가의+회고록" alt="창업가의 회고록">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">8시간 22분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.7</span>
                        <span class="audiobook-category">자서전</span>
                    </div>
                    <h3 class="audiobook-title">창업가의 회고록</h3>
                    <p class="audiobook-author">저자: 정태호</p>
                    <p class="audiobook-narrator">낭독: 김영우</p>
                </div>
            </div>

            <!-- 오디오북 카드 5 -->
            <div class="audiobook-card">
                <div class="audiobook-badge popular">인기</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/805ad5/ffffff?text=우주+탐험기" alt="우주 탐험기">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">10시간 5분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.5</span>
                        <span class="audiobook-category">SF</span>
                    </div>
                    <h3 class="audiobook-title">우주 탐험기</h3>
                    <p class="audiobook-author">저자: 김과학</p>
                    <p class="audiobook-narrator">낭독: 이우주</p>
                </div>
            </div>
        </div>

        <!-- 오디오북 프로모션 -->
        <div class="audiobook-promotion">
            <div class="promo-content-box">
                <div class="promo-icon-large">🎧</div>
                <div class="promo-text">
                    <h3 class="promo-main-title">첫 달 무료체험</h3>
                    <p class="promo-description">매월 1권 무료 + 30% 할인혜택</p>
                </div>
                <button class="start-trial-btn">무료체험 시작하기</button>
            </div>
            <a href="/audiobooks-all" class="more-audiobooks-link">더 많은 오디오북 보기</a>
        </div>
    </section>

    <!-- 수상 섹션 -->
    <section class="awards-section">
        <div class="awards-header">
            <h2>수상 및 인증</h2>
            <p>고객님께 더 나은 서비스를 제공하기 위한 저희의 노력이 다양한 기관으로부터 인정받고 있습니다.</p>
        </div>
        <div class="awards-cards">
            <div class="award-card yellow">
                <div class="icon">🏆</div>
                <div class="year">2024년</div>
                <div class="title">대한민국 우수서점상</div>
                <div class="subtitle">문화체육관광부 장관상</div>
                <div class="desc">고객 서비스 및 도서 큐레이션 부문</div>
            </div>
            <div class="award-card lightblue">
                <div class="icon">🥇</div>
                <div class="year">2023년</div>
                <div class="title">온라인 서점 대상</div>
                <div class="subtitle">한국서점협회</div>
                <div class="desc">디지털 혁신 및 사용자 경험</div>
            </div>
            <div class="award-card orange">
                <div class="icon">🎖️</div>
                <div class="year">2023년</div>
                <div class="title">베스트 북커머스</div>
                <div class="subtitle">온라인쇼핑몰협회</div>
                <div class="desc">고객 만족도 최우수</div>
            </div>
            <div class="award-card blue">
                <div class="icon">⭐</div>
                <div class="year">2022년</div>
                <div class="title">독서문화진흥 공로상</div>
                <div class="subtitle">국립중앙도서관</div>
                <div class="desc">지역 독서문화 확산 기여</div>
            </div>
        </div>
        <div class="awards-footer">
            <p>신뢰할 수 있는 온라인 서점</p>
            <p>2020년부터 지금까지 누적 고객 만족도 98.5%를 달성하며, 독자 여러분께 사랑받는 서점으로 성장해왔습니다. 앞으로도 더 나은 독서 환경을 만들어 나가겠습니다.</p>
            <div class="features">
                <span class="feature red">● 안전한 결제 시스템</span>
                <span class="feature green">● 신속한 배송 서비스</span>
                <span class="feature navy">● 전문 큐레이션</span>
                <span class="feature yellow">● 24시간 고객지원</span>
            </div>
        </div>
    </section>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {

        /*** === 편집장의 선택 (탭 자동 슬라이드) === ***/
        let currentTabIndex = 0;
        let autoSlideInterval = null;
        let isPlaying = false;
        const autoSlideDelay = 4000;

        const tabItems = document.querySelectorAll('.tab-item');
        const playButton = document.querySelector('.play-button');

        const tabContents = [
            'editor-choice-content',
            'event-content',
            'weekly-content',
            'new-books-content',
            'trending-content',
            'goods-content',
            'hotdeal-content'
        ];

        const tabTexts = [
            '편집장의 선택',
            '추천 이벤트',
            '이 주의 책',
            '신간 소개',
            '화제의 책',
            '이벤트 굿즈',
            '지금 핫딜중'
        ];

        function showTabContent(tabIndex) {
            tabItems.forEach(t => t.classList.remove('active'));
            if (tabItems[tabIndex]) {
                tabItems[tabIndex].classList.add('active');
            }

            tabContents.forEach(contentId => {
                const content = document.getElementById(contentId);
                if (content) {
                    content.style.display = 'none';
                    content.classList.remove('active');
                }
            });

            const activeContent = document.getElementById(tabContents[tabIndex]);
            if (activeContent) {
                activeContent.style.display = 'block';
                activeContent.classList.add('active');
            }

            const sectionTitle = document.getElementById('section-title');
            if (sectionTitle) {
                sectionTitle.textContent = tabTexts[tabIndex];
            }

            currentTabIndex = tabIndex;
        }

        function nextTabSlide() {
            currentTabIndex = (currentTabIndex + 1) % tabContents.length;
            showTabContent(currentTabIndex);
        }

        function prevTabSlide() {
            currentTabIndex = (currentTabIndex - 1 + tabContents.length) % tabContents.length;
            showTabContent(currentTabIndex);
        }

        function startAutoSlide() {
            if (!isPlaying) {
                isPlaying = true;
                autoSlideInterval = setInterval(nextTabSlide, autoSlideDelay);
                playButton.classList.remove('playing');
                playButton.classList.add('paused');
            }
        }

        function stopAutoSlide() {
            if (isPlaying) {
                isPlaying = false;
                clearInterval(autoSlideInterval);
                autoSlideInterval = null;
                playButton.classList.remove('paused');
                playButton.classList.add('playing');
            }
        }

        if (playButton) {
            playButton.addEventListener('click', function () {
                if (isPlaying) {
                    stopAutoSlide();
                } else {
                    startAutoSlide();
                }
            });
        }

        if (tabItems.length > 0) {
            tabItems.forEach((tab, index) => {
                tab.addEventListener('click', function () {
                    if (isPlaying) {
                        stopAutoSlide();
                    }
                    showTabContent(index);
                });
            });
        }

        // === 탭용 전역 함수 등록 ===
        window.nextTab = function () {
            if (isPlaying) stopAutoSlide();
            nextTabSlide();
        };

        window.prevTab = function () {
            if (isPlaying) stopAutoSlide();
            prevTabSlide();
        };

        showTabContent(0);
        setTimeout(() => {
            startAutoSlide();
        }, 1000);

        /*** === 큰 광고 배너 슬라이드 === ***/
        let currentBannerSlide = 0;
        const totalBannerSlides = 3;
        let bannerInterval = null;
        let userInteracting = false;

        function updateBannerSlider() {
            const sliderTrack = document.getElementById('sliderTrack');
            if (sliderTrack) {
                const translateX = -currentBannerSlide * 33.333;
                sliderTrack.style.transform = `translateX(${translateX}%)`;
            }
        }

        function nextBannerSlide() {
            currentBannerSlide = (currentBannerSlide + 1) % totalBannerSlides;
            updateBannerSlider();
        }

        function prevBannerSlide() {
            currentBannerSlide = (currentBannerSlide - 1 + totalBannerSlides) % totalBannerSlides;
            updateBannerSlider();
        }

        function startBannerAutoSlide() {
            bannerInterval = setInterval(() => {
                if (!userInteracting) {
                    nextBannerSlide();
                }
            }, 4000);
        }

        function stopBannerAutoSlide() {
            if (bannerInterval) {
                clearInterval(bannerInterval);
                bannerInterval = null;
            }
        }

        function resetBannerAutoSlide() {
            stopBannerAutoSlide();
            userInteracting = false;
            setTimeout(() => {
                startBannerAutoSlide();
            }, 3000);
        }

        // 전역 등록 (HTML 버튼에서 호출 가능)
        window.nextBanner = function () {
            userInteracting = true;
            stopBannerAutoSlide();
            nextBannerSlide();
            resetBannerAutoSlide();
        }

        window.prevBanner = function () {
            userInteracting = true;
            stopBannerAutoSlide();
            prevBannerSlide();
            resetBannerAutoSlide();
        }

        // 배너 자동 시작
        setTimeout(() => {
            startBannerAutoSlide();
        }, 2000);

        console.log('BookStore 웹사이트가 성공적으로 로드되었습니다!');
    });
    /*** === 2칸 프로모션 슬라이드 (active 토글 방식) === ***/
    (function initPromotionSliderByActive(){
        const pages = Array.from(document.querySelectorAll('.promotion-page'));
        const prevBtn = document.getElementById('promoPrevBtn');
        const nextBtn = document.getElementById('promoNextBtn');
        if (!pages.length || !prevBtn || !nextBtn) return;

        // 현재 인덱스 계산 (없으면 0)
        let idx = Math.max(0, pages.findIndex(p => p.classList.contains('active')));
        if (idx === -1) { idx = 0; pages[0].classList.add('active'); }

        const show = (n) => {
            pages[idx].classList.remove('active');
            idx = (n + pages.length) % pages.length;   // 순환
            pages[idx].classList.add('active');
        };

        // 버튼
        prevBtn.addEventListener('click', () => { show(idx - 1); bounce(); });
        nextBtn.addEventListener('click', () => { show(idx + 1); bounce(); });

        // 마우스 오버 시 일시정지(선택)
        const container = document.querySelector('.promotion-slider');
        if (container) {
            container.addEventListener('mouseenter', stop);
            container.addEventListener('mouseleave', () => { if (!timer) start(); });
        }

        start(); // 시작
    })();

</script>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>