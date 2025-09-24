package com.error404.geulbut.jpa.orders.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.entity.Orders;
import com.error404.geulbut.jpa.orders.repository.OrdersRepository;
import com.error404.geulbut.jpa.users.service.UsersService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import static com.error404.geulbut.jpa.orders.entity.Orders.STATUS_PENDING;
import static com.error404.geulbut.jpa.orders.entity.Orders.STATUS_PAID;

@Service
@RequiredArgsConstructor
public class OrdersService {
    private final OrdersRepository ordersRepository;
    private final MapStruct mapStruct;
    private final BooksRepository booksRepository;
    private final UsersService usersService;                // 추가 ( 덕규)

    @Transactional
    public OrdersDto createOrder(OrdersDto dto) {
        Orders order = new Orders();
        order.setUserId(dto.getUserId());
        order.setTotalPrice(dto.getTotalPrice());
        order.setPaymentMethod(dto.getPaymentMethod());
        order.setAddress(dto.getAddress());
        order.setStatus(STATUS_PENDING);             // PENDING -> STATUS_PENDING (덕규:문자열 대신 상수)
        order.setStatus("PAID");

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
        Orders reloadedOrder = ordersRepository.findWithItemsAndBooksByOrderId(savedOrder.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("주문 재조회 실패 id=" + savedOrder.getOrderId()));
        return mapStruct.toDto(reloadedOrder);
    }

    @Transactional(readOnly = true)
    public OrdersDto getOrder(Long orderId) {
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


    //    주문 상태 변경 (예: PENDING -> PAID -> SHIPPED/CANCELLED)
    @Transactional // 추가:덕규

    public OrdersDto updateOrderStatus(Long orderId, String newStatus) {
        Orders order = ordersRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없음. id=" + orderId));

        String oldStatus = nvl(order.getStatus());

//     배송완료 시각 기록 (DB에 DELIVERED_AT 하나만 추가하는 최소 설계)
        if ("DELIVERED".equalsIgnoreCase(newStatus)) {
            if (order.getDeliveredAt() == null) {
                order.setDeliveredAt(java.time.LocalDateTime.now());
            }
        }

        // 1) 상태 저장
        order.setStatus(newStatus);
        Orders updateOrder = ordersRepository.save(order);

        // 2) 등급/누적 처리
        long amount = nz(order.getTotalPrice());

        // 펜딩/다른상태 -> paid : 누적증가
        if (!STATUS_PAID.equalsIgnoreCase(oldStatus) && STATUS_PAID.equalsIgnoreCase(newStatus)) {
            usersService.addPurchaseAndRegrade(updateOrder.getUserId(), amount);
        }
        // PAID -> (PAID 외) : 환불/취소로 간주하여 누적 감소
        else if (STATUS_PAID.equalsIgnoreCase(oldStatus) && !STATUS_PAID.equalsIgnoreCase(newStatus)) {
            usersService.refundAndRegrade(updateOrder.getUserId(), amount);
        }

        return mapStruct.toDto(updateOrder);
    }


    private static long nz(Long v) {
        return v == null ? 0L : v;
    }

    private static String nvl(String s) {
        return (s == null) ? "" : s;
    }

    //    주문 삭제
    @Transactional
    public void deleteOrder(Long orderId, String userId) {
        Orders order = ordersRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("주문을 찾을 수 없습니다."));

        // 🔐 보안: 자기 주문만 삭제 가능
        if (!order.getUserId().equals(userId)) {
            throw new RuntimeException("본인 주문만 삭제할 수 있습니다.");
        }

        ordersRepository.delete(order);
    }

    //    배송조회 페이지 구현
    public enum ViewDeliveryStatus {READY, IN_TRANSIT, DELIVERED}

    public static class DeliveryView {
        private final ViewDeliveryStatus viewDeliveryStatus;
        private final OrdersDto ordersDto;

        public DeliveryView(ViewDeliveryStatus viewDeliveryStatus, OrdersDto ordersDto) {
            this.viewDeliveryStatus = viewDeliveryStatus;
            this.ordersDto = ordersDto;
        }
        public ViewDeliveryStatus getViewDeliveryStatus() {return viewDeliveryStatus;}
        public OrdersDto getOrdersDto() {return ordersDto;}

        public String getViewDeliveryStatusName() {
            return viewDeliveryStatus == null ? "" : viewDeliveryStatus.name();
        }
}
@Transactional(readOnly = true)
public DeliveryView buildDeliveryView (Long orderId) {
    OrdersDto ordersDto = getOrder(orderId);
    ViewDeliveryStatus vs = resolveViewStatus(ordersDto);
    return new DeliveryView(vs, ordersDto);
    }
private ViewDeliveryStatus resolveViewStatus(OrdersDto o) {
    if ("DELIVERED".equalsIgnoreCase(o.getStatus()) || o.getDeliveredAt() != null) {
        return ViewDeliveryStatus.DELIVERED;
    }
    if ("SHIPPED".equalsIgnoreCase(o.getStatus())) {
        return ViewDeliveryStatus.IN_TRANSIT;
    }
        return ViewDeliveryStatus.READY;
    }
}



