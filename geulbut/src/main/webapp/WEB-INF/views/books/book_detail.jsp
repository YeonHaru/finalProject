<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 9. 24.
  Time: 오전 9:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>도서 상세</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/book_detail/book_detail.css">
</head>
<body class="bg-main">
<jsp:include page="/common/header.jsp"/>
<div class="page py-4">
    <p>제목:${book.title}</p>
    <p>작가:${book.authorName}</p>
    <p>출판사:${book.publisherName}</p>
    <p>해시태그:${book.hashtags}</p>
</div>

<main id="main" class="page py-4" role="main">
    <!-- 브레드크럼 -->
    <nav aria-label="경로" class="mb-3">
        <ol class="row gap-2 breadcrumb list-reset">
            <li><a href="/" class="text-light">홈</a></li>
            <li aria-hidden="true">/</li>
            <li><a href="/book" class="text-light">도서</a></li>
            <li aria-hidden="true">/</li>
            <li aria-current="page"><strong class="text-main">${book.title}</strong></li>
        </ol>
    </nav>

    <!-- 상세 카드 -->
    <article class="book-detail bg-surface border rounded shadow-sm p-4 grid cols-2 gap-4" itemscope itemtype="https://schema.org/Book">
        <!-- 좌측: 커버 -->
        <section class="grid gap-3" aria-label="도서 이미지">
            <figure class="book-cover">
                <img src="${empty book.imgUrl ? '/images/thumb_ing.gif' : book.imgUrl}"
                     alt="${fn:escapeXml(data.title)} 표지">
            </figure>

            <!-- 작은 카드: 배송/재고 안내 등 -->
            <div class="info-card">
                <p class="mb-1"><strong>배송</strong> : 오늘 출고 (평균 1–2일 내 도착)</p>
                <p class="mb-0"><strong>반품</strong> : 수령 후 7일 이내 가능</p>
            </div>
        </section>

        <!-- 우측: 메타/가격/액션 -->
        <section class="grid gap-3" aria-label="도서 정보">
            <header>
                <h1 class="mb-1" itemprop="name">${book.title}</h1>
                <p class="text-light">
                    <span itemprop="author">${book.authorName}</span>
                    <span aria-hidden="true"> · </span>
                    <span itemprop="publisher">${book.publisherName}</span>
                </p>
            </header>

            <!-- 가격 영역 -->
            <div class="bg-main rounded p-3 border" aria-label="가격 정보">
                <div class="row gap-2">
                    <p class="price-original">정가: ${book.price}</p>
                    <p class="text-main"><strong class="price-discount">할인가: ${book.discountedPrice}</strong></p>
                    <span class="badge bg-accent-dark text-invert">25%↓</span>
                </div>
                <p class="mt-1 text-light">재고: ${book.stock}</p>
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

            <!-- 액션 버튼 -->
            <div class="row gap-2 mt-2" role="group" aria-label="작업">
                <form action="/cart" method="post" class="row gap-2">
                    <input type="hidden" name="bno" value="123"/>
                    <button type="submit" class="border rounded px-3 py-2 bg-accent-dark text-invert">장바구니 담기</button>
                </form>
                <form action="/wish" method="post" class="row gap-2">
                    <input type="hidden" name="bno" value="123"/>
                    <button type="submit" class="border rounded px-3 py-2">위시리스트</button>
                </form>
            </div>

            <!-- 추가 정보 -->
            <section class="grid gap-1 mt-2" aria-label="추가 정보">
                <p class="text-light">ISBN: 978-89-12345-67-8</p>
                <p class="text-light">출간일: <time datetime="2025-01-01">2025-01-01</time></p>
                <p class="text-light">쪽수: 320쪽</p>
                <p class="text-light">크기/무게: 148 x 210mm / 420g</p>
            </section>
        </section>
    </article>

    <!-- 상세 설명 & 목차 -->
    <section class="grid gap-3 mt-3">
        <article class="bg-surface border rounded p-4" aria-label="도서 소개">
            <h2 class="mb-2">도서 소개</h2>
            <p>
                ${book.description}
            </p>
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
</body>
</html>
</body>
</html>
