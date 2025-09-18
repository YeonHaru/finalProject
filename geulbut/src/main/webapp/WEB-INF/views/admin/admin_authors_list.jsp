<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 9. 18.
  Time: 오후 4:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>작가 관리</title>
  <link rel="stylesheet" href="<c:url value='/css/admin/admin-authors.css'/>">
</head>
<body>
<h2>작가 관리</h2>

<!-- 검색 -->
<input type="text" id="searchKeyword" placeholder="작가명 검색">
<button id="btnSearch">검색</button>
<button id="btnAdd">작가 등록</button>

<!-- 작가 목록 테이블 -->
<table>
  <thead>
  <tr>
    <th>ID</th>
    <th>이름</th>
    <th>생성일</th>
    <th>작업</th>
  </tr>
  </thead>
  <tbody id="authorsTableBody">
  <c:forEach var="author" items="${authorsPage.content}">
    <tr data-id="${author.authorId}">
      <td>${author.authorId}</td>
      <td class="author-name">${author.name}</td>
      <td>${author.createdAt}</td>
      <td>
        <button class="btn btn-edit">수정</button>
        <button class="btn btn-delete">삭제</button>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<!-- 모달 -->
<div id="authorModal" class="modal">
  <div class="modal-content">
    <h3 id="modalTitle">작가 등록</h3>
    <input type="hidden" id="modalAuthorId">
    <div>
      <label>이름: </label>
      <input type="text" id="modalAuthorName">
    </div>
    <button id="modalSaveBtn">저장</button>
    <button id="modalCloseBtn">닫기</button>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/js/admin/admin_authors.js'/>"></script>
</body>
</html>
