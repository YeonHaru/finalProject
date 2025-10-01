console.log('[search_results] wired: wishlist + cart (form-encoded)');

(function () {
    /* ===== 0) 엔드포인트 ===== */
    const CTX = (typeof window.CONTEXT_PATH !== 'undefined'
        ? window.CONTEXT_PATH
        : (typeof pageContext !== 'undefined' && pageContext?.request?.contextPath) || '');
    const URLS = {
        wishlistAdd: CTX + '/wishlist',                  // POST @RequestParam bookId
        cartAdd:     CTX + '/cart',                      // POST @RequestParam bookId, quantity
        // buy-now는 아직 컨트롤러 없음 → 필요 시 추후 연결
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
        let data = null;
        try { data = await res.clone().json(); } catch (_) {}
        if (!res.ok) {
            const msg = data?.message || data?.error || `요청 실패 (${res.status})`;
            throw new Error(msg);
        }
        return data;
    }

    /* ===== 2) 체크박스 ===== */
    const checkAll = document.getElementById('checkAll');
    const itemChecks = Array.from(document.querySelectorAll('.srch-item input[type="checkbox"][name="selected"]'));
    if (checkAll) {
        checkAll.addEventListener('change', () => itemChecks.forEach(chk => chk.checked = checkAll.checked));
    }
    itemChecks.forEach(chk => {
        chk.addEventListener('change', () => {
            if (!chk.checked && checkAll) checkAll.checked = false;
            if (itemChecks.length && itemChecks.every(c => c.checked) && checkAll) checkAll.checked = true;
        });
    });

    /* ===== 3) 토스트 ===== */
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

    /* ===== 4) 단건 액션 ===== */
    document.addEventListener('click', async (e) => {
        const btn = e.target.closest('[data-act]');
        if (!btn) return;

        const act = btn.dataset.act;   // cart | buy | like
        const id  = btn.dataset.id;
        const qty = Number(btn.dataset.qty || 1); // 필요하면 data-qty로 개별 수량 전달
        if (!id) { alert('도서 ID가 없습니다.'); return; }

        try {
            if (act === 'like') {
                await postForm(URLS.wishlistAdd, { bookId: Number(id) });
                toast('위시리스트에 담았습니다.');
            } else if (act === 'cart') {
                await postForm(URLS.cartAdd, { bookId: Number(id), quantity: qty });
                toast('장바구니에 담았습니다.');
            } else if (act === 'buy') {
                // 아직 buy-now 엔드포인트가 없으니, 임시로 상세로 이동 or 체크아웃 고정경로 이동
                // location.href = CTX + '/orders/checkout';
                location.href = CTX + '/book/' + id; // 임시 (원하면 checkout으로 교체)
            }
        } catch (err) {
            alert(err.message || '처리 중 오류가 발생했습니다.');
        }
    });

    /* ===== 5) 일괄 액션(위/장) : bulk 엔드포인트가 없으므로 N회 호출 ===== */
    document.querySelectorAll('[data-bulk]').forEach(btn => {
        btn.addEventListener('click', async () => {
            const ids = itemChecks.filter(c => c.checked).map(c => Number(c.value));
            if (ids.length === 0) { alert('선택된 도서가 없습니다.'); return; }

            const type = btn.dataset.bulk;  // 'cart' | 'like'
            try {
                if (type === 'like') {
                    for (const id of ids) { await postForm(URLS.wishlistAdd, { bookId: id }); }
                    toast(`위시리스트 담기 완료 (${ids.length}건)`);
                } else if (type === 'cart') {
                    for (const id of ids) { await postForm(URLS.cartAdd, { bookId: id, quantity: 1 }); }
                    toast(`장바구니 담기 완료 (${ids.length}건)`);
                }
            } catch (err) {
                alert(err.message || '처리 중 오류가 발생했습니다.');
            }
        });
    });
})();
