<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 9. 9.
  Time: 오전 10:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/notice/notice.css">
    <link rel="stylesheet" href="/css/header.css">
</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>
<div class="page my-5">
    <div class="bg-surface rounded shadow-sm p-4" style="width: 100%;">
        <h2 class="mb-4">공지사항</h2>

        <table class="notice-table border" style="width: 100%;">
            <thead class="bg-main">
            <tr>
                <th class="py-2 px-3 ">번호</th>
                <th class="py-2 px-6 ">제목</th>
                <th class="py-2 px-3 ">글쓴이</th>
                <th class="py-2 px-3 ">날짜</th>
                <th class="py-2 px-3 ">조회</th>
            </tr>
            </thead>
            <tbody>
            <%--            <c:forEach var="data" items="${notices}">--%>
            <tr>
                <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                <td class="py-2 px-6">
                    <a href="noticeDetail.do?id=${data.no}" class="text-main">
                        ${data.title}asd
                    </a>
                </td>
                <td class="py-2 px-3">${data.writer}zxc</td>
                <td class="py-2 px-3">${data.regDate}cxc</td>
                <td class="py-2 px-3">${data.viewCnt}adxc</td>
            </tr>

            <tr>
                <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                <td class="py-2 px-6">
                    <a href="noticeDetail.do?id=${data.no}" class="text-main">
                        ${data.title}asd
                    </a>
                </td>
                <td class="py-2 px-3">${data.writer}zxc</td>
                <td class="py-2 px-3">${data.regDate}cxc</td>
                <td class="py-2 px-3">${data.viewCnt}adxc</td>
            </tr>
            <tr>
                <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                <td class="py-2 px-6">
                    <a href="noticeDetail.do?id=${data.no}" class="text-main">
                        ${data.title}asd
                    </a>
                </td>
                <td class="py-2 px-3">${data.writer}zxc</td>
                <td class="py-2 px-3">${data.regDate}cxc</td>
                <td class="py-2 px-3">${data.viewCnt}adxc</td>
            </tr>
            <tr>
                <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                <td class="py-2 px-6">
                    <a href="noticeDetail.do?id=${data.no}" class="text-main">
                        ${data.title}asd
                    </a>
                </td>
                <td class="py-2 px-3">${data.writer}zxc</td>
                <td class="py-2 px-3">${data.regDate}cxc</td>
                <td class="py-2 px-3">${data.viewCnt}adxc</td>
            </tr>
            <%--            </c:forEach>--%>
            </tbody>
        </table>
        <%--페이지네이션--%>
        <div class="pagination">
            <c:if test="${page > 1}">
                <a href="?page=${page-1}" class="prev">&laquo; 이전</a>
            </c:if>

            <c:forEach var="i" begin="1" end="${totalPage}">
                <c:choose>
                    <c:when test="${i == page}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${page < totalPage}">
                <a href="?page=${page+1}" class="next">다음 &raquo;</a>
            </c:if>
        </div>

    </div>
</div>


</body>
</html>
