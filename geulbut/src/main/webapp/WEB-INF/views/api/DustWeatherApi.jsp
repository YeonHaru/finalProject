<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>오늘의 날씨 & 미세먼지</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 16px; }

        /* 헤더 왼쪽 상단 고정 */
        #weather-dust-header {
            position: fixed;
            top: 5px;
            left: 5px;
            font-size: 12px;
            padding: 3px 6px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 4px;
            z-index: 9999;
            box-shadow: 0 0 3px rgba(0,0,0,0.3);
        }

        /* 전체 ticker 스타일 */
        .ticker-item {
            padding: 6px 10px;
            margin-bottom: 6px;
            border-radius: 6px;
            background-color: lightblue;
        }
        .region-name {
            font-weight: bold;
        }
    </style>
</head>
<body>

<div id="weather-dust-header">불러오는 중...</div>



<script>
    document.addEventListener("DOMContentLoaded", async function () {
        const headerTicker = document.getElementById('weather-dust-header');
        const items = [];

        try {
            console.log("API 호출 시작...");

            // 1) 두 API 동시에 호출
            const [weatherRes, dustRes] = await Promise.all([fetch('/weatherApi'), fetch('/dustApi')]);
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


            weatherList.forEach((w, idx) => {
                if (!w || !w.districtName) return;

                const region = w.districtName.trim();
                const weather = w.weather || '-';

                // dust 매칭
                let dust = dustData[region];
                if (!dust) {
                    const norm = region.replace(/(광역시|특별시|도|시)$/, '');
                    dust = dustData[norm] || '-';
                }

                // 1) DOM 블록 생성 (날씨/미세먼지 별도)
                const div = document.createElement('div');
                div.className = 'ticker-item';
                div.innerHTML = '<div class="region-name">' + region + ' : ' + weather + '</div>' +
                    '<div>미세먼지 : ' + dust + '</div>';


                // 2) 헤더 ticker용 배열에도 추가
                items.push(div.innerHTML);
            });

            console.log("items 배열:", items);

            // 3) 헤더 3초마다 순환
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

        }
    });

</script>

</body>
</html>
