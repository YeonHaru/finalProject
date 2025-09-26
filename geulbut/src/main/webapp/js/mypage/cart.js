/// 📌 장바구니 탭 리렌더링 (SPA 방식)
function refreshCart() {
    const cartContainer = document.querySelector('#v-pills-cart');

    cartContainer.innerHTML = '<div class="text-muted small">불러오는 중...</div>';

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

            let html = `
        <h2 class="mb-3 pb-2 border-bottom">장바구니</h2>
        <div class="list-group" id="cart-list">
      `;

            data.items.forEach(item => {
                const title = escapeHtml(item.title);
                const imgUrl = escapeHtml(item.imgUrl || '');
                const price = Number(item.price ?? 0);
                const discounted = item.discountedPrice != null ? Number(item.discountedPrice) : null;
                const totalPrice = Number(item.totalPrice ?? (discounted ?? price) * Number(item.quantity ?? 1));
                const bookId = Number(item.bookId);

                html += `
          <div class="list-group-item d-flex" data-book-id="${bookId}">
            <div class="me-3">
              <img src="${imgUrl}" alt="${title}"
                   style="width:70px; height:100px; object-fit:cover; border-radius:4px;">
            </div>
            <div class="flex-grow-1">
              <h6 class="mb-1">${title}</h6>
              <p class="mb-1 text-muted small">
                수량:
                <input type="number" min="1" value="${Number(item.quantity ?? 1)}"
                       class="form-control form-control-sm d-inline-block cart-qty"
                       style="width:70px;">
              </p>
              <p class="mb-1">
                ${
                    discounted !== null
                        ? `<span class="text-muted"><del>${fmtKR(price)} 원</del></span>
                       → <span class="fw-bold text-danger">${fmtKR(discounted)} 원</span>`
                        : `${fmtKR(price)} 원`
                }
              </p>
              <p class="fw-bold text-accent-dark cart-item-total">
                가격: ${fmtKR(totalPrice)} 원
              </p>

              <button type="button"
                      class="btn btn-sm btn-outline-danger cart-remove">
                삭제
              </button>
            </div>
          </div>
        `;
            });

            html += `</div>`;
            html += `
        <div class="mt-3 text-end">
          <h5>총합: <span id="cart-total">${fmtKR(data.cartTotal)}</span> 원</h5>
         
          <button class="btn btn-primary"
           onclick="openOrderInfoModal(${Number(data.cartTotal || 0)})">💳 결제하기</button>
        </div>
      `;

            cartContainer.innerHTML = html;
        })
        .catch(err => {
            console.error("❌ 장바구니 갱신 실패", err);
            cartContainer.innerHTML =
                '<div class="alert alert-danger">장바구니를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.</div>';
        });
}

// 📌 이벤트 위임: 수량 변경 / 삭제 버튼 (재렌더에도 자동 적용)
document.addEventListener('input', (e) => {
    if (!e.target.classList.contains('cart-qty')) return;
    const row = e.target.closest('[data-book-id]');
    const bookId = row && Number(row.dataset.bookId);
    const qty = Number(e.target.value || 1);
    if (!bookId || qty <= 0) return;
    updateCart(bookId, qty);
});

document.addEventListener('click', (e) => {
    if (!e.target.classList.contains('cart-remove')) return;
    const row = e.target.closest('[data-book-id]');
    const bookId = row && Number(row.dataset.bookId);
    if (!bookId) return;
    removeCart(bookId);
});

// 📌 장바구니 수량 업데이트
function updateCart(bookId, quantity) {
    fetch(`/cart/${encodeURIComponent(bookId)}?quantity=${encodeURIComponent(quantity)}`, {
        method: 'PUT',
        headers: { 'X-CSRF-TOKEN': window.csrfToken },
    })
        .then(res => res.json())
        .then(data => {
            console.log("🛒 장바구니 수량 업데이트 성공:", data);

            // 개별 상품 합계 즉시 반영
            const itemRow = document
                .querySelector(`#v-pills-cart [data-book-id="${bookId}"]`);

            if (itemRow && data.itemTotal !== undefined) {
                const itemTotalEl = itemRow.querySelector(".cart-item-total");
                if (itemTotalEl) itemTotalEl.textContent = `가격: ${fmtKR(data.itemTotal)} 원`;
            }

            // 장바구니 총합 반영
            if (data.cartTotal !== undefined) {
                const totalEl = document.querySelector("#cart-total");
                if (totalEl) totalEl.textContent = fmtKR(data.cartTotal);
            }
        })
        .catch(err => console.error("❌ 장바구니 수량 업데이트 실패:", err));
}

// 장바구니 삭제
function removeCart(bookId) {
    fetch(`/cart/${encodeURIComponent(bookId)}`, {
        method: 'DELETE',
        headers: {'X-CSRF-TOKEN': window.csrfToken}
    })
        .then(res => {
            if (!res.ok) return res.json().then(err => { throw new Error(err.message || "삭제 실패"); });
            console.log(`🗑️ 장바구니 삭제 성공: ${bookId}`);
            refreshCart();
        })
        .catch(err => console.error("❌ 장바구니 삭제 실패:", err));
}

// 📌 결제 모달 열기
function openOrderInfoModal(amount) {
    const modalEl = document.getElementById("orderInfoModal");
    if (!modalEl) {
        alert("❌ 주문 정보 모달을 찾을 수 없습니다.");
        return;
    }

    // 총액 표시
    const totalEl = modalEl.querySelector("#oiTotal");
    if (totalEl) {
        totalEl.textContent = fmtKR(amount);
    }

    // Bootstrap Modal 열기
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
}

// 📌 결제 진행 버튼 이벤트
document.addEventListener("click", async (e) => {
    if (e.target.id !== "oi-confirm") return;

    const form = document.getElementById("orderForm");
    if (!form) return;

    // form 데이터 수집
    const formData = new FormData(form);
    const payload = {};
    formData.forEach((v, k) => payload[k] = v);

    try {
        const res = await fetch("/payments/verify", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": window.csrfToken
            },
            body: JSON.stringify(payload)
        });

        if (!res.ok) throw new Error("결제 요청 실패");
        const data = await res.json();

        if (data.status === "ok") {
            alert("✅ 결제가 완료되었습니다.");
            bootstrap.Modal.getInstance(document.getElementById("orderInfoModal")).hide();

            // 장바구니 비우고, 주문내역 새로고침
            refreshCart();
            if (window.Orders && Orders.refreshOrders) {
                Orders.refreshOrders();
            }
        } else {
            alert("❌ 결제 실패: " + (data.message || "알 수 없는 오류"));
        }
    } catch (err) {
        console.error("❌ 결제 오류:", err);
        alert("결제 중 문제가 발생했습니다.");
    }
});

// 전역 노출
window.refreshCart = refreshCart;
window.openOrderInfoModal = openOrderInfoModal;