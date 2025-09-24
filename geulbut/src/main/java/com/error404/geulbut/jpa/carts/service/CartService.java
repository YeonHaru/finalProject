package com.error404.geulbut.jpa.carts.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.carts.dto.CartDto;
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
    private final MapStruct mapStruct;

    @Transactional(readOnly = true)
    public List<CartDto> getCartList(String userId) {
        List<Cart> carts = cartRepository.findByUserId(userId);
        return mapStruct.toCartDtos(carts);
    }


    // 장바구니 합계
    @Transactional(readOnly = true)
    public long getCartTotal(String userId) {
        List<CartDto> cartList = getCartList(userId);
        return cartList.stream()
                .mapToLong(CartDto::getTotalPrice)
                .sum();
    }

    /** 📌 장바구니 추가 */
    @Transactional
    public void addToCart(String userId, Long bookId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("quantity must be > 0");
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

    // 장바구니 수량 금액 합계 수정
    @Transactional
    public Cart updateCartItem(String userId, Long bookId, int quantity) {
        if (quantity <= 0) {
            cartRepository.deleteByUserIdAndBook_BookId(userId, bookId);
            return null;
        }
        Cart cart = cartRepository.findByUserIdAndBook_BookId(userId, bookId)
                .orElseThrow(() -> new RuntimeException("장바구니 항목을 찾을 수 없습니다."));
        cart.setQuantity(quantity);
        return cart;
    }


    /** 📌 장바구니 삭제 */
    @Transactional
    public void removeFromCart(String userId, Long bookId) {
        cartRepository.deleteByUserIdAndBook_BookId(userId, bookId);
    }
}
