package com.error404.geulbut.jpa.orders.dto;

import com.error404.geulbut.jpa.orderitem.dto.OrderItemDto;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrdersDto {
    private Long orderId;                 // 주문 ID
    private String userId;                  // 주문자 ID
    private String status;                // 주문 상태
    private Long totalPrice;              // 총 금액
    private LocalDateTime createdAt;
    private String address;               // 배송지
    private String paymentMethod;         // 결제 수단

    private List<OrderItemDto> items;     // 주문 상세 목록
}

