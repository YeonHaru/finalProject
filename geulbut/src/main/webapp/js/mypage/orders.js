// ✅ 주문 내역 갱신 (SPA 방식)
function refreshOrders() {
    const ordersContainer = document.querySelector('#v-pills-orders');
    const userId = window.currentUserId;  // JSP에서 내려준 전역 변수 사용

    fetch(`/orders/user`, {
        method: 'GET',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(orderList => {
            console.log("📌 [DEBUG] 주문 내역 데이터:", orderList);

            if (!Array.isArray(orderList) || orderList.length === 0) {
                ordersContainer.innerHTML =
                    '<div class="alert alert-info">주문 내역이 없습니다.</div>';
                return;
            }

            // 👉 주문 내역 테이블 생성
            let html = `
                <h2 class="mb-3 pb-2 border-bottom">주문 내역</h2>
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>주문일</th>
                            <th>도서</th>
                            <th>금액</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            orderList.forEach(order => {
                const itemsHtml = order.items.map(
                    item => `${item.title ?? '알 수 없음'} x ${item.quantity}`
                ).join('<br/>');

                html += `
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.createdAt ?? ''}</td>
                        <td>${itemsHtml}</td>
                        <td>${order.totalPrice?.toLocaleString() ?? 0} 원</td>
                        <td>${order.status}</td>
                    </tr>
                `;
            });

            html += `</tbody></table>`;
            ordersContainer.innerHTML = html;
        })
        .catch(err => console.error("❌ 주문 내역 갱신 실패", err));
}

function updateOrderStatus(orderId, newStatus){
    fetch(`/orders/${orderId}/status?status=${newStatus}`,{
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
            console.log("주문상태 변경 성공:", data);
            refreshOrders(); // 성공하면 새로고침
        })
        .catch(err => console.error("상태 변경 오류:", err));
}
