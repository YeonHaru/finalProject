document.addEventListener('DOMContentLoaded', function () {

    const hashtagModal = document.getElementById('hashtagModal');
    const modalTitle = document.getElementById('modalTitle');
    const hashtagNameInput = document.getElementById('hashtagName');
    const modalSaveBtn = document.getElementById('modalSaveBtn');
    const modalCloseBtn = document.getElementById('modalCloseBtn');

    const btnAddHashtag = document.getElementById('btnAddHashtag');
    const hashtagsTable = document.getElementById('hashtagsTable').querySelector('tbody');
    const pagination = document.getElementById('pagination');
    const keywordInput = document.getElementById('keyword');
    const searchForm = document.getElementById('searchForm');

    // 책 모달
    const booksModal = document.getElementById('booksModal');
    const booksModalClose = document.getElementById('booksModalClose');
    const booksList = document.getElementById('booksList');
    const booksModalTitle = document.getElementById('booksModalTitle');

    let currentEditId = null;

    /* ---------- Toast 알람 생성 ---------- */
    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.textContent = message;
        toast.className = `toast ${type}`;
        document.body.appendChild(toast);
        setTimeout(() => toast.classList.add('show'), 100); // fade-in
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 2000); // 2초 후 사라짐
    }

    /* ---------- 모달 열기/닫기 ---------- */
    function openModal(edit = false, name = '', id = null) {
        hashtagModal.style.display = 'flex';
        hashtagNameInput.value = name;
        currentEditId = id;
        modalTitle.textContent = edit ? '해시태그 수정' : '해시태그 등록';
    }

    function closeModal() {
        hashtagModal.style.display = 'none';
        hashtagNameInput.value = '';
        currentEditId = null;
    }

    function openBooksModal(title, books) {
        booksModal.style.display = 'flex';
        booksModalTitle.textContent = title;
        booksList.innerHTML = '';
        if (!books || books.length === 0) {
            booksList.innerHTML = '<p>등록된 도서가 없습니다.</p>';
        } else {
            const ul = document.createElement('ul');
            books.forEach(b => {
                const li = document.createElement('li');
                li.textContent = `${b.title} (${b.isbn})`;
                ul.appendChild(li);
            });
            booksList.appendChild(ul);
        }
    }

    function closeBooksModal() {
        booksModal.style.display = 'none';
        booksList.innerHTML = '';
    }

    btnAddHashtag.addEventListener('click', () => openModal());
    modalCloseBtn.addEventListener('click', closeModal);
    booksModalClose.addEventListener('click', closeBooksModal);

    /* ---------- CRUD ---------- */
    modalSaveBtn.addEventListener('click', () => {
        const name = hashtagNameInput.value.trim();
        if (!name) { showToast('해시태그 이름을 입력해주세요', 'error'); return; }

        if (currentEditId) {
            // 수정
            fetch(`/admin/hashtags/${currentEditId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name })
            })
                .then(res => res.json())
                .then(data => {
                    closeModal();
                    showToast('해시태그가 수정되었습니다');
                    setTimeout(() => location.reload(), 800);
                })
                .catch(err => {
                    console.error(err);
                    showToast('수정에 실패했습니다', 'error');
                });
        } else {
            // 등록
            fetch('/admin/hashtags', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name })
            })
                .then(res => res.json())
                .then(data => {
                    closeModal();
                    showToast('해시태그가 등록되었습니다');
                    setTimeout(() => location.reload(), 800);
                })
                .catch(err => {
                    console.error(err);
                    showToast('등록에 실패했습니다', 'error');
                });
        }
    });

    /* ---------- 삭제 ---------- */
    hashtagsTable.addEventListener('click', async e => {
        if (!e.target.classList.contains('btnDelete')) return;
        const tr = e.target.closest('tr');
        const id = tr.dataset.id;
        if (!confirm('정말 삭제하시겠습니까?')) return;

        try {
            const res = await fetch(`/admin/hashtags/${id}`, { method: 'DELETE' });
            if (!res.ok) throw new Error(await res.text() || '삭제 중 오류 발생');
            const success = await res.json();
            if (success) {
                showToast('해시태그가 삭제되었습니다');
                setTimeout(() => location.reload(), 800);
            } else showToast('삭제에 실패했습니다', 'error');
        } catch (err) {
            console.error(err);
            showToast(`삭제에 실패했습니다: ${err.message}`, 'error');
        }
    });

    /* ---------- 수정 ---------- */
    hashtagsTable.addEventListener('click', e => {
        if (!e.target.classList.contains('btnEdit')) return;
        const tr = e.target.closest('tr');
        const id = tr.dataset.id;
        const name = tr.children[1].textContent;
        openModal(true, name, id);
    });

    /* ---------- ID 클릭 → 해시태그 등록 도서 보기 ---------- */
    hashtagsTable.addEventListener('click', async e => {
        if (!e.target.classList.contains('hashtag-id')) return;
        const id = e.target.dataset.id;

        try {
            const res = await fetch(`/admin/hashtags/${id}/books`);
            if (!res.ok) throw new Error('도서를 불러오는 중 오류 발생');
            const books = await res.json();
            openBooksModal(`해시태그 [${e.target.textContent}] 등록 도서`, books);
        } catch (err) {
            console.error(err);
            showToast(`도서를 불러오는 중 오류 발생: ${err.message}`, 'error');
        }
    });

    /* ---------- 페이징 ---------- */
    pagination.addEventListener('click', e => {
        if (!e.target.classList.contains('page-btn')) return;
        const page = e.target.dataset.page;
        const keyword = keywordInput.value.trim();
        let url = `/admin/hashtags?page=${page}`;
        if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
        location.href = url;
    });

    /* ---------- 검색 ---------- */
    searchForm.addEventListener('submit', e => {
        e.preventDefault();
        const keyword = keywordInput.value.trim();
        let url = '/admin/hashtags';
        if (keyword) url += `?keyword=${encodeURIComponent(keyword)}`;
        location.href = url;
    });

});
