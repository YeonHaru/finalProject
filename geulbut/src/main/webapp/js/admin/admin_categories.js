$(function () {
    const $modal = $('#categoryModal');
    const $modalTitle = $('#modalTitle');
    const $tbody = $('#categoriesTableBody');

    const $booksModal = $('#booksModal');
    const $booksTbody = $('#booksTable tbody');
    const $booksModalTitle = $('#booksModalTitle');

    const showMessage = (msg) => alert(msg);

    // ---------------- 모달 열기/닫기 ----------------
    const openModal = ($targetModal) => {
        $targetModal.css('display', 'flex'); // flex 유지
        $targetModal.find('.modal-content').scrollTop(0); // 스크롤 초기화
    };

    const closeModal = ($targetModal) => {
        $targetModal.hide();
    };

    // 카테고리 등록 버튼
    $('#btnAddCategory').on('click', function () {
        openModal($modal);
        $modalTitle.text('카테고리 등록');
        $('#modalCategoryId').val('');
        $('#modalCategoryName').val('').focus();
    });

    // 모달 닫기 버튼
    $('#modalCloseBtn').on('click', () => closeModal($modal));
    $modal.on('click', e => { if (e.target.id === 'categoryModal') closeModal($modal); });
    $(document).on('keydown', e => { if (e.key === 'Escape') closeModal($modal); });

    $('#booksModalCloseBtn').on('click', () => closeModal($booksModal));
    $booksModal.on('click', e => { if (e.target.id === 'booksModal') closeModal($booksModal); });

    // ---------------- 카테고리 저장 ----------------
    $('#modalSaveBtn').on('click', function () {
        const id = $('#modalCategoryId').val();
        const data = { name: $('#modalCategoryName').val().trim() };
        if (!data.name) {
            showMessage('카테고리 이름을 입력하세요.');
            return;
        }

        const ajaxOpt = {
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: () => { showMessage(id ? '수정 완료' : '등록 완료'); location.reload(); },
            error: () => { showMessage(id ? '수정 실패' : '등록 실패'); }
        };

        if (id) $.ajax({ url: `/admin/categories/${id}`, method: 'PUT', ...ajaxOpt });
        else $.ajax({ url: '/admin/categories', method: 'POST', ...ajaxOpt });
    });

    // ---------------- 카테고리 수정/삭제 ----------------
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
            url: `/admin/categories/${id}`,
            method: 'DELETE',
            success: () => { showMessage('삭제 완료'); location.reload(); },
            error: () => { showMessage('삭제 실패'); }
        });
    });

    // ---------------- 검색/페이징 ----------------
    $('#btnSearch').on('click', function () {
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/categories?keyword=${encodeURIComponent(keyword)}`;
    });

    $('#pagination').on('click', '.page-btn', function () {
        const page = $(this).data('page');
        const keyword = $('#searchKeyword').val();
        window.location.href = `/admin/categories?page=${page}&keyword=${encodeURIComponent(keyword)}`;
    });

    // ---------------- 카테고리 ID 클릭 시 속한 책 조회 ----------------
    $tbody.on('click', 'td.category-id', function () {
        const categoryId = $(this).closest('tr').data('id');
        $.ajax({
            url: `/admin/categories/${categoryId}/books`,
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

                // 모달 중앙 정렬 및 스크롤 처리
                const $dialog = $booksModal.find('.modal-content');
                $dialog.css({ 'max-height': '80vh', 'overflow-y': 'auto' });

                openModal($booksModal);
            },
            error: function () { showMessage('책 정보를 불러오는데 실패했습니다.'); }
        });
    });
});
