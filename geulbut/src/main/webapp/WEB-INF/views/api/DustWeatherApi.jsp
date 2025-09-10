<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>날씨 & 미세먼지</title>
    <style>
        /* 왼쪽 상단 고정 Ticker */
        #weather-dust-header {
            position: fixed;
            top: 5px;
            left: 5px;
            font-size: 12px;
            line-height: 1.2em;
            padding: 3px 6px;
            background: rgba(255,255,255,0.9);
            border-radius: 4px;
            box-shadow: 0 0 3px rgba(0,0,0,0.3);
            z-index: 9999;
        }
    </style>
</head>
<body>

<div id="weather-dust-header">불러오는 중...</div>

<script>
    document.addEventListener("DOMContentLoaded", async function() {
        const header = document.getElementById('weather-dust-header');
        const items = [];

        try {
            console.log("=== Ticker API 호출 시작 ===");

            // REST API 호출
            const [weatherRes, dustRes] = await Promise.all([
                fetch('/weatherApi'),
                fetch('/dustApi')
            ]);

            if (!weatherRes.ok) throw new Error(`weatherApi 오류: ${weatherRes.status}`);
            if (!dustRes.ok) throw new Error(`dustApi 오류: ${dustRes.status}`);

            const weatherList = await weatherRes.json(); // [{districtName, weather}, ...]
            const dustData = await dustRes.json();       // { "서울":"좋음", ... }

            console.log("weatherList:", weatherList);
            console.log("dustData:", dustData);

            if (!Array.isArray(weatherList) || weatherList.length === 0) {
                header.textContent = "데이터 없음";
                return;
            }

            // 가나다 순 정렬
            weatherList.sort((a,b) => (a?.districtName||'').localeCompare(b?.districtName||'', 'ko-KR'));

            // items 배열에 안전하게 HTML 문자열 저장
            weatherList.forEach(w => {
                if (!w || !w.districtName) return;

                const region = w.districtName.trim();
                const weather = w.weather || '-';

                // dust 데이터 안전하게 가져오기
                let dust = dustData[region];
                if (!dust) {
                    const simpleRegion = region.replace(/(광역시|특별시|도|시)$/,'');
                    dust = dustData[simpleRegion] || '-';
                }

                console.log("region:", region, "weather:", weather, "dust:", dust);

                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = `<strong>${region}</strong> : ${weather}<br>미세먼지 : ${dust}`;
                items.push(tempDiv.innerHTML);
            });

            console.log("items 배열:", items);

            // 3초마다 순환 표시
            if (items.length > 0) {
                let index = 0;
                header.innerHTML = items[index];

                setInterval(() => {
                    index = (index + 1) % items.length;
                    header.innerHTML = items[index];
                    console.log("Ticker 업데이트:", items[index]);
                }, 3000);
            }

        } catch (err) {
            console.error("Ticker 에러:", err);
            header.textContent = "API 호출 실패";
        }
    });
</script>

</body>
</html>
