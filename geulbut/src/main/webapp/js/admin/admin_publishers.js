$(function() {
    const $modal = $('#publisherModal');
    const $modalTitle = $('#modalTitle');

    // 공통 알림 함수
    function showMessage(msg) {
        alert(msg);
    }

    // 모달 열기
    $('#btnAddPublisher').click(function() {
        $modal.show();
        $modalTitle.text('출판사 등록');
        $('#modalPublisherId').val('');
        $('#modalPublisherName').val('');
        $('#modalPublisherDescription').val(''); // 추가
    });

    // 모달 닫기
    $('#modalCloseBtn').click(function() {
        $modal.hide();
    });

    // 저장 버튼 클릭
    $('#modalSaveBtn').click(function() {
        const id = $('#modalPublisherId').val();
        const data = {
            name: $('#modalPublisherName').val(),
            description: $('#modalPublisherDescription').val()  // 추가
        };

        if (!data.name) {
            showMessage('출판사 이름을 입력하세요.');
            return;
        }

        if (id) {
            // 수정
            $.ajax({
                url: `/admin/publishers/${id}`,
                method: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function() { showMessage('수정 완료'); location.reload(); },
                error: function() { showMessage('수정 실패'); }
            });
        } else {
            // 등록
            $.ajax({
                url: `/admin/publishers`,
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function() { showMessage('등록 완료'); location.reload(); },
                error: function() { showMessage('등록 실패'); }
            });
        }
    });

    // 수정 버튼 클릭
    $('.btn-edit').click(function() {
        const $row = $(this).closest('tr');
        const id = $row.data('id');
        const name = $row.find('.publisher-name').text();
        const description = $row.find('.publisher-description').text(); // 추가

        $('#modalPublisherId').val(id);
        $('#modalPublisherName').val(name);
        $('#modalPublisherDescription').val(description); // 추가
        $modalTitle.text('출판사 수정');
        $modal.show();
    });

    // 삭제 버튼 클릭
    $('.btn-delete').click(function() {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        const id = $(this).closest('tr').data('id');

        $.ajax({
            url: `/admin/publishers/${id}`,
            method: 'DELETE',
            success: function() { showMessage('삭제 완료'); location.reload(); },
            error: function() { showMessage('삭제 실패'); }
        });
    });

    // 검색 버튼
    $('#btnSearch').click(function() {
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/publishers?keyword=${encodeURIComponent(keyword)}`;
    });

    // 페이지 버튼
    $('.page-btn').click(function() {
        const page = $(this).data('page');
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/publishers?page=${page}&keyword=${encodeURIComponent(keyword)}`;
    });
});
