package com.error404.geulbut.jpa.carts.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class CartDto {
    private Long cartId;       // 장바구니 PK
    private Long bookId;       // 책 PK
    private String title;      // 책 제목
    private String author;     // 저자
    private String publisher;  // 출판사
    private Long price;         // 가격
    private String imgUrl;     // 이미지 URL
    private int quantity;      // 수량
    private Long totalPrice;    // 총액 (price * quantity)
}
