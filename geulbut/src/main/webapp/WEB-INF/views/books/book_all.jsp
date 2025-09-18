<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>
<div class="page">
    <form name="listForm" action="${pageContext.request.contextPath}/search" method="get">
        ${searches}
        <input type="hidden" id="page" name="page" value="0">
    </form>
</div>
</body>
</html>
