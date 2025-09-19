<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>출판사 관리</title>
    <link rel="stylesheet" href="<c:url value='/css/admin/admin-publishers.css'/>">
</head>
<body>
<h2>출판사 관리</h2>

<!-- 검색 -->
<input type="text" id="searchKeyword" placeholder="출판사 ID 또는 이름 검색" value="${keyword != null ? keyword : ''}">
<button id="btnSearch">검색</button>
<button id="btnAddPublisher">출판사 등록</button>

<!-- 출판사 목록 테이블 -->
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>이름</th>
        <th>설명</th>
        <th>생성일</th>
        <th>작업</th>
    </tr>
    </thead>
    <tbody id="publishersTableBody">
    <c:forEach var="publisher" items="${publishersPage.content}">
        <tr data-id="${publisher.publisherId}">
            <td>${publisher.publisherId}</td>
            <td class="publisher-name">${publisher.name}</td>
            <td class="publisher-description">${publisher.description}</td> <!-- 수정 -->
            <td>${publisher.createdAt}</td>
            <td>
                <button class="btn btn-edit">수정</button>
                <button class="btn btn-delete">삭제</button>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 페이징 버튼 -->
<div id="pagination">
    <c:if test="${publishersPage.totalPages > 0}">
        <c:if test="${!publishersPage.first}">
            <button class="page-btn" data-page="${publishersPage.number - 1}">이전</button>
        </c:if>

        <c:forEach begin="0" end="${publishersPage.totalPages - 1}" var="i">
            <button class="page-btn ${i == publishersPage.number ? 'active' : ''}" data-page="${i}">${i + 1}</button>
        </c:forEach>

        <c:if test="${!publishersPage.last}">
            <button class="page-btn" data-page="${publishersPage.number + 1}">다음</button>
        </c:if>
    </c:if>
</div>

<!-- 모달 -->
<div id="publisherModal" class="modal">
    <div class="modal-content">
        <h2 id="modalTitle"></h2>
        <input type="hidden" id="modalPublisherId">
        <div>
            <label>출판사 이름</label>
            <input type="text" id="modalPublisherName">
        </div>
        <div>
            <label>설명</label>
            <textarea id="modalPublisherDescription"></textarea>
        </div>
        <button id="modalSaveBtn">저장</button>
        <button id="modalCloseBtn">닫기</button>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/js/admin/admin_publishers.js'/>"></script>
</body>
</html>
