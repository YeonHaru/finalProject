// 탭 유지 (쿼리 파라미터 & 해시 기반)
document.addEventListener("DOMContentLoaded", function () {
    const tabMap = {
        wishlist: "#v-pills-wishlist",
        cart: "#v-pills-cart",
        orders: "#v-pills-orders",
        info: "#v-pills-info"
    };

    const params = new URLSearchParams(window.location.search);
    let targetId = null;

    if (params.has("tab") && tabMap[params.get("tab")]) {
        targetId = tabMap[params.get("tab")];
    }

    if (!targetId && window.location.hash) {
        targetId = window.location.hash;
    }

    if (targetId) {
        const triggerEl = document.querySelector(`button[data-bs-target="${targetId}"]`);
        if (triggerEl) {
            new bootstrap.Tab(triggerEl).show();
        }
    }
});

// ✅ 위시리스트 → 장바구니 담기 (POST /cart)
function addToCart(bookId, btn) {
    fetch('/cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': window.csrfToken // JSP에서 주입 필요
        },
        body: 'bookId=' + bookId + '&quantity=1'
    })
        .then(res => res.text())
        .then(data => {
            if (data === 'OK') {
                alert('장바구니에 담겼습니다 ✅');
            } else {
                alert('이미 장바구니에 있습니다 ❌');
            }
        })
        .catch(err => console.error(err));
}

// ✅ 위시리스트 삭제 (아직 RESTful 변환 전 → 그대로 POST)
function removeWishlist(bookId, btn) {
    if (!confirm("정말 삭제하시겠습니까?")) {
        return;
    }

    fetch('/wishlist/remove-ajax', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': window.csrfToken
        },
        body: 'bookId=' + bookId
    })
        .then(res => res.text())
        .then(data => {
            if (data === 'OK') {
                btn.closest('li').remove();
                if (document.querySelectorAll('#v-pills-wishlist li').length === 0) {
                    document.querySelector('#v-pills-wishlist').innerHTML =
                        '<div class="alert alert-info">위시리스트에 담긴 책이 없습니다.</div>';
                }
            } else {
                alert('삭제 실패 ❌');
            }
        })
        .catch(err => console.error(err));
}

// ✅ 장바구니 수량 변경 (PUT /cart/{bookId})
function updateCart(bookId, quantity) {
    fetch(`/cart/${bookId}?quantity=${quantity}`, {
        method: 'PUT',
        headers: {
            'X-CSRF-TOKEN': window.csrfToken
        }
    })
        .then(res => res.text())
        .then(data => {
            if (data === 'OK') {
                location.reload(); // 새로고침으로 합계 갱신
            } else {
                alert('수량 변경 실패 ❌');
            }
        })
        .catch(err => console.error(err));
}

// ✅ 장바구니 삭제 (DELETE /cart/{bookId})
function removeCart(bookId, btn) {
    if (!confirm('정말 삭제하시겠습니까?')) return;

    fetch(`/cart/${bookId}`, {
        method: 'DELETE',
        headers: {
            'X-CSRF-TOKEN': window.csrfToken
        }
    })
        .then(res => res.text())
        .then(data => {
            if (data === 'OK') {
                btn.closest('tr').remove();
                if (document.querySelectorAll('#v-pills-cart tbody tr').length === 0) {
                    document.querySelector('#v-pills-cart').innerHTML =
                        '<div class="alert alert-info">장바구니가 비어 있습니다.</div>';
                }
            } else {
                alert('삭제 실패 ❌');
            }
        })
        .catch(err => console.error(err));
}
