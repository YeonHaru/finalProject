<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자 - 도서 관리</title>

    <!-- 공통/헤더 + 도서관리 전용 CSS (usersInfo.css는 더이상 참조하지 않습니다) -->
    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin-books.css" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-main text-main admin-books">
<jsp:include page="/common/header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">도서 관리</h1>

    <!-- 검색 -->
    <div class="search-wrapper">
        <form id="searchForm" method="get" action="${pageContext.request.requestURI}" class="search-form">
            <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="제목, ISBN 검색" />
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 상단 툴바 -->
    <div class="toolbar">
        <button type="button" class="btn btn-accent" id="btnAddBook">도서 등록</button>
    </div>

    <!-- 도서 목록 테이블 -->
    <div class="table-scroll">
        <table class="admin-table admin-books-table" id="booksTable">
            <colgroup>
                <col class="col-id" />
                <col class="col-title" />
                <col class="col-isbn" />
                <col class="col-author" />
                <col class="col-publisher" />
                <col class="col-category" />
                <col class="col-price" />
                <col class="col-discount" />
                <col class="col-stock" />
                <col class="col-created" />
                <col class="col-actions" />
            </colgroup>
            <thead>
            <tr>
                <th>책 ID</th>
                <th>제목</th>
                <th class="hide-md">ISBN</th>
                <th>저자</th>
                <th class="hide-lg">출판사</th>
                <th class="hide-lg">카테고리</th>
                <th>가격</th>
                <th class="hide-lg">할인가</th>
                <th>재고</th>
                <th class="hide-lg">생성일</th>
                <th>작업</th>
            </tr>
            </thead>

            <tbody id="booksTableBody">
            <c:forEach var="book" items="${booksPage.content}">
                <tr class="data-row"
                    data-id="${book.bookId}"
                    data-title="${book.title}"
                    data-isbn="${book.isbn}"
                    data-price="${book.price}"
                    data-stock="${book.stock}"
                    data-authorname="${book.authorName}"
                    data-publishername="${book.publisherName}"
                    data-categoryname="${book.categoryName}">
                    <td>${book.bookId}</td>
                    <td class="t-left" title="${book.title}">
                        <div class="title-ellipsis">${book.title}</div>
                        <c:if test="${not empty book.categoryName}">
                            <span class="chip chip--ghost">${book.categoryName}</span>
                        </c:if>
                    </td>
                    <td class="hide-md"><span class="isbn-mono">${book.isbn}</span></td>
                    <td>${book.authorName != null ? book.authorName : ''}</td>
                    <td class="hide-lg">${book.publisherName != null ? book.publisherName : ''}</td>
                    <td class="hide-lg">${book.categoryName != null ? book.categoryName : ''}</td>
                    <td class="t-right"><c:out value="${book.price}" /></td>
                    <td class="t-right hide-lg"><c:out value="${book.discountedPrice}" /></td>
                    <td>${book.stock}</td>
                    <td class="hide-lg">${book.createdAt}</td>
                    <td>
                        <button type="button" class="btn btn-accent btnEdit">수정</button>
                        <button type="button" class="btn btn-delete btnDelete">삭제</button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty booksPage.content}">
                <tr><td colspan="11" class="t-center text-light">검색 결과가 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- 페이징 -->
    <c:if test="${booksPage.totalPages > 0}">
        <div class="pagination mt-2">
            <c:if test="${booksPage.number > 0}">
                <a href="?keyword=${param.keyword}&page=${booksPage.number - 1}">◀ 이전</a>
            </c:if>
            <c:forEach begin="0" end="${booksPage.totalPages - 1}" var="i">
                <a href="?keyword=${param.keyword}&page=${i}" class="${i == booksPage.number ? 'active' : ''}">${i + 1}</a>
            </c:forEach>
            <c:if test="${booksPage.number < booksPage.totalPages - 1}">
                <a href="?keyword=${param.keyword}&page=${booksPage.number + 1}">다음 ▶</a>
            </c:if>
        </div>
    </c:if>
</div>

<!-- 모달 (JS는 show/hide만 호출하므로 ID 그대로 유지) -->
<div id="bookModal" aria-hidden="true" role="dialog" aria-modal="true">
    <h3 id="modalTitle">도서 등록</h3>
    <form id="bookForm" action="#" method="post">
        <input type="hidden" name="bookId" id="bookId" />

        <p>제목
            <input type="text" name="title" id="title" required />
        </p>
        <p>ISBN
            <input type="text" name="isbn" id="isbn" required />
        </p>
        <p>가격
            <input type="number" name="price" id="price" min="0" step="1" required />
        </p>
        <p>재고
            <input type="number" name="stock" id="stock" min="0" step="1" required />
        </p>
        <p>저자
            <select id="authorId" name="authorId">
                <option value="">선택</option>
            </select>
        </p>
        <p>출판사
            <select id="publisherId" name="publisherId">
                <option value="">선택</option>
            </select>
        </p>
        <p>카테고리
            <select id="categoryId" name="categoryId">
                <option value="">선택</option>
            </select>
        </p>

        <p>
            <button type="submit">저장</button>
            <button type="button" id="btnCloseModal">닫기</button>
        </p>
    </form>
</div>

<!-- 기존 JS 그대로 사용 -->
<script src="${ctx}/js/admin/admin_books_list.js"></script>
</body>
</html>
