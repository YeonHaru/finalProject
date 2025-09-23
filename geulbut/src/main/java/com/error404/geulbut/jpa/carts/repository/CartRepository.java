package com.error404.geulbut.jpa.carts.repository;

import com.error404.geulbut.jpa.carts.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * CartRepository
 * -----------------------------
 * - JpaRepository<Cart, Long> : Cart 엔티티 기본 CRUD 기능 제공
 * - CartQueryRepositoryCustom : QueryDSL 기반의 커스텀 조회 기능 제공 (DTO 매핑 등)
 */
public interface CartRepository extends JpaRepository<Cart, Long> {

    Optional<Cart> findByUserIdAndBook_BookId(String userId, Long bookId);
    List<Cart> findByUserId(String userId);
    boolean existsByUserIdAndBook_BookId(String userId, Long bookId);
    void deleteByUserIdAndBook_BookId(String userId, Long bookId);

}
