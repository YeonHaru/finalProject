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
    <link rel="stylesheet" href="/css/notice/notice2.css">
    <link rel="stylesheet" href="/css/header.css">
</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>

<div class="page my-3">
    <div class="grid gap-4 notice-layout">
        <!-- 왼쪽 사이드바 -->
        <aside class="bg-surface border rounded p-4">
            <h2 class="mb-3 text-center">고객센터</h2>
            <nav class="grid gap-2">
                <a href="#" class="text-main">공지사항</a>
                <a href="#" class="text-light">자주 묻는 질문</a>
                <a href="${pageContext.request.contextPath}/qna?id=${data.no}" class="text-light">1:1 문의</a>
            </nav>
        </aside>

        <!-- 오른쪽 공지사항 콘텐츠 -->
        <div class="bg-surface rounded shadow-sm p-4" style="width: 100%;">
            <h2 class="mb-4 notice-title">▣ 공지사항</h2>

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
                    <td class="py-2 px-3">
                        <a href="${pageContext.request.contextPath}/noticeText?id=${data.no}" class="text-main">
                            ${data.title}aass
                        </a>

                    </td>
                    <td class="py-2 text-center">${data.writer}zxc</td>
                    <td class="py-2 text-center">${data.regDate}cxc</td>
                    <td class="py-2 text-center">${data.viewCnt}adxc</td>
                </tr>

                <tr>
                    <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                    <td class="py-2 px-3">
                        <a href="${pageContext.request.contextPath}/noticeText?id=${data.no}" class="text-main">
                            ${data.title}aass
                        </a>

                    </td>
                    <td class="py-2 text-center">${data.writer}zxc</td>
                    <td class="py-2 text-center">${data.regDate}cxc</td>
                    <td class="py-2 text-center">${data.viewCnt}adxc</td>
                </tr>
                <tr>
                    <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                    <td class="py-2 px-3">
                        <a href="${pageContext.request.contextPath}/noticeText?id=${data.no}" class="text-main">
                            ${data.title}aass
                        </a>

                    </td>
                    <td class="py-2 text-center">${data.writer}zxc</td>
                    <td class="py-2 text-center">${data.regDate}cxc</td>
                    <td class="py-2 text-center">${data.viewCnt}adxc</td>
                </tr>
                <tr>
                    <td class="py-2 px-3 text-light">${data.no}sdsd</td>
                    <td class="py-2 px-3">
                        <a href="${pageContext.request.contextPath}/noticeText?id=${data.no}" class="text-main">
                            ${data.title}aass
                        </a>

                    </td>
                    <td class="py-2 text-center">${data.writer}zxc</td>
                    <td class="py-2 text-center">${data.regDate}cxc</td>
                    <td class="py-2 text-center">${data.viewCnt}adxc</td>
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
</div>

</body>
</html>
