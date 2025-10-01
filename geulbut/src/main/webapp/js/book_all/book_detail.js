console.log('[book_detail] payment modal integration');

(function () {
    const U = window.URLS || {};
    const CSRF_H = window.csrfHeaderName || 'X-CSRF-TOKEN';
    const CSRF_T = window.csrfToken || '';

    function headersJSON() {
        const h = new Headers({ 'Content-Type': 'application/json' });
        if (CSRF_T) h.set(CSRF_H, CSRF_T);
        return h;
    }

    async function fetchCartTotal() {
        const res = await fetch(U.cart, { method: 'GET', headers: headersJSON() });
        if (res.status === 401) { location.href = U.login; return null; }
        const data = await res.json();
        return data.cartTotal ?? 0;
    }

    async function preparePay() {
        const res = await fetch(U.payPrepare, { method: 'POST', headers: headersJSON(), body: JSON.stringify({}) });
        if (res.status === 401) { location.href = U.login; return null; }
        return res.json(); // { merchantUid }
    }

    function getOrderFormValues() {
        const f = document.getElementById('orderForm');
        return {
            userId: f.userId?.value,
            userName: f.userName?.value,
            email: f.email?.value,
            phone: f.phone?.value,
            recipient: f.recipient?.value,
            address: f.address?.value,
            memo: f.memo?.value,
            paymentMethod: f.paymentMethod?.value || 'card'
        };
    }

    async function requestPay(total, prep) {
        const o = getOrderFormValues();
        const IMP = window.IMP;
        if (!IMP) { alert('결제 모듈 초기화 실패'); return; }

        const impCode = document.getElementById('imp-root')?.dataset?.impCode;
        if (impCode) IMP.init(impCode);

        IMP.request_pay({
            pg: 'html5_inicis.INIpayTest',
            pay_method: 'card',
            merchant_uid: prep.merchantUid,
            name: '장바구니 결제',
            amount: Number(total),
            buyer_name: o.recipient,
            buyer_tel: o.phone,
            buyer_email: o.email,
            buyer_addr: o.address
        }, async (rsp) => {
            if (!rsp.success) {
                alert('결제 실패: ' + rsp.error_msg);
                return;
            }
            const payload = {
                impUid: rsp.imp_uid,
                merchantUid: rsp.merchant_uid,
                ordersInfo: {
                    userId: o.userId,
                    recipient: o.recipient,
                    phone: o.phone,
                    address: o.address,
                    memo: o.memo,
                    payMethod: o.paymentMethod,
                    amount: Number(total)
                }
            };
            const res = await fetch(U.payVerify, { method: 'POST', headers: headersJSON(), body: JSON.stringify(payload) });
            const data = await res.json();
            if (res.ok && data.orderId) {
                location.href = U.ordersBase + data.orderId;
            } else {
                alert('검증 실패: ' + (data.message || ''));
            }
        });
    }

    async function openOrderInfoModal() {
        const total = await fetchCartTotal();
        if (total == null) return;
        document.getElementById('oiTotal').textContent = new Intl.NumberFormat().format(total);

        const modal = new bootstrap.Modal('#orderInfoModal');
        modal.show();

        const confirmBtn = document.getElementById('oi-confirm');
        confirmBtn.onclick = async () => {
            confirmBtn.disabled = true;
            try {
                const prep = await preparePay();
                await requestPay(total, prep);
            } catch (e) {
                console.error(e);
                alert('결제 준비 오류');
            } finally {
                confirmBtn.disabled = false;
            }
        };
    }

    // 디테일 결제 버튼 바인딩
    document.getElementById('buyNowBtn')?.addEventListener('click', openOrderInfoModal);
})();
