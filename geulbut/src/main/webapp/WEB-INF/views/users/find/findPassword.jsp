<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/find/find-password.css">

</head>
<body>
<div class="findpw-wrapper">
    <div class="findpw-card">
        <h1 class="findpw-title">비밀번호 찾기</h1>

        <form class="findpw-form" action="<c:url value='/find-password'/>" method="post">
            <div class="row">
                <label>아이디</label>
                <input type="text" name="userId" value="${param.userId}">
            </div>
            <div class="row">
                <label>이메일</label>
                <input type="email" name="email" value="${param.email}">
            </div>
            <div class="findpw-actions">
                <button class="findpw-btn ghost" type="button" onclick="location.href='<c:url value="/find-id"/>'">아이디 찾기</button>
                <button class="findpw-btn primary" type="submit">임시 비밀번호 발급</button>
            </div>

            <c:if test="${not empty resetPwMsg}">
                <p class="findpw-msg success">${resetPwMsg}</p>
            </c:if>
            <c:if test="${not empty resetPwError}">
                <p class="findpw-msg error">${resetPwError}</p>
            </c:if>
        </form>
    </div>
</div>
</body>
</html>
