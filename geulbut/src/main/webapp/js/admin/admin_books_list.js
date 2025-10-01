$(function () {
    const ctx = (typeof window.ctx !== 'undefined' && window.ctx) ? window.ctx : '';

    // 🔹 모달 select 옵션 로드
    function loadOptions(callback) {
        $.get(`${ctx}/admin/books/options`, function (res) {
            let authorSelect = $('#authorId');
            let publisherSelect = $('#publisherId');
            let categorySelect = $('#categoryId');

            authorSelect.empty().append('<option value="">선택</option>');
            publisherSelect.empty().append('<option value="">선택</option>');
            categorySelect.empty().append('<option value="">선택</option>');

            res.authors.forEach(a => authorSelect.append(`<option value="${a.authorId}">${a.name}</option>`));
            res.publishers.forEach(p => publisherSelect.append(`<option value="${p.publisherId}">${p.name}</option>`));
            res.categories.forEach(c => categorySelect.append(`<option value="${c.categoryId}">${c.name}</option>`));

            if (callback) callback();
        });
    }

    // 🔹 도서 등록 모달 열기
    $('#btnAddBook').click(function () {
        $('#modalTitle').text('도서 등록');
        $('#bookForm')[0].reset();
        $('#bookId').val('');
        $('#imgPreview').attr('src', '').hide();
        $('#discountedPrice').val(0);

        loadOptions();
        $('#bookModal').css('display', 'flex').attr('aria-hidden', 'false');
    });
    
    // 🔹 모달 닫기
    function closeBookModal() {
        $('#bookModal').hide().attr('aria-hidden', 'true');
    }
    $('#btnCloseModal, #btnCancel').on('click', closeBookModal);
    $('#bookModal').on('click', function (e) {
        if (e.target === this) closeBookModal();
    });
    $(document).on('keydown', function (e) {
        if (e.key === 'Escape' && $('#bookModal').is(':visible')) closeBookModal();
    });

    // 🔹 등록 / 수정 submit
    $('#bookForm').submit(function (e) {
        e.preventDefault();

        let authorVal = $('#authorId').val();
        let publisherVal = $('#publisherId').val();
        let categoryVal = $('#categoryId').val();

        if (!authorVal) { alert('저자를 선택해주세요.'); return; }
        if (!publisherVal) { alert('출판사를 선택해주세요.'); return; }
        if (!categoryVal) { alert('카테고리를 선택해주세요.'); return; }

        let bookId = $('#bookId').val();
        let method = bookId ? 'PUT' : 'POST';
        let url = bookId ? `${ctx}/admin/books/${bookId}` : `${ctx}/admin/books`;

        let data = {
            bookId: bookId || null,
            title: $('#title').val().trim(),
            isbn: $('#isbn').val().trim(),
            price: parseInt($('#price').val(), 10) || 0,
            discountedPrice: parseInt($('#discountedPrice').val(), 10) || 0,
            stock: parseInt($('#stock').val(), 10) || 0,
            authorId: parseInt(authorVal, 10),
            publisherId: parseInt(publisherVal, 10),
            categoryId: parseInt(categoryVal, 10),
            imgUrl: $('#imgUrl').val().trim()
        };

        if (!data.title) { alert('제목을 입력해주세요.'); return; }
        if (!data.isbn) { alert('ISBN을 입력해주세요.'); return; }
        if (data.price < 0 || data.stock < 0 || data.discountedPrice < 0) { alert('가격, 할인가, 재고는 0 이상이어야 합니다.'); return; }

        $.ajax({
            url, method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function () { alert('저장 완료'); location.reload(); },
            error: function (xhr) {
                if (xhr.responseJSON && xhr.responseJSON.message) alert('저장 실패: ' + xhr.responseJSON.message);
                else alert('저장 실패');
            }
        });
    });

    // 🔹 테이블 버튼 이벤트
    $('#booksTableBody')
        .on('click', '.btnDelete', function () {
            let bookId = $(this).closest('tr').data('id');
            if (!confirm('정말 삭제하시겠습니까?')) return;

            $.ajax({
                url: `${ctx}/admin/books/${bookId}`,
                method: 'DELETE',
                success: function () { alert('삭제 완료'); location.reload(); },
                error: function () { alert('삭제 실패'); }
            });
        })
        .on('click', '.btnEdit', function () {
            let bookId = $(this).closest('tr').data('id');
            $.get(`${ctx}/admin/books/${bookId}/edit-options`, function (res) {
                let book = res.book;
                $('#modalTitle').text('도서 수정');
                $('#bookId').val(book.bookId);
                $('#title').val(book.title);
                $('#isbn').val(book.isbn);
                $('#price').val(book.price);
                $('#discountedPrice').val(book.discountedPrice || 0);
                $('#stock').val(book.stock);
                $('#imgUrl').val(book.imgUrl || '');
                $('#imgPreview').attr('src', book.imgUrl || '').toggle(!!book.imgUrl);

                let authorSelect = $('#authorId').empty().append('<option value="">선택</option>');
                let publisherSelect = $('#publisherId').empty().append('<option value="">선택</option>');
                let categorySelect = $('#categoryId').empty().append('<option value="">선택</option>');

                res.authors.forEach(a => authorSelect.append(`<option value="${a.authorId}">${a.name}</option>`));
                res.publishers.forEach(p => publisherSelect.append(`<option value="${p.publisherId}">${p.name}</option>`));
                res.categories.forEach(c => categorySelect.append(`<option value="${c.categoryId}">${c.name}</option>`));

                $('#authorId').val(book.authorId || '');
                $('#publisherId').val(book.publisherId || '');
                $('#categoryId').val(book.categoryId || '');

                $('#bookModal').css('display', 'flex').attr('aria-hidden', 'false');
            });
        })
        .on('click', '.btnView', function () {
            const bookId = $(this).closest('tr').data('id');
            if (bookId) window.open(ctx + `/book/${bookId}`, '_blank');
        });

    // 🔹 이미지 미리보기
    $('#imgUrl').on('input', function () {
        let url = $(this).val().trim();
        $('#imgPreview').attr('src', url).toggle(!!url);
    });

    // 🔹 검색 + 페이징 갱신
    $('#bookSearchForm').submit(function (e) {
        e.preventDefault();
        let keyword = ($(this).find('input[name="keyword"]').val() || '').trim();

        $.get(`${ctx}/admin/books/search`, { keyword }, function (res) {
            let tbody = $('#booksTableBody');
            tbody.empty();

            if (!res.content || res.content.length === 0) {
                tbody.append('<tr><td colspan="12" class="t-center text-light">검색 결과가 없습니다.</td></tr>');
                $('.pagination, .pagination-toolbar').remove();
                return;
            }

            // 목록 렌더
            res.content.forEach(book => {
                let row = `
<tr class="data-row" data-id="${book.bookId}">
  <td>${book.bookId}</td>
  <td class="t-left"><div class="title-ellipsis" title="${book.title}">${book.title}</div></td>
  <td>${book.imgUrl ? `<img src="${book.imgUrl}" class="book-thumb" alt="${book.title}"/>` : ''}</td>
  <td class="hide-md"><span class="isbn-mono">${book.isbn}</span></td>
  <td>${book.authorName ?? ''}</td>
  <td class="hide-lg">${book.publisherName ?? ''}</td>
  <td class="hide-lg">${book.categoryName ?? ''}</td>
  <td class="t-right">${book.price}</td>
  <td class="t-right hide-lg">${book.discountedPrice ?? ''}</td>
  <td>${book.stock}</td>
  <td class="hide-lg">${book.createdAt}</td>
  <td>
    <button type="button" class="btn btn-secondary btnView">상세보기</button>
    <button type="button" class="btn btn-primary btnEdit">수정</button>
    <button type="button" class="btn btn-danger btnDelete">삭제</button>
  </td>
</tr>`;
                tbody.append(row);
            });

            // --- 페이징 (Materia 버튼그룹) : 전체 교체 ---
            $('.pagination, .pagination-toolbar').remove();

            const $toolbar = $(`
<div class="btn-toolbar pagination-toolbar" role="toolbar" aria-label="페이지네이션">
  <div class="btn-group" role="group" aria-label="페이지"></div>
</div>`);
            const $group = $toolbar.find('.btn-group');

            const total = res.totalPages || 0;
            const now   = (typeof res.number === 'number') ? res.number : 0;
            const first = (typeof res.first  === 'boolean') ? res.first : (now === 0);
            const last  = (typeof res.last   === 'boolean') ? res.last  : (now === total - 1);

            if (total > 1) {
                // « 이전
                $group.append(`
<a class="btn btn-secondary btn-nav"
   href="?page=${Math.max(0, now - 1)}&keyword=${encodeURIComponent(keyword)}"
   aria-label="이전" ${first ? 'aria-disabled="true"' : ''}>&laquo;</a>`);

                // 숫자들
                for (let i = 0; i < total; i++) {
                    const isActive = i === now;
                    $group.append(`
<a class="btn btn-secondary ${isActive ? 'active' : ''}"
   href="?page=${i}&keyword=${encodeURIComponent(keyword)}"
   ${isActive ? 'aria-current="page"' : ''}>${i + 1}</a>`);
                }

                // » 다음
                $group.append(`
<a class="btn btn-secondary btn-nav"
   href="?page=${Math.min(total - 1, now + 1)}&keyword=${encodeURIComponent(keyword)}"
   aria-label="다음" ${last ? 'aria-disabled="true"' : ''}>&raquo;</a>`);

                // 비활성 링크 클릭 방지
                $toolbar.on('click', 'a[aria-disabled="true"]', function (e) { e.preventDefault(); });

                // 렌더링 위치
                $('.table-scroll').after($toolbar);
            }

            //  검색/렌더 완료 후: 가로 스크롤 초기화
            $('.table-scroll').each(function () { this.scrollLeft = 0; });
        });
    });

    //  초기 로드 시: 테이블이 오른쪽 끝에서 보이는 현상 방지
    $('.table-scroll').each(function () { this.scrollLeft = 0; });
});
