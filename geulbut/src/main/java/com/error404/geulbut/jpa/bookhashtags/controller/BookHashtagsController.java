package com.error404.geulbut.jpa.bookhashtags.controller;

import com.error404.geulbut.jpa.bookhashtags.dto.BookHashtagsDto;
import com.error404.geulbut.jpa.bookhashtags.service.BookHashtagsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
public class BookHashtagsController {

    private final BookHashtagsService bookHashtagsService;

    @GetMapping("/book-hashtags")
    public String viewAll(Model model,
                          @RequestParam(required = false) Long bookId,
                          @RequestParam(required = false) Long hashtagId) {

        if (bookId != null) {
            model.addAttribute("bookHashtagsByBook", bookHashtagsService.getByBookId(bookId));
            model.addAttribute("bookId", bookId); // <--- 여기 추가
        }
        if (hashtagId != null) {
            model.addAttribute("bookHashtagsByHashtag", bookHashtagsService.getByHashtagId(hashtagId));
            model.addAttribute("hashtagId", hashtagId); // <--- 여기 추가
        }

        return "bookhashtags/book_hashtags_all";
    }

}