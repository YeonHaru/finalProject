<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">

<%-- 파라미터 표준화: q 우선, keyword 보조 --%>
<c:set var="qParam" value="${not empty param.q ? param.q : (not empty param.keyword ? param.keyword : (not empty keyword ? keyword : ''))}" />
<c:set var="currentSortField" value="${empty param.sort_field ? 'popularity_score' : param.sort_field}" />
<c:set var="currentSortOrder" value="${empty param.sort_order ? 'desc' : param.sort_order}" />
<c:set var="currentSize"      value="${empty param.size ? size : param.size}" />

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

    <%--    주간/월간 베스트 셀러 --%>
    <div class="bestseller-container">
        <div class="tab-buttons">
            <button class="tab-btn active" onclick="switchTab(this)">카테고리</button>
            <button class="tab-btn" onclick="switchTab(this)">해시태그</button>
        </div>

        <div class="category-grid-weekly">
            <div class="category-item featured">종합</div>
            <div class="category-item">소설</div>
            <div class="category-item">교육</div>
            <div class="category-item">자기계발</div>
            <div class="category-item">종교</div>
            <div class="category-item">에세이</div>
        </div>

        <div class="category-grid-monthly">
            <div class="category-item">자기계발</div>
            <div class="category-item">인문과학</div>
            <div class="category-item">역사/문화</div>
            <div class="category-item">정치/법률</div>
            <div class="category-item">종교</div>
            <div class="category-item">예술</div>
        </div>
    </div>

    <!-- 상단 툴바 -->
    <div class="row gap-2 mb-3 container">
        <div class="row gap-1 ml-3 text-light">
            <label class="row gap-1">
                <input id="checkAll" type="checkbox">
                <span>전체선택</span>
            </label>
            <button type="button" class="px-2 py-1 border rounded-sm bg-surface" data-bulk="cart">장바구니 담기</button>
            <button type="button" class="px-2 py-1 border rounded-sm bg-surface" data-bulk="like">위시리스트 담기</button>
        </div>
    </div>

    <form name="listForm" action="${pageContext.request.contextPath}/search" method="get" class="container">
        <!-- 0-base 페이지로 서버에 전달 -->
        <input type="hidden" id="page" name="page" value="${pageNumber - 1}"/>
        <!-- 검색어: q(우선) + keyword(후방호환) 둘 다 전달 -->
        <input type="hidden" name="q" value="${fn:escapeXml(qParam)}"/>
        <input type="hidden" name="keyword" value="${fn:escapeXml(qParam)}"/>
        <input type="hidden" name="size" value="${currentSize}"/>

        <%-- 정렬 툴바 --%>
        <section class="row gap-2 mb-2 items-center">
            <div class="row gap-1 items-center">
                <label for="sort_field" class="text-light">정렬</label>
                <select id="sort_field" name="sort_field" class="border rounded-sm bg-surface px-2 py-1">
                    <option value="popularity_score" ${currentSortField=='popularity_score' ? 'selected' : ''}>인기순</option>
                    <option value="sales_count"      ${currentSortField=='sales_count' ? 'selected' : ''}>판매량순</option>
                    <option value="wish_count"       ${currentSortField=='wish_count' ? 'selected' : ''}>위시순</option>
                    <option value="pub_date"         ${currentSortField=='pub_date' ? 'selected' : ''}>출간일순</option>
                    <option value="created_at"       ${currentSortField=='created_at' ? 'selected' : ''}>등록일순</option>
                    <option value="updated_at"       ${currentSortField=='updated_at' ? 'selected' : ''}>업데이트순</option>
                    <option value="price"            ${currentSortField=='price' ? 'selected' : ''}>가격순</option>
                </select>

                <label for="sort_order" class="visually-hidden">정렬 방향</label>
                <select id="sort_order" name="sort_order" class="border rounded-sm bg-surface px-2 py-1">
                    <option value="asc"  ${currentSortOrder=='asc'  ? 'selected' : ''}>오름차순 ▲</option>
                    <option value="desc" ${currentSortOrder=='desc' ? 'selected' : ''}>내림차순 ▼</option>
                </select>

                <button type="submit" class="px-2 py-1 rounded bg-accent text-invert"
                        onclick="document.getElementById('page').value=0">적용</button>

                <c:url var="resetUrl" value="/search">
                    <c:param name="q" value="${fn:escapeXml(qParam)}"/>
                    <c:param name="keyword" value="${fn:escapeXml(qParam)}"/>
                    <c:param name="page" value="0"/>
                    <c:param name="size" value="${currentSize}"/>
                    <c:param name="sort_field" value="popularity_score"/>
                    <c:param name="sort_order" value="desc"/>
                </c:url>
                <a class="px-2 py-1 border rounded-sm bg-surface" href="${resetUrl}">초기화</a>
            </div>
        </section>

        <!-- 총 건수 안내 -->
        <p class="mb-2 text-light">
            총 <strong><fmt:formatNumber value="${pages.totalElements}" groupingUsed="true"/></strong>건
            (현재 <strong>${pageNumber}</strong> / ${totalPages} 페이지)
        </p>

        <c:choose>
            <c:when test="${pages.totalElements == 0}">
                <div class="card p-3 border rounded bg-surface">검색 결과가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <ol class="grid gap-3">
                    <c:forEach var="data" items="${searches}" varStatus="status">
                        <li class="srch-item bg-surface border rounded shadow-sm p-3">
                            <div class="srch-col-check row">
                                <input type="checkbox" name="selected" value="${data.bookId}">
                            </div>

                            <a class="srch-thumb rounded-sm border bg-main"
                               href="${pageContext.request.contextPath}/book/${data.bookId}">
                                <c:if test="${status.index < 3}">
                                    <span class="rank-badge rank-${status.index + 1}">${status.index + 1}위</span>
                                </c:if>
                                <img src="${empty data.bookImgUrl ? '/images/thumb_ing.gif' : data.bookImgUrl}"
                                     alt="${fn:escapeXml(data.title)} 표지">
                            </a>

                            <div class="srch-info">
                                <div class="row gap-1 mb-1 text-light">
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
                                    <c:if test="${not empty data.authorName}">${data.authorName}</c:if>
                                    <c:if test="${not empty data.publisherName}">&nbsp;|&nbsp; ${data.publisherName}</c:if>
                                </p>

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

                                <div class="row gap-1 mb-2 text-light">
                                    <span class="chip chip--soft">알뜰배송</span>
                                    <span>내일 도착 보장</span>
                                </div>

                                <c:if test="${not empty data.hashtags}">
                                    <ul class="row gap-1 mb-2">
                                        <c:forEach var="tag" items="${data.hashtags}">
                                            <c:url var="tagUrl" value="/search">
                                                <c:param name="q" value="${fn:escapeXml(tag)}"/>
                                                <c:param name="keyword" value="${fn:escapeXml(tag)}"/>
                                                <c:param name="page" value="0"/>
                                                <c:param name="size" value="${currentSize}"/>
                                                <c:param name="sort_field" value="${currentSortField}"/>
                                                <c:param name="sort_order" value="${currentSortOrder}"/>
                                            </c:url>
                                            <li><a class="chip chip--tag" href="${tagUrl}">#${tag}</a></li>
                                        </c:forEach>
                                    </ul>
                                </c:if>

                                <div class="row gap-2">
                                    <button type="button" class="px-3 py-2 rounded bg-accent text-invert"
                                            data-act="cart" data-id="${data.bookId}">장바구니</button>
                                    <button type="button" class="px-3 py-2 border rounded bg-surface"
                                            data-act="like" data-id="${data.bookId}">위시리스트</button>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ol>
            </c:otherwise>
        </c:choose>

        <!-- 하단 페이징 -->
        <c:if test="${pages.totalElements > 0}">
            <div class="container mt-4">
                <nav aria-label="페이지 네비게이션">
                    <ul class="row gap-1">
                        <c:if test="${pageNumber > 1}">
                            <li>
                                <a class="px-2 py-1 border rounded-sm bg-surface shadow-sm"
                                   href="<c:url value='/search'>
                                            <c:param name='q' value='${fn:escapeXml(qParam)}'/>
                                            <c:param name='keyword' value='${fn:escapeXml(qParam)}'/>
                                            <c:param name='page' value='${pageNumber - 2}'/>
                                            <c:param name='size' value='${currentSize}'/>
                                            <c:param name='sort_field' value='${currentSortField}'/>
                                            <c:param name='sort_order' value='${currentSortOrder}'/>
                                        </c:url>">이전</a>
                            </li>
                        </c:if>

                        <c:forEach var="p" begin="${startPage}" end="${endPage}">
                            <c:set var="isActive" value="${p == pageNumber}"/>
                            <li>
                                <c:choose>
                                    <c:when test="${isActive}">
                                        <span class="px-2 py-1 border rounded-sm bg-surface shadow-sm is-active">[${p}]</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="px-2 py-1 border rounded-sm bg-surface shadow-sm"
                                           href="<c:url value='/search'>
                                                    <c:param name='q' value='${fn:escapeXml(qParam)}'/>
                                                    <c:param name='keyword' value='${fn:escapeXml(qParam)}'/>
                                                    <c:param name='page' value='${p - 1}'/>
                                                    <c:param name='size' value='${currentSize}'/>
                                                    <c:param name='sort_field' value='${currentSortField}'/>
                                                    <c:param name='sort_order' value='${currentSortOrder}'/>
                                                </c:url>">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>

                        <c:if test="${pageNumber < totalPages}">
                            <li>
                                <a class="px-2 py-1 border rounded-sm bg-surface shadow-sm"
                                   href="<c:url value='/search'>
                                            <c:param name='q' value='${fn:escapeXml(qParam)}'/>
                                            <c:param name='keyword' value='${fn:escapeXml(qParam)}'/>
                                            <c:param name='page' value='${pageNumber}'/>
                                            <c:param name='size' value='${currentSize}'/>
                                            <c:param name='sort_field' value='${currentSortField}'/>
                                            <c:param name='sort_order' value='${currentSortOrder}'/>
                                        </c:url>">다음</a>
                            </li>
                        </c:if>
                    </ul>

                    <p class="mt-2 text-light">페이지 범위: ${startPage} ~ ${endPage}</p>
                </nav>
            </div>
        </c:if>
    </form>

</div>

<script src="/js/book_all/book_all.wired.js"></script>
</body>
</html>
