package com.error404.geulbut.jpa.orders.controller;

import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.service.OrdersService;
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
@RequestMapping("/orders")
public class OrdersController {
    private final OrdersService ordersService;

    //    주문 생성
    @PostMapping
    public OrdersDto createOrder(@RequestBody OrdersDto dto,
                                 Authentication authentication) {
        String userId = authentication.getName();
        log.info(" [POST] 주문 생성 요청 - userId: {}", userId);

        dto.setUserId(userId);

        return ordersService.createOrder(dto);
    }

    //  주문 조회
    @GetMapping("/{orderId}")
    public OrdersDto getOrder(@PathVariable Long orderId,
                              Authentication authentication) {
        String userId = authentication.getName();
        log.info(" [GET] 주문 조회 - userId: {}, orderId: {}", userId, orderId);

        return ordersService.getOrder(orderId);
    }

    //    주문 내역 조회
    @GetMapping("/user")
    public List<OrdersDto> getUserOrders(Authentication authentication) {
        String userId = authentication.getName();
        log.info(" [GET] 사용자 주문 내역 조회 - userId: {}", userId);

        return ordersService.getUserOrders(userId);
    }

//    주문 상태 변경
    @PatchMapping("/{orderId}/status")
    public OrdersDto updateOrderStatus(@PathVariable Long orderId,
                                       @RequestParam String status,
                                       Authentication authentication){
        String userId = authentication.getName();
        log.info("[PATCH] 주문 상태 변경 - uesrId: {}, orderId: {}, status: {}", userId, orderId, status);
        return ordersService.updateOrderStatus(orderId, status);
    }

//    주문 삭제
    @DeleteMapping("/{orderId}")
    public ResponseEntity<?> deleteOrder(@PathVariable Long orderId,
                            Authentication authentication){
        String userId = authentication.getName();
        log.info("[DELETE] 주문 삭제 - userId: {}, orderID: {}", userId, orderId);

        try {
            ordersService.deleteOrder(orderId, userId);
            return ResponseEntity.ok(Map.of("status", "ok", "message", "주문이 삭제되었습니다."));
        } catch (Exception e) {
            log.error("❌ 주문 삭제 실패 - userId: {}, orderId: {}", userId, orderId, e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "fail", "message", e.getMessage()));
        }
    }
}