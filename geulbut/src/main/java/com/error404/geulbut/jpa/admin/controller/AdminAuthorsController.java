package com.error404.geulbut.jpa.admin.controller;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.jpa.admin.service.AdminAuthorsService;
import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RequiredArgsConstructor
@Controller
@RequestMapping("/admin/authors")
@PreAuthorize("hasRole('ADMIN')")
public class AdminAuthorsController {

    private final AdminAuthorsService adminAuthorsService;
    private final ErrorMsg errorMsg;

    // 작가 목록 페이지
    @GetMapping
    public String listAuthorsPage(Model model,
                                  @RequestParam(defaultValue = "0") int page,
                                  @RequestParam(defaultValue = "10") int size) {
        Page<AuthorsDto> authorsDtoPage = adminAuthorsService.getAllAuthors(page, size);
        model.addAttribute("authorsPage", authorsDtoPage);
        return "admin/admin_authors_list";
    }

    // 단일 작가 조회
    @GetMapping("/{authorId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAuthorById(@PathVariable Long authorId) {
        try {
            AuthorsDto dto = adminAuthorsService.getAuthorById(authorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "author", dto
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", errorMsg.getMessage("error.authors.notfound")
            ));
        }
    }

    // 작가 등록
    @PostMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createAuthor(@RequestBody AuthorsDto authorsDto) {
        if (authorsDto.getName() == null || authorsDto.getName().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", errorMsg.getMessage("error.authors.name.required")
            ));
        }

        try {
            AuthorsDto saved = adminAuthorsService.saveAuthor(authorsDto);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "author", saved
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", errorMsg.getMessage("error.authors.invalid")
            ));
        }
    }

    // 작가 수정
    @PutMapping("/{authorId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateAuthor(@PathVariable Long authorId,
                                                            @RequestBody AuthorsDto authorsDto) {
        authorsDto.setAuthorId(authorId);

        if (authorsDto.getName() == null || authorsDto.getName().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", errorMsg.getMessage("error.authors.name.required")
            ));
        }

        try {
            AuthorsDto updated = adminAuthorsService.updateAuthor(authorsDto);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "author", updated
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", errorMsg.getMessage("error.authors.notfound")
            ));
        }
    }

    // 작가 삭제
    @DeleteMapping("/{authorId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteAuthor(@PathVariable Long authorId) {
        boolean deleted = adminAuthorsService.deleteAuthor(authorId);
        if (deleted) {
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", errorMsg.getMessage("admin.authors.delete.success")
            ));
        } else {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", errorMsg.getMessage("admin.authors.delete.notfound")
            ));
        }
    }

    // 작가 검색
    @GetMapping("/search")
    @ResponseBody
    public Page<AuthorsDto> searchAuthors(@RequestParam(required = false) String keyword,
                                          @RequestParam(defaultValue = "0") int page,
                                          @RequestParam(defaultValue = "10") int size) {
        return adminAuthorsService.searchAuthors(keyword, page, size);
    }
}
