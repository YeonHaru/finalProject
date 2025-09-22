// /js/admin/admin_categories.js
$(function() {
    const $modal = $('#categoryModal');
    const $modalTitle = $('#modalTitle');
    const $tbody = $('#categoriesTableBody');

    const showMessage = (msg) => alert(msg);

    // 모달 열기(등록)
    $('#btnAddCategory').on('click', function() {
        $modal.show();
        $modalTitle.text('카테고리 등록');
        $('#modalCategoryId').val('');
        $('#modalCategoryName').val('');
        $('#modalCategoryName').focus();
    });

    // 모달 닫기
    $('#modalCloseBtn').on('click', function() { $modal.hide(); });

    // 저장
    $('#modalSaveBtn').on('click', function() {
        const id = $('#modalCategoryId').val();
        const data = { name: $('#modalCategoryName').val().trim() };

        if (!data.name) { showMessage('카테고리 이름을 입력하세요.'); return; }

        const ajaxOpt = {
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: () => { showMessage(id ? '수정 완료' : '등록 완료'); location.reload(); },
            error: () => { showMessage(id ? '수정 실패' : '등록 실패'); }
        };

        if (id) {
            $.ajax({ url: `/admin/categories/${id}`, method: 'PUT',  ...ajaxOpt });
        } else {
            $.ajax({ url: '/admin/categories',        method: 'POST', ...ajaxOpt });
        }
    });

    // 수정(위임) — 동적 행 대응
    $tbody.on('click', '.btn-edit', function() {
        const $row = $(this).closest('tr');
        const id   = $row.data('id');
        const name = $row.find('.category-name').text();

        $('#modalCategoryId').val(id);
        $('#modalCategoryName').val(name);
        $modalTitle.text('카테고리 수정');
        $modal.show();
    });

    // 삭제(위임)
    $tbody.on('click', '.btn-delete', function() {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        const id = $(this).closest('tr').data('id');

        $.ajax({
            url: `/admin/categories/${id}`,
            method: 'DELETE',
            success: () => { showMessage('삭제 완료'); location.reload(); },
            error:   () => { showMessage('삭제 실패'); }
        });
    });

    // 검색
    $('#btnSearch').on('click', function() {
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/categories?keyword=${encodeURIComponent(keyword)}`;
    });

    // 페이징(기존 유지)
    $('#pagination').on('click', '.page-btn', function() {
        const page = $(this).data('page');
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/categories?page=${page}&keyword=${encodeURIComponent(keyword)}`;
    });

    // 모달 접근성(배경 클릭/ESC 닫기)
    $modal.on('click', function(e){ if (e.target.id === 'categoryModal') $modal.hide(); });
    $(document).on('keydown', function(e){ if (e.key === 'Escape') $modal.hide(); });
});
