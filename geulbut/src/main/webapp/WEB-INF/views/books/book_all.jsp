<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">


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
        <!-- 탭 버튼 -->
        <div class="tab-buttons">

            <button class="tab-btn active" onclick="switchTab(this, 'weekly')">카테고리</button>
            <button class="tab-btn" onclick="switchTab(this, 'monthly')">해시태그</button>
        </div>

      <!-- 카테고리 -->
<div class="category-grid-weekly">
    <div class="category-item featured">종합</div>
    <div class="category-item">소설</div>
    <div class="category-item">교육</div>
    <div class="category-item">자기계발</div>
    <div class="category-item">종교</div>
    <div class="category-item">에세이</div>
</div>

<!-- 해시태그 -->
<div class="category-grid-monthly">
    <div class="category-item">자기계발</div>
    <div class="category-item">인문과학</div>
    <div class="category-item">역사/문화</div>
    <div class="category-item">정치/법률</div>
    <div class="category-item">종교</div>
    <div class="category-item">예술</div>
</div>
    </div>

    <!-- 상단 툴바(체크/일괄 버튼만 유지, 페이징 링크는 하단으로 이동) -->
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
        <!-- 컨트롤러에서 내려준 표시용 1-base 페이지 번호를 보존하려면 필요시 사용 -->
        <input type="hidden" id="page" name="page" value="${pageNumber - 1}"/>
        <input type="hidden" name="keyword" value="${keyword}"/>
        <input type="hidden" name="size" value="${size}"/>

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
                            <!-- ✅ 아이콘 영역 (공유만 표시) -->
                            <div class="srch-icons">
                                <button class="icon-btn" data-act="share" title="공유">
                                    <i class="fa-solid fa-share-nodes">🔗</i>
                                </button>

                                <!-- 품절인 경우만 재입고 알림 표시 -->
                                <!-- 디버깅: stock = ${data.stock} -->
                                <c:if test="${data.stock != null && data.stock == 0}">
                                    <button class="icon-btn" data-act="restock" title="재입고 알림">
                                        <i class="fa-regular fa-bell">🔔</i>
                                    </button>
                                </c:if>
                            </div>

                            <!-- 체크박스 -->
                            <div class="srch-col-check row">
                                <input type="checkbox" name="selected" value="${data.bookId}">
                            </div>

                            <!-- 썸네일 -->
                            <a class="srch-thumb rounded-sm border bg-main"
                               href="${pageContext.request.contextPath}/book/${data.bookId}">
                                <c:if test="${status.index < 3}">
                                    <span class="rank-badge rank-${status.index + 1}">${status.index + 1}위</span>
                                </c:if>
                                <img src="${empty data.bookImgUrl ? '/images/thumb_ing.gif' : data.bookImgUrl}"
                                     alt="${fn:escapeXml(data.title)} 표지">
                            </a>

                            <!-- 정보 -->
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
                                    <span>내일 도착 보장</span>
                                </div>

                                <!-- 해시태그 -->
                                <c:if test="${not empty data.hashtags}">
                                    <ul class="row gap-1 mb-2">
                                        <c:forEach var="tag" items="${data.hashtags}">
                                            <c:url var="tagUrl" value="/search">
                                                <c:param name="keyword" value="${fn:escapeXml(tag)}"/>
                                                <c:param name="page" value="0"/>
                                                <c:param name="size" value="${size}"/>
                                            </c:url>
                                            <li>
                                                <a class="chip chip--tag" href="${tagUrl}">#${tag}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:if>

                                <!-- 액션 버튼 (품절 여부에 따라 다르게 표시) -->
                                <div class="row gap-2">
                                    <!-- 디버깅: stock = ${data.stock} -->
                                    <c:choose>
                                        <c:when test="${data.stock != null && data.stock == 0}">
                                            <!-- 품절인 경우: 장바구니 버튼 비활성화 -->
                                            <button type="button" class="px-3 py-2 rounded bg-disabled text-muted" disabled>
                                                품절
                                            </button>
                                            <button type="button" class="px-3 py-2 border rounded bg-surface"
                                                    data-act="like" data-id="${data.bookId}">위시리스트</button>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- 정상 재고인 경우: 장바구니 버튼 활성화 -->
                                            <button type="button" class="px-3 py-2 rounded bg-accent text-invert"
                                                    data-act="cart" data-id="${data.bookId}">장바구니</button>
                                            <button type="button" class="px-3 py-2 border rounded bg-surface"
                                                    data-act="like" data-id="${data.bookId}">위시리스트</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ol>
            </c:otherwise>
        </c:choose>

        <!-- 하단 페이징 (0-base page 전송) -->
        <c:if test="${pages.totalElements > 0}">
            <div class="container mt-4">
                <nav aria-label="페이지 네비게이션">
                    <ul class="row gap-1">
                        <!-- 이전 -->
                        <c:if test="${pageNumber > 1}">
                            <li>
                                <a class="px-2 py-1 border rounded-sm bg-surface shadow-sm"
                                   href="<c:url value='/search'>
                                            <c:param name='keyword' value='${keyword}'/>
                                            <c:param name='page' value='${pageNumber - 2}'/>
                                            <c:param name='size' value='${size}'/>
                                        </c:url>">이전</a>
                            </li>
                        </c:if>

                        <!-- 번호 (블록 페이징) -->
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
                                                    <c:param name='keyword' value='${keyword}'/>
                                                    <c:param name='page' value='${p - 1}'/>
                                                    <c:param name='size' value='${size}'/>
                                                </c:url>">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>

                        <!-- 다음 -->
                        <c:if test="${pageNumber < totalPages}">
                            <li>
                                <a class="px-2 py-1 border rounded-sm bg-surface shadow-sm"
                                   href="<c:url value='/search'>
                                            <c:param name='keyword' value='${keyword}'/>
                                            <c:param name='page' value='${pageNumber}'/>
                                            <c:param name='size' value='${size}'/>
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

<script src="/js/book_all/book_all.js"></script>

</body>
</html>