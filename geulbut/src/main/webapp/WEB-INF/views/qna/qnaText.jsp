<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
          <span>${qna.userId} </span>
        </div>
        <div class="meta-item">
          <i class="fa-solid fa-comment"></i>
          <span>0</span>
        </div>
        <div class="meta-item">
          <i class="fa-solid fa-eye"></i>
          <span><c:out value="${qna.viewCount}"/></span>
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

        <div class="comment-input mb-4">
          <form action="${pageContext.request.contextPath}/qnaComment" method="post">
            <input type="hidden" name="id" value="${qna.id}" />
            <textarea class="comment-textarea" name="aContent" placeholder="댓글을 작성하세요..." rows="3"></textarea>
            <button type="submit" class="mt-3 btn-comment" style="float: right;">등록</button>
          </form>
        </div>


        <div class="comment-list">
          <c:forEach var="comment" items="${comments}">
            <div class="comment-item">
              <span class="comment-author">${comment.userId}</span>
              <span class="comment-date">
        <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
      </span>
              <p class="comment-text">${comment.content}</p>

              <!-- 댓글 작성자와 로그인 사용자 일치 시 수정/삭제 버튼 표시 -->
              <c:if test="${comment.userId == pageContext.request.userPrincipal.name}">
                <div style="margin-top:0.5rem;">
                  <!-- 수정 버튼 -->
                  <form action="${pageContext.request.contextPath}/qnaCommentUpdate" method="get" style="display:inline;">
                    <input type="hidden" name="commentId" value="${comment.commentId}" />
                    <button type="submit" class="btn btn-main btn-sm">수정</button>
                  </form>

                  <!-- 삭제 버튼 -->
                  <form action="${pageContext.request.contextPath}/qnaCommentDelete" method="post" style="display:inline;">
                    <input type="hidden" name="commentId" value="${comment.commentId}" />
                    <button type="submit" class="btn btn-main btn-sm">삭제</button>
                  </form>
                </div>
              </c:if>

            </div>
          </c:forEach>
        </div>




      </div>
      <div>

      </div>
    </div>
  </div>
</div>

</body>
</html>
