// src/main/java/com/error404/geulbut/es/searchAllBooks/controller/SearchAllBooksController.java
package com.error404.geulbut.es.searchAllBooks.controller;

import com.error404.geulbut.es.searchAllBooks.dto.SearchAllBooksDto;
import com.error404.geulbut.es.searchAllBooks.service.SearchAllBooksService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 통합검색 + 전체조회 컨트롤러 (ES 전용)
 * - keyword가 비어있으면 ES match_all(전체조회)
 * - keyword가 있으면 ES 검색 템플릿 실행
 *
 * JSP는 기존 book_all.jsp(또는 books/book_all.jsp)를 그대로 재사용:
 *   pages, searches, keyword, pageNumber(1-base), totalPages, startPage, endPage, size
 */
@Controller
@RequiredArgsConstructor
public class SearchAllBooksController {

    private final SearchAllBooksService searchAllBooksService;

    @GetMapping("/search")
    public String search(@RequestParam(defaultValue = "") String keyword,
                         @RequestParam(required = false) String sortField,
                         @RequestParam(required = false) String sortOrder,
                         @PageableDefault(page = 0, size = 10) Pageable pageable,
                         Model model) throws Exception {

        // 1) 검색어 정리
        final String kw = keyword == null ? "" : keyword.trim();

        String sf = (sortField == null ? "popularity_score" : sortField.trim().toLowerCase());
        if (!java.util.Set.of("popularity_score","sales_count","pub_date","created_at","price").contains(sf)) {
            sf = "popularity_score";
        }
        String so = (sortOrder == null ? "desc" : sortOrder.trim().toLowerCase());
        if (!java.util.Set.of("asc","desc").contains(so)) {
            so = "desc";
        }

        // 2) ES 호출: 비어있으면 전체조회(match_all), 있으면 검색
        Page<SearchAllBooksDto> pages = kw.isEmpty()
                ? searchAllBooksService.listAll(pageable)          // ★ 서비스에 match_all 구현
                : searchAllBooksService.searchByTemplate(kw, pageable);

        // 3) 페이징 값(표시용) 계산 — JSP가 1-base를 기대하므로 변환
        int pageZero = pages.getNumber();                 // 0-base
        int pageNumber = pageZero + 1;                    // 1-base
        int size = pages.getSize();
        int totalPages = Math.max(pages.getTotalPages(), 1);

        // 블록 페이징(예: 10페이지 단위)
        int blockSize = 10;
        int currentBlock = (pageNumber - 1) / blockSize;
        int startPage = currentBlock * blockSize + 1;     // 1-base
        int endPage = Math.min(startPage + blockSize - 1, totalPages);

        // 4) 모델 바인딩 — 기존 JSP 키와 100% 일치
        model.addAttribute("pages", pages);
        model.addAttribute("searches", pages.getContent());
        model.addAttribute("keyword", kw);
        model.addAttribute("pageNumber", pageNumber);     // 1-base
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("size", size);
        model.addAttribute("sortField", sf);
        model.addAttribute("sortOrder", so);

        return "books/book_all"; // 기존 JSP 경로 유지
    }

    /**
     * 선택사항: /books 로 들어오는 전체조회 요청을 /search로 합치고 싶을 때 사용
     * 예) /books?page=0&size=10 → /search?keyword=&page=0&size=10
     */
    @GetMapping("/books")
    public String listRedirect(@RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size) {
        return "redirect:/search?keyword=&page=" + page + "&size=" + size;
    }
}
