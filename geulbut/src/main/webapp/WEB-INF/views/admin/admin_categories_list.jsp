<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자 - 카테고리 관리</title>

    <!-- 공통/헤더 + 통합 관리자 CSS -->
    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-main text-main admin-categories">
<jsp:include page="/common/header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">카테고리 관리</h1>

    <!-- 검색 (카테고리 전용: admin.css에서 .admin-categories .search-box 스타일 적용) -->
    <div class="search-box">
        <input type="text" id="searchKeyword" placeholder="카테고리 이름 검색"
               value="${param.keyword != null ? param.keyword : ''}">
        <button id="btnSearch">검색</button>
        <button id="btnAddCategory">카테고리 등록</button>
    </div>

    <!-- 목록 -->
    <div class="table-scroll">
        <table class="admin-table admin-categories-table" id="categoriesTable">
            <colgroup>
                <col style="width:100px" />   <!-- ID -->
                <col style="width:auto" />    <!-- 이름 -->
                <col style="width:160px" />   <!-- 생성일 -->
                <col style="width:170px" />   <!-- 작업 -->
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
                    <td>${category.categoryId}</td>
                    <td class="category-name t-left" title="${category.name}">${category.name}</td>
                    <td>${category.createdAt}</td>
                    <td>
                        <button type="button" class="btn btn-edit">수정</button>
                        <button type="button" class="btn btn-delete">삭제</button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty categoriesPage.content}">
                <tr><td colspan="4" class="t-center">데이터가 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- 페이징(기존 JS 유지: #pagination .page-btn) -->
    <div id="pagination" class="mt-2">
        <c:if test="${categoriesPage.totalPages > 0}">
            <c:if test="${!categoriesPage.first}">
                <button class="page-btn" data-page="${categoriesPage.number - 1}">이전</button>
            </c:if>

            <c:forEach begin="0" end="${categoriesPage.totalPages - 1}" var="i">
                <button class="page-btn ${i == categoriesPage.number ? 'active' : ''}" data-page="${i}">${i + 1}</button>
            </c:forEach>

            <c:if test="${!categoriesPage.last}">
                <button class="page-btn" data-page="${categoriesPage.number + 1}">다음</button>
            </c:if>
        </c:if>
    </div>
</div>

<!-- 모달 -->
<div id="categoryModal" class="modal" style="display:none;" aria-hidden="true" role="dialog" aria-modal="true">
    <div class="modal-content" role="document">
        <h2 id="modalTitle" class="mb-2">카테고리 등록</h2>
        <input type="hidden" id="modalCategoryId" />
        <div class="mb-2">
            <label for="modalCategoryName">카테고리 이름</label>
            <input type="text" id="modalCategoryName" />
        </div>
        <button id="modalSaveBtn">저장</button>
        <button id="modalCloseBtn">닫기</button>
    </div>
</div>

<script src="${ctx}/js/admin/admin_categories.js"></script>
</body>
</html>
