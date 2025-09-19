<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글벗 로그인</title>

    <!-- 공통/페이지 CSS: 컨텍스트패스 안전하게 -->
    <link rel="stylesheet" href="<c:url value='/css/00_common.css'/>">
    <link rel="stylesheet" href="<c:url value='/v/users/login/css/login.css'/>">
</head>
<body>
<main class="page">

    <!-- 브랜드 -->
    <a class="brand" href="<c:url value='/'/>">
        <span class="logo-badge" aria-hidden="true">ㄱㅂ</span>
        <span class="logo-title">글벗</span>
        <span class="logo-sub">Geulbut</span>
    </a>

    <!-- 오류 메시지 (컨트롤러에서 model.addAttribute('loginError', ...) 또는 쿼리파라미터로 제어) -->
    <c:if test="${not empty loginError}">
        <div class="alert error">${loginError}</div>
    </c:if>
    <c:if test="${empty loginError and param.error ne null}">
        <div class="alert error">로그인에 실패했습니다. 아이디/비밀번호를 확인해주세요.</div>
    </c:if>
    <%--  탈퇴 완료 안내 문구   --%>
    <c:if test="${param.withdrawn ne null}">
        <p class="notice" style="color: green; font-weight: bold;">
            탈퇴가 완료되었습니다. 이용해 주셔서 감사합니다.
        </p>
    </c:if>

    <section class="grid-2">
        <article class="card" aria-labelledby="loginTitle">
            <div class="tabbar" role="tablist">
                <button id="tab-member" class="tab active" role="tab" aria-selected="true"
                        aria-controls="panel-member">회원 로그인</button>
                <button id="tab-guest" class="tab" role="tab" aria-selected="false"
                        aria-controls="panel-guest">비회원 주문조회</button>
            </div>

            <!-- 회원 로그인 탭 -->
            <div id="panel-member" class="card-body" role="tabpanel" aria-labelledby="tab-member">
                <h1 id="loginTitle" class="sr-only">글벗 회원 로그인</h1>

                <!-- ★ 폼 로그인: /loginProc 로 전송 (SecurityConfig와 일치) -->
                <form class="form" method="post" action="<c:url value='/loginProc'/>">
                    <!-- CSRF 사용 시(운영 권장) 아래 hidden 추가
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    -->

                    <div class="field">
                        <label for="uid">아이디</label>
                        <div class="input">
                            <input id="uid" name="username" type="text" placeholder="아이디를 입력하세요"
                                   autocomplete="username" required>
                        </div>
                    </div>
                    <div class="field">
                        <label for="upw">비밀번호</label>
                        <div class="input">
                            <input id="upw" name="password" type="password" placeholder="비밀번호를 입력하세요"
                                   autocomplete="current-password" required>
                        </div>
                    </div>

                    <div class="options">
                        <!-- remember-me 기능 사용 시 SecurityConfig에 .rememberMe() 추가 필요 -->
                        <label class="opt"><input type="checkbox" name="remember-me"> 로그인 상태 유지</label>
                        <label class="opt"><input type="checkbox" name="save-id"> 아이디 저장</label>
                    </div>

                    <button type="submit" class="btn-primary">로그인</button>

                    <nav class="links" aria-label="부가 링크">
                        <a href="<c:url value='/find-id'/>">아이디 찾기</a>
                        <span class="dot">·</span>
                        <a href="<c:url value='/find-password'/>">비밀번호 찾기</a>
                        <span class="dot">·</span>
                        <a href="<c:url value='/signup'/>">회원가입</a>
                    </nav>

                    <div class="divider">또는 간편 로그인</div>
                    <div class="sns-list" role="group" aria-label="간편 로그인">
                        <!-- 실제 OAuth2 엔드포인트로 연결 -->
                        <a class="sns-btn" href="<c:url value='/oauth2/authorization/naver'/>" aria-label="네이버로 로그인">
                            <img src="<c:url value='/v/users/login/img/naver-icon.png'/>" alt="네이버 로그인" class="sns-img"/>
                        </a>
                        <a class="sns-btn" href="<c:url value='/oauth2/authorization/kakao'/>" aria-label="카카오로 로그인">
                            <img src="<c:url value='/v/users/login/img/kakao-icon.png'/>" alt="카카오 로그인" class="sns-img"/>
                        </a>
                        <a class="sns-btn" href="<c:url value='/oauth2/authorization/google'/>" aria-label="구글로 로그인">
                            <img src="<c:url value='/v/users/login/img/google-icon.png'/>" alt="구글 로그인" class="sns-img"/>
                        </a>
                    </div>
                </form>
            </div>

            <!-- 비회원 주문조회 탭 -->
            <div id="panel-guest" class="card-body" role="tabpanel" aria-labelledby="tab-guest" hidden>
                <form class="form" method="get" action="<c:url value='/guest/order'/>">
                    <div class="field">
                        <label for="ordNo">주문번호</label>
                        <div class="input"><input id="ordNo" name="orderNo" type="text"
                                                  placeholder="예) GB2025-000001" required></div>
                    </div>
                    <div class="field">
                        <label for="ordPw">비회원 주문 비밀번호</label>
                        <div class="input"><input id="ordPw" name="orderPw" type="password"
                                                  placeholder="주문 시 설정한 비밀번호" required></div>
                    </div>
                    <button type="submit" class="btn-primary">주문조회</button>
                    <div class="links mt-1">
                        <a href="<c:url value='/users/join'/>">회원가입 후 더 많은 혜택 받기</a>
                    </div>
                </form>
            </div>
        </article>

        <!-- 우측 배너 -->
        <aside class="banner" aria-label="배경">
            <div>
                <img src="<c:url value='/v/users/login/img/login.png'/>" alt="로그인 이미지">
            </div>
        </aside>
    </section>

</main>

<!-- 간단 스크립트는 인라인(원칙 준수) -->
<script>
    // 탭/패널 매핑: 키값만 바꿔 부르면 되도록 단순화
    const tabs = {
        member: { btn: document.getElementById('tab-member'), panel: document.getElementById('panel-member') },
        guest:  { btn: document.getElementById('tab-guest'),  panel: document.getElementById('panel-guest')  }
    };

    function show(which) {
        const other = (which === 'member') ? 'guest' : 'member';
        tabs[which].btn.classList.add('active');
        tabs[other].btn.classList.remove('active');
        tabs[which].btn.setAttribute('aria-selected', 'true');
        tabs[other].btn.setAttribute('aria-selected', 'false');
        tabs[which].panel.hidden = false;
        tabs[other].panel.hidden = true;
    }

    tabs.member.btn.onclick = () => show('member');
    tabs.guest .btn.onclick = () => show('guest');
</script>
</body>
</html>
