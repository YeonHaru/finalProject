<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="<c:url value='/css/00_common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/find/find-password.css'/>">

    <!-- CSRF(켰을 때만 사용됨; 꺼져 있으면 JS가 자동으로 생략) -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <style>
        /* 최소 스타일 (원하면 제거해도 됨) */
        .findpw-card { max-width:520px; margin:40px auto; padding:24px; background:#fff; border:1px solid #eee; }
        .findpw-title { margin:0 0 12px 0; }
        .tabs { display:flex; gap:8px; margin-bottom:16px; }
        .tab-btn { padding:8px 12px; border:1px solid #ddd; background:#f7f7f7; cursor:pointer; }
        .tab-btn.active { background:#fff; border-bottom-color:#fff; font-weight:600; }
        .tab-panel { display:none; }
        .tab-panel.active { display:block; }
        .row { margin:8px 0; }
        .hint { font-size:12px; color:#888; }
        .timer { font-size:12px; color:#d33; margin-left:6px; }
        .actions { display:flex; gap:8px; margin-top:8px; }
        .btn { padding:8px 12px; border:none; cursor:pointer; }
        .btn.primary { background:#2e7d32; color:#fff; }
        .btn.ghost { background:#eee; }
        .btn[disabled] { opacity:.6; cursor:not-allowed; }
        .msg { margin-top:12px; }
        .msg.success { color:#237804; }
        .msg.error { color:#c62828; }
    </style>
</head>
<body>
<div class="findpw-card">
    <h1 class="findpw-title">비밀번호 찾기</h1>

    <!-- 탭 -->
    <div class="tabs">
        <button type="button" class="tab-btn active" data-target="#tab-email">이메일로 찾기</button>
        <button type="button" class="tab-btn" data-target="#tab-sms">휴대폰 문자로 찾기</button>
    </div>

    <!-- 이메일 탭 -->
    <div id="tab-email" class="tab-panel active">

        <!-- 검증 폼(이메일/코드 모두 여기서 입력) -->
        <form id="emailVerifyForm" method="post" action="<c:url value='/find-password/email/verify'/>">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="row">
                <label for="emailField">이메일</label><br/>
                <input id="emailField" name="email" type="email" placeholder="example@domain.com"
                       style="width:100%;" required>
                <div class="hint">가입 시 등록한 이메일 주소</div>
                <div class="actions" style="margin-top:6px;">
                    <button id="emailSendBtn" class="btn ghost" type="button" onclick="sendEmailCode()">인증코드 전송</button>
                    <span id="emailTimer" class="timer"></span>
                </div>
                <div id="emailSendMsg" class="msg"></div>
            </div>

            <div class="row">
                <label for="emailCodeField">인증코드</label><br/>
                <input id="emailCodeField" name="code" type="text" maxlength="6" pattern="[0-9]{6}"
                       placeholder="6자리 숫자" style="width:100%;" required>
            </div>

            <div class="actions">
                <button class="btn primary" type="submit">인증 & 임시 비밀번호 발급</button>
            </div>

            <c:if test="${not empty resetPwMsg}">
                <p class="msg success">${resetPwMsg}</p>
            </c:if>
            <c:if test="${not empty resetPwError}">
                <p class="msg error">${resetPwError}</p>
            </c:if>
        </form>
    </div>

    <!-- SMS 탭 -->
    <div id="tab-sms" class="tab-panel">

        <!-- 검증 폼(휴대폰/코드 모두 여기서 입력) -->
        <form id="smsVerifyForm" method="post" action="<c:url value='/find-password/sms/verify'/>">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="row">
                <label for="phoneField">휴대폰 번호</label><br/>
                <input id="phoneField" name="phone" type="text" inputmode="numeric"
                       placeholder="01012345678 (숫자만)" style="width:100%;" required
                       pattern="01[016789][0-9]{7,8}">
                <div class="hint">하이픈 없이 숫자만 입력</div>
                <div class="actions" style="margin-top:6px;">
                    <button id="smsSendBtn" class="btn ghost" type="button" onclick="sendSmsCode()">인증코드 전송</button>
                    <span id="smsTimer" class="timer"></span>
                </div>
                <div id="smsSendMsg" class="msg"></div>
            </div>

            <div class="row">
                <label for="smsCodeField">인증코드</label><br/>
                <input id="smsCodeField" name="code" type="text" maxlength="6" pattern="[0-9]{6}"
                       placeholder="6자리 숫자" style="width:100%;" required>
            </div>

            <div class="actions">
                <button class="btn primary" type="submit">인증 & 임시 비밀번호 발급</button>
            </div>

            <c:if test="${not empty resetPwMsg}">
                <p class="msg success">${resetPwMsg}</p>
            </c:if>
            <c:if test="${not empty resetPwError}">
                <p class="msg error">${resetPwError}</p>
            </c:if>
        </form>
    </div>

    <div class="actions" style="margin-top:16px;">
        <button class="btn ghost" type="button" onclick="location.href='<c:url value="/find-id"/>'">아이디 찾기</button>
        <button class="btn ghost" type="button" onclick="location.href='<c:url value="/login"/>'">로그인</button>
    </div>
</div>

<script>
    /* --- 탭 전환 --- */
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
            btn.classList.add('active');
            document.querySelector(btn.dataset.target).classList.add('active');
        });
    });

    /* --- 공통: CSRF 안전 처리 --- */
    function csrf() {
        const t = document.querySelector('meta[name="_csrf"]')?.content || null;
        // 스프링 기본 헤더명은 보통 X-CSRF-TOKEN
        const h = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
        return { token: t, header: h };
    }

    /* --- 공통: POST(JSON) --- */
    async function postJson(url, body) {
        const headers = { 'Content-Type': 'application/json' };
        const { token, header } = csrf();
        // 토큰이 있을 때만 헤더 추가(없으면 생략 → Invalid name 방지)
        if (token) headers[header] = token;

        return fetch(url, {
            method: 'POST',
            headers,
            body: JSON.stringify(body)
        });
    }

    /* --- 타이머/쿨타임 --- */
    function startTimer(spanEl, buttonEl, ttlSec = 180, cooldownSec = 60) {
        const startedAt = Date.now();
        clearInterval(spanEl._timer);
        spanEl._timer = setInterval(() => {
            const elapsed = Math.floor((Date.now() - startedAt) / 1000);
            const remain = Math.max(0, ttlSec - elapsed);
            const mm = String(Math.floor(remain / 60)).padStart(2, '0');
            const ss = String(remain % 60).padStart(2, '0');
            spanEl.textContent = remain > 0 ? `남은시간 ${mm}:${ss}` : '';
            if (remain <= 0) clearInterval(spanEl._timer);
        }, 250);

        buttonEl.disabled = true;
        let cd = cooldownSec;
        const origText = buttonEl.textContent;
        buttonEl.textContent = `재전송(${cd})`;
        clearInterval(buttonEl._cool);
        buttonEl._cool = setInterval(() => {
            cd--;
            buttonEl.textContent = cd > 0 ? `재전송(${cd})` : origText;
            if (cd <= 0) { buttonEl.disabled = false; clearInterval(buttonEl._cool); }
        }, 1000);
    }

    /* --- 이메일 코드 전송 (검증 폼의 email 값을 사용) --- */
    async function sendEmailCode() {
        const emailField = document.querySelector('#emailVerifyForm [name=email]');
        const email = emailField.value.trim();
        const msg = document.getElementById('emailSendMsg');
        const btn = document.getElementById('emailSendBtn');
        const timer = document.getElementById('emailTimer');

        msg.className = 'msg'; msg.textContent = '';
        if (!email) { msg.classList.add('error'); msg.textContent = '이메일을 입력해주세요.'; return; }

        const res = await postJson('<c:url value="/find-password/email/code"/>', { email });
        const text = await res.text();
        if (res.ok) {
            msg.classList.add('success');
            msg.textContent = '인증코드를 전송했습니다. 3분 내에 입력하세요.';
            startTimer(timer, btn, 180, 60);
        } else {
            msg.classList.add('error');
            msg.textContent = text || '전송에 실패했습니다.';
        }
    }

    /* --- SMS 코드 전송 (검증 폼의 phone 값을 사용) --- */
    async function sendSmsCode() {
        const phoneField = document.querySelector('#smsVerifyForm [name=phone]');
        const phone = phoneField.value.replace(/\D/g,'');
        const msg = document.getElementById('smsSendMsg');
        const btn = document.getElementById('smsSendBtn');
        const timer = document.getElementById('smsTimer');

        msg.className = 'msg'; msg.textContent = '';
        if (!phone) { msg.classList.add('error'); msg.textContent = '휴대폰 번호를 입력해주세요.'; return; }

        const res = await postJson('<c:url value="/find-password/sms/code"/>', { phone });
        const text = await res.text();
        if (res.ok) {
            msg.classList.add('success');
            msg.textContent = '인증코드를 전송했습니다. 3분 내에 입력하세요.';
            startTimer(timer, btn, 180, 60);
        } else {
            msg.classList.add('error');
            msg.textContent = text || '전송에 실패했습니다.';
        }
    }
</script>
</body>
</html>
