package com.error404.geulbut.jpa.books.controller;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.books.service.BooksService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
public class BooksController {


    private final BooksService booksService;
    private final BooksRepository booksRepository;
    private final MapStruct mapStruct;

    @GetMapping("/book/{bookId}")
    public String bookDetail(@PathVariable long bookId, Model model) {
        BooksDto booksDto = booksService.findDetailByBookId(bookId);
        model.addAttribute("book", booksDto);
        return "books/book_detail";
    }

    @GetMapping("/books/search")
    public String searchBooksByAuthor(String q, Model model) {
        List<BooksDto> books;

        if (q != null && !q.isEmpty()) {
            // 작가 이름으로 책 검색
            books = booksRepository.findByAuthorNameContaining(q)
                    .stream()
                    .map(mapStruct::toDto)
                    .toList();
        } else {
            books = List.of(); // 빈 리스트
        }

        model.addAttribute("books", books);
        model.addAttribute("keyword", q); // 검색창에 표시
        return "authors/authors_search"; // JSP
    }

}
