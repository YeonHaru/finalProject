// orders.js (권장: mypage-common.js 다음, cart.js 이전에 로드)
window.Orders = (() => {

    /** ========== 1) 주문 내역 SPA 렌더 ========== */
    async function refreshOrders() {
        const ordersContainer = document.querySelector('#v-pills-orders');
        try {
            const res = await fetch('/orders/user', {
                method: 'GET',
                headers: {'X-CSRF-TOKEN': window.csrfToken}
            });
            const data = await res.json();

            if (!data || !data.length) {
                ordersContainer.innerHTML = `
          <h2 class="mb-3 pb-2 border-bottom">주문 내역</h2>
          <div class="alert alert-info">주문 내역이 없습니다.</div>`;
                return;
            }

            let html = `
        <h2 class="mb-3 pb-2 border-bottom">주문 내역</h2>
        <div class="orders-list">
      `;

            data.forEach(order => {
                // 👉 대표 도서(첫 번째 아이템) 추출
                const firstItem = order.items[0];
                const firstTitle = escapeHtml(firstItem.title);
                const thumbUrl = escapeHtml(firstItem.imageUrl || '');
                const totalItems = order.items.length;
                const createdAt = (order.createdAt || '').substring(0, 10);

                // 카드 요약 + 아코디언
                html += `
                <div class="card mb-3 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <img src="${thumbUrl}" alt="${firstTitle}"
                                 style="width:60px; height:85px; object-fit:cover; border-radius:4px; margin-right:10px;">
                            <div class="flex-grow-1">
                                <div class="fw-bold">${firstTitle}${totalItems > 1 ? ` 외 ${totalItems - 1}권` : ''}</div>
                                <div class="small text-muted">주문일: ${escapeHtml((order.createdAt || '').substring(0,10))}</div>
                                <div class="fw-bold text-primary">최종 결제금액: ${fmtKR(order.totalPrice)} 원</div>
                            </div>
                            <div>
                                ${renderOrderStatus(order)}
                            </div>
                        </div>

                        <!-- 아코디언 상세 -->
                        <div class="accordion mt-3" id="orderAccordion-${order.orderId}">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="heading-${order.orderId}">
                                    <button class="accordion-button collapsed" type="button"
                                            data-bs-toggle="collapse"
                                            data-bs-target="#collapse-${order.orderId}"
                                            aria-expanded="false"
                                            aria-controls="collapse-${order.orderId}">
                                        📦 주문 상세 보기
                                    </button>
                                </h2>
                                <div id="collapse-${order.orderId}" class="accordion-collapse collapse"
                                     aria-labelledby="heading-${order.orderId}"
                                     data-bs-parent="#orderAccordion-${order.orderId}">
                                    <div class="accordion-body">
                                        <div class="text-muted small mb-2">
                                            주문번호: ${escapeHtml(order.merchantUid)} <br>
                                            주문일: ${escapeHtml((order.createdAt || '').substring(0,10))}
                                        </div>
                                        ${order.items.map(item => {
                    const discountRate = item.price && item.discountedPrice
                        ? Math.round((item.price - item.discountedPrice) / item.price * 100)
                        : 0;
                    return `
                                                <div class="mb-3">
                                                    <div>
                                                        <strong>${escapeHtml(item.title)}</strong>
                                                        <span class="text-muted ms-1">(${item.quantity}권)</span>
                                                    </div>
                                                    <div class="small text-muted">
                                                        ${discountRate > 0
                        ? `정가: <span class="text-decoration-line-through">${fmtKR(item.price)}원</span>
                                                               <span class="badge bg-danger ms-2">${discountRate}% 할인</span>`
                        : `정가: ${fmtKR(item.price)}원`}
                                                    </div>
                                                    <div class="fw-bold text-success">
                                                        가격: ${fmtKR(item.discountedPrice || item.price)}원
                                                    </div>
                                                </div>
                                            `;
                }).join("")}
                                        <div class="fw-bold text-primary mt-2">
                                            총 결제 금액: ${fmtKR(order.totalPrice)} 원
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            `;
            });

            html += `</div>`;
            ordersContainer.innerHTML = html;

        } catch (err) {
            console.error("❌ 주문내역 갱신 실패:", err);
        }
    }


    /** 상태별 뱃지/버튼 렌더 (HTML 문자열 반환) */
    function renderOrderStatus(order) {
        const id = order.orderId;
        switch (order.status) {
            case 'PAID':
                return `
          <span class="badge bg-primary">결제 완료</span>
            <button class="btn btn-sm btn-outline-danger ms-2"
              onclick="Orders.cancelPay(${id})">결제 취소</button>`;
            case 'CANCELLED':
                return `<span class="badge bg-secondary">취소됨</span>`;
            case 'SHIPPED':
                return `<span class="badge bg-info text-dark">배송중</span>`;
            case 'DELIVERED':
                return `<span class="badge bg-success">배송완료</span>`;
            default:
                return `<span class="badge bg-light text-dark">알 수 없음</span>`;
        }
    }

    /** ========== 2) 주문 상태 변경/삭제 ========== */
    async function updateOrderStatus(orderId, newStatus) {
        let confirmMsg = "";
        let successMsg = "주문 상태가 변경되었습니다.";

        if (newStatus === 'REFUND_REQUEST') {
            confirmMsg = "환불을 신청하시겠습니까?";
            successMsg = "환불 신청이 접수되었습니다.";
        }

        if (confirmMsg && !confirm(confirmMsg)) return;

        try {
            const res = await fetch(`/orders/${orderId}/status?status=${encodeURIComponent(newStatus)}`, {
                method: 'PATCH',
                headers: {
                    'X-CSRF-TOKEN': window.csrfToken,
                    'Content-Type': 'application/json'
                }
            });
            if (!res.ok) throw new Error("상태 변경 실패");
            const data = await res.json();
            console.log("✅ 주문상태 변경 성공:", data);
            if (successMsg) alert(successMsg);
            await refreshOrders();
        } catch (err) {
            console.error("❌ 상태 변경 오류:", err);
        }
    }

    async function removeOrder(orderId) {
        if (!confirm("정말 주문을 취소하시겠습니까?")) return;

        try {
            const res = await fetch(`/orders/${orderId}`, {
                method: 'DELETE',
                headers: {'X-CSRF-TOKEN': window.csrfToken}
            });
            const data = await res.json();
            if (res.ok && data.status === "ok") {
                alert(data.message || "주문이 취소되었습니다.");
                await refreshOrders();
            } else {
                alert("❌ 취소 실패: " + (data.message || ''));
            }
        } catch (err) {
            console.error("취소 요청 실패:", err);
        }
    }

    async function cancelPay(orderId) {
        if (!confirm("정말 결제를 취소하시겠습니까?")) return;

        const reason = prompt("취소 사유(선택):") || "";

        const headers = { 'Accept': 'application/json' };
        // CSRF 쓰면 헤더 추가
        if (window.csrfToken) headers['X-CSRF-TOKEN'] = window.csrfToken;

        try {
            const res = await fetch(`/payments/cancel/${orderId}?reason=${encodeURIComponent(reason)}`, {
                method: 'POST',
                headers,
                credentials: 'include', // 로그인 세션 쿠키 포함!
            });

            const data = await res.json().catch(() => ({}));

            if (!res.ok) {
                alert(data.message || '취소 실패');
                return;
            }
            alert(data.message || '결제가 정상적으로 취소되었습니다.');
            await refreshOrders();
        } catch (e) {
            console.error('❌ 결제 취소 요청 실패:', e);
            alert('네트워크 오류로 취소에 실패했습니다.');
        }
    }
    /** ========== 3) 결제 모달 → prepare → 결제 → verify ========== */

    /** 모달 열기: 총액 세팅, 확인버튼 바인딩 */
    function openOrderInfoModal(total) {

        const latestEl = document.querySelector("#cart-total");
        if (latestEl){
            const latestAmount = parseInt(latestEl.textContent.replace(/[^0-9]/g,""))
            total = latestAmount;
        }

        const totalEl = document.getElementById('oiTotal');
        if (totalEl) totalEl.textContent = fmtKR(total);

        const orderIdView = document.getElementById('f-orderId');
        if (orderIdView) orderIdView.value = '';

        const modal = new bootstrap.Modal('#orderInfoModal');
        modal.show();

        const confirmBtn = document.getElementById('oi-confirm');
        confirmBtn.onclick = async () => {
            confirmBtn.disabled = true;
            try {
                const prep = await preparePay(total);
                if (orderIdView) orderIdView.value = prep.merchantUid || '';
                await requestDemoPay(total, prep);
            } catch (e) {
                console.error(e);
                alert('결제 준비 중 오류가 발생했습니다.');
            } finally {
                confirmBtn.disabled = false;
            }
        };
    }

    /** 폼 값 수집 (모달 입력/hidden 기준) */
    function getOrderFormValues() {
        const f = document.getElementById('orderForm');
        return {
            userId: (f.userId?.value || '').trim(),
            userName: (f.userName?.value || '').trim(),
            email: (f.email?.value || '').trim(),
            phone: (f.phone?.value || '').trim(),
            recipient: (f.recipient?.value || '').trim(),
            address: (f.address?.value || '').trim(),
            memo: (f.memo?.value || '').trim(),
            paymentMethod: (f.paymentMethod?.value || 'card')
        };
    }

    /** prepare: merchantUid 발급 */
    async function preparePay(total) {
        const headers = {'Content-Type': 'application/json'};
        if (window.csrfToken) headers['X-CSRF-TOKEN'] = window.csrfToken;

        const res = await fetch('/payments/prepare', {
            method: 'POST',
            headers,
            body: JSON.stringify({amount: Number(total)})
        });
        if (!res.ok) throw new Error('prepare 실패');
        return res.json(); // { merchantUid }
    }

    /** 결제/검증 */
    async function requestDemoPay(total, prep /* { merchantUid } */) {
        const o = getOrderFormValues();

        const oiTotalEl = document.getElementById("oiTotal");
        if (oiTotalEl){
            total = parseInt(oiTotalEl.textContent.replace(/[^0-9]/g, ""), 10);
        }
        const IMP = window.IMP;
        if (!IMP) {
            alert('결제 모듈 초기화에 실패했습니다. 새로고침 후 다시 시도해 주세요.');
            return;
        }

        const payReq = {
            pg: 'html5_inicis.INIpayTest',
            pay_method: 'card',
            merchant_uid: prep.merchantUid,
            name: '장바구니 결제',
            amount: Number(total),
            buyer_name: o.recipient,
            buyer_tel: o.phone,
            buyer_email: o.email,
            buyer_addr: o.address,
            custom_data: JSON.stringify({memo: o.memo, address: o.address}),
            m_redirect_url: location.origin + '/payments/verify-redirect'
        };

        IMP.request_pay(payReq, async (rsp) => {
            if (!rsp.success) {
                alert('결제 실패: ' + (rsp.error_msg || ''));
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
                    payMethod: 'card',
                    amount: Number(total)
                }
            };

            const headers = {'Content-Type': 'application/json'};
            if (window.csrfToken) headers['X-CSRF-TOKEN'] = window.csrfToken;

            const res = await fetch('/payments/verify', {
                method: 'POST',
                headers,
                body: JSON.stringify(payload)
            });

            const raw = await res.text();
            try {
                const data = JSON.parse(raw);
                if (data.status === 'PAID') {
                    alert('결제 완료');
                    if (window.refreshCart) window.refreshCart();
                    await refreshOrders();

                    //  모달 닫기
                    const modalEl = document.getElementById("orderInfoModal");
                    if (modalEl) {
                        const modal = bootstrap.Modal.getInstance(modalEl);
                        if (modal) modal.hide();
                    }

                    // 주문 탭으로 자동 전환(선택)
                    const ordersTabBtn = document.querySelector('#v-pills-orders-tab');
                    if (ordersTabBtn && window.bootstrap?.Tab) new bootstrap.Tab(ordersTabBtn).show();
                } else {
                    alert('검증 실패: ' + (data.message || ''));
                }
            } catch {
                console.error('VERIFY RAW:', raw);
                alert('서버 응답 파싱 실패(verify). 콘솔 확인');
            }
        });
    }

    /** 선택: 초기 마운트(필요 시 호출) */
    function mount() {
        const tab = document.getElementById('v-pills-orders-tab');
        if (tab) tab.addEventListener('shown.bs.tab', refreshOrders);
    }

    // 공개 API
    return {
        refreshOrders,
        renderOrderStatus,
        updateOrderStatus,
        removeOrder,
        getOrderFormValues,
        openOrderInfoModal,
        requestDemoPay,
        preparePay,
        cancelPay,
        mount
    };
})();
