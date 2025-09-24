$(document).ready(function () {

    // 상세보기 버튼 클릭
    $('.btn-detail').click(function () {
        const orderId = $(this).data('id');  // 버튼에서 orderId 가져오기
        $.get('/admin/orders/' + orderId, function (data) {
            let html = `<p>주문ID: ${data.orderId}</p>
                        <p>사용자ID: ${data.userId}</p>
                        <p>사용자 이름: ${data.userName}</p>
                        <p>총액: ${data.totalPrice}</p>
                        <p>상태: ${data.status}</p>
                        <p>결제수단: ${data.paymentMethod}</p>
                        <p>주문번호: ${data.merchantUid}</p>
                        <p>수령인: ${data.recipient}</p>
                        <p>전화번호: ${data.phone}</p>
                        <p>메모: ${data.memo}</p>
                        <p>주소: ${data.address}</p>
                        <h4>주문 아이템</h4>
                        <ul>`;
            data.items.forEach(item => {
                html += `<li>${item.title} - 수량: ${item.quantity} - 가격: ${item.price}</li>`;
            });
            html += '</ul>';
            $('#orderDetailContent').html(html);
            $('#orderDetailModal').show();
        }).fail(function () {
            alert('주문 상세 조회 중 오류가 발생했습니다.');
        });
    });

    // 모달 닫기
    $('#closeModal').click(function () {
        $('#orderDetailContent').empty();
        $('#orderDetailModal').hide();
    });

    // 상태 변경 시 confirm + rollback 처리
    $('.status-select').change(function () {
        const $select = $(this);
        const orderId = $select.data('id');
        const newStatus = $select.val();
        const currentStatus = $select.data('current-status');

        if (!confirm(`주문 ${orderId} 상태를 '${newStatus}'로 변경하시겠습니까?`)) {
            $select.val(currentStatus); // 취소 시 원래 상태로
            return;
        }

        $.post('/admin/orders/' + orderId + '/status', {status: newStatus})
            .done(function (data) {
                alert('주문 상태가 변경되었습니다: ' + data.status);
                $select.data('current-status', data.status); // 현재 상태 갱신
            })
            .fail(function () {
                alert('주문 상태 변경 중 오류가 발생했습니다.');
                $select.val(currentStatus); // 실패 시 롤백
            });
    });

});
