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

    <!-- 🔹 CSRF 토큰 메타 태그 -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
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
                        <!-- 책 카드 -->
                        <div class="book-card">
                                <%-- <div class="book-badge recommend">추천</div> --%>

                            <div class="book-image">
                                <!-- 이미지 없을 때 기본 이미지 -->
                                <img src="${empty data.imgUrl ? '/images/thumb_ing.gif' : data.imgUrl}"
                                     alt="${fn:escapeXml(data.title)}">
                                <div class="book-number">1</div>
                            </div>

                            <!-- 제목 길이 제한 -->
                            <h3 class="book-title">
                                <c:choose>
                                    <c:when test="${fn:length(data.title) > 25}">
                                        ${fn:substring(data.title, 0, 25)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${data.title}
                                    </c:otherwise>
                                </c:choose>
                            </h3>

                            <p class="book-author my-3"><c:out value="${data.name}"/></p>

                            <div class="editor-comment">
                                <!-- 설명 없을 때 '설명 준비중' -->
                                <h4 class="new-book-description">
                                        ${empty data.description ? '설명 준비중' : data.description}
                                </h4>
                            </div>

                            <div class="book-rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                            </div>
                        </div>
                    </a>

                </c:forEach>

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
                                <c:choose>
                                    <c:when test="${not empty data.imgUrl}">
                                        <img src="${data.imgUrl}" alt="${fn:escapeXml(data.title)}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/thumb_ing.gif" alt="${fn:escapeXml(data.title)}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </a>

                        <h3 class="new-book-title">
                            <c:choose>
                                <c:when test="${fn:length(data.title) > 15}">
                                    ${fn:substring(data.title, 0, 15)}...
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${data.title}"/>
                                </c:otherwise>
                            </c:choose>
                        </h3>

                        <p class="new-book-author"><c:out value="${data.name}"/></p>
                        <div class="new-book-date"><c:out value="${data.publishedDate}"/></div>
                        <p class="new-book-description">
                            <c:choose>
                                <c:when test="${not empty data.description}">
                                    <c:out value="${data.description}"/>
                                </c:when>
                                <c:otherwise>
                                    설명 준비중
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <button class="new-book-button">예약구매</button>
                    </div>
                </c:forEach>
            </div>
        </div>


        <!-- 화제의 책 컨텐츠 -->
        <div class="tab-content" id="trending-content">
            <div class="trending-grid">
                <c:forEach var="data" items="${randomBooks}">
                    <c:url var="detailUrl" value="/book/${data.bookId}"/>

                    <div class="trending-card">
                        <!-- 배지 -->
                        <div class="trending-badge hot">HOT</div>

                        <!-- 이미지 클릭 시 상세 페이지 이동 -->
                        <a href="${detailUrl}" class="trending-book-link" aria-label="${fn:escapeXml(data.title)} 상세보기">
                            <div class="trending-image">
                                <c:choose>
                                    <c:when test="${not empty data.imgUrl}">
                                        <img src="${data.imgUrl}" alt="${fn:escapeXml(data.title)}"
                                             onerror="this.src='${pageContext.request.contextPath}/images/thumb_ing.gif'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/thumb_ing.gif"
                                             alt="기본 이미지">
                                    </c:otherwise>
                                </c:choose>
                                <div class="trending-rank">-</div> <!-- 순위 필요시 표시 -->
                            </div>
                        </a>

                        <!-- 제목 클릭 시 상세 페이지 이동 -->
                        <h3 class="trending-title">
                            <a href="${detailUrl}"><c:out value="${data.title}"/></a>
                        </h3>

                        <!-- 작가 -->
                        <p class="trending-author"><c:out value="${data.authorName != null ? data.authorName : '인기작가'}"/></p>

                        <!-- 화제 지수 -->
                        <div class="trending-stats">
                            <h4 class="stats-title">화제 지수</h4>
                            <div class="stats-info">
                                <div class="stats-views">🔥 15.2K 언급</div>
                                <div class="stats-trend">↗ 250%</div>
                            </div>
                        </div>

                        <!-- 별점 -->
                        <div class="trending-rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="rating-number">(4.7)</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 지금 핫딜중 컨텐츠 -->
        <div class="tab-content" id="hotdeal-content">
            <div class="hotdeal-grid">
                <c:forEach var="data" items="${hotdeal}">
                    <!-- 핫딜 카드 1 -->
                    <c:url var="detailUrl" value="/book/${data.bookId}"/>
                    <div class="hotdeal-card">

                        <!-- 할인 배지 -->
                        <div class="hotdeal-badge discount-30">
                            <c:set var="discountRate" value="${(data.price - data.discounted_price) * 100 / data.price}"/>
                            할인율: <c:out value="${discountRate}"/>%
                        </div>

                        <!-- 이미지 클릭 시 상세보기 이동 -->
                        <div class="hotdeal-image">
                            <a href="${detailUrl}" aria-label="${fn:escapeXml(data.title)} 상세보기">
                                <c:choose>
                                    <c:when test="${not empty data.imgUrl}">
                                        <img src="<c:out value='${data.imgUrl}'/>"
                                             alt="<c:out value='${data.title}'/>"
                                             onerror="this.src='${pageContext.request.contextPath}/images/thumb_ing.gif'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/thumb_ing.gif"
                                             alt="기본 이미지">
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </div>

                        <!-- 제목 클릭 시 상세보기 이동 -->
                        <h3 class="hotdeal-title">
                            <a href="${detailUrl}"><c:out value="${data.title}"/></a>
                        </h3>

                        <!-- 저자 -->
                        <p class="hotdeal-author"><c:out value="${data.name}"/></p>

                        <!-- 가격 정보 -->
                        <div class="hotdeal-prices">
                            <span class="original-price"><c:out value="${data.price}"/></span>
                            <span class="sale-price"><c:out value="${data.discounted_price}"/></span>
                        </div>

                        <!-- 장바구니 안내 -->
                        <button class="hotdeal-time" onclick="addToCart(${data.bookId}, 1)">
                            장바구니🛒
                        </button>
                        <!-- 구매 버튼 디테일페이지로 이동 후 결제모달뜨게 -->
                        <button class="hotdeal-button"
                                onclick="location.href='/book/${data.bookId}'">
                            구매하기
                        </button>
                    </div>
                </c:forEach>
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
                                <img src="${empty book.imgUrl ? '/images/thumb_ing.gif' : book.imgUrl}"
                                     alt="${fn:escapeXml(book.title)}" class="book-thumb"/>

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
                                    <p class="comment-text">
                                            ${empty book.description ? '설명 준비중' : book.description}
                                    </p>
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
            <button class="tab-item" onclick="showTab('weekly-content', '이 주의 책')">이 주의 책</button>
            <button class="tab-item" onclick="showTab('new-books-content', '신간 소개')">신간 소개</button>
            <button class="tab-item" onclick="showTab('trending-content', '화제의 책')">화제의 책</button>
            <button class="tab-item" onclick="showTab('hotdeal-content', '지금 핫딜중')">지금 핫딜중</button>
        </div>
    </section>

    <!-- 광고창 -->
    <section class="ad-marquee">
        <div class="marquee-content">
            📢 특별 할인! 9월 한정, 인기 도서 최대 30% 할인 중! 🎁 | 신규 회원은 첫 구매 시 추가 쿠폰 지급! ✨ | 이번 주 이벤트: 베스트셀러 1+1!
        </div>
    </section>

    <%--    <!-- 아이콘 메뉴 -->--%>
    <%--    <section class="icon-menu">--%>
    <%--        <div class="icon-menu-grid">--%>
    <%--            <a href="/gift" class="icon-item gift">--%>
    <%--                <div class="icon-wrapper">--%>
    <%--                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e53e3e" stroke-width="2">--%>
    <%--                        <polyline points="20,12 20,19 4,19 4,12"></polyline>--%>
    <%--                        <rect x="2" y="5" width="20" height="7"></rect>--%>
    <%--                        <line x1="12" y1="22" x2="12" y2="5"></line>--%>
    <%--                        <path d="m9,5 A3,3 0 0,1 6,2 A3,3 0 0,1 9,5 m6,0 A3,3 0 0,0 18,2 A3,3 0 0,0 15,5"></path>--%>
    <%--                    </svg>--%>
    <%--                </div>--%>
    <%--                <span class="icon-label">기프트카드</span>--%>
    <%--            </a>--%>
    <%--            <a href="/discount" class="icon-item discount">--%>
    <%--                <div class="icon-wrapper">--%>
    <%--                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#38a169" stroke-width="2">--%>
    <%--                        <circle cx="8" cy="8" r="6"></circle>--%>
    <%--                        <path d="m18.09 10.37 1.51 1.51c.39.39.39 1.02 0 1.41l-8.94 8.94c-.39.39-1.02.39-1.41 0l-1.51-1.51"></path>--%>
    <%--                        <path d="m8 8 6 6"></path>--%>
    <%--                        <path d="m7 7h.01"></path>--%>
    <%--                        <path d="m17 17h.01"></path>--%>
    <%--                    </svg>--%>
    <%--                </div>--%>
    <%--                <span class="icon-label">할인혜택</span>--%>
    <%--            </a>--%>
    <%--            <a href="/recommended" class="icon-item event">--%>
    <%--                <div class="icon-wrapper">--%>
    <%--                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#d69e2e" stroke-width="2">--%>
    <%--                        <path d="M9 11H3v8h6m11-8h-6v8h6m-7-14v8m-5-5 5 5 5-5"></path>--%>
    <%--                    </svg>--%>
    <%--                </div>--%>
    <%--                <span class="icon-label">이벤트</span>--%>
    <%--            </a>--%>
    <%--            <a href="/bestseller" class="icon-item bestseller">--%>
    <%--                <div class="icon-wrapper">--%>
    <%--                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3182ce" stroke-width="2">--%>
    <%--                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>--%>
    <%--                    </svg>--%>
    <%--                </div>--%>
    <%--                <span class="icon-label">베스트셀러</span>--%>
    <%--            </a>--%>
    <%--            <a href="/review" class="icon-item review">--%>
    <%--                <div class="icon-wrapper">--%>
    <%--                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#805ad5" stroke-width="2">--%>
    <%--                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>--%>
    <%--                        <path d="M8 9h8"></path>--%>
    <%--                        <path d="M8 13h6"></path>--%>
    <%--                    </svg>--%>
    <%--                </div>--%>
    <%--                <span class="icon-label">리뷰·추천</span>--%>
    <%--            </a>--%>
    <%--        </div>--%>
    <%--    </section>--%>

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

                <!-- 첫 번째 페이지: index 0~1 -->
                <div class="promotion-page active">
                    <div class="promotion-grid">
                        <c:forEach var="p" items="${promoBooks}" varStatus="st">
                            <c:if test="${st.index lt 2}">
                                <c:url var="detailUrl" value="/book/${p.bookId}"/>
                                <div class="promotion-card
                          ${st.index == 0 ? 'bestseller-promo' : ''}
                          ${st.index == 1 ? 'md-promo' : ''}">
                                    <!-- 아이콘 (기존 SVG 유지) -->
                                    <div class="promo-icon">
                                        <c:choose>
                                            <c:when test="${st.index == 0}">
                                                <!-- bestseller star -->
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2">
                                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87
                                 1.18 6.88L12 17.77l-6.18 3.25L7 14.14
                                 2 9.27l6.91-1.01L12 2z"></path>
                                                </svg>
                                                <span>선간</span>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- MD 추천 -->
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2">
                                                    <path d="M9 11H3v8h6m11-8h-6v8h6m-7-14v8m-5-5 5 5 5-5"></path>
                                                </svg>
                                                <span>MD추천</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="promo-content">
                                        <h3 class="promo-title"><c:out value="${p.title}"/></h3>
                                        <h4 class="promo-subtitle">
                                            <c:out value="${p.authorName}"/> · <c:out value="${p.publisherName}"/>
                                        </h4>
                                        <p class="promo-description">
                                            <c:out value="${fn:length(p.description) > 60
                                   ? fn:substring(p.description,0,60).concat('...')
                                   : p.description}"/>
                                        </p>
                                        <a class="promo-button" href="${detailUrl}">자세히 보기 ></a>
                                    </div>

                                    <div class="promo-image">
                                        <a href="${detailUrl}">
                                            <img
                                                    src="${empty p.imgUrl
                              ? 'https://via.placeholder.com/120x160/cccccc/000000?text=No+Image'
                              : p.imgUrl}"
                                                    alt="${fn:escapeXml(p.title)}"
                                                    onerror="this.src='https://via.placeholder.com/120x160/cccccc/000000?text=No+Image'">
                                        </a>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- 두 번째 페이지: index 2~3 -->
                <div class="promotion-page">
                    <div class="promotion-grid">
                        <c:forEach var="p" items="${promoBooks}" varStatus="st">
                            <c:if test="${st.index ge 2}">
                                <c:url var="detailUrl" value="/book/${p.bookId}"/>
                                <div class="promotion-card
                          ${st.index == 2 ? 'new-book-promo' : ''}
                          ${st.index == 3 ? 'audiobook-promo' : ''}">
                                    <!-- 아이콘 (기존 SVG 유지) -->
                                    <div class="promo-icon">
                                        <c:choose>
                                            <c:when test="${st.index == 2}">
                                                <!-- 신간 -->
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2">
                                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                    <polyline points="14,2 14,8 20,8"></polyline>
                                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                                    <polyline points="10,9 9,9 8,9"></polyline>
                                                </svg>
                                                <span>신간</span>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- 오디오 -->
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                     stroke="currentColor" stroke-width="2">
                                                    <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                                                    <path d="m19.07 4.93-1.4 1.4A6.5 6.5 0 0 1 19.5 12
                                 a6.5 6.5 0 0 1-1.83 5.67l1.4 1.4A8.5 8.5 0 0 0
                                 21.5 12a8.5 8.5 0 0 0-2.43-7.07z"></path>
                                                    <path d="m15.54 8.46-1.4 1.4A2.5 2.5 0 0 1 15.5 12
                                 a2.5 2.5 0 0 1-1.36 2.14l1.4 1.4A4.5 4.5 0 0 0
                                 17.5 12a4.5 4.5 0 0 0-1.96-4.54z"></path>
                                                </svg>
                                                <span>오디오</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="promo-content">
                                        <h3 class="promo-title"><c:out value="${p.title}"/></h3>
                                        <h4 class="promo-subtitle">
                                            <c:out value="${p.authorName}"/> · <c:out value="${p.publisherName}"/>
                                        </h4>
                                        <p class="promo-description">
                                            <c:out value="${fn:length(p.description) > 60
                                   ? fn:substring(p.description,0,60).concat('...')
                                   : p.description}"/>
                                        </p>
                                        <a class="promo-button" href="${detailUrl}">자세히 보기 ></a>
                                    </div>

                                    <div class="promo-image">
                                        <a href="${detailUrl}">
                                            <img
                                                    src="${empty p.imgUrl
                              ? 'https://via.placeholder.com/120x160/cccccc/000000?text=No+Image'
                              : p.imgUrl}"
                                                    alt="${fn:escapeXml(p.title)}"
                                                    onerror="this.src='https://via.placeholder.com/120x160/cccccc/000000?text=No+Image'">
                                        </a>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
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
            <c:forEach var="book" items="${audiobooks}" varStatus="status">
                <a href="/book/${book.bookId}" class="audiobook-card-link">
                    <div class="audiobook-card">
                        <!-- 배지 하드코딩 -->
                        <div class="audiobook-badge">
                            <c:choose>
                                <c:when test="${status.index == 0}">NEW</c:when>
                                <c:when test="${status.index == 1}">인기</c:when>
                                <c:otherwise>BEST</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="audiobook-cover">
                            <!-- 디폴트 이미지 추가 -->
                            <img src="${book.imgUrl != null && !book.imgUrl.isEmpty() ? book.imgUrl : '/images/thumb_ing.gif'}"
                                 alt="${book.title}">
                            <div class="audio-icon">🎧</div>
                            <div class="play-time">
                                <c:choose>
                                    <c:when test="${status.index == 0}">7시간 32분</c:when>
                                    <c:when test="${status.index == 1}">5시간 15분</c:when>
                                    <c:when test="${status.index == 2}">6시간</c:when>
                                    <c:otherwise>6시간 40분</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="audiobook-info">
                            <div class="audiobook-rating">
                        <span class="rating-stars">
                            <c:choose>
                                <c:when test="${status.index == 0}">⭐ 4.8</c:when>
                                <c:when test="${status.index == 1}">⭐ 4.5</c:when>
                                <c:when test="${status.index == 2}">⭐ 4.9</c:when>
                                <c:otherwise>⭐ 4.7</c:otherwise>
                            </c:choose>
                        </span>
                                <span class="audiobook-category">${book.categoryName}</span>
                            </div>
                            <h3 class="audiobook-title">${book.title}</h3>
                            <p class="audiobook-author">저자: ${book.authorName}</p>
                            <p class="audiobook-narrator">
                                <c:choose>
                                    <c:when test="${status.index == 0}">낭독: 최종일</c:when>
                                    <c:when test="${status.index == 1}">낭독: 서덕규</c:when>
                                    <c:when test="${status.index == 2}">낭독: 신승화</c:when>
                                    <c:otherwise>낭독: 문려경</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </a>
            </c:forEach>
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

        /*** === 탭 자동 슬라이드 === ***/
        let currentTabIndex = 0;
        let autoSlideInterval = null;
        let isPlaying = false;
        const autoSlideDelay = 4000;

        const tabItems = document.querySelectorAll('.tab-item');
        const playButton = document.querySelector('.play-button');

        const tabContents = [
            'editor-choice-content',
            'weekly-content',
            'new-books-content',
            'trending-content',
            'hotdeal-content'
        ];

        const tabTexts = [
            '편집장의 선택',
            '이 주의 책',
            '신간 소개',
            '화제의 책',
            '지금 핫딜중'
        ];

        function showTabContent(tabIndex) {
            tabItems.forEach(t => t.classList.remove('active'));
            if (tabItems[tabIndex]) tabItems[tabIndex].classList.add('active');

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
            if (sectionTitle) sectionTitle.textContent = tabTexts[tabIndex];

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
                if (playButton) {
                    playButton.classList.remove('playing');
                    playButton.classList.add('paused');
                }
            }
        }

        function stopAutoSlide() {
            if (isPlaying) {
                isPlaying = false;
                clearInterval(autoSlideInterval);
                autoSlideInterval = null;
                if (playButton) {
                    playButton.classList.remove('paused');
                    playButton.classList.add('playing');
                }
            }
        }

        if (playButton) {
            playButton.addEventListener('click', function () {
                if (isPlaying) stopAutoSlide();
                else startAutoSlide();
            });
        }

        if (tabItems.length > 0) {
            tabItems.forEach((tab, index) => {
                tab.addEventListener('click', function () {
                    if (isPlaying) stopAutoSlide();
                    showTabContent(index);
                });
            });
        }

        // 전역 탭 함수 노출
        window.showTab = showTabContent;
        window.nextTab = nextTabSlide;
        window.prevTab = prevTabSlide;

        showTabContent(0);
        setTimeout(startAutoSlide, 1000);

        /*** === 큰 배너 슬라이드 === ***/
        let currentBannerSlide = 0;
        const totalBannerSlides = 3;
        let bannerInterval = null;
        let userInteracting = false;

        function updateBannerSlider() {
            const sliderTrack = document.getElementById('sliderTrack');
            if (sliderTrack) sliderTrack.style.transform = `translateX(${-currentBannerSlide * 33.333}%)`;
        }

        function nextBannerSlide() { currentBannerSlide = (currentBannerSlide + 1) % totalBannerSlides; updateBannerSlider(); }
        function prevBannerSlide() { currentBannerSlide = (currentBannerSlide - 1 + totalBannerSlides) % totalBannerSlides; updateBannerSlider(); }

        function startBannerAutoSlide() {
            bannerInterval = setInterval(() => { if (!userInteracting) nextBannerSlide(); }, 4000);
        }

        function stopBannerAutoSlide() { if (bannerInterval) { clearInterval(bannerInterval); bannerInterval = null; } }
        function resetBannerAutoSlide() { stopBannerAutoSlide(); userInteracting = false; setTimeout(startBannerAutoSlide, 3000); }

        window.nextBanner = function () { userInteracting = true; stopBannerAutoSlide(); nextBannerSlide(); resetBannerAutoSlide(); }
        window.prevBanner = function () { userInteracting = true; stopBannerAutoSlide(); prevBannerSlide(); resetBannerAutoSlide(); }

        setTimeout(startBannerAutoSlide, 2000);

        /*** === 핫딜 / 장바구니 버튼 === ***/
        async function addToCart(bookId, qty = 1) {
            if (!Number.isFinite(bookId)) return alert('도서 ID가 없습니다.');

            const CTX = (typeof window.CONTEXT_PATH !== 'undefined'
                ? window.CONTEXT_PATH
                : (typeof pageContext !== 'undefined' && pageContext?.request?.contextPath) || '');
            const URL = CTX + '/cart'; // 장바구니 전용

            const CSRF_TOKEN  = document.querySelector('meta[name="_csrf"]')?.getAttribute('content') || null;
            const CSRF_HEADER = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';

            try {
                const headers = new Headers();
                headers.set('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
                if (CSRF_TOKEN) headers.set(CSRF_HEADER, CSRF_TOKEN);

                const body = new URLSearchParams();
                body.append('bookId', bookId);
                body.append('quantity', qty);

                const res = await fetch(URL, { method: 'POST', headers, body });

                if (res.status === 401) { location.href = CTX + '/users/login'; return; }

                const data = await res.json();
                if (data.status === 'ok') toast('장바구니에 담겼습니다!');
                else toast('장바구니 담기 실패: ' + (data.message || '알 수 없는 오류'));
            } catch (err) {
                console.error('장바구니 추가 오류', err);
                toast('장바구니 담기 실패: 네트워크 오류');
            }
        }

        /*** === 핫딜 / 구매 버튼 === ***/
        async function buyBook(bookId, qty = 1) {
            if (!Number.isFinite(bookId)) return alert('도서 ID가 없습니다.');

            const CTX = (typeof window.CONTEXT_PATH !== 'undefined'
                ? window.CONTEXT_PATH
                : (typeof pageContext !== 'undefined' && pageContext?.request?.contextPath) || '');
            const URL = CTX + '/orders/buy-now'; // 구매 전용

            try {
                // 상세페이지로 이동 + 결제 모달 열기
                if (window.PRODUCT && window.PRODUCT.id === bookId && window.Orders?.openOrderInfoModal) {
                    // 이미 상세페이지에 있다면 바로 모달
                    const total = Number((window.PRODUCT?.discountedPrice ?? window.PRODUCT?.price) ?? 0);
                    if (Number.isNaN(total) || total <= 0) return alert('결제 금액을 계산할 수 없습니다.');
                    Orders.openOrderInfoModal(total);
                    return;
                }

                // 상세페이지로 이동하고 URL 파라미터로 자동 구매 모드 전달
                const detailUrl = document.querySelector(`.hotdeal-card[data-book-id="${bookId}"]`)?.dataset.detailUrl;
                if (detailUrl) {
                    const url = new URL(detailUrl, window.location.origin);
                    url.searchParams.set('autoBuy', 'true');
                    window.location.href = url.toString();
                }
            } catch (err) {
                console.error('구매 오류', err);
                alert('구매 처리 중 오류가 발생했습니다.');
            }
        }

// 전역 노출
        window.addToCart = addToCart;
        window.buyBook = buyBook;

// 장바구니 버튼
        document.querySelectorAll('.hotdeal-card .hotdeal-button.add-cart').forEach(button => {
            button.addEventListener('click', function(e) {
                e.stopPropagation();
                const bookId = Number(this.dataset.bookId);
                addToCart(bookId, 1);
            });
        });

// 구매 버튼
        document.querySelectorAll('.hotdeal-card .hotdeal-button.buy-now').forEach(button => {
            button.addEventListener('click', function(e) {
                e.stopPropagation();
                const bookId = Number(this.dataset.bookId);
                buyBook(bookId);
            });
        });

// 카드 전체 클릭 → 상세페이지 이동 (버튼 클릭이면 무시)
        document.querySelectorAll('.hotdeal-card').forEach(card => {
            card.addEventListener('click', function(e) {
                if (e.target.closest('.hotdeal-button')) return;
                const detailUrl = this.dataset.detailUrl;
                if (detailUrl) window.location.href = detailUrl;
            });
        });

// 간단한 토스트 함수
        function toast(msg) {
            let t = document.getElementById('_toast');
            if (!t) {
                t = document.createElement('div');
                t.id = '_toast';
                Object.assign(t.style, {
                    position: 'fixed', left: '50%', bottom: '28px', transform: 'translateX(-50%)',
                    padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,.78)',
                    color: '#fff', fontWeight: '600', zIndex: '9999', transition: 'opacity .25s ease'
                });
                document.body.appendChild(t);
            }
            t.textContent = msg;
            t.style.opacity = '1';
            setTimeout(() => (t.style.opacity = '0'), 1400);
        }

        console.log('BookStore 웹사이트가 성공적으로 로드되었습니다!');
    });
</script>

<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>