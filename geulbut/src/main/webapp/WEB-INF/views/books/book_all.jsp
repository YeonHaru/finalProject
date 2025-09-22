<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head><title>Title</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>
<div class="page">
    <form name="listForm" action="${pageContext.request.contextPath}/search" method="get">
        ${searches}
        <input type="hidden" id="page" name="page" value="0">

<%--            @JsonProperty("book_id")--%>
<%--            private Long bookId;--%>
<%--            private String title;--%>
<%--            private Long price;--%>
<%--            @JsonProperty("discounted_price")--%>
<%--            private Long discountedPrice;--%>
<%--            private Long stock;--%>
<%--            @JsonProperty("author_name")--%>
<%--            private String authorName;--%>
<%--            @JsonProperty("category_name")--%>
<%--            private String categoryName;--%>
<%--            @JsonProperty("publisher_name")--%>
<%--            private String publisherName;--%>
<%--            @JsonProperty("books_img_url")--%>
<%--            private String booksImgUrl;--%>
<%--            private List<String> hashtags;--%>
        <%--반복문 시작--%>
        <c:forEach var="data" items="${searches}">
            <li>제목: <c:out value="${data.title}"></c:out></li>
            <li>작가: <c:out value="${data.authorName}"></c:out></li>
            <li>출판사: <c:out value="${data.publisherName}"></c:out></li>
            <li>정가: <c:out value="${data.price}"></c:out></li>
            <li>할인가: <c:out value="${data.discountedPrice}"></c:out></li>
            <li>카테고리: <c:out value="${data.categoryName}"></c:out></li>
            <li>해시태그: <c:out value="${data.hashtags}"></c:out></li>

        </c:forEach>
    </form>
</div>
</body>
</html>