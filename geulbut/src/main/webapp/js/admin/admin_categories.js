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
        $targetModal.css('display', 'flex');
        $targetModal.find('.modal-content').scrollTop(0);
    };
    const closeModal = ($targetModal) => $targetModal.hide();

    // 등록 버튼
    $('#btnAddCategory').on('click', function () {
        openModal($modal);
        $modalTitle.text('카테고리 등록');
        $('#modalCategoryId').val('');
        $('#modalCategoryName').val('').focus();
    });

    // 모달 닫기
    $('#modalCloseBtn').on('click', () => closeModal($modal));
    $modal.on('click', e => { if (e.target.id === 'categoryModal') closeModal($modal); });
    $(document).on('keydown', e => { if (e.key === 'Escape') closeModal($modal); });

    $('#booksModalCloseBtn').on('click', () => closeModal($booksModal));
    $booksModal.on('click', e => { if (e.target.id === 'booksModal') closeModal($booksModal); });

    // ---------- 저장 ----------
    $('#modalSaveBtn').on('click', function () {
        const id = $('#modalCategoryId').val();
        const data = { name: $('#modalCategoryName').val().trim() };
        if (!data.name) { showMessage('카테고리 이름을 입력하세요.'); return; }

        const ajaxOpt = {
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: () => { showMessage(id ? '수정 완료' : '등록 완료'); location.reload(); },
            error: () => { showMessage(id ? '수정 실패' : '등록 실패'); }
        };

        if (id) $.ajax({ url: `${ctx}/admin/categories/${id}`, method: 'PUT', ...ajaxOpt });
        else $.ajax({ url: `${ctx}/admin/categories`, method: 'POST', ...ajaxOpt });
    });

    // ---------- 수정/삭제 ----------
    $tbody.on('click', '.btn-edit', function () {
        const $row = $(this).closest('tr');
        const id = $row.data('id');
        const name = $row.find('.category-name').text();
        $('#modalCategoryId').val(id);
        $('#modalCategoryName').val(name);
        $modalTitle.text('카테고리 수정');
        openModal($modal);
    });

    $tbody.on('click', '.btn-delete', function () {
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
        // GET 그대로 전송 (action/form 으로 처리) — 여기선 굳이 JS 리로딩 안 함
        // 필요 시 아래처럼 막고 location.href로 넘겨도 됩니다.
        // e.preventDefault();
    });

    // ---------- 페이징 (a.page-btn) ----------
    $('#pagination').on('click', '.page-btn', function (e) {
        e.preventDefault();
        const page = $(this).data('page');
        const keyword = ($('#searchKeyword').val() || '').trim();
        let url = `${ctx}/admin/categories?page=${page}`;
        if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
        window.location.href = url;
    });

    // ---------- 카테고리 ID 클릭 → 속한 책 조회 ----------
    $tbody.on('click', 'td.category-id', function () {
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
                        const authorName = b.author ? b.author.name : '-';
                        const publisherName = b.publisher ? b.publisher.name : '-';
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
