$(document).ready(function () {

    // --- 날짜 포맷 함수 (한국식, AM/PM) ---
    function formatDate(dateStr) {
        if (!dateStr) return '-';
        try {
            const isoStr = typeof dateStr === 'string' ? dateStr.replace(' ', 'T') : dateStr;
            const d = new Date(isoStr);
            if (isNaN(d.getTime())) return '-';
            return d.toLocaleString('ko-KR', {
                year: 'numeric', month: 'numeric', day: 'numeric',
                hour: 'numeric', minute: 'numeric', second: 'numeric',
                hour12: true
            });
        } catch (e) {
            return '-';
        }
    }

    // --- 테이블 날짜 적용 ---
    $('td[data-date], td.deliveredAt').each(function () {
        const $td = $(this);
        const status = $td.data('status');
        const created = $td.data('created');
        let date = $td.data('date');

        // 배송완료일 계산
        if ($td.hasClass('deliveredAt')) {
            if (status === "DELIVERED") {
                if (!date && created) {
                    try {
                        let d = new Date(created.replace(' ', 'T'));
                        d.setDate(d.getDate() + 3); // 주문일 +3
                        date = d;
                    } catch (e) {
                        date = null;
                    }
                }
            } else {
                date = null;
            }
        }
        $td.text(formatDate(date));
    });

    // --- 상세보기 ---
    $(document).on('click', '.btn-detail', function () {
        const orderId = $(this).data('id');

        $.get(`${ctx}/admin/orders/${orderId}`, function (data) {
            let deliveredAt = "-";

            if (data.status === "DELIVERED") {
                if (data.deliveredAt) {
                    deliveredAt = formatDate(data.deliveredAt); // DB값
                } else if (data.createdAt) {
                    const base = new Date(data.createdAt.replace(' ', 'T'));
                    base.setDate(base.getDate() + 3); // 주문일 +3
                    deliveredAt = formatDate(base);
                }
            }

            let html = `<p>주문ID: ${data.orderId}</p>
                        <p>사용자ID: ${data.userId}</p>
                        <p>사용자 이름: ${data.userName || '-'}</p>
                        <p>총액: ${data.totalPrice || '-'}</p>
                        <p>상태: ${data.status}</p>
                        <p>결제수단: ${data.paymentMethod || '-'}</p>
                        <p>주문번호: ${data.merchantUid || '-'}</p>
                        <p>수령인: ${data.recipient || '-'}</p>
                        <p>전화번호: ${data.phone || '-'}</p>
                        <p>메모: ${data.memo || '-'}</p>
                        <p>주소: ${data.address || '-'}</p>
                        <p>주문일: ${formatDate(data.createdAt)}</p>
                        <p>결제일시: ${formatDate(data.paidAt)}</p>
                        <p>배송일시: ${deliveredAt}</p>
                        <h4>주문 아이템</h4>
                        <ul>`;

            if (data.items && data.items.length > 0) {
                data.items.forEach(item => {
                    html += `<li>${item.title} - 수량: ${item.quantity} - 가격: ${item.price}</li>`;
                });
            } else {
                html += `<li>주문 아이템 없음</li>`;
            }
            html += '</ul>';

            $('#orderDetailContent').html(html);
            $('#orderDetailModal').fadeIn();
        }).fail(function () {
            alert('주문 상세 조회 중 오류가 발생했습니다.');
        });
    });

    // --- 모달 닫기 ---
    $('#closeModal').click(function () {
        $('#orderDetailContent').empty();
        $('#orderDetailModal').fadeOut();
    });

    // --- 상태 변경 ---
    $(document).on('change', '.status-select', function () {
        const $select = $(this);
        const orderId = $select.data('id');
        const newStatus = $select.val();
        const currentStatus = $select.data('current-status');

        if (!confirm(`주문 ${orderId} 상태를 '${newStatus}'로 변경하시겠습니까?`)) {
            $select.val(currentStatus);
            return;
        }

        $.ajax({
            url: `${ctx}/admin/orders/${orderId}/status`,
            type: 'POST',
            data: { status: newStatus },
            success: function (data) {
                alert('주문 상태가 변경되었습니다: ' + data.status);
                $select.data('current-status', data.status);

                if (data.status === "DELIVERED") {
                    const $row = $select.closest('tr');
                    let deliveredAt = data.deliveredAt;
                    if (!deliveredAt && data.createdAt) {
                        const base = new Date(data.createdAt.replace(' ', 'T'));
                        base.setDate(base.getDate() + 3);
                        deliveredAt = base;
                    }
                    $row.find('td.deliveredAt').text(formatDate(deliveredAt));
                } else {
                    $select.closest('tr').find('td.deliveredAt').text('-');
                }
            },
            error: function () {
                alert('주문 상태 변경 중 오류가 발생했습니다.');
                $select.val(currentStatus);
            }
        });
    });

});
