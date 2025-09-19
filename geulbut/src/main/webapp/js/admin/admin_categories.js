$(function() {
    const $modal = $('#categoryModal');
    const $modalTitle = $('#modalTitle');

    function showMessage(msg) { alert(msg); }

    // 모달 열기 (등록)
    $('#btnAddCategory').click(function() {
        $modal.show();
        $modalTitle.text('카테고리 등록');
        $('#modalCategoryId').val('');
        $('#modalCategoryName').val('');
    });

    // 모달 닫기
    $('#modalCloseBtn').click(function() { $modal.hide(); });

    // 저장 버튼
    $('#modalSaveBtn').click(function() {
        const id = $('#modalCategoryId').val();
        const data = { name: $('#modalCategoryName').val() };

        if (!data.name) { showMessage('카테고리 이름을 입력하세요.'); return; }

        if (id) { // 수정
            $.ajax({
                url: `/admin/categories/${id}`,
                method: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function() { showMessage('수정 완료'); location.reload(); },
                error: function() { showMessage('수정 실패'); }
            });
        } else { // 등록
            $.ajax({
                url: `/admin/categories`,
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function() { showMessage('등록 완료'); location.reload(); },
                error: function() { showMessage('등록 실패'); }
            });
        }
    });

    // 수정 버튼
    $('.btn-edit').click(function() {
        const $row = $(this).closest('tr');
        const id = $row.data('id');
        const name = $row.find('.category-name').text();

        $('#modalCategoryId').val(id);
        $('#modalCategoryName').val(name);
        $modalTitle.text('카테고리 수정');
        $modal.show();
    });

    // 삭제 버튼
    $('.btn-delete').click(function() {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        const id = $(this).closest('tr').data('id');

        $.ajax({
            url: `/admin/categories/${id}`,
            method: 'DELETE',
            success: function() { showMessage('삭제 완료'); location.reload(); },
            error: function() { showMessage('삭제 실패'); }
        });
    });

    // 검색
    $('#btnSearch').click(function() {
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/categories?keyword=${encodeURIComponent(keyword)}`;
    });

    // 페이징
    $('.page-btn').click(function() {
        const page = $(this).data('page');
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/categories?page=${page}&keyword=${encodeURIComponent(keyword)}`;
    });
});
