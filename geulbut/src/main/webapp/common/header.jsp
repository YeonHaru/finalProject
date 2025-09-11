<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="site-header">
    <div class="container site-header__inner">
        <!-- 좌측: 홈만 -->
        <nav class="site-header__nav site-header__nav--left" aria-label="Primary">
            <ul class="site-header__menu">
                <li><a href="${pageContext.request.contextPath}/">홈</a></li>
            </ul>
        </nav>

        <!-- 가운데 로고 -->
        <h1 class="site-header__logo">
            <a href="${pageContext.request.contextPath}/" title="홈으로">
                <img src="/images/logo.png" alt="글벗">
            </a>
        </h1>

        <!-- 우측: 계정 메뉴 -->
        <nav class="site-header__nav site-header__nav--right" aria-label="Account">
            <ul class="site-header__menu">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login">로그인</a></li>
                        <li><a href="${pageContext.request.contextPath}/signup">회원가입</a></li>
                        <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
                        <li><a href="${pageContext.request.contextPath}/notice">공지사항</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>

        <!-- 검색 -->
        <div class="site-header__search" role="search">
            <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                <label for="type" class="visually-hidden">검색 유형</label>
                <select id="type" name="type" class="search-select">
                    <option value="all">통합검색</option>
                    <option value="book">도서검색</option>
                    <option value="publisher">출판사검색</option>
                    <option value="author">작가검색</option>
                </select>

                <label for="q" class="visually-hidden">검색어</label>
                <input id="q" name="q" type="text" placeholder="검색어를 입력하세요" />

                <button type="submit" class="btn-search">검색</button>
            </form>
        </div>

        <!-- 하단: 추가 메뉴 -->
        <nav class="site-header__nav site-header__nav--bottom" aria-label="Sub">
            <ul class="site-header__menu site-header__menu--bottom">
                <li><a href="${pageContext.request.contextPath}/books">도서목록</a></li>
                <li><a href="${pageContext.request.contextPath}/publishers">출판사목록</a></li>
                <li><a href="${pageContext.request.contextPath}/authors">작가목록</a></li>
            </ul>
        </nav>
    </div>
</header>
