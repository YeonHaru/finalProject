$(function() {
    // =============================
    // 🔹 모달 select 옵션 로드
    // =============================
    function loadOptions(callback) {
        $.get('/admin/books/options', function(res) {
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

    // =============================
    // 🔹 모달 열기 (도서 등록)
    // =============================
    $('#btnAddBook').click(function() {
        $('#modalTitle').text('도서 등록');
        $('#bookForm')[0].reset();
        $('#bookId').val('');
        loadOptions(); // 옵션 최신화
        $('#bookModal').show();
    });

    // =============================
    // 🔹 모달 닫기
    // =============================
    $('#btnCloseModal').click(function() {
        $('#bookModal').hide();
    });

    // =============================
    // 🔹 등록 / 수정 submit
    // =============================
    $('#bookForm').submit(function(e) {
        e.preventDefault();

        let bookId = $('#bookId').val();
        let method = bookId ? 'PUT' : 'POST';
        let url = bookId ? '/admin/books/' + bookId : '/admin/books';

        let data = {
            bookId: bookId || null,
            title: $('#title').val().trim(),
            isbn: $('#isbn').val().trim(),
            price: parseInt($('#price').val()),
            stock: parseInt($('#stock').val()),
            discountedPrice: null,
            author: { authorId: parseInt($('#authorId').val()) || null },
            publisher: { publisherId: parseInt($('#publisherId').val()) || null },
            category: { categoryId: parseInt($('#categoryId').val()) || null }
        };

        if (!data.title) { alert('제목을 입력해주세요.'); return; }
        if (!data.isbn) { alert('ISBN을 입력해주세요.'); return; }
        if (data.price < 0 || data.stock < 0) { alert('가격/재고는 0 이상이어야 합니다.'); return; }

        $.ajax({
            url: url,
            method: method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function() {
                alert('저장 완료');
                location.reload();
            },
            error: function(xhr) {
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    alert('저장 실패: ' + xhr.responseJSON.message);
                } else {
                    alert('저장 실패');
                }
            }
        });
    });

    // =============================
    // 🔹 삭제
    // =============================
    $('#booksTableBody').on('click', '.btnDelete', function() {
        let bookId = $(this).closest('tr').data('id');
        if (confirm('정말 삭제하시겠습니까?')) {
            $.ajax({
                url: '/admin/books/' + bookId,
                method: 'DELETE',
                success: function() {
                    alert('삭제 완료');
                    location.reload();
                },
                error: function() {
                    alert('삭제 실패');
                }
            });
        }
    });

    // =============================
    // 🔹 수정 버튼 클릭
    // =============================
    $('#booksTableBody').on('click', '.btnEdit', function() {
        let bookId = $(this).closest('tr').data('id');

        $.get('/admin/books/' + bookId, function(book) {
            $('#modalTitle').text('도서 수정');
            $('#bookId').val(book.bookId);
            $('#title').val(book.title);
            $('#isbn').val(book.isbn);
            $('#price').val(book.price);
            $('#stock').val(book.stock);

            // ✅ 옵션 로드 후 기존 값 세팅
            loadOptions(function() {
                $('#authorId').val(book.authorId || '');
                $('#publisherId').val(book.publisherId || '');
                $('#categoryId').val(book.categoryId || '');
            });

            $('#bookModal').show();
        });
    });

    // =============================
    // 🔹 검색
    // =============================
    $('#searchForm').submit(function(e) {
        e.preventDefault();
        let keyword = $(this).find('input[name="keyword"]').val().trim();

        $.get('/admin/books/search', { keyword: keyword }, function(res) {
            let tbody = $('#booksTableBody');
            tbody.empty();

            if (res.content.length === 0) {
                tbody.append('<tr><td colspan="9">검색 결과가 없습니다.</td></tr>');
                return;
            }

            res.content.forEach(book => {
                let row = `
                    <tr data-id="${book.bookId}">
                        <td>${book.bookId}</td>
                        <td>${book.title}</td>
                        <td>${book.isbn}</td>
                        <td>${book.author ? book.author.name : ''}</td>
                        <td>${book.publisher ? book.publisher.name : ''}</td>
                        <td>${book.price}</td>
                        <td>${book.stock}</td>
                        <td>${book.createdAt}</td>
                        <td>
                            <button class="btnEdit">수정</button>
                            <button class="btnDelete">삭제</button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        });
    });
});
