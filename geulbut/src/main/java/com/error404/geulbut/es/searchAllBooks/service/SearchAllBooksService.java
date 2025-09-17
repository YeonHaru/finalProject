
package com.error404.geulbut.es.searchAllBooks.service;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
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
