package com.error404.geulbut;


import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.service.BooksService;
import com.error404.geulbut.jpa.introduction.dto.IntroductionDto;
import com.error404.geulbut.jpa.introduction.service.IntroductionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
public class HomeController {
    private final IntroductionService introductionService;
    private final BooksService booksService;

    @GetMapping("/")
    public String home(Model model, @PageableDefault(page = 0, size = 4) Pageable pageable) {
        Page<IntroductionDto> pages = introductionService.getAllIntroductions(pageable);


        model.addAttribute("hotNews", booksService.getHotNewsBooks(
                List.of(157L, 42L, 15L)
        ));
        model.addAttribute("introductions", pages.getContent());
        model.addAttribute("featuredBooks", pages.getContent());
        model.addAttribute("bestSellers", booksService.getBestSellersTop10());
        return "home";
    }
}
