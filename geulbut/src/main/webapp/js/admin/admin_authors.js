$(function() {
    const $modal = $('#authorModal');
    const $modalTitle = $('#modalTitle');
    const $modalAuthorId = $('#modalAuthorId');
    const $modalAuthorName = $('#modalAuthorName');

    // =============================
    // 🔹 모달 열기 (등록)
    // =============================
    $('#btnAdd').click(function() {
        $modalTitle.text('작가 등록');
        $modalAuthorId.val('');
        $modalAuthorName.val('');
        $modal.show();
    });

    // =============================
    // 🔹 모달 닫기
    // =============================
    $('#modalCloseBtn').click(function() {
        $modal.hide();
    });

    // =============================
    // 🔹 저장 버튼 (등록/수정)
    // =============================
    $('#modalSaveBtn').click(function() {
        const authorId = $modalAuthorId.val();
        const name = $modalAuthorName.val().trim();

        if (!name) {
            alert('작가명을 입력해주세요.');
            return;
        }

        // ✅ Controller URL과 method에 맞게 수정
        const url = authorId ? `/admin/authors/${authorId}` : `/admin/authors`;
        const method = authorId ? 'PUT' : 'POST';
        const data = { name };

        $.ajax({
            url: url,
            method: method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(res) {
                alert('저장 성공!');
                location.reload(); // 간단하게 새로고침
            },
            error: function(err) {
                console.error(err);
                alert('저장 실패');
            }
        });
    });

    // =============================
    // 🔹 수정 버튼
    // =============================
    $(document).on('click', '.btn-edit', function() {
        const $tr = $(this).closest('tr');
        const authorId = $tr.data('id');
        const name = $tr.find('.author-name').text();

        $modalTitle.text('작가 수정');
        $modalAuthorId.val(authorId);
        $modalAuthorName.val(name);
        $modal.show();
    });

    // =============================
    // 🔹 삭제 버튼
    // =============================
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

    // =============================
    // 🔹 검색 버튼
    // =============================
    $('#btnSearch').click(function() {
        const keyword = $('#searchKeyword').val().trim();
        const url = `/admin/authors/search?keyword=${encodeURIComponent(keyword)}`;
        location.href = url; // 페이지 이동으로 검색 처리
    });
});
