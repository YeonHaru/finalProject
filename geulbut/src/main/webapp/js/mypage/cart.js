/// 📌 장바구니 탭 리렌더링 (SPA 방식)
function refreshCart() {
    const cartContainer = document.querySelector('#v-pills-cart');

    fetch('/cart', {
        method: 'GET',
        headers: {'X-CSRF-TOKEN': window.csrfToken}
    })
        .then(res => res.json())
        .then(data => {
            console.log("📌 [DEBUG] 장바구니 데이터:", data);

            if (data.status !== "success" || !data.items || data.items.length === 0) {
                cartContainer.innerHTML =
                    '<div class="alert alert-info">장바구니가 비어 있습니다.</div>';
                return;
            }

            // 카드형 JSP와 동일하게 만듬
            let html = `
                <h2 class="mb-3 pb-2 border-bottom">장바구니</h2>
                <div class="list-group">
            `;

            data.items.forEach(item => {
                html += `
                    <div class="list-group-item d-flex">
                        <div class="me-3">
                            <img src="${item.imgUrl}" alt="${item.title}"
                                 style="width:70px; height:100px; object-fit:cover;">
                        </div>
                        <div class="flex-grow-1">
                            <h6 class="mb-1">${item.title}</h6>
                            <p class="mb-1 text-muted small">
                                수량:
                                <input type="number" min="1" value="${item.quantity}"
                                    class="form-control form-control-sm d-inline-block"
                                    style="width:70px;"
                                    onchange="updateCart(${item.bookId}, this.value)">
                            </p>
                              <p class="mb-1">
                                ${item.discountedPrice
                    ? `<span class="text-muted"><del>${item.price.toLocaleString()} 원</del></span>
                                       → <span class="fw-bold text-danger">${item.discountedPrice.toLocaleString()} 원</span>`
                    : `${item.price.toLocaleString()} 원`}
                            </p>
                            
                             <p class="fw-bold text-accent-dark">
                                가격: ${item.totalPrice.toLocaleString()} 원
                            </p>
                            
                            <button type="button"
                                    class="btn btn-sm btn-outline-danger"
                                    onclick="removeCart(${item.bookId}, this)">
                                삭제
                            </button>
                        </div>
                    </div>
                `;
            });
            html += `</div>`;
            html += `
                <div class="mt-3 text-end">
                    <h5>총합: ${data.cartTotal.toLocaleString()} 원</h5>
                    <button class="btn btn-primary" onclick="checkout()">💳 결제하기</button>
                </div>
            `;

            // 📌 DOM 교체
            cartContainer.innerHTML = html;
        })
        .catch(err => console.error("❌ 장바구니 갱신 실패", err));
}

// 📌 장바구니 수량 업데이트
function updateCart(bookId, quantity) {
    fetch(`/cart/${bookId}?quantity=${quantity}`, {
        method: 'PUT',
        headers: {
            'X-CSRF-TOKEN': window.csrfToken
        },
    })
        .then(res => res.json())
        .then(data => {
            console.log("🛒 장바구니 수량 업데이트 성공:", data);

            // ✅ 개별 상품 가격 즉시 반영
            const itemRow = document.querySelector(
                `#v-pills-cart input[onchange*="${bookId}"]`
            ).closest(".list-group-item");

            if (itemRow && data.itemTotal) {
                itemRow.querySelector(".fw-bold.text-accent-dark").innerText =
                    `가격: ${data.itemTotal.toLocaleString()} 원`;
            }

            // ✅ 장바구니 총합 반영
            if (data.cartTotal !== undefined) {
                document.querySelector("#v-pills-cart h5").innerText =
                    `총합: ${data.cartTotal.toLocaleString()} 원`;
            }
        })
        .catch(err => console.error("❌ 장바구니 수량 업데이트 실패:", err));
}

// 장바구니 결제하기
function checkout() {
    // 총합 가져오기
    const totalPrice = parseInt(
        document.querySelector("#v-pills-cart h5").innerText.replace(/[^0-9]/g, "")
    );

    const items = [];
    document.querySelectorAll("#v-pills-cart .list-group-item").forEach(card => {
        const bookId = card.querySelector("input").getAttribute("onchange").match(/\d+/)[0];
        const quantity = parseInt(card.querySelector("input").value);

        const price = parseInt(card.querySelector(".fw-bold.text-accent-dark")
            .innerText.replace(/[^0-9]/g, ""));

        items.push({bookId: parseInt(bookId), quantity, price});
    });

    fetch('/orders', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            userId: window.currentUserId,
            totalPrice,
            paymentMethod: 'CARD',
            address: '서울시 강남구 역삼동',
            items
        })
    })
        .then(res => res.json())
        .then(order => {
            console.log("✅ 주문 완료:", order);
            const ordersTab = document.querySelector('#v-pills-orders-tab');
            const tab = new bootstrap.Tab(ordersTab);
            tab.show();
            refreshOrders();
        })
        .catch(err => console.error("❌ 주문 실패:", err));
}

// 장바구니 삭제
function removeCart(bookId, el) {
    fetch(`/cart/${bookId}`, {
        method: 'DELETE',
        headers: {'X-CSRF-TOKEN': window.csrfToken}
    })
        .then(res => {
            if (res.ok) {
                console.log(`🗑️ 장바구니 삭제 성공: ${bookId}`);
                refreshCart(); // 장바구니 다시 불러오기
            } else {
                return res.json().then(err => {
                    throw new Error(err.message || "삭제 실패");
                });
            }
        })
        .catch(err => console.error("❌ 장바구니 삭제 실패:", err));
}
// 위시리스트에서 사용
window.refreshCart = refreshCart;