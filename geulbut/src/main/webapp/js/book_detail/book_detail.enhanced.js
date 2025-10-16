// /js/book_detail/book_detail.enhanced.js
console.log('[book_detail] enhanced: qty/total, sticky bar, image skeleton, reveal');

(() => {
    const fmtKR = (n) => new Intl.NumberFormat('ko-KR').format(Number(n||0));
    const priceUnit = (window.PRODUCT?.discountedPrice ?? window.PRODUCT?.price) ?? 0;

    /* 1) 표지 스켈레톤/로드 */
    const cover = document.querySelector('.book-cover');
    if (cover) {
        cover.classList.add('loading');
        const img = cover.querySelector('img');
        if (img?.complete) onCoverLoad(); else img?.addEventListener('load', onCoverLoad);
        function onCoverLoad(){ cover.classList.remove('loading'); cover.classList.add('loaded'); }
    }

    /* 2) 수량 & 합계 */
    const qtyInput = document.getElementById('qtyInput');
    const totalEl  = document.getElementById('totalPrice');
    const stickyBar= document.getElementById('stickyBar');
    const sQty     = document.getElementById('stickyQty');
    const sTot     = document.getElementById('stickyTotal');

    const key = 'BOOK_QTY_' + (window.PRODUCT?.id || '');
    const saved = Number(sessionStorage.getItem(key)) || 1;
    if (qtyInput) qtyInput.value = String(Math.max(1, saved));

    function getQty() {
        const n = Number(qtyInput?.value);
        return Number.isFinite(n) && n > 0 ? Math.floor(n) : 1;
    }
    function setQty(n) {
        const v = Math.max(1, Math.min(99, Number(n)||1));
        if (qtyInput) qtyInput.value = String(v);
        sessionStorage.setItem(key, String(v));
        updateTotals();
    }
    function updateTotals() {
        const q = getQty();
        const tot = priceUnit * q;
        if (totalEl) totalEl.textContent = fmtKR(tot) + '원';
        if (sQty) sQty.textContent = `수량 ${q}`;
        if (sTot) sTot.textContent = fmtKR(tot) + '원';
        // cart 버튼의 data-qty 동기화
        document.querySelectorAll('[data-act="cart"]').forEach(b => b.dataset.qty = String(q));
    }
    updateTotals();

    document.querySelector('[data-qty-dec]')?.addEventListener('click', () => setQty(getQty()-1));
    document.querySelector('[data-qty-inc]')?.addEventListener('click', () => setQty(getQty()+1));
    qtyInput?.addEventListener('change', () => setQty(qtyInput.value));
    qtyInput?.addEventListener('keydown', (e)=>{
        if (e.key === 'Enter') { e.preventDefault(); updateTotals(); }
    });

    /* 3) 스크롤 리빌 */
    const toReveal = Array.from(document.querySelectorAll('.book-detail, .info-card, .price-box, .tag-list, .accordion .acc'));
    toReveal.forEach(el => el.classList.add('reveal'));
    const io = new IntersectionObserver((ents)=>{
        ents.forEach(ent => { if (ent.isIntersecting){ ent.target.classList.add('is-in'); io.unobserve(ent.target); } });
    }, { threshold: 0.08 });
    toReveal.forEach(el => io.observe(el));

    /* 4) 하단 고정 구매바 표시 조건 */
    if (stickyBar) {
        const anchor = document.querySelector('.actions-grid') || document.querySelector('.price-box');
        if (anchor) {
            const io2 = new IntersectionObserver((ents)=>{
                const visible = ents[0].isIntersecting;
                stickyBar.hidden = visible; // 액션 영역 보이면 숨김
            }, { threshold: 0.05 });
            io2.observe(anchor);
        } else {
            stickyBar.hidden = false;
        }
    }

    /* 5) Sticky 구매 버튼 -> 기존 buyNowBtn 클릭 재사용 */
    document.getElementById('buyNowBtnSticky')?.addEventListener('click', ()=>{
        document.getElementById('buyNowBtn')?.click();
    });

    /* 6) 위시리스트 미세 애니메이션 */
    const wishBtn = document.getElementById('btnWishlist');
    wishBtn?.addEventListener('click', ()=>{
        wishBtn.classList.add('wiggle');
        setTimeout(()=> wishBtn.classList.remove('wiggle'), 500);
    });

    /* 7) 키보드 접근성 */
    document.querySelectorAll('[data-act], .qty-btn').forEach(el=>{
        el.setAttribute('tabindex','0');
        el.addEventListener('keydown',(e)=>{
            if (e.key === ' ' || e.key === 'Enter'){ e.preventDefault(); el.click(); }
        });
    });
})();
