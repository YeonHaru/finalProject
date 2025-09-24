package com.error404.geulbut.jpa.orders.repository;

import com.error404.geulbut.jpa.orders.entity.Orders;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface OrdersRepository extends JpaRepository<Orders, Long> {
    List<Orders> findByUserId(String userId);

    // 멱등 체크용 — merchantUid로 조회
    Optional<Orders> findByMerchantUid(String merchantUid);

    @Query("SELECT o FROM Orders o " +
            "JOIN FETCH o.items i " +
            "JOIN FETCH i.book b " +
            "WHERE o.orderId = :orderId")
    Optional<Orders> findWithItemsAndBooksByOrderId(@Param("orderId") Long orderId);


    //    order orderItem book 전부 한번에 가져옴
    @Query("SELECT DISTINCT o FROM Orders o " +
            "JOIN FETCH o.items i " +
            "JOIN FETCH i.book b " +
            "WHERE o.userId = :userId " +
            "AND o.status <> 'PENDING' " +
            "ORDER BY o.createdAt DESC")
    List<Orders> findWithItemsAndBooksByUserId(@Param("userId") String userId);

    //  이 합계 쿼리문은 배치/점검용 (덕규)
    @Query("""
  select coalesce(sum(o.totalPrice), 0)
  from Orders o
  where o.userId = :userId and o.status = :status
""")
    Long sumTotalByUserAndStatus(@Param("userId") String userId,
                                 @Param("status") String status);

    // 관리자 조회용
    @Query("SELECT DISTINCT o FROM Orders o " +
            "JOIN FETCH o.user u " +
            "JOIN FETCH o.items i " +
            "JOIN FETCH i.book b " +
            "ORDER BY o.createdAt DESC")
    List<Orders> findAllWithItemsAndBooks();

    @Query("""
  select distinct o
  from Orders o
    join fetch o.items i
    join fetch i.book b
  where o.userId = :userId
    and o.deliveredAt is not null
  order by o.deliveredAt desc
""")
    List<Orders> findDeliveredWithItemsAndBooksByUserId(
            @Param("userId") String userId
    );

    // 페이징/개수 제한이 필요할 때 쓸 버전 (선택)
    @Query(value = """
  select distinct o
  from Orders o
    join fetch o.items i
    join fetch i.book b
  where o.userId = :userId
    and o.deliveredAt is not null
  order by o.deliveredAt desc
""",
            countQuery = """
  select count(o)
  from Orders o
  where o.userId = :userId
    and o.deliveredAt is not null
""")
    Page<Orders> findDeliveredWithItemsAndBooksByUserId(
            @Param("userId") String userId,
            Pageable pageable
    );

}
