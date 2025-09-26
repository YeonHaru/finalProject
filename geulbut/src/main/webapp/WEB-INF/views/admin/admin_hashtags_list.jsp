<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <script>window.ctx = "${ctx}";</script>
    <title>관리자 - 해시태그 관리</title>

    <!-- 공통/헤더 + 관리자 통합 CSS -->
    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-main text-main admin-hashtags has-bg">
<jsp:include page="/common/admin_page_header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">해시태그 관리</h1>

    <!-- 검색 -->
    <div class="search-wrapper">
        <form id="searchForm" method="get" action="${ctx}/admin/hashtags" class="search-form">
            <input type="text" id="keyword" name="keyword" placeholder="해시태그 검색..." value="${param.keyword}" />
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 상단 툴바 -->
    <div class="toolbar">
        <button id="btnAddHashtag" type="button" class="btn btn-accent btn--glass">해시태그 추가</button>
    </div>

    <!-- 테이블 -->
    <div class="table-scroll">
        <table class="admin-table admin-hashtags-table" id="hashtagsTable">
            <colgroup>
                <col class="col-id" />
                <col class="col-name" />
                <col class="col-created" />
                <col class="col-books" />
                <col class="col-actions" />
            </colgroup>
            <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>생성일</th>
                <th>등록 도서</th>
                <th>작업</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="h" items="${hashtagsPage.content}">
                <tr class="data-row" data-id="${h.hashtagId}">
                    <td class="hashtag-id" data-id="${h.hashtagId}">${h.hashtagId}</td>
                    <td class="t-left">${h.name}</td>
                    <td>${h.createdAt}</td>
                    <td class="t-left">
                        <c:choose>
                            <c:when test="${not empty h.books}">
                                <ul>
                                    <c:forEach var="b" items="${h.books}">
                                        <li>${b.title} (${b.isbn})</li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                등록된 도서 없음
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="actions-cell">
                        <button type="button" class="btn btn-cer-secondary save-btn">수정</button>
                        <button type="button" class="btn btn-cer-success delete-btn">삭제</button>
                        <button type="button" class="btn btn--glass btn-accent btn-manage-books">도서 관리</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이지네이션 (카테고리/공통 톤과 동일: #pagination .page-btn) -->
    <div id="pagination" class="pagination">
        <c:forEach var="i" begin="0" end="${hashtagsPage.totalPages - 1}">
            <a href="#" class="page-btn ${i == hashtagsPage.number ? 'active' : ''}" data-page="${i}">${i + 1}</a>
        </c:forEach>
    </div>
</div>

<p class="ht-footnote">© Geulbut Admin Hashtags List</p>


<!-- 해시태그 등록/수정 모달: 공통 모달 톤 사용 -->
<div class="modal" id="hashtagModal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="modal-content" role="document">
        <h2 id="modalTitle" style="margin-top:0;">해시태그 등록</h2>
        <label>
            <span class="t-left" style="display:block; margin-bottom:4px; font-size:.9rem;">이름</span>
            <input type="text" id="hashtagName" placeholder="해시태그 이름" />
        </label>
        <div class="t-right" style="margin-top:10px;">
            <button id="modalSaveBtn" type="button" class="btn btn-cer-secondary save-btn">저장</button>
            <button id="modalCloseBtn" type="button" class="btn btn-cer-success delete-btn">닫기</button>
        </div>
    </div>
</div>

<!-- 책 목록 모달 -->
<div class="modal" id="booksModal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="modal-content" role="document">
        <h2 id="booksModalTitle" style="margin-top:0;">해시태그 등록 도서</h2>

        <!-- 검색창 (공통 검색폼 톤) -->
        <div class="search-wrapper">
            <form id="bookSearchForm" class="search-form">
                <input type="text" id="bookKeyword" name="bookKeyword" placeholder="도서 검색..." />
                <button type="submit" class="btn-search">검색</button>
            </form>
        </div>

        <!-- 검색 결과 리스트 -->
        <div id="booksList" class="modal__scroll"></div>

        <!-- 모달 내부 전용 페이지네이션 -->
        <div id="booksPager" class="pagination modal-pagination"></div>

        <!-- 우하단 정렬 푸터 -->
        <div class="modal__footer" id="booksModalFooter">
            <!-- 저장 버튼은 JS가 필요할 때 주입합니다 -->
            <button id="booksModalClose" type="button" class="btn btn-cer-success delete-btn">닫기</button>
        </div>
    </div>
</div>

<!-- JS 분리 -->
<script src="${ctx}/js/admin/admin_hashtags.js?v=1"></script>
<!-- 관리자 헤더 드롭다운 스크립트 -->
<script src="${ctx}/js/admin/admin_page_header.js" defer></script>
</body>
</html>
