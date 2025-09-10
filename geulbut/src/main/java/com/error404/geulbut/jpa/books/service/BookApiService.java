package com.error404.geulbut.jpa.books.service;

import com.error404.geulbut.jpa.books.dto.BookApiDto;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookApiService {

    @Value("${api.key}")
    private String apiKey;
    @Value("${api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public List<BookApiDto> fetchBooks(String keyword,
                                       Integer pageNum,
                                       Integer pageSize,
                                       String systemType,
                                       String govYn) throws Exception {

        // 1) 쿼리 파라미터로 URL 구성 (자동 인코딩 처리됨)
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(apiUrl)
                .queryParam("key", apiKey)                                  // 발급키(필수)
                .queryParam("apiType", "json")                       // 응답 형식
                .queryParam("srchTarget", "total")                   // 검색 대상: 제목
                .queryParam("kwd", keyword)                                 // 검색어
                .queryParam("pageNum", pageNum == null ? 1 : pageNum)
                .queryParam("pageSize", pageSize == null ? 10 : pageSize);

        String url = builder.toUriString(); // 최종 URL

        // 3) API 호출 (원문 JSON)
        String json = restTemplate.getForObject(url, String.class);
        System.out.println("API 최종 요청 URL: " + url);
        System.out.println("API 응답 원본: " + json);
        // 4) JSON 파싱 → DTO 매핑 (필요한 필드만)
        //    ObjectMapper는 JSON 데이터를 자바 객체로 변환해 주는 도구
        //    mapper.readTree(json) : JSON 문자열을 트리(Tree) 구조로 변환(파일 시스템의 폴더처럼 계층적으로 탐색할 수 있게 )
        //    .path("docs"): 변환된 JSON 트리에서 **docs라는 이름의 노드 찾기
        ObjectMapper mapper = new ObjectMapper();
        JsonNode resultArray = mapper.readTree(json).path("result");

        List<BookApiDto> result = new ArrayList<>();
        for (JsonNode item : resultArray) {
            result.add(new BookApiDto(
                    item.path("titleInfo").asText(""),      // 제목
                    item.path("authorInfo").asText(""),     // 저자
                    item.path("pubInfo").asText(""),        // 발행자
                    item.path("pubYearInfo").asText(""),    // 발행년도
                    item.path("imageUrl").asText(""),      // 응답에 없으면 빈 문자열 처리
                    item.path("description").asText("")     // 응답에 없으면 빈 문자열 처리
            ));
        }

        return result;
    }
}
