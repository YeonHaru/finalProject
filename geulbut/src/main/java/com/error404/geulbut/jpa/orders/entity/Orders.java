package com.error404.geulbut.jpa.orders.entity;

import com.error404.geulbut.common.BaseTimeEntity;
import com.error404.geulbut.jpa.orderitem.entity.OrderItem;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "ORDERS")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Orders extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_ORDERS")
    @SequenceGenerator(name = "SEQ_ORDERS", sequenceName = "SEQ_ORDERS", allocationSize = 1)
    private Long orderId;

    private String userId;
    private Long totalPrice;
    private String status;

    private String phone;
    private String memo;
    private String paymentMethod;
    private String recipient;
    private String address;

    @Builder.Default
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    // 편의 메서드
    public void addItem(OrderItem item) {
        items.add(item);
        item.setOrder(this);
    }
}
