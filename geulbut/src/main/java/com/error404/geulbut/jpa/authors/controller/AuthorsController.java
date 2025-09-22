package com.error404.geulbut.jpa.authors.controller;


import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.service.AuthorsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Log4j2
@Controller
@RequiredArgsConstructor
public class AuthorsController {

//  AuthorsService 가져오기
    private final AuthorsService authorsService;

    //	전체조회
    @GetMapping("/authors")
    public String selectDeptList(@PageableDefault(page = 0, size = 3) Pageable pageable,
                                  Model model) {

        Page<AuthorsDto> pages=authorsService.findAllAuthors(pageable);
        log.info("테스트 : "+pages);
        model.addAttribute("authors", pages.getContent());
        model.addAttribute("pages", pages);

        return "authors/authors_all";
    }
}
