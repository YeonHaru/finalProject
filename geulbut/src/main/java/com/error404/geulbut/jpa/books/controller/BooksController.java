package com.error404.geulbut.jpa.books.controller;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.books.service.BooksService;
import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.service.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import java.util.Map;
import java.util.List;


@Log4j2
@Controller
@RequiredArgsConstructor
public class BooksController {

    private final BooksService booksService;
    private final UsersService usersService;
    private final BooksRepository booksRepository;
    private final MapStruct mapStruct;
  
  
    // application.yml(or properties)에 정의된 값. 없으면 imp_test로 기본(개발 임시) 세팅
    @Value("${portone.imp_code}")
    private String iamportCode;
    
    @GetMapping("/book/{bookId}")
    public String bookDetail(@PathVariable long bookId,
                             Model model,
                             Authentication authentication) {

        BooksDto book = booksService.findDetailByBookId(bookId);
        model.addAttribute("book", book);

        // 로그인 사용자 내려주기 (모달에 user.* 바인딩)
        if (authentication != null && authentication.isAuthenticated()) {
            String userId = authentication.getName();
            Users user = usersService.getUserById(userId);   // UsersService에 이미 존재하는 조회 메서드

            Map<String,Object> userinfo = Map.of(
                    "userId", user.getUserId(),
                    "userName", user.getName(),   // 여기서 JSP용으로 키 맞춰줌
                    "email", user.getEmail(),
                    "phone", user.getPhone(),
                    "address", user.getAddress()
            );
            model.addAttribute("user", userinfo);
        }

        // 아임포트 가맹점 코드(JS 초기화용)
        model.addAttribute("iamportCode", iamportCode);

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
