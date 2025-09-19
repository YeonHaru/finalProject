<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>카테고리 관리</title>
    <link rel="stylesheet" href="<c:url value='/css/admin/admin-categories.css'/>">
</head>
<body>
<h2>카테고리 관리</h2>

<!-- 검색 -->
<div class="search-box">
    <input type="text" id="searchKeyword" placeholder="카테고리 이름 검색" value="${keyword != null ? keyword : ''}">
    <button id="btnSearch">검색</button>
    <button id="btnAddCategory">카테고리 등록</button>
</div>

<!-- 카테고리 목록 테이블 -->
<table>
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
            <td class="category-name">${category.name}</td>
            <td>${category.createdAt}</td>
            <td>
                <button class="btn btn-edit">수정</button>
                <button class="btn btn-delete">삭제</button>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 페이징 -->
<div id="pagination">
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

<!-- 모달 -->
<div id="categoryModal" class="modal" style="display:none;">
    <div class="modal-content">
        <h2 id="modalTitle"></h2>
        <input type="hidden" id="modalCategoryId">
        <div>
            <label>카테고리 이름</label>
            <input type="text" id="modalCategoryName">
        </div>
        <button id="modalSaveBtn">저장</button>
        <button id="modalCloseBtn">닫기</button>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/js/admin/admin_categories.js'/>"></script>
</body>
</html>
