
(() => {
    const $form = document.getElementById('signupForm');
    if (!$form) return;

    const $postcode = document.getElementById('postcode');
    const $roadAddress = document.getElementById('roadAddress');
    const $jibunAddress = document.getElementById('jibunAddress');
    const $detailAddress = document.getElementById('detailAddress');
    const $extraAddress = document.getElementById('extraAddress');
    const $hiddenAddress = document.getElementById('address'); // 서버 제출용

    const $btnFind = document.getElementById('btnFindAddress');

    function assembleHiddenAddress() {
        // 제출용 address 문자열 조립 (도로명 기준, 상세/참고/지번 포함)
        const parts = [];
        if ($roadAddress.value) parts.push($roadAddress.value);
        if ($detailAddress.value) parts.push($detailAddress.value);
        if ($extraAddress.value) parts.push(`(${ $extraAddress.value })`);
        if ($jibunAddress.value) parts.push(`[지번:${ $jibunAddress.value }]`);
        if ($postcode.value) parts.push(`우편번호:${ $postcode.value }`);

        $hiddenAddress.value = parts.join(' ');
    }

    // 상세주소 입력 시에도 hidden 최신화
    $detailAddress?.addEventListener('input', assembleHiddenAddress);

    // 카카오 우편번호 팝업 호출
    function openPostcode() {
        // 카카오 라이브러리 가드
        if (!window.daum || !daum.Postcode) {
            alert('주소 검색 스크립트를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.');
            return;
        }

        new daum.Postcode({
            oncomplete: function(data) {
                // data 구조: https://postcode.map.daum.net/guide 참고
                // 1) 기본 도로명 주소/지번 주소
                const roadAddr = data.roadAddress || '';
                const jibunAddr = data.jibunAddress || '';

                // 2) 참고항목(법정동/건물명 등)
                let extra = '';
                if (data.bname && /[동|로|가]$/g.test(data.bname)) { extra += data.bname; }
                if (data.buildingName && data.apartment === 'Y') {
                    extra += (extra ? ', ' : '') + data.buildingName;
                }

                // 3) 채우기
                $postcode.value = data.zonecode || '';
                $roadAddress.value = roadAddr;
                $jibunAddress.value = jibunAddr;
                $extraAddress.value = extra;

                // 4) 상세주소 포커스 & hidden 최신화
                $detailAddress.focus();
                assembleHiddenAddress();
            },
            // 모바일 환경에서 화면 꽉 차게: false면 레이어, true면 새창
            // Kakao 기본은 레이어/팝업 자동 선택. 필요 시 theme, width/height 옵션도 가능.
        }).open();
    }

    $btnFind?.addEventListener('click', openPostcode);

    // 폼 제출 직전에도 최종 병합(안전장치)
    $form.addEventListener('submit', assembleHiddenAddress);
})();
