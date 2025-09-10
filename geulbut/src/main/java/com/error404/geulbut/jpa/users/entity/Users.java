package com.error404.geulbut.jpa.users.entity;

import jakarta.persistence.*;
import lombok.*;


import java.time.LocalDate;
import java.time.LocalDateTime;
@Entity
@Table(name = "USERS")
@SequenceGenerator(
        name = "SEQ_USERS_JPA",
        sequenceName = "SEQ_USERS",
        allocationSize = 1
)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@EqualsAndHashCode(of = "userId", callSuper = false)
public class Users {

    @Id
    @Column(name = "USER_ID", length = 50)
    private String userId; // @GeneratedValue 제거
    private String password;
    private String passwordTemp;
    private String name;
    private String email;
    private String phone;
    private LocalDate joinDate;
    private String role;
    private char gender;
    private LocalDate birthday;
    private String address;
    private Long point;
    private char postNotifyAgree;
    private char promoAgree;
    private String grade;
    private Long totalPurchase;

    @Lob
    private byte[] profileImg;

    private String imgUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;




}
