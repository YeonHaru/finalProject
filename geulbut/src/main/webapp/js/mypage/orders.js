// orders.js (권장: mypage-common.js 다음, cart.js 이전에 로드)
window.Orders = (() => {

    /** ========== 1) 주문 내역 SPA 렌더 ========== */
    async function refreshOrders() {
        const ordersContainer = document.querySelector('#v-pills-orders');
        try {
            const res = await fetch('/orders/user', {
                method: 'GET',
                headers: { 'X-CSRF-TOKEN': window.csrfToken }
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
                const firstItem = order.items[0]; // 대표 아이템
                const firstTitle = escapeHtml(firstItem.title);
                const thumbUrl = escapeHtml(firstItem.imageUrl || '');
                const totalItems = order.items.length;

                // 카드 요약 (대표 도서 + 기본정보)
                html += `
                    <div class="card mb-3 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <img src="${thumbUrl}" alt="${firstTitle}"
                                     style="width:60px; height:85px; object-fit:cover; border-radius:4px; margin-right:10px;">
                                <div class="flex-grow-1">
                                    <div class="fw-bold">${firstTitle}${totalItems > 1 ? ` 외 ${totalItems - 1}권` : ''}</div>
                                    <div class="small text-muted">
                                        정가: ${fmtKR(firstItem.price)}원
                                        ${firstItem.discountedPrice && firstItem.discountedPrice < firstItem.price
                    ? `<span class="badge bg-danger ms-2">
                                                ${Math.round((firstItem.price - firstItem.discountedPrice) / firstItem.price * 100)}% 할인
                                               </span>`
                    : ""}
                                    </div>
                                    <div class="small text-muted">주문일: ${escapeHtml(order.createdAt || '')}</div>
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
                                                주문일: ${escapeHtml(order.createdAt || '')}
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
                            onclick="Orders.removeOrder(${id})">취소</button>`;
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
        if (!confirm("정말 주문을 삭제하시겠습니까?")) return;

        try {
            const res = await fetch(`/orders/${orderId}`, {
                method: 'DELETE',
                headers: { 'X-CSRF-TOKEN': window.csrfToken }
            });
            const data = await res.json();
            if (data.status === "ok") {
                alert(data.message || "주문이 삭제되었습니다.");
                await refreshOrders();
            } else {
                alert("❌ 삭제 실패: " + (data.message || ''));
            }
        } catch (err) {
            console.error("삭제 요청 실패:", err);
        }
    }

    // 공개 API
    return {
        refreshOrders,
        renderOrderStatus,
        updateOrderStatus,
        removeOrder
    };
})();
