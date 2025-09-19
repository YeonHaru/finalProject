package com.error404.geulbut.jpa.carts.service;

import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.carts.dto.CartDto;
import com.error404.geulbut.jpa.carts.dto.CartSummaryDto;
import com.error404.geulbut.jpa.carts.entity.Cart;
import com.error404.geulbut.jpa.carts.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CartService {

    private final CartRepository cartRepository;
    private final BooksRepository booksRepository;

    /** 📌 장바구니 전체 조회 (DTO 반환)
     *   - QueryDSL 구현체(CartRepositoryImpl)에서 DTO 매핑 후 가져옴
     *   - userId 기준으로 사용자의 장바구니 목록 + 책 정보 조회*/
    public List<CartDto> getCartList(String userId) {
        return cartRepository.findCartWithBookInfo(userId);
    }

    // 새로운 getCartSummary 추가
    public CartSummaryDto getCartSummary(String userId) {
        List<CartDto> cartList = getCartList(userId);
        long totalPrice = cartList.stream()
                .mapToLong(CartDto::getTotalPrice)
                .sum();
        return new CartSummaryDto(cartList, totalPrice);
    }

    /** 📌 장바구니 추가 */
    @Transactional
    public void addToCart(String userId, Long bookId, int quantity) {
        // 해당 책이 이미 장바구니에 있는지 확인
        Cart cart = cartRepository.findByUserIdAndBook_BookId(userId, bookId)
                .orElse(null);

        if (cart != null) {
            // 이미 있으면 수량 증가
            cart.setQuantity(cart.getQuantity() + quantity);
        } else {
            // 없으면 새로 생성
            Books book = booksRepository.findById(bookId)
                    .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 책 ID: " + bookId));

            Cart newCart = Cart.builder()
                    .userId(userId)
                    .book(book)
                    .quantity(quantity)
                    .build();

            cartRepository.save(newCart);
        }
    }

    /** 📌 장바구니 수량 수정
     * - 특정 책의 수량을 새 값으로 덮어쓰기
     * - JPA dirty checking → 트랜잭션 종료 시 자동 UPDATE*/
    @Transactional
    public void updateQuantity(String userId, Long bookId, int quantity) {
        Cart cart = cartRepository.findByUserIdAndBook_BookId(userId, bookId)
                .orElseThrow(() -> new IllegalArgumentException("장바구니에 해당 상품이 없습니다."));

        cart.setQuantity(quantity);  // 새 수량으로 갱신
        // save() 불필요 (JPA dirty checking)
    }

    /** 📌 장바구니 삭제 */
    @Transactional
    public void removeFromCart(String userId, Long bookId) {
        cartRepository.deleteByUserIdAndBook_BookId(userId, bookId);
    }
}
