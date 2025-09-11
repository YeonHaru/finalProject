package com.error404.geulbut.jpa.users.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.users.dto.UsersLoginDto;
import com.error404.geulbut.jpa.users.dto.UsersOAuthUpsertDto;
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
    private final ErrorMsg errorMsg;

//   TODO :  1. 회원가입
    @Transactional
    public Users signup(UsersSignupDto usersSignupDto) {
//        기본검증
        if (usersSignupDto == null)
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.request.null"));

        if (usersSignupDto.getUserId() == null || usersSignupDto.getUserId().isBlank())
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.id.required"));

        if (usersSignupDto.getPassword() == null || usersSignupDto.getPassword().isBlank())
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.password.required"));

        if (usersRepository.existsByUserId(usersSignupDto.getUserId()))
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.id.duplicate"));

//       동의항목 등을 기본필드 매핑
        Users users = mapStruct.toEntity(usersSignupDto);

//        비밀번호 해시
        users.setPassword(passwordEncoder.encode(usersSignupDto.getPassword()));

//        기본값 보정(null 인 경우에만)
        if (users.getRole() == null) users.setRole("ROLE_USER");
        if (users.getGrade() == null) users.setGrade("BRONZE");
        if (users.getPoint() == null) users.setPoint(0L);
        if (users.getTotalPurchase() == null) users.setTotalPurchase(0L);

        return usersRepository.save(users);
    }

//   TODO : 2. 로그인(일반)
    public Users login(UsersLoginDto usersLoginDto) {

        if (usersLoginDto == null) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.request.null"));
        }
        if (usersLoginDto.getUserId() == null || usersLoginDto.getUserId().isBlank()
                || usersLoginDto.getPassword() == null || usersLoginDto.getPassword().isBlank()) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.login.required"));
        }

        // 2) 회원 조회
        Users users = usersRepository.findById(usersLoginDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException(
                        errorMsg.getMessage("error.user.login.notfound")));

        // 3) 간편 로그인 계정 여부 체크
        if (users.getPassword() == null || users.getPassword().isBlank()) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.login.oauth"));
        }

        // 4) 비밀번호 검증
        if (!passwordEncoder.matches(usersLoginDto.getPassword(), users.getPassword())) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.user.login.password.mismatch"));
        }

        return users;
    }
    
//      TODO : 3사 업서트
    @Transactional
    public Users upsertFromOAuth(UsersOAuthUpsertDto  usersOAuthUpsertDto) {
        if (usersOAuthUpsertDto == null) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.oauth.request.null"));
        }
        if (usersOAuthUpsertDto.getProvider() == null || usersOAuthUpsertDto.getProvider().isBlank()
                || usersOAuthUpsertDto.getProviderId() == null || usersOAuthUpsertDto.getProviderId().isBlank()) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.oauth.provider.required"));
        }

        final String key = usersOAuthUpsertDto.toUserIdKey();      // 예) "kakao:123456"

//        (1) 존재 -> 로드, 없다 -> 기본값 신규생성
        Users users = usersRepository.findById(key).orElseGet(() -> {
            Users nusers = new Users();
            nusers.setUserId(key);
            nusers.setRole("ROLE_USER");            // 기본 권한
            nusers.setGrade("BRONZE");              // 기본 등급
            nusers.setPoint(0L);
            nusers.setTotalPurchase(0L);
            return nusers;
        });


//        (2) 부분업데이트 널은 무시 - 맵 스트럭쳐 사용
        mapStruct.updateFromOAuth(usersOAuthUpsertDto, users);
        return usersRepository.save(users);
    }
}
