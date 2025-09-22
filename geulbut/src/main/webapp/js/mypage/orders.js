// ✅ 주문 내역 갱신 (SPA 방식)
function refreshOrders() {
    const ordersContainer = document.querySelector('#v-pills-orders');
    const userId = "${user.userId}";  // JSP에서 로그인 사용자 ID 내려주기

    fetch(`/orders/user/${userId}`, {
        method: 'GET',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(orderList => {
            console.log("📌 [DEBUG] 주문 내역 데이터:", orderList);

            if (!orderList || orderList.length === 0) {
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
                            <th>상품</th>
                            <th>금액</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            orderList.forEach(order => {
                const itemsHtml = order.items.map(
                    item => `${item.bookId} x ${item.quantity}`
                ).join('<br/>');

                html += `
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.createdAt ?? ''}</td>
                        <td>${itemsHtml}</td>
                        <td>${order.totalPrice.toLocaleString()} 원</td>
                        <td>${order.status}</td>
                    </tr>
                `;
            });

            html += `</tbody></table>`;
            ordersContainer.innerHTML = html;
        })
        .catch(err => console.error("❌ 주문 내역 갱신 실패", err));
}
