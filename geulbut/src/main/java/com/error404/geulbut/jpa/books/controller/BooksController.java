package com.error404.geulbut.jpa.books.controller;

import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.service.BooksService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Log4j2
@Controller
@RequiredArgsConstructor
public class BooksController {


    private final BooksService booksService;

    @GetMapping("/book/{bookId}")
    public String bookDetail(@PathVariable long bookId, Model model) {
        BooksDto booksDto = booksService.findDetailByBookId(bookId);
        model.addAttribute("book", booksDto);
        return "books/book_detail";
    }
}
