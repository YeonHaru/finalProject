package com.error404.geulbut.jpa.wishlist.service;

import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.carts.service.CartService;
import com.error404.geulbut.jpa.wishlist.dto.WishlistDto;
import com.error404.geulbut.jpa.wishlist.entity.Wishlist;
import com.error404.geulbut.jpa.wishlist.repository.WishlistRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Log4j2
@Service
@RequiredArgsConstructor
@Transactional
public class WishlistService {
    private final WishlistRepository wishlistRepository;
    private final BooksRepository booksRepository;
    private final CartService cartService;

    /** 📌 위시리스트 조회 (BOOK, AUTHOR, PUBLISHER JOIN 포함) */
    public List<WishlistDto> getWishlist(String userId) {
        return wishlistRepository.findWishlistWithBookInfo(userId);
    }

    /** 📌 위시리스트 추가 */
    public void addWishlist(String userId, Long bookId) {
        boolean exists = wishlistRepository.existsByUserIdAndBook_BookId(userId, bookId);

        if (!exists) {
            Long seq = wishlistRepository.getNextSeq(); // 시퀀스 번호
            String newId = "W" + String.format("%03d", seq);

            // ✅ bookId로 Books 엔티티를 찾아오기
            Books book = booksRepository.findById(bookId)
                    .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 책 ID: " + bookId));

            Wishlist wishlist = Wishlist.builder()
                    .wishlistId(newId)
                    .userId(userId)
                    .book(book)
                    .build();

            wishlistRepository.save(wishlist);
        }
    }

    /** 📌 위시리스트 → 장바구니 이동 */
    @Transactional
    public void moveToCart(String userId, Long bookId, int quantity) {
        // 1. 장바구니에 담기
        //    CartService의 addToCart() 호출 필요 (DI로 주입)
        cartService.addToCart(userId, bookId, quantity);

        // 2. 위시리스트에서 제거
        wishlistRepository.deleteByUserIdAndBook_BookId(userId, bookId);

        log.info("📌 위시리스트 → 장바구니 이동 완료 - userId: {}, bookId: {}, quantity: {}",
                userId, bookId, quantity);
    }

    /** 📌 위시리스트 삭제 */
    public void removeWishlist(String userId, Long bookId) {
        wishlistRepository.deleteByUserIdAndBook_BookId(userId, bookId);
    }
}
