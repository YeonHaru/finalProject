<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
  <title>공지사항 작성</title>
  <link rel="stylesheet" href="/css/00_common.css">
  <link rel="stylesheet" href="/css/notice/noticeWrite.css">
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
        <a href="${pageContext.request.contextPath}/notice" class="text-main">공지사항</a>
        <a href="${pageContext.request.contextPath}/commonquestions" class="text-light">자주 묻는 질문</a>
        <a href="${pageContext.request.contextPath}/qna" class="text-light">1:1 문의</a>
      </nav>
    </aside>

    <!-- 오른쪽 공지사항 글 작성 -->
    <div class="bg-surface rounded shadow-sm p-4 notice-write">
      <h2 class="mb-4 notice-title">공지사항 작성</h2>

      <c:choose>
        <c:when test="${not empty notice}">
          <form action="${pageContext.request.contextPath}/noticeUpdateSubmit" method="post">
            <input type="hidden" name="id" value="${notice.noticeId}" />

            <label for="title" class="tt ml-1">제목</label>
            <input type="text" id="title" name="title" class="form-input mb-5 mt-3"
                   placeholder="제목을 입력하세요"
                   value="<c:out value='${notice.title}' />">

            <label for="content" class="ml-1">내용</label>
            <textarea id="content" name="content" class="form-textarea mb-3 mt-3"
                      placeholder="내용을 입력하세요" rows="8"><c:out value='${notice.content}' /></textarea>

            <div class="text-right">
              <button type="submit" class="btn btn-main">수정</button>
            </div>
          </form>
        </c:when>

        <c:otherwise>
          <form action="${pageContext.request.contextPath}/noticeSubmit" method="post">
            <label for="title" class="ml-1">제목</label>
            <input type="text" id="title" name="title" class="form-input mb-5 mt-3"
                   placeholder="제목을 입력하세요">

            <label for="content" class="ml-1">내용</label>
            <textarea id="content" name="content" class="form-textarea mb-3 mt-3"
                      placeholder="내용을 입력하세요" rows="8"></textarea>

            <div class="text-right">
              <button type="submit" class="btn btn-main">등록</button>
            </div>
          </form>
        </c:otherwise>
      </c:choose>

    </div>
  </div>
</div>

</body>
</html>
