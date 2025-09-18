package com.error404.geulbut.jpa.carts.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class CartSummaryDto {
    private List<CartDto> items;    // 장바구니 상품 목록
    private long totalPrice;        // 총합
}
