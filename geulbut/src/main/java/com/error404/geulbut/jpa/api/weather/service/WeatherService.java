package com.error404.geulbut.jpa.api.weather.service;

import com.error404.geulbut.jpa.api.weather.dto.WeatherDto;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RequiredArgsConstructor
@Service
public class WeatherService {

    private final RestTemplate restTemplate;

    @Value("${kdhc.weather.url}")
    private String weatherUrl;

    @Value("${kdhc.weather.key}")
    private String weatherKey;

    // 🔹 캐시 저장소
    private final Map<String, List<Map<String, String>>> weatherCache = new HashMap<>();
    private String lastBaseDate;
    private String lastBaseTime;

    /**
     * 전국 주요 17개 지역 nx/ny 좌표
     */
    private static final Map<String, String[]> REGION_COORDS = Map.ofEntries(
            Map.entry("서울", new String[]{"60", "127"}),
            Map.entry("부산", new String[]{"98", "76"}),
            Map.entry("대구", new String[]{"83", "105"}),
            Map.entry("인천", new String[]{"55", "124"}),
            Map.entry("광주", new String[]{"58", "74"}),
            Map.entry("대전", new String[]{"67", "100"}),
            Map.entry("울산", new String[]{"102", "91"}),
            Map.entry("세종", new String[]{"67", "100"}), // 대전과 동일 좌표
            Map.entry("경기", new String[]{"61", "128"}),
            Map.entry("강원", new String[]{"73", "134"}),
            Map.entry("충북", new String[]{"80", "110"}),
            Map.entry("충남", new String[]{"68", "102"}),
            Map.entry("전북", new String[]{"73", "101"}),
            Map.entry("전남", new String[]{"51", "67"}),
            Map.entry("경북", new String[]{"102", "94"}),
            Map.entry("경남", new String[]{"95", "77"}),
            Map.entry("제주", new String[]{"52", "38"})
    );

    /**
     * 단기예보 조회 (nx, ny 기준)
     * TMP, PTY, SKY 등 모든 카테고리 항목을 가져옴
     */
    public List<WeatherDto> getShortWeather(String nx, String ny, String baseDate, String baseTime) {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(weatherUrl + "/getVilageFcst")
                    .queryParam("ServiceKey", weatherKey)
                    .queryParam("pageNo", 1)
                    .queryParam("numOfRows", 1000)
                    .queryParam("dataType", "JSON")
                    .queryParam("base_date", baseDate)
                    .queryParam("base_time", baseTime)
                    .queryParam("nx", nx)
                    .queryParam("ny", ny)
                    .build(true)
                    .toUri();

            String result = restTemplate.getForObject(uri, String.class);

            if (result == null || result.trim().startsWith("<")) {
                return Collections.emptyList();
            }

            ObjectMapper mapper = new ObjectMapper();
            JsonNode items;
            try {
                items = mapper.readTree(result)
                        .path("response")
                        .path("body")
                        .path("items")
                        .path("item");
            } catch (JsonParseException e) {
                e.printStackTrace();
                return Collections.emptyList();
            }

            List<WeatherDto> list = new ArrayList<>();
            if (items.isArray()) {
                for (JsonNode item : items) {
                    WeatherDto dto = new WeatherDto();
                    dto.setNx(item.path("nx").asText());
                    dto.setNy(item.path("ny").asText());
                    dto.setFcstDate(item.path("fcstDate").asText());
                    dto.setFcstTime(item.path("fcstTime").asText());
                    dto.setCategory(item.path("category").asText());
                    dto.setValue(item.path("fcstValue").asText());
                    list.add(dto);
                }
            }
            return list;

//         에러 로그가 너무 많이 떠서 한줄로 압축 하겠습니다.
        } catch (Exception e) {
            System.out.println("Weather API 접속 실패: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            return Collections.emptyList();
        }

//      Api 복구전까진 주석으로 막아 두겠습니다.
//        } catch (Exception e) {
//            e.printStackTrace();
//            return Collections.emptyList();
//        }
    }

