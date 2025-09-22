<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>검색 결과</title>
    <!-- 전역 공통 -->
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <!-- 페이지 전용(전역 유틸 보조만) -->
    <link rel="stylesheet" href="/css/book_all/book_all.css">
</head>
<body class="bg-main">
<jsp:include page="/common/header.jsp"/>

<div class="page py-4">
    <!-- 상단 툴바 -->
    <div class="row gap-2 mb-3 container">
        <div class="row gap-1">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <a class="px-2 py-1 border rounded-sm bg-surface shadow-sm ${i == page ? 'is-active' : ''}"
                   href="${pageContext.request.contextPath}/search?q=${param.q}&page=${i}">
                        ${i}
                </a>
            </c:forEach>
        </div>
        <div class="row gap-1 ml-3 text-light">
            <label class="row gap-1">
                <input id="checkAll" type="checkbox">
                <span>전체선택</span>
            </label>
            <button type="button" class="px-2 py-1 border rounded-sm bg-surface" data-bulk="cart">장바구니 담기</button>
            <button type="button" class="px-2 py-1 border rounded-sm bg-surface" data-bulk="wish">보관함 담기</button>
            <button type="button" class="px-2 py-1 border rounded-sm bg-surface" data-bulk="like">마이리스트 담기</button>
        </div>
    </div>

    <form name="listForm" action="${pageContext.request.contextPath}/search" method="get" class="container">
        <input type="hidden" id="page" name="page" value="${page}"/>

        <ol class="grid gap-3">
            <c:forEach var="data" items="${searches}">
                <li class="srch-item bg-surface border rounded shadow-sm p-3">
                    <!-- 체크박스 -->
                    <div class="srch-col-check row">
                        <input type="checkbox" name="selected" value="${data.bookId}">
                    </div>

                    <!-- 썸네일 -->
                    <a class="srch-thumb rounded-sm border bg-main"
                       href="${pageContext.request.contextPath}/book/${data.bookId}">
                        <img src="${empty data.booksImgUrl ? '/images/thumb_ing.gif' : data.booksImgUrl}"
                             alt="${fn:escapeXml(data.title)} 표지">
                    </a>

                    <!-- 정보 -->
                    <div class="srch-info">
                        <div class="row gap-1 mb-1 text-light">
                            <span class="chip">국내도서</span>
                            <c:if test="${not empty data.categoryName}">
                                <span class="text-light">${data.categoryName}</span>
                            </c:if>
                        </div>

                        <h3 class="mb-1 srch-title">
                            <a href="${pageContext.request.contextPath}/book/${data.bookId}">
                                    ${data.title}
                            </a>
                        </h3>

                        <p class="mb-2 text-light">
                            <c:if test="${not empty data.authorName}">
                                ${data.authorName}
                            </c:if>
                            <c:if test="${not empty data.publisherName}">
                                &nbsp;|&nbsp; ${data.publisherName}
                            </c:if>
                        </p>

                        <!-- 가격 -->
                        <div class="row gap-2 mb-2">
                            <span class="text-light strike">
                                <fmt:formatNumber value="${data.price}" type="number"/>원
                            </span>
                            <c:choose>
                                <c:when test="${data.discountedPrice != null && data.discountedPrice < data.price}">
                                    <span class="accent-strong">
                                        <fmt:formatNumber value="${data.discountedPrice}" type="number"/>원
                                    </span>
                                    <span class="accent-strong">
                                        <fmt:formatNumber value="${(1 - (data.discountedPrice * 1.0 / data.price)) * 100}"
                                                          maxFractionDigits="0"/>%할인
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-light">할인 없음</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 배송/뱃지 -->
                        <div class="row gap-1 mb-2 text-light">
                            <span class="chip chip--soft">알뜰배송</span>
                            <span>밤 11시 잠들기전 배송</span>
                        </div>

                        <!-- 해시태그 -->
                        <c:if test="${not empty data.hashtags}">
                            <ul class="row gap-1 mb-2">
                                <c:forEach var="tag" items="${data.hashtags}">
                                    <li><a class="chip chip--tag"
                                           href="${pageContext.request.contextPath}/search?tag=${fn:escapeXml(tag)}">#${tag}</a></li>
                                </c:forEach>
                            </ul>
                        </c:if>

                        <!-- 액션 -->
                        <div class="row gap-2">
                            <button type="button" class="px-3 py-2 rounded bg-accent text-invert"
                                    data-act="cart" data-id="${data.bookId}">장바구니</button>
                            <button type="button" class="px-3 py-2 border rounded bg-surface"
                                    data-act="buy" data-id="${data.bookId}">바로구매</button>
                            <button type="button" class="px-3 py-2 border rounded bg-surface"
                                    data-act="wish" data-id="${data.bookId}">보관함</button>
                            <button type="button" class="px-3 py-2 border rounded bg-surface"
                                    data-act="like" data-id="${data.bookId}">마이리스트</button>
                        </div>
                    </div>
                </li>
            </c:forEach>
        </ol>
    </form>
</div>

<script src="/js/book_all/book_all.js"></script>
</body>
</html>
