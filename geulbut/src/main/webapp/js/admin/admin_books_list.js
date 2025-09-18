(function($){
    const $modal = $('#bookModal');
    const $form  = $('#bookForm');
    const $title = $('#title');
    const $isbn  = $('#isbn');
    const $price = $('#price');
    const $stock = $('#stock');
    const $bookId= $('#bookId');

    const $author = $('#authorId');
    const $publisher = $('#publisherId');
    const $category = $('#categoryId');

    // ---------- 공통: 모달 ----------
    function openModal(titleText){
        $('#modalTitle').text(titleText || '도서 등록');
        $modal.addClass('is-open').attr('aria-hidden', 'false');
    }
    function closeModal(){
        $modal.removeClass('is-open').attr('aria-hidden', 'true');
    }

    $('#btnAddBook').on('click', function(){
        // 초기화
        $form[0].reset();
        $bookId.val('');
        openModal('도서 등록');
    });

    $('#btnCloseModal, #btnCancel, [data-close-modal]').on('click', function(){
        closeModal();
    });

    $(document).on('keydown', function(e){
        if(e.key === 'Escape' && $modal.hasClass('is-open')) closeModal();
    });

    // ---------- 편집 ----------
    $('#booksTableBody').on('click', '.btnEdit', function(){
        const $tr = $(this).closest('tr');
        const id  = $tr.data('id');

        $bookId.val(id);
        $title.val($tr.data('title') || '');
        $isbn.val($tr.data('isbn') || '');
        $price.val($tr.data('price') || 0);
        $stock.val($tr.data('stock') || 0);

        // 선택값(저자/출판사/카테고리)은 서버에서 ID를 내려주고 셀렉트를 채워야 정확함.
        // data-*에 name만 있는 경우, 일단 리스트를 불러온 뒤 사용자가 다시 선택하도록 둡니다.
        // 옵션 자동 로딩(엔드포인트가 존재할 때만 동작)
        populateSelects().then(() => {
            // 만약 서버가 book의 authorId/publisherId/categoryId를 data-*로 내려준다면 아래처럼 preselect
            // $author.val($tr.data('authorid') || '');
            // $publisher.val($tr.data('publisherid') || '');
            // $category.val($tr.data('categoryid') || '');
        });

        openModal('도서 수정');
    });

    // ---------- 삭제 ----------
    $('#booksTableBody').on('click', '.btnDelete', function(){
        const $tr = $(this).closest('tr');
        const id  = $tr.data('id');
        if(!id) return;

        if(confirm(`이 도서를 삭제하시겠습니까? (#${id})`)){
            // 1순위: REST API가 있을 때 (DELETE /admin/books/{id})
            fetch(`${getCtx()}/admin/books/${id}`, {
                method: 'DELETE',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
                .then(res => {
                    if(res.ok){ location.reload(); return; }
                    // 2순위: 쿼리스트링 기반 엔드포인트로 폴백
                    location.href = `${getCtx()}/admin/books/delete?bookId=${id}`;
                })
                .catch(() => {
                    // 폴백
                    location.href = `${getCtx()}/admin/books/delete?bookId=${id}`;
                });
        }
    });

    // ---------- 저장 (등록/수정 공용) ----------
    $form.on('submit', function(e){
        e.preventDefault();

        const formData = new FormData($form[0]);
        const id = formData.get('bookId');
        const isEdit = !!(id && String(id).trim().length);

        // 1순위: REST API가 있을 때
        const url = isEdit ? `${getCtx()}/admin/books/${id}` : `${getCtx()}/admin/books`;
        const method = isEdit ? 'PUT' : 'POST';

        fetch(url, {
            method,
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
            body: isEdit ? JSON.stringify(toJson(formData)) : JSON.stringify(toJson(formData))
        })
            .then(res => {
                if(res.ok){ location.reload(); return; }
                // 2순위: 기존 폼 액션으로 포스트 (백엔드 기존 형태)
                $form.off('submit'); // 무한루프 방지
                $form[0].submit();
            })
            .catch(() => {
                // 폴백: 기존 폼 제출
                $form.off('submit');
                $form[0].submit();
            });
    });

    function toJson(fd){
        const obj = {};
        fd.forEach((v,k)=>{ obj[k]=v; });
        return obj;
    }

    function getCtx(){
        // JSP에서 header 포함 시, 보통 절대경로 사용이므로 contextPath 추정
        return window.location.pathname.startsWith('/')
            ? (document.body.getAttribute('data-ctx') || '')
            : '';
    }

    // ---------- 옵션 셀렉트(저자/출판사/카테고리) 자동 로딩 (엔드포인트 있을 때만) ----------
    async function populateSelects(){
        const tasks = [
            fillSelect($author),
            fillSelect($publisher),
            fillSelect($category),
        ];
        await Promise.allSettled(tasks);
    }

    async function fillSelect($select){
        const src = $select.attr('data-src');
        if(!src) return;
        try{
            const res = await fetch(src, { headers:{'X-Requested-With':'XMLHttpRequest'} });
            if(!res.ok) return;
            const list = await res.json();
            if(!Array.isArray(list)) return;

            // 기대형태: [{id:1, name:'...'}, ...] 혹은 [{authorId:1, name:'...'}]
            const idKey = Object.keys(list[0]||{}).find(k => /id$/i.test(k)) || 'id';
            const nameKey = Object.keys(list[0]||{}).find(k => /(name|title)/i.test(k)) || 'name';

            // 기존 옵션 초기화(첫 '선택' 유지)
            $select.find('option:not(:first)').remove();

            list.forEach(item=>{
                const opt = document.createElement('option');
                opt.value = item[idKey];
                opt.textContent = item[nameKey];
                $select.append(opt);
            });
        }catch(_e){ /* 엔드포인트 없으면 조용히 패스 */ }
    }

    // 초기화: 필요 시 옵션 미리 로딩
    // populateSelects();

})(jQuery);
