<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/signup/signup.css">
</head>
<body>
<div class="signup-wrapper">
    <div class="signup-card">
        <h1 class="signup-title">ㄱㅂ</h1>

        <c:if test="${not empty signupError}">
            <p class="error-msg">${signupError}</p>
        </c:if>

        <form class="signup-form" action="<c:url value='/signup'/>" method="post" id="signupForm">
            <!-- CSRF -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="input-group">
                <input id="userId" type="text" name="userId" placeholder="아이디" value="${usersSignupDto.userId}"/>
                <span id="userIdMsg" class="help-msg"></span>
            </div>

            <div class="input-group">
                <input id="password" type="password" name="password" placeholder="비밀번호"/>
                <span id="passwordMsg" class="help-msg"></span>
            </div>

            <div class="input-group">
                <input type="text" name="name" placeholder="이름" value="${usersSignupDto.name}"/>
            </div>

            <div class="input-group">
                <input id="email" type="email" name="email" placeholder="이메일" value="${usersSignupDto.email}"/>
                <span id="emailMsg" class="help-msg"></span>
            </div>

            <div class="input-group">
                <input type="text" name="phone" placeholder="전화번호" value="${usersSignupDto.phone}"/>
            </div>

            <div class="input-group">
                <input type="text" name="address" placeholder="주소" value="${usersSignupDto.address}"/>
            </div>

            <div class="input-group">
                <input type="date" name="birthday" value="${usersSignupDto.birthday}"/>
            </div>

            <div class="form-row">
                <label class="select-label">성별:
                    <c:set var="g" value="${usersSignupDto.gender}" />
                    <select name="gender">
                        <option value="M" ${fn:toUpperCase(g) eq 'M' ? 'selected="selected"' : ''}>남</option>
                        <option value="F" ${fn:toUpperCase(g) eq 'F' ? 'selected="selected"' : ''}>여</option>
                    </select>
                </label>
                <div class="checkbox-group">
                    <input type="hidden" name="_postNotifyAgree" value="on"/>
                    <label class="checkbox-label">
                        <input type="checkbox" name="postNotifyAgree" value="true"
                        ${usersSignupDto.postNotifyAgree ? 'checked' : ''}/> 알림 수신
                    </label>

                    <input type="hidden" name="_promoAgree" value="on"/>
                    <label class="checkbox-label">
                        <input type="checkbox" name="promoAgree" value="true"
                        ${usersSignupDto.promoAgree ? 'checked' : ''}/> 프로모션 수신
                    </label>
                </div>
            </div>

            <button id="submitBtn" type="submit" class="submit-btn" disabled>회원가입</button>
        </form>
    </div>
</div>

<script>
<%--  1) 문서에 한번만 찾아서 변수로 보관  --%>
    const $form = document.getElementById('signupForm');
    const $submit = document.getElementById('submitBtn');

    const $userId = document.getElementById('userId');
    const $email = document.getElementById('email');
    const $password = document.getElementById('password');

    const $userIdMsg = document.getElementById('userIdMsg');
    const $emailMsg = document.getElementById('emailMsg');
    const $passwordMsg = document.getElementById('passwordMsg');

    // 2) 검사결과를 기억함
    // - idOK: 아이디 사용 가능 여부
    // - emailOK: 이메일 사용 가능 여부 (비워도 되는 정책이면, 비었을 때 true)
    // - pwOK: 비밀번호 조건 충족 여부
    let idOK = false, emailOK = true, pwOK = false;

    // 3) 유틸: 디바운스(debounce)
    // - 입력이 연속으로 들어올 때, "일정 시간(ms) 동안 입력이 멈추면" 한 번만 실행
    // - 서버에 과도한 요청(중복확인 AJAX)을 방지
    const debounce = (fn, ms=300) => {
        let t; return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), ms); };
    };
    // 4) 제출 버튼 활성/비활성 스위치
    // - 세 플래그가 모두 true일 때만 버튼을 활성화
    function refreshSubmit() {
        // 하나라도 false 면 disabled = true 버튼 비활성
        $submit.disabled = !(idOK && emailOK && pwOK);
    }
    // 5) 아이디 중복 확인
    // 흐름:
    //  (1) 입력값 기본 규칙(길이 등) 확인
    //  (2) 서버에 GET /users/check-id?userId=... 요청
    //  (3) true/false 응답에 따라 메시지와 idOK 갱신
    async function checkId() {
        const v = $userId.value.trim();
        // 1) 최소길이 규칙 예 ) 4자 이상
        if (v.length < 4) {
            idOK = false;
            $userIdMsg.textContent = '아이디는 4자 이상이어야 합니다.';
            refreshSubmit(); return;
        }
        try {
            // 2) 서버에 중복확인 요청
            const res = await fetch('/users/check-id?userId=' + encodeURIComponent(v));
            const ok = await res.json();
            idOK = !!ok;
            // 3) 사용자에게 결과 메시지 표시
            $userIdMsg.textContent = ok ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.';
        } catch(e) {
            // 네트워크/서버 오류등등
            idOK = false;
            $userIdMsg.textContent = '아이디 확인 중 오류가 발생했습니다.';
        } finally {
            // 다 되면 버튼 갱신
            refreshSubmit();
        }
    }

    async function checkEmail() {
        let v = $email.value.trim().toLowerCase();
        $email.value = v;
        if (v === '') { // 이메일 선택항목이면 비워도 통과
            emailOK = true;
            $emailMsg.textContent = '';
            refreshSubmit(); return;
        }
        // 간단 패턴
        const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRe.test(v)) {
            emailOK = false;
            $emailMsg.textContent = '이메일 형식을 확인해주세요.';
            refreshSubmit(); return;
        }
        try {
            const res = await fetch('/users/check-email?email=' + encodeURIComponent(v));
            const ok = await res.json();
            emailOK = !!ok;
            $emailMsg.textContent = ok ? '사용 가능한 이메일입니다.' : '이미 가입된 이메일입니다.';
        } catch(e) {
            emailOK = false;
            $emailMsg.textContent = '이메일 확인 중 오류가 발생했습니다.';
        } finally {
            refreshSubmit();
        }
    }

    function checkPassword() {
        const v = $password.value;
        // 간단 정책: 8자 이상
        if (v.length >= 8) {
            pwOK = true;
            $passwordMsg.textContent = '';
        } else {
            pwOK = false;
            $passwordMsg.textContent = '비밀번호는 8자 이상이어야 합니다.';
        }
        refreshSubmit();
    }

    $userId.addEventListener('input', debounce(checkId, 400));
    $email.addEventListener('input', debounce(checkEmail, 400));
    $password.addEventListener('input', checkPassword);

    // 최종 제출 전 정규화/최종검증
    $form.addEventListener('submit', (e) => {
        $userId.value = $userId.value.trim();
        $email.value = $email.value.trim().toLowerCase();

        if (!(idOK && emailOK && pwOK)) {
            e.preventDefault();
            alert('입력값을 확인해주세요.');
        }
    });

    // 초기 상태 점검(값이 미리 있을 수 있으니)
    checkPassword();
    if ($userId.value.trim()) checkId();
    if ($email.value.trim()) checkEmail();

</script>
</body>
</html>
