package com.error404.geulbut.jpa.users.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;


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
@ToString(exclude = {"password", "passwordTemp", "profileImg"})
@DynamicInsert
@DynamicUpdate
@EqualsAndHashCode(of = "userId", callSuper = false)
public class Users {

    @Id
    @Column(name = "USER_ID", length = 50, nullable = false)        // 컬럼 어노테이션 쓸 이유가없다.
    private String userId; // @GeneratedValue 제거
//    로그인/회원가입 공통
    private String password;
    private String passwordTemp;                        // 임시비밀번호로 넣어둠
    private String name;
    private String email;                                       // 카카오는 null 가능
    private String phone;

//    기본정보
    private LocalDate joinDate;
    private String role;
    private char gender;
    private LocalDate birthday;
    private String address;

//    포인트 & 등급
    private Long point;
    private char postNotifyAgree;
    private char promoAgree;
    private String grade;                   // 브론즈/실버/골드
    private Long totalPurchase;

//    프로필
    @Lob
    private byte[] profileImg;
    private String imgUrl;

//    생성/수정 시간
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

//    업데이트_AT 자동갱신
    @PreUpdate
    public void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }




}
