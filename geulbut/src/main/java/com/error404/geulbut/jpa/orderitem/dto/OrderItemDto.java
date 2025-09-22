package com.error404.geulbut.jpa.orderitem.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderItemDto {
    private Long orderedItemId;  // 주문 상세 ID
    private Long bookId;       // 도서 ID
    private int quantity;      // 주문 수량
    private int price;         // 단가
    private String title;
}
