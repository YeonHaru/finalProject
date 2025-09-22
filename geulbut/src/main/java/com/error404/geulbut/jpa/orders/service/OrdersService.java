package com.error404.geulbut.jpa.orders.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
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
    private final BooksRepository booksRepository;

    @Transactional
    public OrdersDto createOrder(OrdersDto dto) {
        Orders order = new Orders();
        order.setUserId(dto.getUserId());
        order.setTotalPrice(dto.getTotalPrice());
        order.setPaymentMethod(dto.getPaymentMethod());
        order.setAddress(dto.getAddress());
        order.setStatus("PENDING");

        dto.getItems().forEach(itemDto -> {
            Long bookId = itemDto.getBookId();
            if (bookId == null) {
                throw new IllegalArgumentException("bookId가 없습니다.");
            }

            Books book = booksRepository.findById(bookId)
                    .orElseThrow(() -> new IllegalArgumentException("해당 도서를 찾을 수 없습니다. id=" + bookId));

            // OrderItem 엔티티 만들어서 채워주기
            var orderItem = mapStruct.toEntity(itemDto);
            orderItem.setOrder(order);
            orderItem.setBook(book);

            order.getItems().add(orderItem);
        });

        Orders savedOrder = ordersRepository.save(order);
        Orders reloadedOrder= ordersRepository.findWithItemsAndBooksByOrderId(savedOrder.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("주문 재조회 실패 id=" + savedOrder.getOrderId()));
        return mapStruct.toDto(reloadedOrder);
    }

    @Transactional(readOnly = true)
    public OrdersDto getOrder(Long orderId){
        Orders order = ordersRepository.findWithItemsAndBooksByOrderId(orderId)
                .orElseThrow(() -> new IllegalArgumentException("해당 주문을 찾을 수 없습니다. id=" + orderId));
        return mapStruct.toDto(order);
    }

    @Transactional(readOnly = true)
    public List<OrdersDto> getUserOrders(String userId) {
        List<Orders> orders = ordersRepository.findWithItemsAndBooksByUserId(userId);
        return orders.stream()
                .map(mapStruct::toDto)
                .toList();
    }

//    주문 상태 변경 (예: PENDING -> PAID -> SHIPPED)

    public OrdersDto updateOrderStatus(Long orderId, String newStatus) {
        Orders order = ordersRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없음. id=" + orderId));

        order.setStatus(newStatus);
        Orders updateOrder = ordersRepository.save(order);

        return mapStruct.toDto(updateOrder);
    }
}
