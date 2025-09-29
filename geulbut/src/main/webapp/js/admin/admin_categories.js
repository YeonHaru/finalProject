// /js/admin/admin_categories.js
$(function () {
    const ctx = (typeof window.ctx !== 'undefined' && window.ctx) ? window.ctx : '';

    const $modal = $('#categoryModal');
    const $modalTitle = $('#modalTitle');
    const $tbody = $('#categoriesTableBody');

    const $booksModal = $('#booksModal');
    const $booksTbody = $('#booksTable tbody');
    const $booksModalTitle = $('#booksModalTitle');

    const showMessage = (msg) => alert(msg);

    // ---------- 공통 모달 open/close ----------
    const openModal = ($targetModal) => {
        $targetModal.css('display', 'flex').attr('aria-hidden', 'false');
        $targetModal.find('.modal-content').scrollTop(0);
    };
    const closeModal = ($targetModal) => {$targetModal.hide().attr('aria-hidden', 'true');};

    // 버튼/배경 클릭 닫기
    $modal.off('click.cat').on('click.cat', e => { if (e.target.id === 'categoryModal') closeModal($modal); });

    $('#modalCloseBtn, #modalCancelBtn').off('click.cat').on('click.cat', () => closeModal($modal));
    $booksModal.off('click.cat').on('click.cat', e => { if (e.target.id === 'booksModal') closeModal($booksModal); });

    // ESC로 두 모달 모두 닫기
    $(document).off('keydown.catmod').on('keydown.catmod', e => {
        if (e.key === 'Escape') {
            if ($modal.is(':visible')) closeModal($modal);
            if ($booksModal.is(':visible')) closeModal($booksModal);
        }
    });
    // 등록 버튼
    $('#btnAddCategory').on('click', function () {
        openModal($modal);
        $modalTitle.text('카테고리 등록');
        $('#modalCategoryId').val('');
        $('#modalCategoryName').val('').focus();
    });

    // ---------- 저장 ----------
    $('#categoryForm').off('submit.cat').on('submit.cat', function(e) {
        e.preventDefault();
        const $btn = $('#modalSaveBtn');
        if ($btn.prop('disabled')) return;

        const id = $('#modalCategoryId').val();
        const data = { name: $('#modalCategoryName').val().trim() };
        if (!data.name) { alert('카테고리 이름을 입력하세요.'); return; }

        $btn.prop('disabled', true);

        const ajaxOpt = {
            contentType: 'application/json',
            data: JSON.stringify(data),
            complete: () => $btn.prop('disabled', false),
            success: () => { alert(id ? '수정 완료' : '등록 완료'); location.reload(); },
            error: () => { alert(id ? '수정 실패' : '등록 실패'); }
        };

        if (id) $.ajax({ url: `${ctx}/admin/categories/${id}`, method: 'PUT', ...ajaxOpt });
        else $.ajax({ url: `${ctx}/admin/categories`, method: 'POST', ...ajaxOpt });
    });

    // ---------- 수정/삭제 ----------
    $tbody.on('click', '.btn-edit, .btnEdit', function (){
        const $row = $(this).closest('tr');
        const id = $row.data('id');
        const name = $row.find('.category-name').text();
        $('#modalCategoryId').val(id);
        $('#modalCategoryName').val(name);
        $modalTitle.text('카테고리 수정');
        openModal($modal);
    });

    $tbody.on('click', '.btn-delete, .btnDelete', function (){
        if (!confirm('정말 삭제하시겠습니까?')) return;
        const id = $(this).closest('tr').data('id');
        $.ajax({
            url: `${ctx}/admin/categories/${id}`,
            method: 'DELETE',
            success: () => { showMessage('삭제 완료'); location.reload(); },
            error: () => { showMessage('삭제 실패'); }
        });
    });

    // ---------- 검색 ----------
    $('#searchForm').on('submit', function (e) {
        // GET 그대로 전송 (action/form 으로 처리)
        // e.preventDefault();
    });

    // ---------- 카테고리 ID/이름 클릭 → 속한 책 조회 ----------
    $tbody.on('click', 'td.category-id, td.category-name', function () {
        const categoryId = $(this).closest('tr').data('id');
        $.ajax({
            url: `${ctx}/admin/categories/${categoryId}/books`,
            method: 'GET',
            success: function (books) {
                $booksTbody.empty();
                if (!books || books.length === 0) {
                    $booksTbody.append('<tr><td colspan="5" class="t-center">등록된 책이 없습니다.</td></tr>');
                } else {
                    books.forEach(b => {
                        // DTO 기준으로 authorName/publisherName 가져오기
                        const authorName = b.authorName || '-';
                        const publisherName = b.publisherName || '-';
                        $booksTbody.append(`
<tr>
  <td>${b.bookId}</td>
  <td>${b.title}</td>
  <td>${authorName}</td>
  <td>${publisherName}</td>
  <td>${b.price}</td>
</tr>`);
                    });
                }
                $booksModalTitle.text(`카테고리 ${categoryId} 속 책 목록`);
                openModal($booksModal);
            },
            error: function () { showMessage('책 정보를 불러오는데 실패했습니다.'); }
        });
    });
});
