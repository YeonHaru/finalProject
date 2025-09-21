<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Book Hashtags 조회</title>
</head>
<body>

<h1>Book Hashtags 조회</h1>

<!-- 검색 폼 -->
<form action="/book-hashtags" method="get">
    <label for="bookId">책 ID 조회:</label>
    <input type="number" id="bookId" name="bookId" value="${bookId}"/>

    <label for="hashtagId">해시태그 ID 조회:</label>
    <input type="number" id="hashtagId" name="hashtagId" value="${hashtagId}"/>

    <button type="submit">검색</button>
</form>

<hr/>

<!-- 책 기준 해시태그 목록 -->
<h2>책 ID: ${bookId} 기준 해시태그 목록</h2>
<c:if test="${not empty bookHashtagsByBook}">
    <table border="1">
        <thead>
        <tr>
            <th>책 ID</th>
            <th>책 제목</th>
            <th>해시태그 ID</th>
            <th>해시태그 이름</th>
            <th>연결 생성일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="bh" items="${bookHashtagsByBook}">
            <tr>
                <td>${bh.book.bookId}</td>
                <td>${bh.book.title}</td>
                <td>${bh.hashtag.hashtagId}</td>
                <td>${bh.hashtag.name}</td>
                <td>${bh.createdAt}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</c:if>
<c:if test="${empty bookHashtagsByBook}">
    <p>해당 책에 연결된 해시태그가 없습니다.</p>
</c:if>

<!-- 해시태그 기준 책 목록 -->
<h2>해시태그 ID: ${hashtagId} 기준 책 목록</h2>
<c:if test="${not empty bookHashtagsByHashtag}">
    <table border="1">
        <thead>
        <tr>
            <th>해시태그 ID</th>
            <th>해시태그 이름</th>
            <th>책 ID</th>
            <th>책 제목</th>
            <th>연결 생성일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="bh" items="${bookHashtagsByHashtag}">
            <tr>
                <td>${bh.hashtag.hashtagId}</td>
                <td>${bh.hashtag.name}</td>
                <td>${bh.book.bookId}</td>
                <td>${bh.book.title}</td>
                <td>${bh.createdAt}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</c:if>
<c:if test="${empty bookHashtagsByHashtag}">
    <p>해당 해시태그에 연결된 책이 없습니다.</p>
</c:if>

</body>
</html>
