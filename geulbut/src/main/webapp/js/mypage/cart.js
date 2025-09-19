// ✅ 장바구니 수량 변경
function updateCart(bookId, quantity) {
    fetch(`/cart/${bookId}?quantity=${quantity}`, {
        method: 'PUT',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'ok') {
                refreshCart();          // 테이블 전체 리렌더링
            } else {
                alert('수량 변경 실패 ❌ ' + data.message);
            }
        })
        .catch(err => console.error(err));
}

// ✅ 장바구니 삭제
function removeCart(bookId) {
    if (!confirm('정말 삭제하시겠습니까?')) return;

    fetch(`/cart/${bookId}`, {
        method: 'DELETE',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'ok') {
                refreshCart(); // ✅ 항상 최신 데이터 반영
            } else {
                alert('삭제 실패 ❌ ' + data.message);
            }
        })
        .catch(err => console.error(err));
}

/// 📌 장바구니 탭 리렌더링 (SPA 방식)
function refreshCart() {
    const cartContainer = document.querySelector('#v-pills-cart');

    fetch('/cart', {
        method: 'GET',
        headers: { 'X-CSRF-TOKEN': window.csrfToken }
    })
        .then(res => res.json())
        .then(cartSummary => {
            console.log("📌 [DEBUG] 장바구니 데이터:", cartSummary);

            if (!cartSummary.items || cartSummary.items.length === 0) {
                cartContainer.innerHTML =
                    '<div class="alert alert-info">장바구니가 비어 있습니다.</div>';
                return;
            }

            // 👉 새로운 테이블 HTML 생성
            let html = `
                <h2 class="mb-3 pb-2 border-bottom">장바구니</h2>
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>상품</th>
                            <th style="width:120px;">수량</th>
                            <th>가격</th>
                            <th>합계</th>
                            <th style="width:150px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            cartSummary.items.forEach(item => {
                html += `
                    <tr>
                        <td>${item.title}</td>
                        <td>
                            <input type="number" min="1" value="${item.quantity}"
                                class="form-control form-control-sm"
                                onchange="updateCart(${item.bookId}, this.value)">
                        </td>
                        <td>${item.price.toLocaleString()} 원</td>
                        <td>${item.totalPrice.toLocaleString()} 원</td>
                        <td>
                            <button class="btn btn-sm btn-outline-danger"
                                onclick="removeCart(${item.bookId}, this)">
                                삭제
                            </button>
                        </td>
                    </tr>
                `;
            });

            html += `
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="2"></td>
                            <td class="text-end"><strong>총합</strong></td>
                            <td> <strong><span>${cartSummary.total.toLocaleString()} 원</span></strong></td>
                            <td class="text-end">
                                <button class="btn btn-primary" onclick="checkout()">💳 결제하기</button>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            `;

            // 📌 DOM 교체
            cartContainer.innerHTML = html;
        })
        .catch(err => console.error("❌ 장바구니 갱신 실패", err));
}


// ✅ 전역 결제하기 함수
function checkout() {
    const userId = "${user.userId}"; // JSP에서 세션 사용자 넣어주기
    const totalPrice = parseInt(
        document.querySelector("#v-pills-cart tfoot strong").innerText.replace(/[^0-9]/g, "")
    );

    const items = [];
    document.querySelectorAll("#v-pills-cart tbody tr").forEach(row => {
        const bookId = row.querySelector("input").getAttribute("onchange").match(/\d+/)[0];
        const quantity = parseInt(row.querySelector("input").value);
        const price = parseInt(row.querySelector("td:nth-child(3)").innerText.replace(/[^0-9]/g, ""));
        items.push({ bookId, quantity, price });
    });

    fetch('/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            userId,
            totalPrice,
            paymentMethod: 'CARD',
            address: '서울시 강남구 역삼동',
            items
        })
    })
        .then(res => res.json())
        .then(order => {
            console.log("주문 완료:", order);
            // 주문 내역 탭으로 이동
            const ordersTab = document.querySelector('#v-pills-orders-tab');
            const tab = new bootstrap.Tab(ordersTab);
            tab.show();
            refreshOrders();
        })
        .catch(err => console.error("주문 실패:", err));
}





