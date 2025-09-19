// 📌 전역 CSRF 토큰 설정 (서버에서 JSP로 주입된 값을 JS에서 전역으로 사용 가능하게 함)
window.csrfToken = '${_csrf.token}';

// 📌 페이지 로드가 완료되면 실행
document.addEventListener("DOMContentLoaded", function () {
    // 탭 이름 → 실제 DOM id 매핑
    const tabMap = {
        wishlist: "#v-pills-wishlist", // 위시리스트 탭
        cart: "#v-pills-cart",         // 장바구니 탭
        orders: "#v-pills-orders",     // 주문 내역 탭
        info: "#v-pills-info"          // 내 정보 탭
    };

    // URL에서 쿼리 파라미터 추출 (?tab=wishlist 같은 형태)
    const params = new URLSearchParams(window.location.search);
    let targetId = null;

    // 1️⃣ 쿼리 파라미터에 tab 값이 있으면 해당 탭 id 가져오기
    if (params.has("tab") && tabMap[params.get("tab")]) {
        targetId = tabMap[params.get("tab")];
    }

    // 2️⃣ 쿼리 파라미터가 없으면, URL 해시값 (#v-pills-cart 같은 형태) 확인
    if (!targetId && window.location.hash) {
        targetId = window.location.hash;
    }

    // 3️⃣ targetId가 존재하면 해당 탭을 활성화
    if (targetId) {
        const triggerEl = document.querySelector(`button[data-bs-target="${targetId}"]`);
        if (triggerEl) new bootstrap.Tab(triggerEl).show();
    }
    // ✅ 장바구니 탭 클릭 시 항상 최신화
    const cartTabBtn = document.querySelector('#v-pills-cart-tab');
    if (cartTabBtn) {
        cartTabBtn.addEventListener('shown.bs.tab', function () {
            console.log("📌 [DEBUG] 장바구니 탭 전환 → refreshCart 실행");
            refreshCart();
        });
    }
});

