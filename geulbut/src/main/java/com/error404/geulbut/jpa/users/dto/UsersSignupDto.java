//  TODO : 회원가입 요청 DTO

package com.error404.geulbut.jpa.users.dto;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class UsersSignupDto {

//    필수입력사항
    private String userId;
    private String password;
    private String name;
    private String email;
    private String phone;

//    선택입력
    private Character gender;
    private LocalDate birthday;
    private String address;

//    동의 항목
    private boolean postNotifyAgree;
    private boolean promoAgree;

}
