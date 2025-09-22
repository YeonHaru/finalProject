console.log('[search_results] loaded');


(function () {
    const checkAll = document.getElementById('checkAll');
    const itemChecks = Array.from(document.querySelectorAll('.srch-item input[type="checkbox"][name="selected"]'));

    if (checkAll) {
        checkAll.addEventListener('change', () => {
            itemChecks.forEach(chk => chk.checked = checkAll.checked);
        });
    }
    itemChecks.forEach(chk => {
        chk.addEventListener('change', () => {
            if (!chk.checked && checkAll) checkAll.checked = false;
            if (itemChecks.every(c => c.checked) && checkAll) checkAll.checked = true;
        });
    });

    document.addEventListener('click', (e) => {
        const btn = e.target.closest('[data-act]');
        if (!btn) return;
        const act = btn.dataset.act;
        const id = btn.dataset.id;
        alert(`'${act}' 처리: ${id}`);
    });

    document.querySelectorAll('[data-bulk]').forEach(btn => {
        btn.addEventListener('click', () => {
            const selected = itemChecks.filter(c => c.checked).map(c => c.value);
            if (selected.length === 0) { alert('선택된 도서가 없습니다.'); return; }
            alert(`일괄 '${btn.dataset.bulk}' 처리: ${selected.join(', ')}`);
        });
    });
})();
