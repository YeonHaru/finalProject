package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.entity.Orders;
import com.error404.geulbut.jpa.orders.repository.OrdersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminOrdersService {

    private final OrdersRepository ordersRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;

    // 전체 주문 조회(페이징)
    public Page<OrdersDto> getAllOrders(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return ordersRepository.findAll(pageable)
                .map(order -> {
                    OrdersDto dto = mapStruct.toDto(order);
                    dto.setUserName(order.getUser() != null ? order.getUser().getName() : null);
                    return dto;
                });
    }

    // 단일 주문 조회(DTO 반환)
    public OrdersDto getOrderById(Long orderId) {
        Orders order = getOrderByIdEntity(orderId);
        return mapToDto(order);
    }

    // 단일 주문 조회(엔티티 반환, Controller용)
    public Orders getOrderByIdEntity(Long orderId) {
        return ordersRepository.findWithItemsAndBooksByOrderId(orderId)
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.orders.notfound")));
    }

    // Orders -> OrdersDto 변환(추가 정보 포함)
    public OrdersDto mapToDto(Orders order) {
        OrdersDto dto = mapStruct.toDto(order);

        if (order.getUser() != null) {
            dto.setUserName(order.getUser().getName());
            dto.setAddress(order.getUser().getAddress());
            dto.setPhone(order.getUser().getPhone());
        }

        dto.setRecipient(order.getRecipient());
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setMemo(order.getMemo());

        // 추가: 결제/배송/주문번호 정보
        dto.setPaidAt(order.getPaidAt());
        dto.setDeliveredAt(order.getDeliveredAt());
        dto.setMerchantUid(order.getMerchantUid());

        return dto;
    }

    // 상태별 주문 조회
    public List<OrdersDto> getOrdersByStatus(String status) {
        return ordersRepository.findAllWithItemsAndBooks().stream()
                .filter(o -> o.getStatus().equalsIgnoreCase(status))
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    // 전체 주문 조회(관리자용, items + books 포함)
    public List<OrdersDto> getAllOrdersWithItems() {
        return ordersRepository.findAllWithItemsAndBooks()
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    // 상태 변경
    public OrdersDto updateOrderStatus(Long orderId, String newStatus) {
        Orders order = ordersRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없습니다."));
        order.setStatus(newStatus);
        Orders saved = ordersRepository.save(order);

        return mapToDto(saved);
    }
}
