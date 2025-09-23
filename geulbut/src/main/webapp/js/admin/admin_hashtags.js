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

    // 책 모달 (JSP에 정적으로 존재한다고 가정)
    const booksModal = document.getElementById('booksModal');
    const booksModalClose = document.getElementById('booksModalClose');
    const booksList = document.getElementById('booksList');
    const booksModalTitle = document.getElementById('booksModalTitle');
    const bookSearchForm = document.getElementById('bookSearchForm'); // 모달 내 검색폼 (정적)
    const bookKeywordInput = document.getElementById('bookKeyword'); // 모달 내 검색 입력

    const BOOKS_SAVE_BTN_ID = 'booksModalSaveBtn';

    let currentEditId = null;
    let currentManageHashtagId = null; // 현재 도서 관리 중인 해시태그 id

    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.textContent = message;
        toast.className = `toast ${type}`;
        document.body.appendChild(toast);
        setTimeout(() => toast.classList.add('show'), 100);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 2000);
    }

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

    function openBooksModal(title) {
        booksModal.style.display = 'flex';
        booksModalTitle.textContent = title;
        booksList.innerHTML = '';
    }

    function closeBooksModal() {
        booksModal.style.display = 'none';
        booksList.innerHTML = '';
        currentManageHashtagId = null;
        // 저장 버튼 제거(있으면)
        const saveBtn = document.getElementById(BOOKS_SAVE_BTN_ID);
        if (saveBtn) saveBtn.remove();
        // 검색어 초기화 (있으면)
        if (bookKeywordInput) bookKeywordInput.value = '';
    }

    btnAddHashtag.addEventListener('click', () => openModal());
    modalCloseBtn.addEventListener('click', closeModal);
    booksModalClose.addEventListener('click', closeBooksModal);

    /* ---------- CRUD ---------- */
    modalSaveBtn.addEventListener('click', () => {
        const name = hashtagNameInput.value.trim();
        if (!name) { showToast('해시태그 이름을 입력해주세요', 'error'); return; }

        if (currentEditId) {
            fetch(`/admin/hashtags/${currentEditId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name })
            })
                .then(res => res.json())
                .then(() => {
                    closeModal();
                    showToast('해시태그가 수정되었습니다');
                    setTimeout(() => location.reload(), 800);
                })
                .catch(err => { console.error(err); showToast('수정에 실패했습니다', 'error'); });
        } else {
            fetch('/admin/hashtags', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name })
            })
                .then(res => res.json())
                .then(() => {
                    closeModal();
                    showToast('해시태그가 등록되었습니다');
                    setTimeout(() => location.reload(), 800);
                })
                .catch(err => { console.error(err); showToast('등록에 실패했습니다', 'error'); });
        }
    });

    /* ---------- 테이블 클릭 처리 ---------- */
    hashtagsTable.addEventListener('click', async e => {
        const tr = e.target.closest('tr');
        if (!tr) return;
        const hashtagId = tr.dataset.id;

        // 삭제
        if (e.target.classList.contains('btnDelete')) {
            if (!confirm('정말 삭제하시겠습니까?')) return;
            try {
                const res = await fetch(`/admin/hashtags/${hashtagId}`, { method: 'DELETE' });
                if (!res.ok) throw new Error(await res.text() || '삭제 중 오류 발생');
                const success = await res.json();
                if (success) { showToast('해시태그가 삭제되었습니다'); setTimeout(() => location.reload(), 800); }
                else showToast('삭제에 실패했습니다', 'error');
            } catch (err) { console.error(err); showToast(`삭제에 실패했습니다: ${err.message}`, 'error'); }
        }

        // 수정
        if (e.target.classList.contains('btnEdit')) {
            const name = tr.children[1].textContent;
            openModal(true, name, hashtagId);
        }

        // ID 클릭 → 해시태그 등록 도서 보기 (읽기 전용)
        if (e.target.classList.contains('hashtag-id')) {
            try {
                const res = await fetch(`/admin/hashtags/${hashtagId}/books`);
                if (!res.ok) throw new Error('도서를 불러오는 중 오류 발생');
                const books = await res.json();
                openBooksModal(`해시태그 [${e.target.textContent}] 등록 도서`);
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
            } catch (err) {
                console.error(err);
                showToast(`도서를 불러오는 중 오류 발생: ${err.message}`, 'error');
            }
        }

        // 도서 관리 버튼 클릭 → (검색폼은 JSP의 정적 #bookSearchForm 사용)
        if (e.target.classList.contains('btn-manage-books')) {
            try {
                currentManageHashtagId = hashtagId;
                openBooksModal(`해시태그 [${tr.children[1].textContent}] 도서 관리`);
                // 초기 도서 로드 (빈 키워드)
                await loadBooks(hashtagId, '');
            } catch (err) {
                console.error(err);
                showToast(`도서 관리 중 오류 발생: ${err.message}`, 'error');
            }
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

    /* ---------- 해시태그 검색 ---------- */
    searchForm.addEventListener('submit', e => {
        e.preventDefault();
        const keyword = keywordInput.value.trim();
        let url = '/admin/hashtags';
        if (keyword) url += `?keyword=${encodeURIComponent(keyword)}`;
        location.href = url;
    });

    /* ---------- 모달 내부 도서 검색(정적 폼 재사용) ---------- */
    if (bookSearchForm) {
        bookSearchForm.addEventListener('submit', function (e) {
            e.preventDefault();
            if (!currentManageHashtagId) {
                showToast('먼저 관리할 해시태그를 선택하세요', 'error');
                return;
            }
            const kw = (bookKeywordInput && bookKeywordInput.value) ? bookKeywordInput.value.trim() : '';
            loadBooks(currentManageHashtagId, kw);
        });
    }

    /* ---------- 도서 로딩 + 저장 처리 함수 ---------- */
    async function loadBooks(hashtagId, keyword = '') {
        if (!hashtagId) return;
        try {
            const resAll = await fetch(`/admin/books/all?keyword=${encodeURIComponent(keyword)}`);
            if (!resAll.ok) throw new Error('도서를 불러오는 중 오류 발생');
            const allBooks = await resAll.json();

            const resLinked = await fetch(`/admin/hashtags/${hashtagId}/books`);
            if (!resLinked.ok) throw new Error('연결된 도서를 불러오는 중 오류 발생');
            const linkedBooks = await resLinked.json();
            const linkedIds = linkedBooks.map(b => Number(b.bookId));

            booksList.innerHTML = '';
            const ul = document.createElement('ul');

            allBooks.forEach(book => {
                const li = document.createElement('li');
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.value = book.bookId;
                checkbox.checked = linkedIds.includes(Number(book.bookId));
                checkbox.className = 'book-checkbox';
                li.appendChild(checkbox);
                li.appendChild(document.createTextNode(` ${book.title} (${book.isbn})`));
                ul.appendChild(li);
            });
            booksList.appendChild(ul);

            // 저장 버튼 하나만 유지
            let saveBtn = document.getElementById(BOOKS_SAVE_BTN_ID);
            if (!saveBtn) {
                saveBtn = document.createElement('button');
                saveBtn.id = BOOKS_SAVE_BTN_ID;
                saveBtn.textContent = '저장';
                saveBtn.className = 'btn btn-accent';
                booksList.parentElement.appendChild(saveBtn);
            }

            // 클릭 핸들러는 매번 새로 할당 (중복 실행 방지)
            saveBtn.onclick = async () => {
                saveBtn.disabled = true;
                try {
                    const checkboxes = booksList.querySelectorAll('input.book-checkbox');
                    const toAdd = [];
                    const toRemove = [];

                    checkboxes.forEach(cb => {
                        const id = Number(cb.value);
                        if (cb.checked && !linkedIds.includes(id)) toAdd.push(id);
                        if (!cb.checked && linkedIds.includes(id)) toRemove.push(id);
                    });

                    // 순차 처리(간단하게)
                    for (const id of toAdd) {
                        const r = await fetch(`/admin/hashtags/${hashtagId}/books/${id}`, { method: 'POST' });
                        if (!r.ok) console.error('추가 실패', id);
                    }
                    for (const id of toRemove) {
                        const r = await fetch(`/admin/hashtags/${hashtagId}/books/${id}`, { method: 'DELETE' });
                        if (!r.ok) console.error('삭제 실패', id);
                    }

                    showToast('도서 연결이 업데이트되었습니다');
                    closeBooksModal();
                    setTimeout(() => location.reload(), 800);
                } catch (err) {
                    console.error(err);
                    showToast('도서 연결 업데이트 중 오류 발생', 'error');
                } finally {
                    saveBtn.disabled = false;
                }
            };

        } catch (err) {
            console.error(err);
            showToast(err.message || '도서 로드 중 오류', 'error');
        }
    }

});
