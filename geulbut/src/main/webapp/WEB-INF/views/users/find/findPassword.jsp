<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="<c:url value='/css/00_common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/find/find-password.css'/>">

    <!-- CSRF 메타 (활성화된 경우에만) -->
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
</head>
<body>
<div class="findpw-card">
    <h1 class="findpw-title">비밀번호 찾기</h1>

    <!-- ✅ SMS 탭/패널 제거 → 단일 이메일 패널만 유지 -->
    <div id="tab-email" class="tab-panel active">

        <!-- 이메일 검증 폼 -->
        <form id="emailVerifyForm" method="post" action="<c:url value='/find-password/email/verify'/>">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>

            <div class="row">
                <label for="emailField">이메일</label>
                <div class="input-group">
                    <input id="emailField" name="email" type="email" placeholder="example@domain.com" required>
                    <button id="emailSendBtn" class="btn ghost" type="button" onclick="sendEmailCode()">인증코드 전송</button>
                </div>
                <div class="hint-row">
                    <span class="hint">가입 시 등록한 이메일 주소</span>
                    <span id="emailTimer" class="timer" aria-live="polite"></span>
                </div>
                <div id="emailSendMsg" class="msg" aria-live="polite"></div>
            </div>

            <div class="row">
                <label for="emailCodeField">인증코드</label><br/>
                <input id="emailCodeField" class="code-input" name="code" type="text" maxlength="6" pattern="[0-9]{6}"
                       inputmode="numeric" autocomplete="one-time-code"
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

    <!-- 임시 비밀번호 안내 박스 (이메일 검증 후 서비스가 temp 반환 시 표시) -->
    <c:if test="${not empty resetPw}">
        <hr style="margin:16px 0;">
        <div class="msg success">임시 비밀번호가 발급되었습니다. 아래 비밀번호로 로그인해 주세요.</div>

        <div class="temp-box">
            <div class="temp-row">
                <input id="issuedTempPw" class="temp-input" type="text" readonly value="${resetPw}">
                <button type="button" class="btn ghost" onclick="copyTempPw()">복사</button>
            </div>
            <div class="hint" style="margin-top:6px;">보안을 위해 로그인 후 반드시 비밀번호를 변경해 주세요.</div>
        </div>
    </c:if>
</div>

<script>
    /* --- CSRF 안전 처리 --- */
    function csrf() {
        const t = document.querySelector('meta[name="_csrf"]')?.content || null;
        const h = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
        return { token: t, header: h };
    }

    /* --- 공통: POST(JSON) --- */
    async function postJson(url, body) {
        const headers = { 'Content-Type': 'application/json' };
        const { token, header } = csrf();
        if (token) headers[header] = token; // 토큰 있을 때만 추가
        return fetch(url, {
            method: 'POST',
            headers,
            body: JSON.stringify(body)
        });
    }

    /* --- 타이머/쿨타임 (이메일 전송용) --- */
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

    /* --- 이메일 코드 전송 --- */
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

    /* --- 임시비밀번호 복사 --- */
    function copyTempPw(){
        const el=document.getElementById('issuedTempPw');
        if(!el) return;
        el.select(); el.setSelectionRange(0,99999);
        try{ navigator.clipboard.writeText(el.value); }catch(e){ document.execCommand('copy'); }
        alert('복사되었습니다.');
    }
</script>
</body>
</html>
