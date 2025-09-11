package com.error404.geulbut.jpa.users.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.users.dto.UsersSignupDto;
import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UsersService {

    private final UsersRepository usersRepository;
    private final PasswordEncoder passwordEncoder;
    private final MapStruct mapStruct;

//    1. 회원가입
    @Transactional
    public Users signup(UsersSignupDto usersSignupDto) {
//        기본검증
        if (usersSignupDto == null) throw new IllegalArgumentException("요청 데이터가 없습니다.");
        if (usersSignupDto.getUserId() == null || usersSignupDto.getUserId().isBlank())
            throw new IllegalArgumentException("아이디는 필수입니다.");
        if (usersSignupDto.getPassword() == null || usersSignupDto.getPassword().isBlank())
            throw new IllegalArgumentException("비밀번호는 필수입니다.");
        if (usersRepository.existsByUserId(usersSignupDto.getUserId()))
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");

//       동의항목 등을 기본필드 매핑
        Users users = mapStruct.toEntity(usersSignupDto);

//        비밀번호 해시
        users.setPassword(passwordEncoder.encode(users.getPassword()));

//        기본값 보정(null 인 경우에만)
        if (users.getRole() == null) users.setRole("ROlE_USER");
        if (users.getGrade() == null) users.setGrade("BRONZE");
        if (users.getPoint() == null) users.setPoint(0L);
        if (users.getTotalPurchase() == null) users.setTotalPurchase(0L);

        return usersRepository.save(users);
    }
}
