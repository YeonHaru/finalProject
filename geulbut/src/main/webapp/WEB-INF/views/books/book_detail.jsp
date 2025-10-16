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

            <!-- 수량 스테퍼 + 합계 -->
            <div class="qty-price row gap-2 align-center" aria-label="수량 선택">
                <div class="qty-stepper" role="group" aria-label="수량 조절">
                    <button type="button" class="qty-btn" data-qty-dec aria-label="수량 감소">−</button>
                    <input id="qtyInput" class="qty-input" inputmode="numeric" value="1" aria-live="polite" aria-label="수량">
                    <button type="button" class="qty-btn" data-qty-inc aria-label="수량 증가">＋</button>
                </div>
                <div class="total-line">
                    <span class="label">합계</span>
                    <strong class="total" id="totalPrice" aria-live="polite">0원</strong>
                </div>
            </div>

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
    <section class="accordion mt-3" id="bookAccordion">
        <details class="acc" open>
            <summary class="acc__sum">도서 소개</summary>
            <div class="acc__panel"><p>${book.description}</p></div>
        </details>
        <details class="acc">
            <summary class="acc__sum">출판 정보</summary>
            <div class="acc__panel">
                <div class="meta-grid">
                    <div class="label">발행처</div><div>${book.publisherName}</div>
                    <div class="label">발행일</div><div>${book.publishedDate}</div>
                    <div class="label">카테고리</div><div>${book.categoryName}</div>
                    <div class="label">ISBN</div><div>${book.isbn}</div>
                </div>
            </div>
        </details>
        <details class="acc">
            <summary class="acc__sum">배송 / 반품 안내</summary>
            <div class="acc__panel">
                <ul class="bullet">
                    <li>평일 오후 2시 이전 결제 시 당일 출고(재고 보유 시)</li>
                    <li>수령 후 7일 이내 반품 가능(미개봉 기준)</li>
                </ul>
            </div>
        </details>
    </section>
    <!--하단 고정 구매바(모바일) -->
    <div id="stickyBar" class="sticky-bar" role="region" aria-label="빠른 구매바" hidden>
        <div class="sticky-bar__left">
            <span class="sticky-qty" id="stickyQty">수량 1</span>
            <strong class="sticky-total" id="stickyTotal">0원</strong>
        </div>
        <div class="sticky-bar__right">
            <button type="button" class="btn-ghost" data-act="cart" data-id="${book.bookId}">장바구니</button>
            <button type="button" class="btn-fill"  id="buyNowBtnSticky">구매하기</button>
        </div>
    </div>

    <!-- ====================== 반품 / 교환 안내 ====================== -->
    <section class="return-policy mt-4" aria-label="반품 및 교환 안내">
        <h2 class="mb-3">반품/교환 안내</h2>
        <table class="policy-table">
            <tbody>
            <tr>
                <th>반품/교환 방법</th>
                <td>
                    「나의계정 &gt; 주문조회 &gt; 반품/교환신청」 또는 고객센터(1544-2514)<br>
                    ※ 판매자 배송상품은 판매자와 협의 후 가능
                </td>
            </tr>
            <tr>
                <th>반품/교환 가능기간</th>
                <td>
                    • 변심: 수령 후 20일 이내 (포장 개봉 전/전자책 다운로드 전)<br>
                    • 파본/불량: 문제 발생일로부터 30일, 수령일로부터 3개월 이내
                </td>
            </tr>
            <tr>
                <th>반품/교환 비용</th>
                <td>
                    • 변심/구매취소: 왕복 배송비 고객 부담<br>
                    • 해외주문: 판매가의 20% 취소수수료<br>
                    • 단, 주문/제작 도서 등 조건에 따라 상이
                </td>
            </tr>
            <tr>
                <th>반품/교환 불가 사유</th>
                <td>
                    • 소비자 책임 사유로 상품 손상 또는 멸실<br>
                    • 포장 개봉된 도서/전자책/음반/영상자료 등<br>
                    • 복제 가능한 콘텐츠 재화(E-book, OMR카드 등)<br>
                    • 세트상품 일부만 반품 요청 시<br>
                    • 신선식품, 사은품 누락/훼손 등 재판매 불가
                </td>
            </tr>
            <tr>
                <th>소비자 피해보상 및 기준</th>
                <td>
                    • 상품하자 및 오배송 시 전액 환불 및 교환<br>
                    • 기타 피해보상은 소비자분쟁해결기준에 따름
                </td>
            </tr>
            </tbody>
        </table>
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
<script src="/js/book_detail/book_detail.enhanced.js"></script>
</body>
</html>
