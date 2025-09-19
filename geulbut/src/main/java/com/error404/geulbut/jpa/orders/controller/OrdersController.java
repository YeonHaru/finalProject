package com.error404.geulbut.jpa.orders.controller;

import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.service.OrdersService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/orders")
public class OrdersController {
    private final OrdersService ordersService;

//    주문 생성
    @PostMapping
    public OrdersDto createOrder(@RequestBody OrdersDto  dto) {
        return ordersService.createOrder(dto);
    }

//    주문 조회
    @GetMapping("/{orderId}")
    public OrdersDto getOrder(@PathVariable Long orderId){
        return ordersService.getOrder(orderId);
    }
    @GetMapping("/user/{userId}")
    public List<OrdersDto> getUserOrders(@PathVariable String userId) {
        return ordersService.getUserOrders(userId);
    }
}