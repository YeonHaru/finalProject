<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- CSS 불러오기 -->
<link rel="stylesheet" href="<c:url value='/css/admin/admin-header.css'/>">

<header class="site-header">
    <div class="container site-header__inner">
        <!-- 좌측: 홈만 -->
        <nav class="site-header__nav site-header__nav--left" aria-label="Primary"></nav>

        <!-- 가운데 로고 -->
        <h1 class="site-header__logo">
            <a href="${pageContext.request.contextPath}/" title="홈으로">
                <img src="/images/logo.png" alt="글벗">
            </a>
        </h1>

        <!-- 우측 계정 메뉴 -->
        <!-- 우측 계정 메뉴 -->
        <nav class="site-header__nav site-header__nav--right" aria-label="Account">
            <ul class="site-header__menu site-header__menu--mobile">
                <sec:authorize access="isAuthenticated()">
                    <c:set var="userName" value="" />

                    <!-- 폼 로그인 사용자 -->
                    <sec:authentication property="principal.username" var="userNameForm" />
                    <c:if test="${not empty userNameForm}">
                        <c:set var="userName" value="${userNameForm}" />
                    </c:if>

                    <!-- OAuth2 로그인 사용자 -->
                    <sec:authentication property="principal" var="authPrincipal"/>
                    <c:if test="${authPrincipal.getClass().getSimpleName() eq 'DefaultOAuth2User'}">
                        <c:set var="userName" value="${authPrincipal.attributes['name']}" />
                    </c:if>

                    <li>
                        <a href="#">
                            안녕하세요, ${userName} 님!
                        </a>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
                    <li><a href="${pageContext.request.contextPath}/notice">공지사항</a></li>
                </sec:authorize>

                <sec:authorize access="!isAuthenticated()">
                    <li><a href="${pageContext.request.contextPath}/login">로그인</a></li>
                    <li><a href="${pageContext.request.contextPath}/signup">회원가입</a></li>
                    <li><a href="${pageContext.request.contextPath}/notice">공지사항</a></li>
                </sec:authorize>
            </ul>
        </nav>

        <!-- 모바일 햄버거 버튼 -->
        <button class="site-header__hamburger" aria-label="메뉴 열기">
            <span></span><span></span><span></span>
        </button>

        <!-- 검색 -->
        <div class="site-header__search" role="search">
            <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                <input type="hidden" name="type" value="all">
                <select id="type" class="search-select" disabled>
                    <option>통합검색</option>
                </select>
                <input id="q" name="keyword" type="text" placeholder="검색어를 입력하세요"/>
                <button type="submit" class="btn-search">검색</button>
            </form>
        </div>

        <!-- 하단 메뉴 -->
        <nav class="site-header__nav site-header__nav--bottom" aria-label="Sub">
            <ul class="site-header__menu site-header__menu--bottom">
                <li><a href="${pageContext.request.contextPath}/books">도서목록</a></li>
                <li><a href="${pageContext.request.contextPath}/publishers">출판사목록</a></li>
                <li><a href="${pageContext.request.contextPath}/authors">작가목록</a></li>
            </ul>
        </nav>

        <!-- 날씨/미세먼지 ticker -->
        <div id="weather-dust-header">불러오는 중...</div>

        <!-- ADMIN 전용 -->
        <sec:authorize access="hasRole('ADMIN')">
            <button class="admin-toggle">관리자</button>
            <aside class="admin-panel">
                <h3>관리자 패널</h3>
                <div class="admin-group">
                    <div class="group-title">📚 책 관리</div>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin/books">도서 등록/수정/삭제</a></li>
                    </ul>
                </div>
                <div class="admin-group">
                    <div class="group-title">👥 회원 관리</div>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin/users-info">회원 조회 & 권한변경</a></li>
                    </ul>
                </div>
                <div class="admin-group">
                    <div class="group-title">🎉 이벤트 관리</div>
                    <ul>
                        <li><a href="#">이벤트 등록</a></li>
                        <li><a href="#">이벤트 수정</a></li>
                    </ul>
                </div>
            </aside>
        </sec:authorize>
    </div>
</header>

<!-- JS 불러오기 -->
<script>
    const isLogin = <sec:authorize access="isAuthenticated()">true</sec:authorize><sec:authorize access="!isAuthenticated()">false</sec:authorize>;
</script>
<script src="<c:url value='/common/js/header.js'/>"></script>
<script src="<c:url value='/js/api/DustWeatherApi.js'/>"></script>
