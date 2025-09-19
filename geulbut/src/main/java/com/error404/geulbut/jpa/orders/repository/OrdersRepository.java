package com.error404.geulbut.jpa.orders.repository;

import com.error404.geulbut.jpa.orders.entity.Orders;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrdersRepository extends JpaRepository<Orders, Long> {
    List<Orders> findByUserId(String userId);
}
