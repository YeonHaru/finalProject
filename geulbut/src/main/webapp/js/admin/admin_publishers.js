// /js/admin/admin_publishers.js  (기존 유지 + 모달 UX/안정성 보강)
$(function() {
    const $modal = $('#publisherModal');
    const $modalTitle = $('#modalTitle');

    const $id   = $('#modalPublisherId');
    const $name = $('#modalPublisherName');
    const $desc = $('#modalPublisherDescription');

    // (선택) ctx 지원
    const ctx = (typeof window.ctx !== 'undefined' && window.ctx) ? window.ctx : '';

    // 공통 알림
    function showMessage(msg) { alert(msg); }

    // 모달 열고/닫기
     function openModal() {
           $modal.css('display','flex').attr('aria-hidden','false');
         }

    function closeModal() {
        $modal.hide().attr('aria-hidden','true');
    }

    // 배경 클릭/ESC 닫기 + 닫기 버튼 2종
    $modal.off('click').on('click', function(e){ if (e.target.id === 'publisherModal') closeModal(); });
    $(document).off('keydown.pubEsc').on('keydown.pubEsc', function(e){ if (e.key === 'Escape') closeModal(); });
    $('#btnCloseModal, #btnCancel').off('click').on('click', closeModal);

    // 등록 모달 열기 (위임 바인딩)
    $(document).off('click.pubAdd', '#btnAddPublisher').on('click.pubAdd', '#btnAddPublisher', function() {
        $modalTitle.text('출판사 등록');
        $id.val(''); $name.val(''); $desc.val('');
        openModal();
    });

    // 수정 모달 열기 (위임 바인딩, 기존 클래스 유지: .btn-edit)
     $(document).off('click.pubEdit', '.btnEdit, .btn-edit')
       .on('click.pubEdit', '.btnEdit, .btn-edit', function () {
        const $row = $(this).closest('tr');
        const id   = $row.data('id');
        const name = $row.find('.publisher-name').text();
        const desc = $row.find('.publisher-description').text();

        $modalTitle.text('출판사 수정');
        $id.val(id); $name.val(name); $desc.val(desc);
        openModal();
    });

    // 저장 (등록/수정) — 기존 구조 유지
    $('#publisherForm').off('submit').on('submit', function(e){
        e.preventDefault();

        const id = $id.val();
        const data = {
            name: ($name.val()||'').trim(),
            description: ($desc.val()||'').trim()
        };
        if (!data.name) { showMessage('출판사 이름을 입력하세요.'); $name.focus(); return; }

        const url = id ? `${ctx}/admin/publishers/${id}` : `${ctx}/admin/publishers`;
        const method = id ? 'PUT' : 'POST';

        const $btn = $('#modalSaveBtn').prop('disabled', true);
        $.ajax({
            url, method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(){ showMessage(id ? '수정 완료' : '등록 완료'); location.reload(); },
            error: function(xhr){
                const msg = (xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : (id ? '수정 실패' : '등록 실패');
                showMessage(msg);
            },
            complete: function(){ $btn.prop('disabled', false); }
        });
    });

    // 삭제 — 기존 클래스 유지: .btn-delete (위임 바인딩)
     $(document).off('click.pubDelete', '.btn-delete, .btnDelete')
       .on('click.pubDelete', '.btn-delete, .btnDelete', function () {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        const id = $(this).closest('tr').data('id');
        $.ajax({
            url: `${ctx}/admin/publishers/${id}`,
            method: 'DELETE',
            success: function(){ showMessage('삭제 완료'); location.reload(); },
            error: function(){ showMessage('삭제 실패'); }
        });
    });

    // 검색/페이징 — JSP의 form/버튼 제출 그대로 활용(필요시 아래 주석 해제)
    // $('#publisherSearchForm').on('submit', function(){ /* 기본 GET 유지 */ });
});