    /**
     * 전국 주요 지역 날씨 요약
     */
    public List<Map<String, String>> getWeatherSummaryList(String baseDate) {
        if (baseDate == null || baseDate.isEmpty()) {
            baseDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        }

        int currentHour = LocalTime.now().getHour();
        int[] forecastTimes = {2, 5, 8, 11, 14, 17, 20, 23};
        int targetTime = 2;
        for (int t : forecastTimes) {
            if (currentHour >= t) targetTime = t;
        }
        String baseTime = String.format("%02d00", targetTime);

        String cacheKey = baseDate + "_" + baseTime;

        // 🔹 캐시 확인
        if (cacheKey.equals(lastBaseDate + "_" + lastBaseTime) && weatherCache.containsKey(cacheKey)) {
            return weatherCache.get(cacheKey);
        }

        List<Map<String, String>> summaryList = new ArrayList<>();

        for (Map.Entry<String, String[]> entry : REGION_COORDS.entrySet()) {
            String region = entry.getKey();
            String nx = entry.getValue()[0];
            String ny = entry.getValue()[1];

            List<WeatherDto> list = getShortWeather(nx, ny, baseDate, baseTime);

            // list가 비어있으면 이전 forecastTime 순회
            if (list.isEmpty()) {
                for (int i = forecastTimes.length - 1; i >= 0; i--) {
                    String prevTime = String.format("%02d00", forecastTimes[i]);
                    if (prevTime.equals(baseTime)) continue; // 현재 시간 제외
                    list = getShortWeather(nx, ny, baseDate, prevTime);
                    if (!list.isEmpty()) break;
                }
            }

            // 각 항목을 별도로 가장 근접한 fcstTime으로 선택
            String tmp = findClosestCategory(list, baseTime, "TMP");
            String pty = findClosestCategory(list, baseTime, "PTY");
            String sky = findClosestCategory(list, baseTime, "SKY");

            String weatherState = parseWeather(pty, sky);
            String value = (tmp != null ? tmp + "°C" : "정보 없음") + " " + weatherState;

            Map<String, String> map = new LinkedHashMap<>();
            map.put("districtName", region);
            map.put("weather", value);
            map.put("forecastTime", baseTime); // 추가: 이 데이터가 기준이 된 시간
            summaryList.add(map);
        }
//      9/19일 15:12분 추가
//        api데이터가 전부 알수없음으로 내려오면 캐싱안함
//        데이터가 한곳이라도 찍히면 그 데이터는 캐싱됨 (새로고침을 해도 캐싱된 데이터가 찍히게 수정함)
        // 🔹 캐시에 저장 (정상 데이터가 있는 경우에만)
        boolean onlyUnknown = summaryList.stream()
                .allMatch(map -> map.get("weather").contains("알수없음"));
        if (!onlyUnknown) {
            weatherCache.put(cacheKey, summaryList);
            lastBaseDate = baseDate;
            lastBaseTime = baseTime;
        }

        return summaryList;
    }

    /**
     * 특정 카테고리(TMP, PTY, SKY)에서 가장 가까운 fcstTime 값 찾기
     */
    private String findClosestCategory(List<WeatherDto> list, String baseTime, String category) {
        String value = null;
        int minDiff = Integer.MAX_VALUE;
        int targetTime = Integer.parseInt(baseTime);

        for (WeatherDto dto : list) {
            if (!category.equals(dto.getCategory())) continue;
            int fcstTime = Integer.parseInt(dto.getFcstTime());
            int diff = Math.abs(fcstTime - targetTime);
            if (diff < minDiff) {
                minDiff = diff;
                value = dto.getValue();
            }
        }
        return value;
    }

    /**
     * PTY + SKY → 날씨 문자열 변환
     */
    private String parseWeather(String pty, String sky) {
        if (pty != null) {
            switch (pty) {
                case "0": // 강수 없음 → SKY 확인
                    if (sky != null) {
                        switch (sky) {
                            case "1": return "맑음";
                            case "3": return "구름많음";
                            case "4": return "흐림";
                        }
                    }
                    return "맑음";
                case "1": return "비";
                case "2": return "비/눈";
                case "3": return "눈";
                case "4": return "소나기";
            }
        }
        return "알수없음";
    }
}
