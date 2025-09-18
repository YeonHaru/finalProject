<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <title>공지사항</title>
  <link rel="stylesheet" href="/css/00_common.css">
  <link rel="stylesheet" href="/css/qna/qnaText.css">
  <link rel="stylesheet" href="/css/header.css">
  <!-- 이미지 아이콘 사용 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
      <h2 class="mb-4 qna-title">▣ 1:1 문의
        <div>
          <c:if test="${qna.userId == pageContext.request.userPrincipal.name}">
            <!-- 수정 버튼 -->
            <form action="${pageContext.request.contextPath}/qnaUpdate" method="get" style="display:inline;">
              <input type="hidden" name="id" value="${qna.id}"/>
              <button type="submit" class="btn btn-main">수정</button>
            </form>

            <!-- 삭제 버튼 -->
            <form action="${pageContext.request.contextPath}/qnaDelete" method="post" style="display:inline;">
              <input type="hidden" name="id" value="${qna.id}"/>
              <button type="submit" class="btn btn-main">삭제</button>
            </form>
          </c:if>
        </div>
      </h2>

      <p>제목 : ${qna.title}</p>

      <!-- 아이콘 + 텍스트 메타 정보 -->
      <div class="notice-meta px-3">
        <div class="meta-item">
          <i class="fa-solid fa-user"></i>
          <span>${qna.userId}</span>
        </div>
        <div class="meta-item">
          <i class="fa-solid fa-comment"></i>
          <span>0</span>
        </div>
        <div class="meta-item">
          <i class="fa-solid fa-eye"></i>
          <span>1,219</span>
        </div>
        <div class="meta-item time-item">
          <i class="fa-regular fa-clock"></i>
          <span><fmt:formatDate value="${qna.QAt}" pattern="yyyy-MM-dd HH:mm"/></span>
        </div>
      </div>
      <%--공지사항 글 내용--%>
      <div class="px-3 py-2 notice-text">
        ${qna.QContent}
      </div>
      <%-- 댓글 구간 --%>
      <div class="comment-section mt-4">
        <!-- 댓글 헤더 -->
        <div>
          <p class="comment-title">Comments</p>
        </div>

        <!-- 댓글 입력 -->
        <div class="comment-input mb-4">
          <textarea class="comment-textarea" placeholder="댓글을 작성하세요..." rows="3"></textarea>
          <button class="btn-comment">등록</button>
        </div>

        <!-- 댓글 리스트 -->
        <div class="comment-list">
          <div class="comment-item">
            <span class="comment-author">홍길동</span>
            <span class="comment-date">2025-09-11 11:00</span>
            <p class="comment-text">첫 번째 댓글입니다.</p>
          </div>
          <div class="comment-item">
            <span class="comment-author">김철수</span>
            <span class="comment-date">2025-09-11 11:15</span>
            <p class="comment-text">두 번째 댓글입니다.</p>
          </div>
        </div>
      </div>
      <div>

      </div>
    </div>
  </div>
</div>

</body>
</html>
