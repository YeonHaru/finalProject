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
        const res = await fetch(url, { method: 'POST', headers: buildHeaders(true), body, credentials: 'same-origin' });
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
        cart: '장바구니에 담으시겠습니까?',
        bulk_like: '선택한 도서를 위시리스트에 담으시겠습니까?',
        bulk_cart: '선택한 도서를 장바구니에 담으시겠습니까?'
    };
    function ask(key) {
        const msg = CONFIRM_MSG[key];
        return msg ? window.confirm(msg) : true;
    }

    /* ===== 4) 헬퍼 ===== */
    const $  = (s, ctx=document) => ctx.querySelector(s);
    const $$ = (s, ctx=document) => Array.from(ctx.querySelectorAll(s));

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
    const selectedCheckboxes = () => $$('input[type="checkbox"][name="selected"]:checked');
    const selectedIds = () => selectedCheckboxes().map(cb => Number(cb.value)).filter(n => Number.isFinite(n));

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

    /* ===== 6) 전체선택 ===== */
    const checkAll = $('#checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', () => {
            const checked = checkAll.checked;
            $$('input[type="checkbox"][name="selected"]').forEach(cb => cb.checked = checked);
        });
    }

    /* ===== 7) 일괄 버튼: data-bulk="cart" | "like" =====
       - 백엔드에 bulk API가 없을 수도 있으므로 단건 API를 묶어서 전송 (Promise.all) */
    $$('button[data-bulk]').forEach((btn) => {
        btn.addEventListener('click', async () => {
            const ids = selectedIds();
            if (ids.length === 0) { alert('선택된 도서가 없습니다.'); return; }

            const mode = btn.dataset.bulk; // 'cart' | 'like'
            const confirmKey = mode === 'cart' ? 'bulk_cart' : 'bulk_like';
            if (!ask(confirmKey)) return;

            try {
                if (mode === 'like') {
                    await Promise.all(ids.map(id => postForm(URLS.wishlistAdd, { bookId: id })));
                    toast('선택 도서를 위시리스트에 담았습니다.');
                } else {
                    const qty = readQty(btn); // 필요 시 data-qty로 동일 수량 적용
                    await Promise.all(ids.map(id => postForm(URLS.cartAdd, { bookId: id, quantity: qty })));
                    toast('선택 도서를 장바구니에 담았습니다.');
                }
            } catch (err) {
                alert(err.message || '일괄 처리 중 오류가 발생했습니다.');
            }
        });
    });

    /* ===== 8) 정렬 툴바 보조 =====
       - form name="listForm" 가정
       - 적용 버튼 클릭 시 page=0 강제
       - 옵션: 셀렉트 변경 즉시 자동 제출(주석 해제 시) */
    const form = document.forms['listForm'];
    if (form) {
        const pageHidden  = $('#page', form);
        const applyBtn    = $('button[type="submit"].bg-accent', form);
        const sortFieldEl = $('#sort_field', form);
        const sortOrderEl = $('#sort_order', form);

        if (applyBtn && pageHidden) {
            applyBtn.addEventListener('click', () => { pageHidden.value = 0; });
        }

        // 셀렉트 변경 시 자동 적용을 원하면 아래 주석 해제
        // const autoSubmit = () => { if (pageHidden) pageHidden.value = 0; form.submit(); };
        // if (sortFieldEl) sortFieldEl.addEventListener('change', autoSubmit);
        // if (sortOrderEl) sortOrderEl.addEventListener('change', autoSubmit);
    }

    /* ===== 9) 탭 전환 (카테고리/해시태그) =====
       - HTML: onclick="switchTab(this)" 로 호출됨 */
    window.switchTab = function switchTab(button) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');

        const idx = [...button.parentElement.querySelectorAll('.tab-btn')].indexOf(button);
        const weekly  = document.querySelector('.category-grid-weekly');
        const monthly = document.querySelector('.category-grid-monthly');
        if (!weekly || !monthly) return;

        const hide = el => el.classList.add('is-hidden');
        const show = el => el.classList.remove('is-hidden');

        if (idx === 0) { // 카테고리 탭
            show(weekly); hide(monthly);
        } else {         // 해시태그 탭
            show(monthly); hide(weekly);
        }
    };

    // 초기상태: 첫 탭 활성화 기준으로 보이기/숨기기
    (function initTabs() {
        const weekly  = document.querySelector('.category-grid-weekly');
        const monthly = document.querySelector('.category-grid-monthly');
        if (!weekly || !monthly) return;

        const firstActive = document.querySelector('.tab-buttons .tab-btn.active');
        if (!firstActive) return;

        const idx = [...firstActive.parentElement.querySelectorAll('.tab-btn')].indexOf(firstActive);
        if (idx === 0) { weekly.classList.remove('is-hidden'); monthly.classList.add('is-hidden'); }
        else { monthly.classList.remove('is-hidden'); weekly.classList.add('is-hidden'); }
    })();

    /* ===== 10) 카테고리 아이템 선택 표시 ===== */
    document.querySelectorAll('.category-item').forEach(item => {
        item.addEventListener('click', function() {
            document.querySelectorAll('.category-item').forEach(cat => cat.classList.remove('featured'));
            this.classList.add('featured');
            console.log('선택된 카테고리:', this.textContent);
            // TODO: 필요 시 여기서 실제 검색 파라미터로 카테고리/해시태그를 반영해 submit하도록 확장
        });
    });
})();
