$(function() {
    const $modal = $('#authorModal');
    const $modalTitle = $('#modalTitle');
    const $modalAuthorId = $('#modalAuthorId');
    const $modalAuthorName = $('#modalAuthorName');
    const $modalAuthorDescription = $('#modalAuthorDescription');

    // 모달 열기 (등록)
    $('#btnAdd').click(function() {
        $modalTitle.text('작가 등록');
        $modalAuthorId.val('');
        $modalAuthorName.val('');
        $modalAuthorDescription.val('');
        $modal.show();
    });

    // 모달 닫기
    $('#modalCloseBtn').click(function() {
        $modal.hide();
    });

    // 저장 버튼 (등록/수정)
    $('#modalSaveBtn').click(function() {
        const authorId = $modalAuthorId.val();
        const name = $modalAuthorName.val().trim();
        const description = $modalAuthorDescription.val().trim();

        if (!name) {
            alert('작가명을 입력해주세요.');
            return;
        }

        const url = authorId ? `/admin/authors/${authorId}` : `/admin/authors`;
        const method = authorId ? 'PUT' : 'POST';
        const data = { name, description };

        $.ajax({
            url: url,
            method: method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(res) {
                alert('저장 성공!');
                location.reload();
            },
            error: function(err) {
                console.error(err);
                alert('저장 실패');
            }
        });
    });

    // 수정 버튼
    $(document).on('click', '.btn-edit', function() {
        const $tr = $(this).closest('tr');
        const authorId = $tr.data('id');
        const name = $tr.find('.author-name').text();
        const description = $tr.find('.author-description').text();

        $modalTitle.text('작가 수정');
        $modalAuthorId.val(authorId);
        $modalAuthorName.val(name);
        $modalAuthorDescription.val(description);
        $modal.show();
    });

    // 삭제 버튼
    $(document).on('click', '.btn-delete', function() {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        const authorId = $(this).closest('tr').data('id');

        $.ajax({
            url: `/admin/authors/${authorId}`,
            method: 'DELETE',
            success: function(res) {
                alert('삭제 완료');
                location.reload();
            },
            error: function(err) {
                console.error(err);
                alert('삭제 실패');
            }
        });
    });

    // 검색 버튼
    $('#btnSearch').click(function() {
        const keyword = $('#searchKeyword').val().trim();
        location.href = `/admin/authors?page=0&keyword=${encodeURIComponent(keyword)}`;
    });

    // 페이징 버튼
    $(document).on('click', '.page-btn', function() {
        const page = $(this).data('page');
        const keyword = $('#searchKeyword').val().trim();
        location.href = `/admin/authors?page=${page}&keyword=${encodeURIComponent(keyword)}`;
    });

});
