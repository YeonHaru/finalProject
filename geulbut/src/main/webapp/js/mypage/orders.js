// ✅ 주문 내역 갱신 (SPA 방식)
function refreshOrders() {
    const ordersContainer = document.querySelector('#v-pills-orders');

    fetch('/orders/user', {
        method: 'GET',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(data => {
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
                html += `
                    <div class="card mb-3 shadow-sm">
                        <div class="card-body">
                            <!-- ✅ 상품 이미지들 -->
                            <div class="d-flex overflow-auto mb-2" style="gap:8px;">
                                ${order.items.map(item =>
                    `<img src="${item.imageUrl}" alt="${item.title}"
                                          style="width:60px; height:85px; object-fit:cover; border-radius:4px;">`
                ).join("")}
                            </div>

                            <!-- ✅ 상품명 + 수량 -->
                            ${order.items.map(item =>
                    `<div><strong>${item.title}</strong> 
                                 <span class="text-muted">x ${item.quantity}</span></div>`
                ).join("")}

                            <!-- ✅ 금액 -->
                            <div class="fw-bold text-primary mt-2">
                                ${order.totalPrice.toLocaleString()} 원
                            </div>

                            <!-- ✅ 주문일 -->
                            <div class="text-muted small">
                                주문일: ${order.createdAt}
                            </div>

                            <!-- ✅ 상태 + 버튼 -->
                            <div class="mt-2">
                                ${renderOrderStatus(order)}
                            </div>
                        </div>
                    </div>
                `;
            });

            html += `</div>`;
            ordersContainer.innerHTML = html;
        })
        .catch(err => console.error("❌ 주문내역 갱신 실패:", err));
}

// 상태별 버튼/뱃지 렌더링
function renderOrderStatus(order) {
    switch (order.status) {
        case 'PAID':
            return `<span class="badge bg-primary">결제 완료</span>
                    <button class="btn btn-sm btn-outline-danger ms-2"
                            onclick="removeOrder(${order.orderId})">취소</button>`;
        case 'SHIPPED':
            return `<span class="badge bg-info text-dark">배송중</span>`;
        case 'DELIVERED':
            return `<span class="badge bg-success">배송완료</span>`;
        default:
            return `<span class="badge bg-light text-dark">알 수 없음</span>`;
    }
}

function updateOrderStatus(orderId, newStatus) {
    let confirmMsg = "";
    let successMsg = "";

    switch (newStatus) {
        case 'REFUND_REQUEST':
            confirmMsg = "환불을 신청하시겠습니까?";
            successMsg = "환불 신청이 접수되었습니다.";
            break;
        default:
            confirmMsg = "";
            successMsg = "주문 상태가 변경되었습니다.";
    }

    // ✅ confirm 메시지가 있으면 확인 받기
    if (confirmMsg && !confirm(confirmMsg)) return;

    fetch(`/orders/${orderId}/status?status=${newStatus}`, {
        method: 'PATCH',
        headers: {
            'X-CSRF-TOKEN': window.csrfToken,
            'Content-Type': 'application/json'
        }
    })
        .then(res => {
            if (!res.ok) throw new Error("상태 변경 실패");
            return res.json();
        })
        .then(data => {
            console.log("✅ 주문상태 변경 성공:", data);
            if (successMsg) alert(successMsg);  // ✅ 상태별 성공 알림
            refreshOrders(); // 새로고침 대신 SPA 갱신
        })
        .catch(err => console.error("❌ 상태 변경 오류:", err));
}

function removeOrder(orderId) {
    if (!confirm("정말 주문을 삭제하시겠습니까?")) return;

    fetch(`/orders/${orderId}`, {
        method: 'DELETE',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === "ok") {
                alert(data.message); // ✅ 주문이 삭제되었습니다.
                refreshOrders();     // ✅ UI 갱신
            } else {
                alert("❌ 삭제 실패: " + data.message);
            }
        })
        .catch(err => console.error("삭제 요청 실패:", err));
}



