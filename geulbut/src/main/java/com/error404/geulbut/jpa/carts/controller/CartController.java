package com.error404.geulbut.jpa.carts.controller;

import com.error404.geulbut.jpa.carts.dto.CartDto;
import com.error404.geulbut.jpa.carts.service.CartService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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
        log.info("📌 [POST] 장바구니 추가 요청 - userId: {}, bookId: {}, quantity: {}", userId, bookId, quantity);

        try {
            cartService.addToCart(userId, bookId, quantity);
            return ResponseEntity.ok(Map.of("status", "ok"));
        } catch (Exception e) {
            log.info("❌ 장바구니 추가 실패 - userId: {}, bookId: {}", userId, bookId, e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "fail", "message", e.getMessage()));
        }
    }

    /**
     * 📌 장바구니 수량 변경 (PUT /cart/{bookId})
     */
    @PutMapping("/{bookId}")
    public ResponseEntity<?> updateCartItem(Authentication authentication,
                                            @PathVariable Long bookId,
                                            @RequestParam int quantity) {
        String userId = authentication.getName();
        log.info("📌 [PUT] 장바구니 수량 변경 요청 - userId: {}, bookId: {}, quantity: {}", userId, bookId, quantity);

        if (quantity <= 0) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "fail", "message", "수량은 1 이상이어야 합니다."));
        }
        try {
            // ✅ 장바구니 업데이트
            var cart = cartService.updateCartItem(userId, bookId, quantity);

            // ✅ 개별 합계 (할인 적용 여부 포함)
            long itemTotal = cart.getQuantity() *
                    (cart.getBook().getDiscountedPrice() != null
                            ? cart.getBook().getDiscountedPrice()
                            : cart.getBook().getPrice());

            // ✅ 전체 합계
            long cartTotal = cartService.getCartTotal(userId);

            return ResponseEntity.ok(Map.of(
                    "status", "ok",
                    "itemTotal", itemTotal,
                    "cartTotal", cartTotal
            ));
        } catch (Exception e) {
            log.error("❌ 장바구니 수량 변경 실패 - userId: {}, bookId: {}", userId, bookId, e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "fail", "message", e.getMessage()));
        }
    }


    /**
     * 📌 장바구니 삭제 (DELETE /cart/{bookId})
     */
    @DeleteMapping("/{bookId}")
    public ResponseEntity<?> removeFromCart(Authentication authentication,
                                            @PathVariable Long bookId) {
        String userId = authentication.getName();
        log.info("📌 [DELETE] 장바구니 삭제 요청 - userId: {}, bookId: {}", userId, bookId);

        try {
            cartService.removeFromCart(userId, bookId);
            return ResponseEntity.ok(Map.of("status", "ok"));
        } catch (Exception e) {
            log.error("❌ 장바구니 삭제 실패 - userId: {}, bookId: {}", userId, bookId, e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "fail", "message", e.getMessage()));
        }
    }

    /**
     * 📌 장바구니 조회 (GET /cart)
     */
    @GetMapping
    public ResponseEntity<?> getCart(Authentication authentication) {
        String userId = authentication.getName();
        log.info("📌 [GET] 장바구니 조회 요청 - userId: {}", userId);

        try {
            List<CartDto> cartList = cartService.getCartList(userId);

            long cartTotal = cartList.stream()
                            .mapToLong(CartDto::getTotalPrice)
                            .sum();
            log.info("➡️ 장바구니 조회 결과: {}건", cartList.size());

            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "items", cartList,
                    "cartTotal", cartTotal
            ));
        } catch (Exception e) {
            log.error("❌ 장바구니 조회 실패 - userId: {}", userId, e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "fail", "message", e.getMessage()));
        }
    }
}