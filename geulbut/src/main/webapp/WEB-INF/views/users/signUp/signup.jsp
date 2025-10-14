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
                <input id="userId" type="text" name="userId" placeholder="아이디" value="${usersSignupDto.userId}"
                    autocomplete="username"
                       inputmode="latin"
                       maxlength="20"
                       pattern="^[a-z0-9]{4,20}$"
                />
                <span id="userIdMsg" class="help-msg"></span>
            </div>

            <div class="input-group">
                <input id="password" type="password" name="password" placeholder="비밀번호"/>
                <span id="passwordMsg" class="help-msg"></span>
            </div>

            <div class="input-group">
                <input id="password2" type="password" name="passwordConfirm" placeholder="비밀번호 확인"/>
                <span id="password2Msg" class="help-msg"></span>
            </div>

            <div class="input-group">
                <input type="text" name="name" placeholder="이름" value="${usersSignupDto.name}"/>
            </div>

            <div class="input-group email-group">
                <div class="email-row">
                    <input id="emailLocal" type="text" placeholder="이메일 아이디(예: user)"
                           autocomplete="email" />
                    <span class="at" aria-hidden="true">@</span>

                    <select id="emailDomainSelect">
                        <option value="">이메일 선택</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="naver.com">naver.com</option>
                        <option value="daum.net">daum.net</option>
                        <option value="kakao.com">kakao.com</option>
                        <option value="outlook.com">outlook.com</option>
                        <option value="_custom">직접입력</option>
                    </select>

                    <input id="emailDomainCustom" type="text" placeholder="도메인 직접입력(예: example.com)"
                           style="display:none" />
                </div>

                <!-- 백엔드 제출용(합쳐서 여기로) -->
                <input id="email" type="hidden" name="email" value="${usersSignupDto.email}"/>

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

    // 이메일 구성 요소
    const $emailHidden = document.getElementById('email'); // 제출용 hidden
    const $emailLocal = document.getElementById('emailLocal');
    const $emailDomainSelect = document.getElementById('emailDomainSelect');
    const $emailDomainCustom = document.getElementById('emailDomainCustom');

    const $password = document.getElementById('password');
    const $password2 = document.getElementById('password2');

    const $userIdMsg = document.getElementById('userIdMsg');
    const $emailMsg = document.getElementById('emailMsg');
    const $passwordMsg = document.getElementById('passwordMsg');
    const $password2Msg = document.getElementById('password2Msg');

    // 2) 검사결과를 기억함
    let idOK = false, emailOK = true, pwOK = false, pw2OK = false;

    // 3) 디바운스
    const debounce = (fn, ms = 300) => {
        let t;
        return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), ms); };
    };

    // 4) 제출 버튼 활성/비활성
    function refreshSubmit() { $submit.disabled = !(idOK && emailOK && pwOK && pw2OK); }

    // ---- 아이디 정책 ----
    const USERID_RE = /^[a-z0-9]{4,20}$/;

    function normalizeUserId(raw) {
        if (!raw) return "";
        const lowered = raw.toLowerCase();
        return lowered.replace(/[^a-z0-9]/g, "");
    }

    // 이메일 조합/검증 유틸
    const EMAIL_LOCAL_RE = /^[A-Za-z0-9._%+-]+$/;                // 로컬파트 간단검사
    const EMAIL_DOMAIN_RE = /^([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$/;  // 도메인 간단검사
    const EMAIL_WHOLE_RE  = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;        // 최종 전체검사(간단)

    function getSelectedDomain() {
        const sel = $emailDomainSelect.value;
        if (sel === "_custom") {
            return ($emailDomainCustom.value || "").trim().toLowerCase();
        }
        return (sel || "").trim().toLowerCase();
    }

    function assembleEmail() {
        const local = ($emailLocal.value || "").trim();
        const domain = getSelectedDomain();
        if (!local || !domain) return "";
        return `${local}@${domain}`.toLowerCase();
    }

    function toggleCustomDomainInput() {
        const useCustom = ($emailDomainSelect.value === "_custom");
        $emailDomainCustom.style.display = useCustom ? "" : "none";
        if (!useCustom) $emailDomainCustom.value = "";
    }

    function populateEmailFieldsFromHidden() {
        const v = ($emailHidden.value || "").trim();
        if (!v || !v.includes("@")) return;
        const [local, domain] = v.split("@");
        $emailLocal.value = local || "";

        // 도메인 셀렉트에 있는 값인지 확인
        const options = Array.from($emailDomainSelect.options).map(o => o.value);
        if (options.includes(domain)) {
            $emailDomainSelect.value = domain;
            $emailDomainCustom.value = "";
            $emailDomainCustom.style.display = "none";
        } else {
            $emailDomainSelect.value = "_custom";
            $emailDomainCustom.value = domain;
            $emailDomainCustom.style.display = "";
        }
    }

    // 5) 아이디 중복 확인 (정책 통과 시에만 서버 조회)
    async function checkId() {
        const raw = $userId.value;
        const normalized = normalizeUserId(raw);
        if (raw !== normalized) $userId.value = normalized;

        const v = normalized;

        if (!v) {
            idOK = false;
            $userIdMsg.textContent = '아이디를 입력하세요.';
            refreshSubmit(); return;
        }
        if (!USERID_RE.test(v)) {
            idOK = false;
            if (v.length < 4)       $userIdMsg.textContent = '아이디는 4자 이상이어야 합니다.';
            else if (v.length > 20) $userIdMsg.textContent = '아이디는 20자 이하여야 합니다.';
            else                    $userIdMsg.textContent = '영문 소문자와 숫자만 사용할 수 있습니다.';
            refreshSubmit(); return;
        }

        try {
            const res = await fetch('/users/check-id?userId=' + encodeURIComponent(v));
            const ok = await res.json(); // true=사용가능
            idOK = !!ok;
            $userIdMsg.textContent = ok ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.';
        } catch (e) {
            idOK = false;
            $userIdMsg.textContent = '아이디 확인 중 오류가 발생했습니다.';
        } finally {
            refreshSubmit();
        }
    }

    // 6) 이메일 검증 + 중복확인(선조합 후 검사)
    async function checkEmail() {
        const local = ($emailLocal.value || "").trim();
        const domain = getSelectedDomain();

        // 선택항목 정책: 둘 다 비어있으면 통과
        if (!local && !domain) {
            emailOK = true;
            $emailHidden.value = "";
            $emailMsg.textContent = '';
            refreshSubmit(); return;
        }

        // 로컬/도메인 각각 기본 검사
        if (!EMAIL_LOCAL_RE.test(local)) {
            emailOK = false;
            $emailMsg.textContent = '이메일 앞부분(아이디) 형식을 확인해주세요.';
            refreshSubmit(); return;
        }
        if (!EMAIL_DOMAIN_RE.test(domain)) {
            emailOK = false;
            $emailMsg.textContent = '이메일 도메인 형식을 확인해주세요.';
            refreshSubmit(); return;
        }

        const email = `${local}@${domain}`.toLowerCase();

        // 전체 패턴(간단) 확인
        if (!EMAIL_WHOLE_RE.test(email)) {
            emailOK = false;
            $emailMsg.textContent = '이메일 형식을 확인해주세요.';
            refreshSubmit(); return;
        }

        // hidden에 반영
        $emailHidden.value = email;

        // 서버 중복확인
        try {
            const res = await fetch('/users/check-email?email=' + encodeURIComponent(email));
            const ok = await res.json();
            emailOK = !!ok;
            $emailMsg.textContent = ok ? '사용 가능한 이메일입니다.' : '이미 가입된 이메일입니다.';
        } catch (e) {
            emailOK = false;
            $emailMsg.textContent = '이메일 확인 중 오류가 발생했습니다.';
        } finally {
            refreshSubmit();
        }
    }

    // 7) 비밀번호/확인
    function checkPassword() {
        const v = $password.value;
        if (v.length >= 8) {
            pwOK = true;
            $passwordMsg.textContent = '';
        } else {
            pwOK = false;
            $passwordMsg.textContent = '비밀번호는 8자 이상이어야 합니다.';
        }
        refreshSubmit();
        checkPasswordConfirm();
    }

    function checkPasswordConfirm() {
        const v1 = $password.value;
        const v2 = $password2.value;
        if (!v2) {
            pw2OK = false;
            $password2Msg.textContent = '비밀번호를 다시 입력하세요.';
        } else if (v1 !== v2) {
            pw2OK = false;
            $password2Msg.textContent = '비밀번호가 일치하지 않습니다.';
        } else {
            pw2OK = true;
            $password2Msg.textContent = '';
        }
        refreshSubmit();
    }

    // 8) IME(한글 조합 등) 입력 대응 + 디바운스 바인딩
    let composing = false;
    $userId.addEventListener('compositionstart', () => composing = true);
    $userId.addEventListener('compositionend', () => { composing = false; debouncedCheckId(); });

    const debouncedCheckId = debounce(() => { if (!composing) checkId(); }, 400);

    $userId.addEventListener('input', debouncedCheckId);

    // 이메일 필드 이벤트
    $emailDomainSelect.addEventListener('change', () => { toggleCustomDomainInput(); checkEmail(); });
    $emailLocal.addEventListener('input', debounce(checkEmail, 400));
    $emailDomainCustom.addEventListener('input', debounce(checkEmail, 400));

    $password.addEventListener('input', checkPassword);
    $password2.addEventListener('input', checkPasswordConfirm);

    // 9) 최종 제출 전 정규화/최종검증
    $form.addEventListener('submit', (e) => {
        // userId 최종 정규화
        $userId.value = normalizeUserId($userId.value);

        // 이메일 최종 합성
        const emailValue = assembleEmail();
        $emailHidden.value = emailValue;

        // 아이디 정책 최종 방어
        if (!USERID_RE.test($userId.value)) {
            e.preventDefault();
            alert('아이디는 영문 소문자와 숫자만 사용하여 4~20자로 입력하세요.');
            return;
        }

        // 이메일 선택항목: 값이 있으면 유효해야 함
        if (emailValue && !EMAIL_WHOLE_RE.test(emailValue)) {
            e.preventDefault();
            alert('이메일 형식을 확인해주세요.');
            return;
        }

        if (!(idOK && emailOK && pwOK && pw2OK)) {
            e.preventDefault();
            alert('입력값을 확인해주세요.');
        }
    });

    // 10) 초기 상태 점검(값이 미리 있을 수 있으니)
    // hidden email 값이 있다면 로컬/도메인으로 분해해서 채워 넣음
    populateEmailFieldsFromHidden();
    toggleCustomDomainInput();

    // 초기 점검 트리거
    checkPassword();
    if ($userId.value.trim()) checkId();
    // 이메일은 값이 있으면 검사
    if ($emailHidden.value.trim()) checkEmail();
    if ($password2.value.trim()) checkPasswordConfirm();
</script>


</body>
</html>
