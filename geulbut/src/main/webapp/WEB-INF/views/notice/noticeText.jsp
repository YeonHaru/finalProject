<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html>
<head>
    <title>공지사항 상세</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/qna/qnaText.css">
    <link rel="stylesheet" href="/css/header.css">
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
                <a href="${pageContext.request.contextPath}/notice" class="text-main">공지사항</a>
                <a href="#" class="text-light">자주 묻는 질문</a>
                <a href="${pageContext.request.contextPath}/qna" class="text-light">1:1 문의</a>
            </nav>
        </aside>

        <!-- 오른쪽 공지사항 콘텐츠 -->
        <div class="bg-surface rounded shadow-sm p-4" style="width: 100%;">
            <h2 class="mb-4 qna-title">▣ 공지사항
                <div>
                    <sec:authorize access="principal.username == '${notice.userId}'">
                        <!-- 수정 버튼 -->
                        <form action="${pageContext.request.contextPath}/noticeUpdate" method="get" style="display:inline;">
                            <input type="hidden" name="id" value="${notice.noticeId}" />
                            <button type="submit" class="btn btn-main">수정</button>
                        </form>

                        <!-- 삭제 버튼 -->
                        <form action="${pageContext.request.contextPath}/noticeDelete" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="${notice.noticeId}" />
                            <button type="submit" class="btn btn-main">삭제</button>
                        </form>
                    </sec:authorize>
                </div>
            </h2>

            <p>제목 : <c:out value="${notice.title}" /></p>

            <!-- 아이콘 + 텍스트 메타 정보 -->
            <div class="notice-meta px-3">
                <div class="meta-item">
                    <i class="fa-solid fa-user"></i>
                    <span><c:out value="${notice.writer}" /></span>
                </div>
                <div class="meta-item">
                    <i class="fa-solid fa-comment"></i>
                    <span>0</span>
                </div>
                <div class="meta-item">
                    <i class="fa-solid fa-eye"></i>
                    <span><c:out value="${notice.viewCount}" /></span>
                </div>
                <div class="meta-item time-item">
                    <i class="fa-regular fa-clock"></i>
                    <span><fmt:formatDate value="${notice.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                </div>
            </div>

            <!-- 공지사항 글 내용 -->
            <div class="px-3 py-2 notice-text">
                <c:out value="${notice.content}" escapeXml="false" />
            </div>

            <!-- 댓글 구간 (기존 구조 그대로 유지) -->
            <div class="comment-section mt-4">
                <div>
                    <p class="comment-title">Comments</p>
                </div>

                <div class="comment-input mb-4">
                    <textarea class="comment-textarea" placeholder="댓글을 작성하세요..." rows="3"></textarea>
                    <button class="btn-comment">등록</button>
                </div>

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

        </div>
    </div>
</div>

</body>
</html>
