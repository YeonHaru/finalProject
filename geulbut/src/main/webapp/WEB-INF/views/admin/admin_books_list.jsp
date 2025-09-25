<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <script>window.ctx = "${ctx}";</script>
    <title>관리자 - 도서 관리</title>

    <link rel="stylesheet" href="${ctx}/css/00_common.css"/>
    <link rel="stylesheet" href="${ctx}/css/header.css"/>
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-main text-main admin-books has-bg">
<jsp:include page="/common/admin_page_header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">도서 관리</h1>

    <!-- 검색 -->
    <div class="search-wrapper">
        <form id="bookSearchForm" method="get" action="${ctx}/admin/books" class="search-form">
            <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="제목, ISBN 검색"/>
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 상단 툴바 -->
    <div class="toolbar">
        <button type="button" class="btn btn-accent btn--glass" id="btnAddBook">도서 등록</button>
    </div>

    <!-- 도서 목록 테이블 -->
    <div class="table-scroll">
        <table class="admin-table admin-books-table" id="booksTable" data-ctx="${ctx}">
            <colgroup>
                <col class="col-id"/>
                <col class="col-title"/>
                <col class="col-img"/>
                <col class="col-isbn"/>
                <col class="col-author"/>
                <col class="col-publisher"/>
                <col class="col-category"/>
                <col class="col-price"/>
                <col class="col-discount"/>
                <col class="col-stock"/>
                <col class="col-created"/>
                <col class="col-actions"/>
            </colgroup>
            <thead>
            <tr>
                <th>책 ID</th>
                <th>제목</th>
                <th>이미지</th>
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
            <c:set var="matchCount" value="0"/>
            <c:forEach var="book" items="${booksPage.content}">
                <c:set var="rowText"
                       value="${fn:toLowerCase(book.title)} ${book.isbn} ${fn:toLowerCase(book.authorName)} ${fn:toLowerCase(book.publisherName)} ${fn:toLowerCase(book.categoryName)}"/>
                <c:if test="${empty param.keyword or fn:contains(rowText, param.keyword)}">
                    <c:set var="matchCount" value="${matchCount + 1}"/>
                    <tr class="data-row" data-id="${book.bookId}">
                        <td>${book.bookId}</td>
                        <td class="t-left">
                            <div class="title-ellipsis" title="${book.title}">${book.title}</div>
                        </td>
                        <td>
                            <c:if test="${not empty book.imgUrl}">
                                <img src="${book.imgUrl}" alt="${book.title}" class="book-thumb"/>
                            </c:if>
                        </td>
                        <td><span class="isbn-mono">${book.isbn}</span></td>
                        <td>${book.authorName}</td>
                        <td>${book.publisherName}</td>
                        <td>${book.categoryName}</td>
                        <td class="t-right"><c:out value="${book.price}"/></td>
                        <td class="t-right"><c:out value="${book.discountedPrice}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${book.stock gt 0}">
                                    <span class="stock-chip ok">${book.stock}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-chip out">품절</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${book.createdAt}</td>
                        <td>

                            <button type="button" class="btn btn-accent btn--glass btnView">상세보기</button>
                            <button type="button" class="btn btn-accent btn--glass btnEdit">수정</button>
                            <button type="button" class="btn btn-delete btn--glass btnDelete">삭제</button>

                        </td>
                    </tr>
                </c:if>
            </c:forEach>
            <c:if test="${matchCount == 0}">
                <tr>
                    <td colspan="12" class="t-center text-light">검색 결과가 없습니다.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- 페이징 -->
    <div class="pagination">
        <c:forEach var="i" begin="0" end="${booksPage.totalPages - 1}">
            <a href="?page=${i}&keyword=${param.keyword}" class="${i == booksPage.number ? 'active' : ''}">${i + 1}</a>
        </c:forEach>
    </div>
</div>

<p class="ht-footnote">© Geulbut Admin Books List</p>

<!-- 도서 등록/수정 모달 -->
<div id="bookModal" aria-hidden="true" role="dialog" aria-modal="true" aria-labelledby="modalTitle" style="display:none;">
    <div class="modal__dialog" role="document">
        <div class="modal__header">
            <h3 id="modalTitle">도서 등록</h3>
            <button type="button" class="modal__close" id="btnCloseModal" aria-label="닫기">×</button>
        </div>

        <form id="bookForm" class="modal__form">
            <input type="hidden" name="bookId" id="bookId"/>

            <!-- 추가된 hidden 필드 -->
            <input type="hidden" name="discountedPrice" id="discountedPrice" value="0"/>
            <input type="hidden" name="orderCount" id="orderCount" value="0"/>
            <input type="hidden" name="wishCount" id="wishCount" value="0"/>

            <div class="form-grid">
                <label>제목 <input type="text" name="title" id="title" required/></label>
                <label>ISBN <input type="text" name="isbn" id="isbn" required/></label>
                <label>가격 <input type="number" name="price" id="price" min="0" step="1" required/></label>
                <label>재고 <input type="number" name="stock" id="stock" min="0" step="1" required/></label>
                <label>저자 <select id="authorId" name="authorId">
                    <option value="">선택</option>
                </select></label>
                <label>출판사 <select id="publisherId" name="publisherId">
                    <option value="">선택</option>
                </select></label>
                <label>카테고리 <select id="categoryId" name="categoryId">
                    <option value="">선택</option>
                </select></label>
                <label>이미지 URL <input type="text" name="imgUrl" id="imgUrl"/></label>
                <div id="imgPreviewWrapper">
                    <img id="imgPreview" src="" alt="이미지 미리보기"
                         style="max-width:200px; max-height:300px; display:none;"/>
                </div>
            </div>

            <div class="modal__footer">
                 <button type="submit" class="btn btn-cer-secondary save-btn">저장</button>
                 <button type="button" class="btn btn-cer-success delete-btn" id="btnCancel">닫기</button>
            </div>

        </form>
    </div>
</div>

<script src="${ctx}/js/admin/admin_books_list.js"></script>
<script src="${ctx}/js/admin/admin_page_header.js" defer></script>
</body>
</html>
