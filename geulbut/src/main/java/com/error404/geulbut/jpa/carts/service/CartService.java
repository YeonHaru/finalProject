package com.error404.geulbut.jpa.carts.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.carts.controller.PaymentController;
import com.error404.geulbut.jpa.carts.dto.CartDto;
import com.error404.geulbut.jpa.carts.entity.Cart;
import com.error404.geulbut.jpa.carts.repository.CartRepository;
import com.error404.geulbut.jpa.orderitem.entity.OrderItem;
import com.error404.geulbut.jpa.orders.entity.Orders;
import com.error404.geulbut.jpa.orders.repository.OrdersRepository;
import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

import static com.error404.geulbut.jpa.orders.entity.Orders.STATUS_PAID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CartService {

    private final CartRepository cartRepository;
    private final BooksRepository booksRepository;
    private final MapStruct mapStruct;
    private final OrdersRepository ordersRepository;
    private final UsersRepository usersRepository;

    /** 장바구니 목록 조회 */
    @Transactional(readOnly = true)
    public List<CartDto> getCartList(String userId) {
        List<Cart> carts = cartRepository.findByUserId(userId);
        return mapStruct.toCartDtos(carts);
    }

    /** 장바구니 합계 */
    @Transactional(readOnly = true)
    public long getCartTotal(String userId) {
        List<CartDto> cartList = getCartList(userId);
        return cartList.stream()
                .mapToLong(CartDto::getTotalPrice)
                .sum();
    }

    /** 장바구니 추가 */
    @Transactional
    public void addToCart(String userId, Long bookId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("quantity must be > 0");
        // 해당 책이 이미 장바구니에 있는지 확인
        Cart cart = cartRepository.findByUserIdAndBook_BookId(userId, bookId)
                .orElse(null);

        if (cart != null) {
            cart.setQuantity(cart.getQuantity() + quantity);
        } else {
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

    /** 장바구니 수량/금액 합계 수정 */
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

    /** 장바구니 삭제 */
    @Transactional
    public void removeFromCart(String userId, Long bookId) {
        cartRepository.deleteByUserIdAndBook_BookId(userId, bookId);
    }

    /** 📌 결제(주문 생성) */
    @Transactional
    public Orders checkout(String userId, String merchantUid, PaymentController.VerifyReq.OrdersInfo info) {

        List<Cart> items = cartRepository.findAllWithBookByUserId(userId);
        if (items.isEmpty()) throw new IllegalStateException("장바구니가 비어있습니다.");

        Users userRef = usersRepository.getReferenceById(userId);

        Orders order = Orders.builder()
                .userId(userId)
                .merchantUid(merchantUid)
                .status(STATUS_PAID)
                .paidAt(LocalDateTime.now())
                .recipient(info != null ? info.recipient() : userRef.getName())
                .phone(info != null ? info.phone() : userRef.getPhone())
                .address(info != null ? info.address() : userRef.getAddress())
                .memo(info != null ? info.memo() : null)
                .paymentMethod(info != null ? info.payMethod().toUpperCase() : "CARD")
                .build();

        long total = 0L;
        for (Cart c : items) {
            long price = c.getBook().getPrice(); // ✅ 주문 시점 단가 스냅샷
            int qty = c.getQuantity();
            total += price * qty;

            order.addItem(OrderItem.builder()
                    .order(order)
                    .book(c.getBook())
                    .price(price)
                    .quantity(qty)
                    .build());
        }

        // 총액 계산 (info.amount()와 다르면 서버값 우선)
        order.setTotalPrice(total);

        ordersRepository.save(order);      // 주문/주문아이템 저장
        cartRepository.deleteByUserId(userId); // 장바구니 비우기
        return order;
    }
}
