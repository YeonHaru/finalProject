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
    private Long orderId;
    private String userId;
    private String status;
    private Long totalPrice;
    private String  createdAt;

    private String recipient;
    private String phone;
    private String address;
    private String memo;
    private String paymentMethod;

    private List<OrderItemDto> items;
}

