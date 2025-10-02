// /js/book_all/book_all.wired.js
console.log('[book_all] wired: wishlist + cart (form-encoded + confirm)');

(function () {
    /* ===== 0) 엔드포인트 ===== */
    const CTX = (typeof window.CONTEXT_PATH !== 'undefined'
        ? window.CONTEXT_PATH
        : (typeof pageContext !== 'undefined' && pageContext?.request?.contextPath) || '');
    const URLS = {
        wishlistAdd: CTX + '/wishlist',
        cartAdd:     CTX + '/cart',
        login:       CTX + '/users/login'
    };

    /* ===== 1) CSRF ===== */
    const CSRF_TOKEN  = document.querySelector('meta[name="_csrf"]')?.getAttribute('content') || null;
    const CSRF_HEADER = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';
    function buildHeaders(isForm = true) {
        const h = new Headers();
        if (isForm) h.set('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
        if (CSRF_TOKEN) h.set(CSRF_HEADER, CSRF_TOKEN);
        return h;
    }
    async function postForm(url, paramsObj) {
        const body = new URLSearchParams();
        Object.entries(paramsObj || {}).forEach(([k, v]) => body.append(k, String(v)));
        const res = await fetch(url, { method: 'POST', headers: buildHeaders(true), body });
        if (res.status === 401) { location.href = URLS.login; return null; }
        let data = null;
        try { data = await res.clone().json(); } catch (_) {}
        if (!res.ok) {
            const msg = data?.message || data?.error || `요청 실패 (${res.status})`;
            throw new Error(msg);
        }
        return data;
    }

    /* ===== 2) 토스트 ===== */
    function toast(msg) {
        let t = document.getElementById('_toast');
        if (!t) {
            t = document.createElement('div');
            t.id = '_toast';
            Object.assign(t.style, {
                position: 'fixed', left: '50%', bottom: '28px', transform: 'translateX(-50%)',
                padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,.78)',
                color: '#fff', fontWeight: '600', zIndex: '9999', transition: 'opacity .25s ease'
            });
            document.body.appendChild(t);
        }
        t.textContent = msg;
        t.style.opacity = '1';
        setTimeout(() => (t.style.opacity = '0'), 1400);
    }

    /* ===== 3) confirm 메세지(구매 없음) ===== */
    const CONFIRM_MSG = {
        like: '위시리스트에 담으시겠습니까?',
        cart: '장바구니에 담으시겠습니까?'
    };
    function ask(act) {
        const msg = CONFIRM_MSG[act];
        return msg ? window.confirm(msg) : true;
    }

    /* ===== 4) 헬퍼 ===== */
    function readIdFrom(btn) {
        const d = btn?.dataset?.id;
        if (d) return Number(d);
        const el = btn?.closest('[data-book-id]') || btn?.closest('[data-id]');
        const v = el?.dataset?.bookId || el?.dataset?.id;
        return v ? Number(v) : NaN;
    }
    function readQty(btn) {
        const dq = Number(btn?.dataset?.qty);
        return Number.isFinite(dq) && dq > 0 ? dq : 1;
    }

    /* ===== 5) 단건 액션: cart / like ===== */
    document.addEventListener('click', async (e) => {
        const btn = e.target.closest('[data-act]');
        if (!btn) return;

        const act = btn.dataset.act;  // 'cart' | 'like'
        if (act !== 'cart' && act !== 'like') return; // 구매는 여기서 처리 안 함

        const id  = readIdFrom(btn);
        const qty = readQty(btn);
        if (!Number.isFinite(id)) { alert('도서 ID가 없습니다.'); return; }

        // ✅ 확인창
        if (!ask(act)) return;

        try {
            if (act === 'like') {
                await postForm(URLS.wishlistAdd, { bookId: id });
                toast('위시리스트에 담었습니다.');
            } else if (act === 'cart') {
                await postForm(URLS.cartAdd, { bookId: id, quantity: qty });
                toast('장바구니에 담았습니다.');
            }
        } catch (err) {
            alert(err.message || '처리 중 오류가 발생했습니다.');
        }
    });
})();
function switchTab(button) {
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });

    button.classList.add('active');
}

document.querySelectorAll('.category-item').forEach(item => {
    item.addEventListener('click', function() {
        document.querySelectorAll('.category-item').forEach(cat => {
            cat.classList.remove('featured');
        });

        this.classList.add('featured');

        console.log('선택된 카테고리:', this.textContent);
    });
});
