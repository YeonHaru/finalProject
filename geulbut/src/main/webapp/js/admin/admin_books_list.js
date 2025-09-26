$(function () {
    const ctx = (typeof window.ctx !== 'undefined' && window.ctx) ? window.ctx : '';

    // =============================
    // 🔹 모달 select 옵션 로드
    // =============================
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


    // 도서 등록 모달 열기
    $('#btnAddBook').click(function () {

        $('#modalTitle').text('도서 등록');
        $('#bookForm')[0].reset();
        $('#bookId').val('');
        $('#imgPreview').attr('src', '').hide();
        $('#discountedPrice').val(0);

        loadOptions();
        $('#bookModal').css('display', 'flex').attr('aria-hidden', 'false');
    });

    // 모달 닫기
    function closeBookModal() {
        $('#bookModal').hide().attr('aria-hidden', 'true');
    }


    // 등록 / 수정 submit
    $('#bookForm').submit(function (e) {

        e.preventDefault();

        let authorVal = $('#authorId').val();
        let publisherVal = $('#publisherId').val();
        let categoryVal = $('#categoryId').val();

        if (!authorVal) {
            alert('저자를 선택해주세요.');
            return;
        }
        if (!publisherVal) {
            alert('출판사를 선택해주세요.');
            return;
        }
        if (!categoryVal) {
            alert('카테고리를 선택해주세요.');
            return;
        }

        let bookId = $('#bookId').val();
        let method = bookId ? 'PUT' : 'POST';
        let url = bookId ? `${ctx}/admin/books/${bookId}` : `${ctx}/admin/books`;

        let data = {
            bookId: bookId || null,
            title: $('#title').val().trim(),
            isbn: $('#isbn').val().trim(),
            price: parseInt($('#price').val(), 10) || 0,
            stock: parseInt($('#stock').val(), 10) || 0,
            discountedPrice: parseInt($('#discountedPrice').val(), 10) || 0,
            authorId: parseInt(authorVal, 10),
            publisherId: parseInt(publisherVal, 10),
            categoryId: parseInt(categoryVal, 10),
            imgUrl: $('#imgUrl').val().trim()
        };

        if (!data.title) {
            alert('제목을 입력해주세요.');
            return;
        }
        if (!data.isbn) {
            alert('ISBN을 입력해주세요.');
            return;
        }
        if (data.price < 0 || data.stock < 0) {
            alert('가격/재고는 0 이상이어야 합니다.');
            return;
        }

        $.ajax({
            url,
            method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function () {
                alert('저장 완료');
                location.reload();
            },
            error: function (xhr) {
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    alert('저장 실패: ' + xhr.responseJSON.message);
                } else {
                    alert('저장 실패');
                }
            }
        });
    });

    // =============================
    // 🔹 테이블 버튼 이벤트
    // =============================
    $('#booksTableBody')
        // 삭제
        .on('click', '.btnDelete', function () {
            let bookId = $(this).closest('tr').data('id');
            if (!confirm('정말 삭제하시겠습니까?')) return;

            $.ajax({
                url: `${ctx}/admin/books/${bookId}`,
                method: 'DELETE',
                success: function () {
                    alert('삭제 완료');
                    location.reload();
                },
                error: function () {
                    alert('삭제 실패');
                }
            });
        })
        // 수정
        .on('click', '.btnEdit', function () {
            let bookId = $(this).closest('tr').data('id');
            $.get(`${ctx}/admin/books/${bookId}/edit-options`, function (res) {
                let book = res.book;
                $('#modalTitle').text('도서 수정');
                $('#bookId').val(book.bookId);
                $('#title').val(book.title);
                $('#isbn').val(book.isbn);
                $('#price').val(book.price);
                $('#stock').val(book.stock);
                $('#discountedPrice').val(book.discountedPrice || 0);
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
        // 상세보기
        .on('click', '.btnView', function () {
            const bookId = $(this).closest('tr').data('id');
            if (bookId) {
                // AdminBooksController가 아닌 BooksController 경로로 이동
                window.location.href = ctx + `/book/${bookId}`;
            }
        });

    // 이미지 미리보기
    $('#imgUrl').on('input', function () {
        let url = $(this).val().trim();
        $('#imgPreview').attr('src', url).toggle(!!url);
    });


    // 검색 + 페이징 갱신
    $('#bookSearchForm').submit(function (e) {

        e.preventDefault();
        let keyword = ($(this).find('input[name="keyword"]').val() || '').trim();

        $.get(`${ctx}/admin/books/search`, {keyword}, function (res) {
            let tbody = $('#booksTableBody');
            tbody.empty();

            if (!res.content || res.content.length === 0) {
                tbody.append('<tr><td colspan="12" class="t-center text-light">검색 결과가 없습니다.</td></tr>');
                $('.pagination').empty();
                return;
            }

            res.content.forEach(book => {
                let row = `
<tr class="data-row" data-id="${book.bookId}">
  <td>${book.bookId}</td>
  <td class="t-left"><div class="title-ellipsis" title="${book.title}">${book.title}</div></td>
  <td>${book.imgUrl ? `<img src="${book.imgUrl}" class="book-thumb" alt="${book.title}"/>` : ''}</td>

  <!-- ISBN → hide-md -->
  <td class="hide-md"><span class="isbn-mono">${book.isbn}</span></td>

  <td>${book.authorName ?? ''}</td>

  <!-- 출판사/카테고리/할인가/생성일 → hide-lg -->
  <td class="hide-lg">${book.publisherName ?? ''}</td>
  <td class="hide-lg">${book.categoryName ?? ''}</td>
  <td class="t-right">${book.price}</td>
  <td class="t-right hide-lg">${book.discountedPrice ?? ''}</td>
  <td>${book.stock}</td>
  <td class="hide-lg">${book.createdAt}</td>

  <td>
    <button type="button" class="btn btn-accent btn--glass btnView">상세보기</button>
    <button type="button" class="btn btn-accent btn--glass btnEdit">수정</button>
    <button type="button" class="btn btn-delete btn--glass btnDelete">삭제</button>
  </td>
</tr>`;

                tbody.append(row);
            });

            // 페이징
            let pagination = $('.pagination');
            pagination.empty();
            for (let i = 0; i < res.totalPages; i++) {
                let active = i === res.number ? 'active' : '';
                pagination.append(`<a href="?page=${i}&keyword=${encodeURIComponent(keyword)}" class="${active}">${i + 1}</a>`);
            }
        });
    });
});
