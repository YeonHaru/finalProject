<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 9. 24.
  Time: 오전 9:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>도서 상세</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
</head>
<body class="bg-main">
<jsp:include page="/common/header.jsp"/>
<div class="page py-4">
    <p>제목:${book.title}</p>
    <p>작가:${book.authorName}</p>
    <p>출판사:${book.publisherName}</p>
    <p>해시태그:${book.hashtags}</p>
</div>

</body>
</html>
