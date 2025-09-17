<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>1:1 문의</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/qna/qna.css">
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
                <a href="${pageContext.request.contextPath}/qna" class="text-light">1:1 문의</a>
            </nav>
        </aside>

        <!-- 오른쪽 콘텐츠 -->
        <div class="bg-surface rounded shadow-sm p-4" style="width: 100%;">
            <h2 class="mb-4 notice-title">
                ▣ 1:1 문의
                <a href="${pageContext.request.contextPath}/qnaWrite" class="btn btn-main">글쓰기</a>
            </h2>

            <table class="notice-table border" style="width: 100%;">
                <thead class="bg-main">
                <tr>
                    <th class="py-2 px-3">번호</th>
                    <th class="py-2 px-6">제목</th>
                    <th class="py-2 px-3">글쓴이</th>
                    <th class="py-2 px-3">질문일</th>
                    <th class="py-2 px-3">답변자</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="data" items="${qnas}">
                    <tr>
                        <td class="py-2 px-3 text-light">${data.id}</td>
                        <td class="py-2 px-3">
                            <a href="${pageContext.request.contextPath}/qnaText?id=${data.id}" class="text-main">
                                    ${data.title}
                            </a>
                        </td>
                        <td class="py-2 text-center">${data.userId}</td>
                        <td class="py-2 text-center">
                            <fmt:formatDate value="${data.qAt}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td class="py-2 text-center">${data.aId}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
