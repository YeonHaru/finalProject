package com.error404.geulbut.jpa.admin.controller;

import com.error404.geulbut.jpa.admin.service.AdminBooksService;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.categories.entity.Categories;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 관리자용 도서 관리 컨트롤러
 */
@RequiredArgsConstructor
@Controller
@RequestMapping("/admin/books")
@PreAuthorize("hasRole('ADMIN')")
public class AdminBooksController {

    private final AdminBooksService adminBooksService;

    // ================================
    // 1️⃣ 도서 목록 페이지 (JSP)
    // ================================
    @GetMapping
    public String listBooksPage(Model model,
                                @RequestParam(defaultValue = "0") int page,
                                @RequestParam(defaultValue = "10") int size) {

        Page<Books> booksPage = adminBooksService.getAllBooks(page, size);

        // Entity → DTO 변환 (Service 헬퍼 사용)
        List<BooksDto> dtoList = booksPage.getContent().stream()
                .map(adminBooksService::toDto)
                .collect(Collectors.toList());

        Page<BooksDto> dtoPage = new PageImpl<>(dtoList, booksPage.getPageable(), booksPage.getTotalElements());

        model.addAttribute("booksPage", dtoPage);
        return "admin/admin_books_list";
    }

    // ================================
    // 2️⃣ 단일 도서 조회 (REST API)
    // ================================
    @GetMapping("/{bookId}")
    @ResponseBody
    public ResponseEntity<BooksDto> getBookById(@PathVariable Long bookId) {
        Optional<Books> book = adminBooksService.getBookById(bookId);
        return book.map(adminBooksService::toDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ================================
    // 3️⃣ 도서 등록 (REST API)
    // ================================
    @PostMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createBook(@RequestBody BooksDto bookDto) {
        try {
            Books book = adminBooksService.fromDto(bookDto);
            Books savedBook = adminBooksService.saveBook(book);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "book", adminBooksService.toDto(savedBook)
            ));
        } catch (IllegalArgumentException e) {
            // ISBN 중복 등 예외 발생 시 상세 메시지를 반환
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        }
    }

    // ================================
    // 4️⃣ 도서 수정 (REST API)
    // ================================
    @PutMapping("/{bookId}")
    @ResponseBody
    public ResponseEntity<BooksDto> updateBook(@PathVariable Long bookId,
                                               @RequestBody BooksDto bookDto) {

        Books book = adminBooksService.getBookById(bookId)
                .orElseThrow(() -> new RuntimeException("Book not found"));

        // DTO → Entity 필드 세팅
        adminBooksService.updateFromDto(bookDto, book);

        Books updatedBook = adminBooksService.updateBook(book);
        return ResponseEntity.ok(adminBooksService.toDto(updatedBook));
    }

    // ================================
    // 5️⃣ 도서 삭제 (REST API)
    // ================================
    @DeleteMapping("/{bookId}")
    @ResponseBody
    public ResponseEntity<String> deleteBook(@PathVariable Long bookId) {
        boolean deleted = adminBooksService.deleteBook(bookId);
        return deleted ? ResponseEntity.ok("도서 삭제 완료")
                : ResponseEntity.badRequest().body("도서가 존재하지 않음");
    }

    // ================================
    // 6️⃣ 검색
    // ================================
    @GetMapping("/search")
    @ResponseBody
    public Page<BooksDto> searchBooks(@RequestParam(required = false) String keyword,
                                      @RequestParam(defaultValue = "0") int page,
                                      @RequestParam(defaultValue = "10") int size) {
        Page<Books> booksPage = adminBooksService.searchBooks(keyword, page, size);
        List<BooksDto> dtoList = booksPage.getContent().stream()
                .map(adminBooksService::toDto)
                .collect(Collectors.toList());
        return new PageImpl<>(dtoList, booksPage.getPageable(), booksPage.getTotalElements());
    }

    // ================================
    // 7️⃣ 모달용 select 옵션 데이터 제공
    // ================================
    @GetMapping("/options")
    @ResponseBody
    public ResponseEntity<BookOptionsResponse> getBookOptions() {
        List<Authors> authors = adminBooksService.getAllAuthors();
        List<Publishers> publishers = adminBooksService.getAllPublishers();
        List<Categories> categories = adminBooksService.getAllCategories();
        return ResponseEntity.ok(new BookOptionsResponse(authors, publishers, categories));
    }

    @Data
    @AllArgsConstructor
    static class BookOptionsResponse {
        private List<Authors> authors;
        private List<Publishers> publishers;
        private List<Categories> categories;
    }

    // ================================
    // 8️⃣ 수정 모달용: 단일 도서 + 전체 옵션
    // ================================
    @GetMapping("/{bookId}/edit-options")
    @ResponseBody
    public ResponseEntity<BookEditOptionsResponse> getBookEditOptions(@PathVariable Long bookId) {
        Map<String, Object> data = adminBooksService.getBookAndRelations(bookId);

        Books book = (Books) data.get("book");
        List<Authors> authors = (List<Authors>) data.get("authors");
        List<Publishers> publishers = (List<Publishers>) data.get("publishers");
        List<Categories> categories = (List<Categories>) data.get("categories");

        return ResponseEntity.ok(new BookEditOptionsResponse(book, authors, publishers, categories));
    }

    @Data
    @AllArgsConstructor
    static class BookEditOptionsResponse {
        private Books book;
        private List<Authors> authors;
        private List<Publishers> publishers;
        private List<Categories> categories;
    }

}
