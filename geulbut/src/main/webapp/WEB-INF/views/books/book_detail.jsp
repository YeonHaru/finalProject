<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>도서 상세</title>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/book_detail/book_detail.css">
</head>
<body class="bg-main">
<jsp:include page="/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/users/mypage/paymentModal.jsp"/>

<main id="main" class="page py-4" role="main">
    <!-- 브레드크럼 -->
    <nav aria-label="경로" class="mb-3">
        <ol class="breadcrumb list-reset">
            <li><a href="<c:url value='/'/>">홈</a></li>
            <li aria-hidden="true">/</li>
            <li><a href="<c:url value='/books'/>">도서</a></li>
            <li aria-hidden="true">/</li>
            <li aria-current="page"><strong class="text-main">${book.title}</strong></li>
        </ol>
    </nav>

    <!-- 상세 카드 -->
    <article class="book-detail grid cols-2 gap-4 bg-surface border rounded shadow-sm p-4"
             itemscope itemtype="https://schema.org/Book">

        <!-- 좌측 -->
        <section class="grid gap-3" aria-label="도서 이미지">
            <figure class="book-cover">
                <img src="${empty book.imgUrl ? '/images/thumb_ing.gif' : book.imgUrl}"
                     alt="${fn:escapeXml(book.title)} 표지">
            </figure>

            <div class="info-card">
                <p class="mb-1"><strong>배송</strong> : 오늘 출고 (평균 1–2일 내 도착)</p>
                <p class="mb-0"><strong>반품</strong> : 수령 후 7일 이내 가능</p>
            </div>
        </section>

        <!-- 우측 -->
        <section class="grid gap-3" aria-label="도서 정보">
            <header>
                <h1 class="mb-1" itemprop="name">${book.title}</h1>
                <p class="text-light">
                    <span itemprop="author">${book.authorName}</span>
                    <span aria-hidden="true"> · </span>
                    <span itemprop="publisher">${book.publisherName}</span>
                </p>
            </header>

            <!-- 가격 영역 (개선) -->
            <c:set var="hasDiscount" value="${not empty book.discountedPrice and book.discountedPrice lt book.price}" />
            <c:set var="discountPercent" value="${hasDiscount ? ((book.price - book.discountedPrice) * 100.0) / book.price : 0}" />
            <div class="price-box border rounded p-3 bg-surface" aria-label="가격 정보">
                <c:choose>
                    <c:when test="${hasDiscount}">
                        <div class="price-line">
                            <strong class="price-now">
                                <fmt:formatNumber value="${book.discountedPrice}" type="number"/>원
                            </strong>
                            <span class="price-badge">-<fmt:formatNumber value="${discountPercent}" maxFractionDigits="0"/>%</span>
                        </div>
                        <div class="price-sub">
                            <span class="price-original">
                                정가 <fmt:formatNumber value="${book.price}" type="number"/>원
                            </span>
                            <span class="stock-chip">재고 ${book.stock}</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="price-line">
                            <strong class="price-now">
                                <fmt:formatNumber value="${book.price}" type="number"/>원
                            </strong>
                        </div>
                        <div class="price-sub">
                            <span class="stock-chip">재고 ${book.stock}</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 해시태그 -->
            <section aria-label="해시태그">
                <h2 class="visually-hidden">해시태그</h2>
                <ul class="tag-list">
                    <c:forEach var="tag" items="${book.hashtags}">
                        <li>${tag}</li>
                    </c:forEach>
                </ul>
            </section>

            <!-- 액션 버튼: 모바일=1열 → 태블릿=3열 -->
            <div class="actions-grid mt-2" role="group" aria-label="작업">
                <button type="button"
                        class="px-3 py-2 rounded bg-accent text-invert"
                        data-act="cart" data-id="${book.bookId}" data-qty="1" id="btnAddCart">
                    장바구니
                </button>

                <button type="button"
                        class="px-3 py-2 border rounded bg-surface"
                        data-act="like" data-id="${book.bookId}" id="btnWishlist">
                    위시리스트
                </button>

                <button type="button" class="px-3 py-2 border rounded bg-surface" id="buyNowBtn">
                    구매하기
                </button>
            </div>

            <!-- 추가 정보 -->
            <section class="grid gap-1 mt-2" aria-label="추가 정보">
                <p class="text-light">ISBN: ${book.isbn}</p>
                <p class="text-light">출간일: <time datetime="2025-01-01">${book.publishedDate}</time></p>
            </section>
        </section>
    </article>

    <!-- 상세 설명 & 출판 정보 -->
    <section class="grid gap-3 mt-3">
        <article class="bg-surface border rounded p-4" aria-label="도서 소개">
            <h2 class="mb-2">도서 소개</h2>
            <p>${book.description}</p>
        </article>

        <article class="bg-surface border rounded p-4" aria-label="출판 정보">
            <h2 class="mb-2">출판 정보</h2>
            <div class="meta-grid">
                <div class="label">발행처</div><div>${book.publisherName}</div>
                <div class="label">발행일</div><div>${book.publishedDate}</div>
                <div class="label">카테고리</div><div>${book.categoryName}</div>
            </div>
        </article>
    </section>
</main>

<footer class="page py-4 text-light" role="contentinfo">
    <p class="mb-0">&copy; 2025 Geulbut</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script> if (window.IMP) { IMP.init("${iamportCode}"); } </script>

<div id="imp-root" data-imp-code="${iamportCode}"></div>

<script src="/js/mypage/orders.js"></script>

<script>
    window.PRODUCT = {
        id: ${book.bookId},
        price: ${book.price},
        discountedPrice: <c:choose>
            <c:when test="${empty book.discountedPrice}">null</c:when>
        <c:otherwise>${book.discountedPrice}</c:otherwise>
        </c:choose>
    };
</script>

<script src="/js/book_detail/book_detail.js"></script>
</body>
</html>
