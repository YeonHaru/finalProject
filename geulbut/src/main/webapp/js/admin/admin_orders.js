$(document).ready(function() {

    // 상세보기 버튼 클릭
    $('.btn-detail').click(function() {
        const orderId = $(this).data('id');
        $.get('/admin/orders/' + orderId, function(data) {
            let html = `<p>주문ID: ${data.orderId}</p>
                        <p>사용자ID: ${data.userId}</p>
                        <p>총액: ${data.totalPrice}</p>
                        <p>상태: ${data.status}</p>
                        <p>결제수단: ${data.paymentMethod}</p>
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
        });
    });

    // 모달 닫기
    $('#closeModal').click(function() {
        $('#orderDetailModal').hide();
    });

    // 상태 변경 시 Ajax 호출
    $('.status-select').change(function() {
        const orderId = $(this).data('id');
        const newStatus = $(this).val();
        $.ajax({
            url: '/admin/orders/' + orderId + '/status',
            type: 'POST',
            data: {status: newStatus},
            success: function(data) {
                alert('주문 상태가 변경되었습니다: ' + data.status);
            },
            error: function() {
                alert('주문 상태 변경 중 오류가 발생했습니다.');
            }
        });
    });

});
