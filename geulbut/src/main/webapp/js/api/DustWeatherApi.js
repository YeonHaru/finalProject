document.addEventListener("DOMContentLoaded", async function () {
    const headerTicker = document.getElementById('weather-dust-header');
    const items = [];

    try {
        console.log("API 호출 시작...");

        // 1) 두 API 동시에 호출
        const [weatherRes, dustRes] = await Promise.all([
            fetch('/weatherApi'),
            fetch('/dustApi')
        ]);
        console.log("weatherRes:", weatherRes);
        console.log("dustRes:", dustRes);

        if (!weatherRes.ok) throw new Error('weather API 응답 오류: ' + weatherRes.status);
        if (!dustRes.ok) throw new Error('dust API 응답 오류: ' + dustRes.status);

        const weatherList = await weatherRes.json(); // [{districtName, weather}, ...]
        const dustData = await dustRes.json();       // { "서울": "좋음", ... }

        console.log("weatherList JSON:", weatherList);
        console.log("dustData JSON:", dustData);

        // 2) 가나다 순 정렬
        weatherList.sort((a, b) => (a?.districtName || '').localeCompare(b?.districtName || '', 'ko-KR'));
        console.log("가나다 순 정렬 후:", weatherList);

        // 3) 아이템 배열 생성
        weatherList.forEach((w) => {
            if (!w || !w.districtName) return;

            const region = w.districtName.trim();
            const weather = w.weather || '-';

            // dust 매칭
            let dust = dustData[region];
            if (!dust) {
                const norm = region.replace(/(광역시|특별시|도|시)$/, '');
                dust = dustData[norm] || '-';
            }

            const div = document.createElement('div');
            div.className = 'ticker-item';
            div.innerHTML = '<div class="region-name">' + region + ' : ' + weather + '</div>' +
                '<div>미세먼지 : ' + dust + '</div>';

            items.push(div.innerHTML);
        });

        console.log("items 배열:", items);

        // 4) 헤더 3초마다 순환
        if (items.length > 0) {
            let index = 0;
            headerTicker.innerHTML = items[index];
            setInterval(() => {
                index = (index + 1) % items.length;
                headerTicker.innerHTML = items[index];
                console.log("헤더 ticker 업데이트:", items[index]);
            }, 3000);
        }

    } catch (err) {
        console.error('API 호출 에러:', err);
        headerTicker.textContent = "API 호출 실패";
    }
});
