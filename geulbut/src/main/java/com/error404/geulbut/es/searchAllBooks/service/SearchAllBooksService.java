
package com.error404.geulbut.es.searchAllBooks.service;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.SortOrder;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.SearchTemplateRequest;
import co.elastic.clients.elasticsearch.core.SearchTemplateResponse;
import co.elastic.clients.elasticsearch.core.search.Hit;
import co.elastic.clients.json.JsonData;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.es.searchAllBooks.dto.SearchAllBooksDto;
import com.error404.geulbut.es.searchAllBooks.entity.SearchAllBooks;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SearchAllBooksService {

    private static final String INDEX = "search-all-books";
    private static final String TEMPLATE_ID = "book_unified_search";

    private final ElasticsearchClient client;
    private final MapStruct mapStruct;

    /**
     * 전체 조회 (keyword가 빈 문자열일 때 사용)
     * - match_all + 정렬(updated_at desc 기준; 필드명은 환경에 맞게 변경)
     */
    public Page<SearchAllBooksDto> listAll(Pageable pageable) throws Exception {
        int size = pageable.getPageSize();
        int from = (int) pageable.getOffset();

        SearchRequest req = SearchRequest.of(b -> b
                .index(INDEX)
                .from(from)
                .size(size)
                .query(q -> q.matchAll(m -> m))
                // 정렬 정책: 최신 업데이트 순. 매핑에 맞게 필드명 교체 가능(e.g. "created_at", "published_at")
                .sort(s -> s.field(f -> f.field("updated_at").order(SortOrder.Desc)))
        );

        SearchResponse<SearchAllBooks> res = client.search(req, SearchAllBooks.class);

        List<SearchAllBooksDto> content = res.hits().hits().stream()
                .map(Hit::source)
                .filter(src -> src != null)
                .map(mapStruct::toDto)
                .toList();

        long total = (res.hits().total() != null) ? res.hits().total().value() : content.size();
        return new PageImpl<>(content, pageable, total);
    }


    /**
     * ES 저장 템플릿(book_unified_search) 호출
     * params: q, size, from  (템플릿 쪽에 모두 정의되어 있어야 함)
     */
    public Page<SearchAllBooksDto> searchByTemplate(String keyword, Pageable pageable) throws Exception {
        String q = (keyword == null) ? "" : keyword;
        int size = pageable.getPageSize();
        int from = (int) pageable.getOffset(); // page * size

        // 템플릿 파라미터 구성 es로 날리는 쿼리
        Map<String, JsonData> params = new HashMap<>();
        params.put("q", JsonData.of(q));
        params.put("size", JsonData.of(size));
        params.put("from", JsonData.of(from));

        SearchTemplateRequest req = SearchTemplateRequest.of(b -> b
                .index(INDEX)
                .id(TEMPLATE_ID)
                .params(params)
        );

        SearchTemplateResponse<SearchAllBooks> res =
                client.searchTemplate(req, SearchAllBooks.class);

        List<SearchAllBooksDto> content = res.hits().hits().stream()
                .map(Hit::source)
                .filter(src -> src != null)
                .map(mapStruct::toDto)
                .toList();

        long total = (res.hits().total() != null) ? res.hits().total().value() : content.size();

        return new PageImpl<>(content, pageable, total);
    }
}
