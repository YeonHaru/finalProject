<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>해시태그 관리</title>
    <link rel="stylesheet" href="<c:url value='/css/admin/admin.css'/>">
</head>
<body class="admin-hashtags">
<div class="page">

    <h1 class="t-left">해시태그 관리</h1>

    <!-- 검색 -->
    <div class="search-wrapper">
        <form id="searchForm" class="search-form">
            <input type="text" id="keyword" name="keyword" placeholder="해시태그 검색..." value="${keyword}">
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 툴바 -->
    <div class="toolbar">
        <button id="btnAddHashtag" class="btn btn-accent">해시태그 추가</button>
    </div>

    <!-- 테이블 -->
    <div class="table-scroll">
        <table class="admin-table" id="hashtagsTable">
            <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>생성일</th>
                <th>등록 도서</th>
                <th>액션</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="h" items="${hashtagsPage.content}">
                <tr data-id="${h.hashtagId}">
                    <td class="hashtag-id" data-id="${h.hashtagId}">${h.hashtagId}</td>
                    <td>${h.name}</td>
                    <td>${h.createdAt}</td>
                    <td>
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
                    <td>
                        <button class="btn btn-edit btnEdit">수정</button>
                        <button class="btn btn-delete btnDelete">삭제</button>
                        <button class="btn btn-accent btn-manage-books">도서 관리</button> <!-- 추가 -->
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이지네이션 -->
    <div id="pagination" class="pagination">
        <c:forEach var="i" begin="0" end="${hashtagsPage.totalPages - 1}">
            <a href="#" class="page-btn ${i == hashtagsPage.number ? 'active' : ''}" data-page="${i}">${i + 1}</a>
        </c:forEach>
    </div>

</div>

<!-- 해시태그 등록/수정 모달 -->
<div class="modal" id="hashtagModal">
    <div class="modal-content">
        <h2 id="modalTitle">해시태그 등록</h2>
        <input type="text" id="hashtagName" placeholder="해시태그 이름">
        <div style="text-align:right;">
            <button id="modalSaveBtn" class="btn btn-accent">저장</button>
            <button id="modalCloseBtn" class="btn btn-delete">닫기</button>
        </div>
    </div>
</div>

<!-- 책 목록 모달 -->
<div class="modal" id="booksModal">
    <div class="modal-content">
        <h2 id="booksModalTitle">해시태그 등록 도서</h2>

        <!-- 검색창 추가 -->
        <div class="search-wrapper">
            <form id="bookSearchForm" class="search-form">
                <input type="text" id="bookKeyword" name="bookKeyword" placeholder="도서 검색...">
                <button type="submit" class="btn-search">검색</button>
            </form>
        </div>

        <!-- 검색 결과 리스트 -->
        <div id="booksList" style="max-height:400px; overflow:auto;"></div>

        <div style="text-align:right; margin-top:10px;">
            <button id="booksModalClose" class="btn btn-delete">닫기</button>
        </div>
    </div>
</div>

<script src="<c:url value='/js/admin/admin_hashtags.js'/>"></script>
</body>
</html>
