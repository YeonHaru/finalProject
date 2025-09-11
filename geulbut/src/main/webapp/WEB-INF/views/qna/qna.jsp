<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 9. 11.
  Time: 오후 12:21
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
            <h2 class="mb-4">1:1 문의</h2>



        </div>
    </div>
</div>
</body>
</html>
