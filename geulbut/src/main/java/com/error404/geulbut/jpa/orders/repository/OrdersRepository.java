package com.error404.geulbut.jpa.orders.repository;

import com.error404.geulbut.jpa.orders.entity.Orders;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface OrdersRepository extends JpaRepository<Orders, Long> {
    List<Orders> findByUserId(String userId);

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
            "ORDER BY o.createdAt DESC")
    List<Orders> findWithItemsAndBooksByUserId(@Param("userId") String userId);
}
