package com.error404.geulbut.jpa.carts.controller;

import com.error404.geulbut.jpa.carts.service.CartService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/cart")
public class CartController {
    private final CartService cartService;

    /**
     * 📌 장바구니 담기 (POST /cart)
     */
    @PostMapping
    public ResponseEntity<?> addToCart(Authentication authentication,
                                       @RequestParam Long bookId,
                                       @RequestParam(defaultValue = "1") int quantity) {
        String userId = authentication.getName();
        try {
            cartService.addToCart(userId, bookId, quantity);
            return ResponseEntity.ok(Map.of("status", "ok"));
        } catch (Exception e) {
            log.error("장바구니 담기 실패", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "FAIL", "message", e.getMessage()));
        }
    }

    /**
     * 📌 장바구니 수량 변경 (PUT /cart/{bookId})
     */
    @PutMapping("/{bookId}")
    public ResponseEntity<?> updateQuantity(Authentication authentication,
                                            @PathVariable Long bookId,
                                            @RequestParam int quantity) {
        String userId = authentication.getName();
        if (quantity <= 0) {
            return ResponseEntity.status((HttpStatus.BAD_REQUEST))
                    .body(Map.of("status", "FAIL", "message", "수량은 1 이상이어야 합니다."));
        }
        cartService.updateQuantity(userId, bookId, quantity);
        return ResponseEntity.ok(Map.of("status", "ok"));
    }

    /**
     * 📌 장바구니 삭제 (DELETE /cart/{bookId})
     */
    @DeleteMapping("/{bookId}")
    public ResponseEntity<?> removeFromCart(Authentication authentication,
                                            @PathVariable Long bookId) {
        String userId = authentication.getName();
        cartService.removeFromCart(userId, bookId);
        return ResponseEntity.ok(Map.of("status", "ok"));
    }

    /**
     * 📌 장바구니 조회 (GET /cart)
     */
    @GetMapping
    public ResponseEntity<?> getCart(Authentication authentication) {
        String userId = authentication.getName();
        return ResponseEntity.ok(cartService.getCartSummary(userId));
    }
}