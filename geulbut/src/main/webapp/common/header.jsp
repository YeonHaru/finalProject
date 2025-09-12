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
            <ul class="site-header__menu site-header__menu--mobile">
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

        <!-- 모바일 햄버거 버튼: 기존 우측 메뉴 뒤, 검색창 위쪽에 위치 -->
        <button class="site-header__hamburger" aria-label="메뉴 열기">
            <span></span>
            <span></span>
            <span></span>
        </button>


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


        <!-- 헤더 최상단 좌측에 고정 -->
        <div id="weather-dust-header" style="
    position: fixed;
    top: 5px;
    left: 5px;
    font-size: 12px;
    padding: 3px 6px;
    background-color: rgba(255,255,255,0.9);
    border-radius: 4px;
    z-index: 9999;
    box-shadow: 0 0 3px rgba(0,0,0,0.3);
">
            불러오는 중...
        </div>
        <!-- 햄버거 토글 JS -->

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const hamburger = document.querySelector('.site-header__hamburger');
                const mobileMenu = document.querySelector('.site-header__nav--right');

                if (!hamburger || !mobileMenu) return;

                // 햄버거 버튼 클릭 이벤트
                hamburger.addEventListener('click', function(e) {
                    e.stopPropagation();
                    toggleMenu();
                });

                // 메뉴 토글 함수
                function toggleMenu() {
                    const isOpen = mobileMenu.classList.contains('open');

                    if (isOpen) {
                        closeMenu();
                    } else {
                        openMenu();
                    }
                }

                // 메뉴 열기
                function openMenu() {
                    mobileMenu.classList.add('open');
                    hamburger.classList.add('active');
                    hamburger.setAttribute('aria-label', '메뉴 닫기');

                    // 메뉴가 열릴 때 약간의 바운스 효과 (햄버거 버튼 바로 아래)
                    setTimeout(() => {
                        mobileMenu.style.transform = 'translateY(2px) scale(1.02)';
                        setTimeout(() => {
                            mobileMenu.style.transform = 'translateY(0) scale(1)';
                        }, 100);
                    }, 50);
                }

                // 메뉴 닫기
                function closeMenu() {
                    mobileMenu.classList.remove('open');
                    hamburger.classList.remove('active');
                    hamburger.setAttribute('aria-label', '메뉴 열기');
                    mobileMenu.style.transform = '';
                }

                // 메뉴 외부 클릭 시 메뉴 닫기
                document.addEventListener('click', function(e) {
                    if (!hamburger.contains(e.target) && !mobileMenu.contains(e.target)) {
                        closeMenu();
                    }
                });

                // ESC 키로 메뉴 닫기
                document.addEventListener('keydown', function(e) {
                    if (e.key === 'Escape') {
                        closeMenu();
                    }
                });

                // 메뉴 링크 클릭 시 메뉴 닫기 (모바일에서 페이지 이동 시)
                const menuLinks = mobileMenu.querySelectorAll('a');
                menuLinks.forEach(link => {
                    link.addEventListener('click', closeMenu);
                });

                // 창 크기 변경 시 데스크톱으로 돌아가면 메뉴 닫기
                window.addEventListener('resize', function() {
                    if (window.innerWidth > 768) {
                        closeMenu();
                    }
                });
            });
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", async function () {
                const headerTicker = document.getElementById('weather-dust-header');
                const items = [];

                try {
                    console.log("API 호출 시작...");

                    // 1) 두 API 동시에 호출
                    const [weatherRes, dustRes] = await Promise.all([fetch('/weatherApi'), fetch('/dustApi')]);
                    console.log("weatherRes:", weatherRes);
                    console.log("dustRes:", dustRes);

                    if (!weatherRes.ok) throw new Error('weather API 응답 오류: ' + weatherRes.status);
                    if (!dustRes.ok) throw new Error('dust API 응답 오류: ' + dustRes.status);

                    const weatherList = await weatherRes.json(); // [{districtName, weather}, ...]
                    const dustData = await dustRes.json();       // { "서울": "좋음", ... }

                    console.log("weatherList JSON:", weatherList);
                    console.log("dustData JSON:", dustData);


                    // 2) 가나다 순 정렬
                    weatherList.sort((a, b) => (a?.districtName || '').localeCompare(b?.districtName || '', 'ko-KR'));
                    console.log("가나다 순 정렬 후:", weatherList);


                    weatherList.forEach((w, idx) => {
                        if (!w || !w.districtName) return;

                        const region = w.districtName.trim();
                        const weather = w.weather || '-';

                        // dust 매칭
                        let dust = dustData[region];
                        if (!dust) {
                            const norm = region.replace(/(광역시|특별시|도|시)$/, '');
                            dust = dustData[norm] || '-';
                        }

                        // 1) DOM 블록 생성 (날씨/미세먼지 별도)
                        const div = document.createElement('div');
                        div.className = 'ticker-item';
                        div.innerHTML = '<div class="region-name">' + region + ' : ' + weather + '</div>' +
                            '<div>미세먼지 : ' + dust + '</div>';


                        // 2) 헤더 ticker용 배열에도 추가
                        items.push(div.innerHTML);
                    });

                    console.log("items 배열:", items);

                    // 3) 헤더 3초마다 순환
                    if (items.length > 0) {
                        let index = 0;
                        headerTicker.innerHTML = items[index];
                        setInterval(() => {
                            index = (index + 1) % items.length;
                            headerTicker.innerHTML = items[index];
                            console.log("헤더 ticker 업데이트:", items[index]);
                        }, 3000);
                    }

                } catch (err) {
                    console.error('API 호출 에러:', err);

                }
            });

        </script>


    </div>
</header>
