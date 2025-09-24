package com.error404.geulbut.jpa.orders.dto;

import com.error404.geulbut.jpa.orderitem.dto.OrderItemDto;
import lombok.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrdersDto {
    private Long orderId;
    private String userId;
    private String userName;  // 추가
    private String status;
    private Long totalPrice;
    private String  createdAt;

    private String recipient;
    private String phone;
    private String address;
    private String memo;
    private String paymentMethod;
    private String phone; // Users 전화번호
    private String memo;  // 주문 메모
    private String  merchantUid;
    private List<OrderItemDto> items;


    private LocalDateTime paidAt;
    private LocalDateTime deliveredAt;

    //  배송 관련 추가
    private String invoiceNo;       // 송장번호
    private String courierName;     // 택배사
    private String courierManName;  // 기사명
    private String courierManPhone; // 기사 연락처
    private String recipient;       // 수취인

    public String getDeliveredAtFormatted() {
        return deliveredAt == null ? null
                : deliveredAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd (E) HH:mm"));
    }



}

