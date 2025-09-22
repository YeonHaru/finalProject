package com.error404.geulbut.jpa.orders.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.entity.Orders;
import com.error404.geulbut.jpa.orders.repository.OrdersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrdersService {
    private final OrdersRepository ordersRepository;
    private final MapStruct mapStruct;

    @Transactional
    public OrdersDto createOrder(OrdersDto dto) {
        Orders order = mapStruct.toEntity(dto);
        order.getItems().forEach(item -> item.setOrder(order));
        Orders savedOrder = ordersRepository.save(order);
        return mapStruct.toDto(savedOrder);
    }

    @Transactional(readOnly = true)
    public OrdersDto getOrder(Long orderId){
        Orders order = ordersRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("해당 주문을 찾을 수 없습니다. id=" + orderId));
        return mapStruct.toDto(order);
    }
    @Transactional(readOnly = true)
    public List<OrdersDto> getUserOrders(String userId) {
        List<Orders> orders = ordersRepository.findByUserId(userId);
        return orders.stream()
                .map(mapStruct::toDto)
                .toList();
    }

}