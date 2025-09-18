package com.error404.geulbut.jpa.wishlist.controller;

import com.error404.geulbut.jpa.wishlist.dto.WishlistDto;
import com.error404.geulbut.jpa.wishlist.service.WishlistService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/wishlist")
public class WishlistController {
    private final WishlistService wishlistService;

    /**
     * 📌 위시리스트 조회 (GET /wishlist)
     */
    @GetMapping
    public ResponseEntity<List<WishlistDto>> getWishlist(Authentication authentication) {
        String userId = authentication.getName();
        log.info("📌 [GET] 위시리스트 조회 요청 - userId: {}", userId);

        List<WishlistDto> wishlist = wishlistService.getWishlist(userId);
        log.info("➡️ [결과 확인] {}건 반환", wishlist.size());

        return ResponseEntity.ok(wishlist);
    }

    /**
     * 위시리스트 추가 (POST /wishlist)
     */
    @PostMapping
    public ResponseEntity<?> addwishlist(Authentication authentication,
                                         @RequestParam Long bookId) {
        String userId = authentication.getName();
        wishlistService.addWishlist(userId, bookId);
        return ResponseEntity.ok("ok");
    }
    /** 📌 위시리스트 삭제 (DELETE /wishlist/{bookId}) */
    @DeleteMapping("/{bookId}")
    public ResponseEntity<?> removeWishlist(Authentication authentication,
                                            @PathVariable Long bookId) {
        String userId = authentication.getName();
        wishlistService.removeWishlist(userId, bookId);
        return ResponseEntity.ok("ok");
    }
}