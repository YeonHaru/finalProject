/* =========================
 * mypage-common.js (공통)
 * ========================= */

/** HTML 이스케이프 (전역) */
window.escapeHtml = function (s) {
    return String(s ?? '')
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
};

/** 한국어 통화/숫자 포맷 (전역) */
window.fmtKR = function (n) {
    const v = Number(n);
    return Number.isFinite(v) ? v.toLocaleString('ko-KR') : '0';
};

/** PortOne(아임포트) init (전역) — SDK 지연 대비, 1회 보장 */
(function initPortOneOnce() {
    let tried = false;
    function tryInit() {
        if (tried) return true;
        const root = document.getElementById('imp-root');
        const impCode = (window.IMP_CODE) || (root && root.dataset.impCode);
        const IMP = window.IMP;

        if (!IMP) return false;                 // SDK 아직
        if (!impCode) {                         // 코드 없음 → 재시도 의미 없음
            console.warn('[IMP] imp_code missing. JSP에서 imp_code 주입 필요');
            return true;
        }
        try {
            IMP.init(impCode);
            console.log('[IMP:init] OK with', impCode);
            tried = true;
            return true;
        } catch (e) {
            console.error('[IMP:init] failed', e);
            return true;
        }
    }

    if (tryInit()) return;
    let count = 0;
    const t = setInterval(() => {
        count++;
        if (tryInit() || count >= 20) clearInterval(t); // 최대 2초 대기
    }, 100);
})();

/* 페이지 로드 시 탭 초기화 & 훅 */
document.addEventListener("DOMContentLoaded", function () {
    const tabMap = {
        wishlist: "#v-pills-wishlist",
        cart: "#v-pills-cart",
        orders: "#v-pills-orders",
        info: "#v-pills-info"
    };

    const params = new URLSearchParams(window.location.search);
    let targetId = null;

    if (params.has("tab") && tabMap[params.get("tab")]) targetId = tabMap[params.get("tab")];
    if (!targetId && window.location.hash) targetId = window.location.hash;

    if (targetId) {
        const triggerEl = document.querySelector(`button[data-bs-target="${targetId}"]`);
        if (triggerEl) new bootstrap.Tab(triggerEl).show();
    }

    // 장바구니 탭 전환 시 항상 최신화
    const cartTabBtn = document.querySelector('#v-pills-cart-tab');
    if (cartTabBtn && window.refreshCart) {
        cartTabBtn.addEventListener('shown.bs.tab', () => {
            console.log("📌 [DEBUG] 장바구니 탭 전환 → refreshCart 실행");
            window.refreshCart();
        });
    }

    // 주문 탭 전환 시 최신화
    const ordersTabBtn = document.querySelector('#v-pills-orders-tab');
    if (ordersTabBtn && window.Orders?.refreshOrders) {
        ordersTabBtn.addEventListener('shown.bs.tab', () => {
            console.log("📌 [DEBUG] 주문 탭 전환 → Orders.refreshOrders 실행");
            window.Orders.refreshOrders();
        });
    }
});
