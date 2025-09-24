<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자 - 카테고리 관리</title>

    <!-- 공통/헤더 + 관리자 통합 CSS -->
    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css" />

    <script>
        window.ctx = "${ctx}";
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-main text-main admin-categories">
<jsp:include page="/common/admin_page_header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">카테고리 관리</h1>

    <!-- 검색 (해시태그와 동일 컴포넌트) -->
    <div class="search-wrapper">
        <form id="searchForm" method="get" action="${ctx}/admin/categories" class="search-form">
            <input type="text" id="searchKeyword" name="keyword" placeholder="카테고리 이름 검색"
                   value="${param.keyword != null ? param.keyword : ''}">
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 상단 툴바 -->
    <div class="toolbar">
        <button id="btnAddCategory" type="button" class="btn btn-accent btn--glass">카테고리 등록</button>    </div>

    <!-- 목록 테이블 -->
    <div class="table-scroll">
        <table class="admin-table admin-categories-table" id="categoriesTable">
            <colgroup>
                <col class="col-id" />
                <col class="col-name" />
                <col class="col-created" />
                <col class="col-actions" />
            </colgroup>
            <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>생성일</th>
                <th>작업</th>
            </tr>
            </thead>
            <tbody id="categoriesTableBody">
            <c:forEach var="category" items="${categoriesPage.content}">
                <tr data-id="${category.categoryId}">
                    <td class="category-id t-center">${category.categoryId}</td>
                    <td class="category-name t-left" title="${category.name}">${category.name}</td>
                    <td>${category.createdAt}</td>
                    <td class="actions-cell">
                        <button type="button" class="btn btn-accent btn--glass btnEdit btn-edit">수정</button>
                        <button type="button" class="btn btn-delete btn--glass btnDelete btn-delete">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty categoriesPage.content}">
                <tr><td colspan="4" class="t-center">데이터가 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- 페이징 (해시태그와 동일 구조/스타일) -->
    <div id="pagination" class="pagination">
        <c:if test="${categoriesPage.totalPages > 0}">
            <c:forEach begin="0" end="${categoriesPage.totalPages - 1}" var="i">
                <a href="#" class="page-btn ${i == categoriesPage.number ? 'active' : ''}" data-page="${i}">${i + 1}</a>
            </c:forEach>
        </c:if>
    </div>
</div>

<p class="ht-footnote">© Geulbut Admin Categories List</p>

<!-- 등록/수정 모달 (공통 모달 톤) -->
<div id="categoryModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="modal-content" role="document">
        <h2 id="modalTitle">카테고리 등록</h2>
        <input type="hidden" id="modalCategoryId" />
        <label>
            <span class="t-left" style="display:block; margin-bottom:4px; font-size:.9rem;">카테고리 이름</span>
            <input type="text" id="modalCategoryName" />
        </label>
        <div class="t-right" style="margin-top:10px;">
            <button id="modalSaveBtn" type="button" class="btn btn-accent btn--glass">저장</button>
            <button id="modalCloseBtn" type="button" class="btn btn-delete btn--glass">닫기</button>
        </div>
    </div>
</div>

<!-- 책 목록 모달 (읽기용) -->
<div id="booksModal" class="modal" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="modal-content" role="document">
        <h2 id="booksModalTitle">카테고리 속 책 목록</h2>
           <!-- 스크롤 래퍼: 작을 땐 스크롤, 클 땐 넉넉한 폭으로 -->
           <div class="modal-table-scroll">
             <table class="admin-table admin-books-table" id="booksTable">
               <colgroup>
                 <col style="width: 84px;" />     <!-- ID -->
                 <col style="width: auto;" />     <!-- 제목 (가변) -->
                 <col style="width: 160px;" />    <!-- 저자 -->
                 <col style="width: 160px;" />    <!-- 출판사 -->
                 <col style="width: 110px;" />    <!-- 가격 -->
               </colgroup>
            <thead>
            <tr>
                <th>ID</th><th>제목</th><th>저자</th><th>출판사</th><th>가격</th>
            </tr>
            </thead>
            <tbody></tbody>
                      </table>
                  </div>
           <div class="modal-footer">
             <button id="booksModalCloseBtn" type="button" class="btn btn-delete btn--glass">닫기</button>
           </div>
    </div>
</div>

<!-- JS 분리 -->
<script src="${ctx}/js/admin/admin_categories.js?v=1"></script>
<!-- 관리자 헤더 드롭다운 스크립트 -->
<script src="${ctx}/js/admin/admin_page_header.js" defer></script>
</body>
</html>
