<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자 - 작가 관리</title>

    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css" />
</head>
<body class="bg-main text-main admin-authors">
<jsp:include page="/common/header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">작가 관리</h1>

    <!-- 검색 -->
    <div class="search-wrapper">
        <form id="authorSearchForm" method="get" action="${ctx}/admin/authors" class="search-form">
            <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="작가명 검색" />
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 상단 툴바 -->
    <div class="toolbar">
        <button type="button" class="btn btn-accent btn--glass" id="btnAddAuthor">작가 등록</button>
    </div>

    <!-- 작가 목록 테이블 -->
    <div class="table-scroll">
        <table class="admin-table admin-authors-table" id="authorsTable">
            <colgroup>
                <col class="col-id" /><col class="col-name" /><col class="col-img" />
                <col class="col-created" /><col class="col-desc" /><col class="col-actions" />
            </colgroup>
            <thead>
            <tr>
                <th>ID</th><th>이름</th><th>이미지</th><th>생성일</th><th>설명</th><th>작업</th>
            </tr>
            </thead>
            <tbody id="authorsTableBody">
            <c:forEach var="author" items="${authorsPage.content}">
                <tr class="data-row"
                    data-id="${author.authorId}"
                    data-name="${author.name}"
                    data-description="${author.description}"
                    data-imgurl="${author.imgUrl}"
                    data-createdat="${author.createdAt}">
                    <td>${author.authorId}</td>
                    <td class="t-left author-name">${author.name}</td>
                    <td>
                        <c:if test="${not empty author.imgUrl}">
                            <img src="${author.imgUrl}" class="author-thumb" alt="작가 이미지">
                        </c:if>
                    </td>
                    <td class="created-at-cell">${author.createdAt}</td>
                    <td class="t-left author-description">${author.description}</td>
                    <td>
                        <button type="button" class="btn btn-accent btn--glass btnEdit">수정</button>
                        <button type="button" class="btn btn-delete btn--glass btnDelete">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이지네이션 -->
    <c:if test="${authorsPage.totalPages > 0}">
        <div class="pagination mt-2">
            <c:forEach begin="0" end="${authorsPage.totalPages - 1}" var="i">
                <c:url var="pageUrl" value="${ctx}/admin/authors">
                    <c:param name="keyword" value="${param.keyword}" />
                    <c:param name="page" value="${i}" />
                </c:url>
                <a href="${pageUrl}" class="${i == authorsPage.number ? 'active' : ''}">${i + 1}</a>
            </c:forEach>
        </div>
    </c:if>
</div>

<!-- 작가 등록/수정 모달 -->
<div id="authorModal" aria-hidden="true" role="dialog" aria-modal="true" style="display:none;">
    <div class="modal__dialog" role="document">
        <div class="modal__header">
            <h3 id="modalTitle">작가 등록</h3>
            <button type="button" class="modal__close" id="btnCloseModal">×</button>
        </div>

        <form id="authorForm" class="modal__form">
            <input type="hidden" id="modalAuthorId">
            <label>이름<input type="text" id="modalAuthorName" placeholder="작가명을 입력하세요" required /></label>
            <label>이미지 URL<input type="text" id="modalAuthorImgUrl" placeholder="https://example.com/image.jpg" /></label>
            <label>생성일<input type="text" id="modalAuthorCreatedAt" placeholder="수정 시 자동 채움" readonly /></label>
            <label style="grid-column:1 / -1;">설명<textarea id="modalAuthorDescription" rows="4" placeholder="간단한 소개나 메모를 입력하세요"></textarea></label>
            <div style="grid-column:1 / -1;">
                <span style="display:block; margin-bottom:4px; font-size:.9rem;">미리보기</span>
                <img id="modalAuthorImgPreview" src="" alt="작가 이미지" />
            </div>
            <div class="modal__footer">
                <button type="submit" class="btn btn-accent" id="modalSaveBtn">저장</button>
                <button type="button" class="btn" id="modalCloseBtn2">닫기</button>
            </div>
        </form>
    </div>
</div>

<!-- 책 목록 전용 모달 -->
<div id="authorBooksModal" aria-hidden="true" role="dialog">
    <div class="modal__dialog">
        <div class="modal__header">
            <h3>작가 책 목록</h3>
            <button type="button" class="modal__close" id="btnCloseBooksModal">×</button>
        </div>
        <div class="modal__content">
            <ul id="booksList"></ul>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${ctx}/js/admin/admin_authors.js"></script>
</body>
</html>
