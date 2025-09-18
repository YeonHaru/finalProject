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

@Controller
@RequiredArgsConstructor
public class SearchAllBooksController {
    private final SearchAllBooksService searchAllBooksService;

    @GetMapping("/search")
    public String search(@RequestParam(defaultValue = "") String keyword,
                         @PageableDefault(page = 0, size = 10)Pageable pageable,
                         Model model) throws Exception {
        Page<SearchAllBooksDto> pages = searchAllBooksService.searchByTemplate(keyword, pageable);
        model.addAttribute("pages", pages);
        model.addAttribute("searches", pages.getContent());
        return "books/book_all";
    }
}
