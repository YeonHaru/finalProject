package com.error404.geulbut.jpa.carts.controller;

import com.error404.geulbut.jpa.carts.service.CartService;
import com.error404.geulbut.jpa.orders.entity.Orders;
import com.error404.geulbut.jpa.orders.repository.OrdersRepository;
import com.error404.geulbut.jpa.users.entity.Users;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/payments")
public class PaymentController {

    private final CartService cartService;
    private final OrdersRepository ordersRepository;

    @PostMapping("/prepare")
    public Map<String, String> prepare(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new org.springframework.web.server.ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
        String userId = authentication.getName();
        String merchantUid = "order_" + System.currentTimeMillis();
        return Map.of("merchantUid", merchantUid);
    }

    public record VerifyReq(
            @NotBlank String impUid,
            @NotBlank String merchantUid,
            OrdersInfo ordersInfo
    ) {
        public record OrdersInfo(
                String userId,
                String recipient,
                String phone,
                String address,
                String memo,
                String payMethod,
                Long amount
        ) {}
    }
    @PostMapping("/verify")
    public ResponseEntity<?> verify(Authentication authentication,
                                    @Valid @RequestBody VerifyReq req) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        String userId = authentication.getName();
        //  멱등 체크 (선조회)
        Orders existing = ordersRepository.findByMerchantUid(req.merchantUid()).orElse(null);
        if (existing != null) {
            if (!userId.equals(existing.getUserId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("message", "owner mismatch"));
            }
            return ResponseEntity.ok(Map.of(
                    "orderId", existing.getOrderId(),
                    "total", existing.getTotalPrice(),
                    "status", existing.getStatus(),
                    "idempotent", true
            ));
        }

        //  최초 생성 시도
        try {
            VerifyReq.OrdersInfo info = req.ordersInfo();
            Orders order = cartService.checkout(userId, req.merchantUid(), info);
            return ResponseEntity.ok(Map.of(
                    "orderId", order.getOrderId(),
                    "total", order.getTotalPrice(),
                    "status", order.getStatus(),
                    "idempotent", false
            ));
        } catch (IllegalStateException e) {
            // 장바구니 비었을 때 등
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (DataIntegrityViolationException race) {
            // UNIQUE(MERCHANT_UID) 레이스: 재조회 후 기존 주문 반환
            log.warn("Idempotency race: {}", race.getMessage());
            Orders after = ordersRepository.findByMerchantUid(req.merchantUid())
                    .orElse(null);
            if (after != null) {
                return ResponseEntity.ok(Map.of(
                        "orderId", after.getOrderId(),
                        "total", after.getTotalPrice(),
                        "status", after.getStatus(),
                        "idempotent", true
                ));
            }
            // 정말 예외적 케이스
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("message", "duplicate merchantUid"));
        }
    }
}
