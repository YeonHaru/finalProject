<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>관리자 도서 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="/css/admin/admin-books.css">
    <script src="/js/admin/admin_books_list.js"></script> <!-- 외부 JS -->
</head>
<body>
<h1>도서 관리</h1>

<!-- 검색 -->
<form id="searchForm">
    <input type="text" name="keyword" placeholder="제목, ISBN 검색">
    <button type="submit">검색</button>
</form>

<!-- 도서 등록 버튼 -->
<button id="btnAddBook">도서 등록</button>

<!-- 도서 목록 테이블 -->
<table id="booksTable">
    <thead>
    <tr>
        <th>책 ID</th>
        <th>제목</th>
        <th>ISBN</th>
        <th>저자</th>
        <th>출판사</th>
        <th>가격</th>
        <th>할인가</th>
        <th>재고</th>
        <th>생성일</th>
        <th>작업</th>
    </tr>
    </thead>
    <tbody id="booksTableBody">
    <c:forEach var="book" items="${booksPage.content}">
        <tr data-id="${book.bookId}">
            <td>${book.bookId}</td>
            <td>${book.title}</td>
            <td>${book.isbn}</td>
            <td>${book.authorName}</td>
            <td>${book.publisherName}</td>
            <td>${book.price}</td>
            <td>${book.discountedPrice}</td>
            <td>${book.stock}</td>
            <td>${book.createdAt}</td>
            <td>
                <button class="btnEdit">수정</button>
                <button class="btnDelete">삭제</button>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 페이징 -->
<div>
    <c:if test="${booksPage.totalPages > 1}">
        <c:forEach begin="0" end="${booksPage.totalPages - 1}" var="i">
            <a href="?page=${i}">${i + 1}</a>
        </c:forEach>
    </c:if>
</div>

<!-- 모달 -->
<!-- 모달 -->
<div id="bookModal">
    <h3 id="modalTitle">도서 등록</h3>
    <form id="bookForm">
        <input type="hidden" name="bookId" id="bookId">
        <p>제목: <input type="text" name="title" id="title"></p>
        <p>ISBN: <input type="text" name="isbn" id="isbn"></p>
        <p>가격: <input type="number" name="price" id="price"></p>
        <p>재고: <input type="number" name="stock" id="stock"></p>
        <p>저자:
            <select id="authorId">
                <option value="">선택</option>
            </select>
        </p>
        <p>출판사:
            <select id="publisherId">
                <option value="">선택</option>
            </select>
        </p>
        <p>카테고리:
            <select id="categoryId">
                <option value="">선택</option>
            </select>
        </p>
        <p>
            <button type="submit">저장</button>
            <button type="button" id="btnCloseModal">닫기</button>
        </p>
    </form>
</div>
</body>
</html>
