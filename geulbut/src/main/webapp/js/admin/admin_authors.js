// admin_authors_list.js (최소 수정 안정화 버전)
console.log('[authors] JS loaded?', new Date().toISOString());
$(document).on('click', '#btnAddAuthor', () => console.log('[authors] Add clicked'));
$(document).on('click', '.btnEdit',      () => console.log('[authors] Edit clicked'));

$(function () {
    // ====== 캐시 ======
    const $modal = $('#authorModal');
    const $modalTitle = $('#modalTitle');
    const $id   = $('#modalAuthorId');
    const $name = $('#modalAuthorName');
    const $img  = $('#modalAuthorImgUrl');
    const $created = $('#modalAuthorCreatedAt');
    const $desc = $('#modalAuthorDescription');
    const $preview = $('#modalAuthorImgPreview');

    // 선택: 컨텍스트 경로(있으면 사용)
    const ctx = (typeof window.ctx !== 'undefined' && window.ctx) ? window.ctx : '';

    // ====== 이미지 미리보기 (디바운스) ======
    let previewTimer = null;
    $img.on('input', function () {
        const url = $(this).val().trim();
        clearTimeout(previewTimer);
        previewTimer = setTimeout(() => { $preview.attr('src', url || ''); }, 120);
    });

    // ====== 공통: 모달 열고 닫기 ======
    function openModal() {
        // jQuery .show() 우선, 혹시 CSS 충돌 시 display 강제
        $modal.show().css('display', 'block').attr('aria-hidden', 'false');
    }
    function closeModal() {
        $modal.hide().attr('aria-hidden', 'true');
    }

    // 배경 클릭/ESC 닫기
    $modal.off('click').on('click', function (e) {
        if (e.target.id === 'authorModal') closeModal();
    });
    $(document).off('keydown.adminAuthorsEsc').on('keydown.adminAuthorsEsc', function (e) {
        if (e.key === 'Escape') closeModal();
    });
    // 닫기 버튼 2종 모두
    $('#btnCloseModal, #modalCloseBtn2').off('click').on('click', closeModal);

    // ====== 등록 모달 열기 (위임 바인딩) ======
    $(document).off('click.openAuthorCreate', '#btnAddAuthor, #btnAdd')
        .on('click.openAuthorCreate', '#btnAddAuthor, #btnAdd', function () {
            $modalTitle.text('작가 등록');
            $id.val('');
            $name.val('');
            $img.val('');
            $created.val('');     // 등록 시 빈 값
            $desc.val('');
            $preview.attr('src', '');
            openModal();
        });

    // ====== 수정 모달 열기 (위임 바인딩 + 클래스명 일치: .btnEdit) ======
    $(document).off('click.openAuthorEdit', '.btnEdit')
        .on('click.openAuthorEdit', '.btnEdit', function () {
            const $tr = $(this).closest('tr');
            const row = {
                id:        ($tr.data('id') || '').toString(),
                name:      ($tr.data('name') || '').toString(),
                imgUrl:    ($tr.data('imgurl') || '').toString(),
                createdAt: ($tr.data('createdat') || $tr.find('.created-at-cell').text() || '').toString(),
                desc:      ($tr.data('description') || '').toString()
            };

            $modalTitle.text('작가 수정');
            $id.val(row.id);
            $name.val(row.name);
            $img.val(row.imgUrl);
            $created.val(row.createdAt);
            $desc.val(row.desc);
            $preview.attr('src', row.imgUrl);

            openModal();
        });

    // ====== 저장(등록/수정) ======
    $('#modalSaveBtn').off('click').on('click', function () {
        const authorId = $id.val();
        const payload = {
            name: ($name.val() || '').trim(),
            description: ($desc.val() || '').trim(),
            imgUrl: ($img.val() || '').trim()
        };

        if (!payload.name) { alert('작가명을 입력해주세요.'); $name.focus(); return; }
        if (payload.imgUrl) {
            try { new URL(payload.imgUrl); } catch (e) { alert('이미지 URL 형식이 올바르지 않습니다.'); $img.focus(); return; }
        }

        const url = authorId ? `${ctx}/admin/authors/${authorId}` : `${ctx}/admin/authors`;
        const method = authorId ? 'PUT' : 'POST';

        const $btn = $(this).prop('disabled', true);
        $.ajax({
            url, method,
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function () {
                alert('저장 완료');
                location.reload();
            },
            error: function (xhr) {
                const msg = (xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : '저장 실패';
                alert(msg);
            },
            complete: function () { $btn.prop('disabled', false); }
        });
    });

    // ====== 삭제 (위임 바인딩 + 클래스명 일치: .btnDelete) ======
    $(document).off('click.authorDelete', '.btnDelete')
        .on('click.authorDelete', '.btnDelete', function () {
            const id = $(this).closest('tr').data('id');
            if (!id) return;
            if (!confirm('정말 삭제하시겠습니까?')) return;

            $.ajax({
                url: `${ctx}/admin/authors/${id}`,
                method: 'DELETE',
                success: function () { alert('삭제 완료'); location.reload(); },
                error: function () { alert('삭제 실패'); }
            });
        });

    // ====== 검색/페이징 (기존 유지) ======
    $('#authorSearchForm').on('submit', function () {/* 기본 submit 유지 */});
});
