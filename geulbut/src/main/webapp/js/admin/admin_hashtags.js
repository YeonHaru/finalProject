// /js/admin/admin_hashtags.js
document.addEventListener('DOMContentLoaded', function () {
    const ctx = (typeof window.ctx !== 'undefined' && window.ctx) ? window.ctx : '';

    const hashtagModal = document.getElementById('hashtagModal');
    const modalTitle = document.getElementById('modalTitle');
    const hashtagNameInput = document.getElementById('hashtagName');
    const modalSaveBtn = document.getElementById('modalSaveBtn');
    const modalCloseBtn = document.getElementById('modalCloseBtn');

    const btnAddHashtag = document.getElementById('btnAddHashtag');
    const tableBody = document.getElementById('hashtagsTable')?.querySelector('tbody');
    const pagination = document.getElementById('pagination');
    const keywordInput = document.getElementById('keyword');
    const searchForm = document.getElementById('searchForm');

    // 책 모달
    const booksModal = document.getElementById('booksModal');
    const booksModalClose = document.getElementById('booksModalClose');
    const booksList = document.getElementById('booksList');
    const booksModalTitle = document.getElementById('booksModalTitle');
    const bookSearchForm = document.getElementById('bookSearchForm');
    const bookKeywordInput = document.getElementById('bookKeyword');

    const BOOKS_SAVE_BTN_ID = 'booksModalSaveBtn';

    // 추가: 모달 전용 요소 참조 & 상태
    const booksPager = document.getElementById('booksPager');
    const booksModalFooter = document.getElementById('booksModalFooter');

    const PAGE_SIZE = 20;
    let paging = { page: 1, size: PAGE_SIZE, total: 0, pages: 0 };
    let allBooksCache = [];                 // 검색 결과 전체 (클라이언트 페이징)
    let originalLinkedIds = new Set();      // 서버에서 가져온 최초 연결 상태
    let selectedBookIds  = new Set();       // 사용자가 체크로 만든 현재 상태(페이지 간 유지)


    let currentEditId = null;
    let currentManageHashtagId = null;

    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.textContent = message;
        toast.className = `toast ${type}`;
        document.body.appendChild(toast);
        requestAnimationFrame(() => toast.classList.add('show'));
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 2000);
    }

    // 모달 헬퍼
    function openModal(edit = false, name = '', id = null) {
        if (!hashtagModal) return;
        hashtagModal.style.display = 'flex';
        hashtagNameInput.value = name;
        currentEditId = id;
        modalTitle.textContent = edit ? '해시태그 수정' : '해시태그 등록';
    }
    function closeModal() {
        if (!hashtagModal) return;
        hashtagModal.style.display = 'none';
        hashtagNameInput.value = '';
        currentEditId = null;
    }
    function openBooksModal(title) {
        if (!booksModal) return;
        booksModal.style.display = 'flex';
        booksModalTitle.textContent = title;
        if (booksList) booksList.innerHTML = '';
    }

    function closeBooksModal() {
        if (!booksModal) return;
        booksModal.style.display = 'none';
        if (booksList) booksList.innerHTML = '';
        if (booksPager) booksPager.innerHTML = '';
        currentManageHashtagId = null;
        const saveBtn = document.getElementById(BOOKS_SAVE_BTN_ID);
        if (saveBtn) saveBtn.remove();
        if (bookKeywordInput) bookKeywordInput.value = '';

        // 상태 초기화
        allBooksCache = [];
        originalLinkedIds = new Set();
        selectedBookIds = new Set();
        paging = { page: 1, size: PAGE_SIZE, total: 0, pages: 0 };
    }

    // 바인딩
    btnAddHashtag?.addEventListener('click', () => openModal());
    modalCloseBtn?.addEventListener('click', closeModal);
    booksModalClose?.addEventListener('click', closeBooksModal);

    // 저장
    modalSaveBtn?.addEventListener('click', () => {
        const name = (hashtagNameInput?.value || '').trim();
        if (!name) { showToast('해시태그 이름을 입력해주세요', 'error'); return; }

        const url = currentEditId
            ? `${ctx}/admin/hashtags/${currentEditId}`
            : `${ctx}/admin/hashtags`;
        const method = currentEditId ? 'PUT' : 'POST';

        fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name })
        })
            .then(res => {
                if (!res.ok) throw new Error('요청 실패');
                return res.json();
            })
            .then(() => {
                closeModal();
                showToast(currentEditId ? '해시태그가 수정되었습니다' : '해시태그가 등록되었습니다');
                setTimeout(() => location.reload(), 800);
            })
            .catch(err => {
                console.error(err);
                showToast(currentEditId ? '수정에 실패했습니다' : '등록에 실패했습니다', 'error');
            });
    });

    // 테이블 위임 처리 (수정/삭제/도서관리/ID클릭)
    tableBody?.addEventListener('click', async (e) => {
        const tr = e.target.closest('tr');
        if (!tr) return;
        const hashtagId = tr.dataset.id;

        // 삭제
        if (e.target.classList.contains('btnDelete') || e.target.classList.contains('btn-delete')) {
            if (!confirm('정말 삭제하시겠습니까?')) return;
            try {
                const res = await fetch(`${ctx}/admin/hashtags/${hashtagId}`, { method: 'DELETE' });
                if (!res.ok) throw new Error(await res.text() || '삭제 중 오류 발생');
                const success = await res.json();
                if (success) { showToast('해시태그가 삭제되었습니다'); setTimeout(() => location.reload(), 800); }
                else showToast('삭제에 실패했습니다', 'error');
            } catch (err) { console.error(err); showToast(`삭제에 실패했습니다: ${err.message}`, 'error'); }
        }

        // 수정
        if (e.target.classList.contains('btnEdit') || e.target.classList.contains('btn-edit')) {
            const name = tr.children[1]?.textContent || '';
            openModal(true, name, hashtagId);
        }

        // ID 클릭 → 등록 도서 보기
        if (e.target.classList.contains('hashtag-id')) {
            try {
                const res = await fetch(`${ctx}/admin/hashtags/${hashtagId}/books`);
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

        // 도서 관리
        if (e.target.classList.contains('btn-manage-books')) {
            try {
                currentManageHashtagId = hashtagId;
                openBooksModal(`해시태그 [${tr.children[1]?.textContent || ''}] 도서 관리`);
                await loadBooks(hashtagId, '');
            } catch (err) {
                console.error(err);
                showToast(`도서 관리 중 오류 발생: ${err.message}`, 'error');
            }
        }
    });

    // 페이징 (기존 공통 톤과 동일)
    pagination?.addEventListener('click', e => {
        if (!e.target.classList.contains('page-btn')) return;
        e.preventDefault();
        const page = e.target.dataset.page;
        const keyword = (keywordInput?.value || '').trim();
        let url = `${ctx}/admin/hashtags?page=${page}`;
        if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
        location.href = url;
    });

    // 검색 (GET 유지)
    searchForm?.addEventListener('submit', e => {
        e.preventDefault();
        const keyword = (keywordInput?.value || '').trim();
        let url = `${ctx}/admin/hashtags`;
        if (keyword) url += `?keyword=${encodeURIComponent(keyword)}`;
        location.href = url;
    });

    // 모달 내 도서 검색
    bookSearchForm?.addEventListener('submit', function (e) {
        e.preventDefault();
        if (!currentManageHashtagId) {
            showToast('먼저 관리할 해시태그를 선택하세요', 'error');
            return;
        }
        const kw = (bookKeywordInput?.value || '').trim();
        loadBooks(currentManageHashtagId, kw);
    });

    // 도서 로드 & 저장
    async function loadBooks(hashtagId, keyword = '') {
        if (!hashtagId) return;
        try {
            // 1) 전체 후보 도서
            const resAll = await fetch(`${ctx}/admin/books/all?keyword=${encodeURIComponent(keyword)}`);
            if (!resAll.ok) throw new Error('도서를 불러오는 중 오류 발생');
            allBooksCache = await resAll.json();

            // 2) 연결된 도서
            const resLinked = await fetch(`${ctx}/admin/hashtags/${hashtagId}/books`);
            if (!resLinked.ok) throw new Error('연결된 도서를 불러오는 중 오류 발생');
            const linkedBooks = await resLinked.json();

            originalLinkedIds = new Set(linkedBooks.map(b => Number(b.bookId)));
            selectedBookIds   = new Set(originalLinkedIds); // 시작 상태 = 서버 상태

            // 3) 페이징 설정 + 첫 페이지 렌더
            paging.total = allBooksCache.length;
            paging.pages = Math.max(1, Math.ceil(paging.total / paging.size));
            paging.page  = 1;

            renderBooksPage();           // ← 아래 함수가 리스트 + 페이저를 그립니다.
            ensureBooksSaveButton();     // 저장 버튼 표시/핸들러 연결

        } catch (err) {
            console.error(err);
            showToast(err.message || '도서 로드 중 오류', 'error');
        }
    }
    function renderBooksPage(){
        // slice
        const start = (paging.page - 1) * paging.size;
        const end   = Math.min(start + paging.size, paging.total);
        const pageItems = allBooksCache.slice(start, end);

        // 리스트 DOM
        booksList.innerHTML = '';
        const ul = document.createElement('ul');

        pageItems.forEach(book => {
            const idNum = Number(book.bookId);
            const li = document.createElement('li');

            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.value = idNum;
            checkbox.className = 'book-checkbox';
            checkbox.checked = selectedBookIds.has(idNum);

            checkbox.addEventListener('change', () => {
                if (checkbox.checked) selectedBookIds.add(idNum);
                else selectedBookIds.delete(idNum);
            });

            li.appendChild(checkbox);
            li.appendChild(document.createTextNode(` ${book.title} (${book.isbn})`));
            ul.appendChild(li);
        });

        booksList.appendChild(ul);

        // 페이저 DOM
        if (booksPager){
            booksPager.innerHTML = '';
            for (let i=1; i<=paging.pages; i++){
                const a = document.createElement('a');
                a.href = '#';
                a.className = `page-btn ${i === paging.page ? 'active' : ''}`;
                a.dataset.page = String(i);
                a.textContent = String(i);
                booksPager.appendChild(a);
            }
        }
    }
    booksPager?.addEventListener('click', (e) => {
        const a = e.target.closest('a.page-btn');
        if (!a) return;
        e.preventDefault();
        const p = Number(a.dataset.page || '1');
        if (p >= 1 && p <= paging.pages){
            paging.page = p;
            renderBooksPage();
        }
    });
    function ensureBooksSaveButton(){
        let saveBtn = document.getElementById(BOOKS_SAVE_BTN_ID);
        if (!saveBtn){
            saveBtn = document.createElement('button');
            saveBtn.id = BOOKS_SAVE_BTN_ID;
            saveBtn.type = 'button';
            saveBtn.textContent = '저장';
            saveBtn.className = 'btn btn-accent btn--glass';
            // 저장 버튼을 '닫기' 버튼 바로 앞에 배치 → [저장][닫기] 순서
            const container = (booksModalFooter || booksList.parentElement);
            const closeBtn  = document.getElementById('booksModalClose');
            if (container && closeBtn && closeBtn.parentElement === container) {
                container.insertBefore(saveBtn, closeBtn);
                } else {
                    container.appendChild(saveBtn);
                }
        }

        saveBtn.onclick = async () => {
            saveBtn.disabled = true;
            try {
                // 전체 선택 상태 vs 원본 상태를 비교 (페이지와 무관)
                const toAdd = [];
                const toRemove = [];

                // 추가: selected - original
                selectedBookIds.forEach(id => { if (!originalLinkedIds.has(id)) toAdd.push(id); });
                // 제거: original - selected
                originalLinkedIds.forEach(id => { if (!selectedBookIds.has(id)) toRemove.push(id); });

                for (const id of toAdd) {
                    const r = await fetch(`${ctx}/admin/hashtags/${currentManageHashtagId}/books/${id}`, { method: 'POST' });
                    if (!r.ok) console.error('추가 실패', id);
                }
                for (const id of toRemove) {
                    const r = await fetch(`${ctx}/admin/hashtags/${currentManageHashtagId}/books/${id}`, { method: 'DELETE' });
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
    }

});
