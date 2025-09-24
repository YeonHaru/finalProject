package com.error404.geulbut.jpa.orders.entity;

import com.error404.geulbut.common.BaseTimeEntity;
import com.error404.geulbut.jpa.orderitem.entity.OrderItem;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
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

//    결제 관련 필드
    @Column(name = "MERCHANT_UID", length = 100, unique = true)
    private String merchantUid;
    @Column(name = "PAID_AT")
    private LocalDateTime paidAt;

    @Builder.Default
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    // 상태 상수 & 편의 메서드 -> 헬퍼 ( 덕규 )
    public static final String STATUS_CREATED = "CREATED";
    public static final String STATUS_PAID = "PAID";
    public static final String STATUS_CANCELLED = "CANCELLED";
    public static final String STATUS_SHIPPED   = "SHIPPED";
    public static final String STATUS_PENDING   = "PENDING";

    public boolean isPaid() {return STATUS_PAID.equalsIgnoreCase(this.status);}
    public void markPaid() {this.status = STATUS_PAID;}
    public void cancel() {this.status = STATUS_CANCELLED;}

    @PrePersist
    public void prePersist() {
        if (this.status == null || this.status.isBlank()) {
            this.status = STATUS_CREATED;   // 기본값
        }
    }

    // 편의 메서드
    public void addItem(OrderItem item) {
        items.add(item);
        item.setOrder(this);
    }
}
