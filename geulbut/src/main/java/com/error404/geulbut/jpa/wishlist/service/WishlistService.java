package com.error404.geulbut.jpa.wishlist.service;

import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
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

    /** 📌 위시리스트 삭제 */
    public void removeWishlist(String userId, Long bookId) {
        wishlistRepository.deleteByUserIdAndBook_BookId(userId, bookId);
    }
}
