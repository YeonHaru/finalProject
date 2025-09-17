$(function () {
    // 세부검색 토글
    $('#toggleAdvancedSearch').click(function() {
        $('#advancedSearch').slideToggle();
        let isVisible = $('#advancedSearch').is(':visible');
        $(this).text(isVisible ? '세부검색 ▲' : '세부검색 ▼');
    });

    // 행 클릭 시 상세 데이터 토글
    $('.data-row').click(function() {
        $(this).next('.detail-row').slideToggle();
    });

    // 권한 변경 저장
    $('.save-btn').click(function (e) {
        e.stopPropagation();
        let userId = $(this).data('userid');
        let newRole = $(this).closest('tr').find('.role-select').val();
        $.ajax({
            url: '/admin/api/users/' + userId + '/role?newRole=' + newRole,
            method: 'PUT',
            success: function () {
                alert('권한이 변경되었습니다.');
                location.reload();
            },
            error: function () { alert('권한 변경 실패'); }
        });
    });

    // 회원 삭제
    $('.delete-btn').click(function (e) {
        e.stopPropagation();
        if (!confirm('정말 삭제하시겠습니까?')) return;
        let userId = $(this).data('userid');
        $.ajax({
            url: '/admin/api/users/' + userId,
            method: 'DELETE',
            success: function () {
                alert('회원이 삭제되었습니다.');
                location.reload();
            },
            error: function () { alert('회원 삭제 실패'); }
        });
    });

    // 계정 상태 변경 저장
    $('.status-select').change(function (e) {
        e.stopPropagation();
        let userId = $(this).data('userid');
        let newStatus = $(this).val();
        $.ajax({
            url: '/admin/api/users/' + userId + '/status?newStatus=' + newStatus,
            method: 'PUT',
            success: function () {
                alert('계정 상태가 변경되었습니다.');
                location.reload();
            },
            error: function () { alert('계정 상태 변경 실패'); }
        });
    });

    // 통계 정보 가져오기
    $.ajax({
        url: '/admin/api/users/stats',
        method: 'GET',
        success: function(data) {
            $('#totalUsers').text(data.totalUsers);
            $('#todayNewUsers').text(data.todayNewUsers);
        },
        error: function() { console.error('통계 정보 불러오기 실패'); }
    });
});
