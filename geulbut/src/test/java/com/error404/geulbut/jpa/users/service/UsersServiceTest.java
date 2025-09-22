package com.error404.geulbut.jpa.users.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.users.dto.UsersLoginDto;
import com.error404.geulbut.jpa.users.dto.UsersOAuthUpsertDto;
import com.error404.geulbut.jpa.users.dto.UsersSignupDto;
import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.repository.UsersRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.BDDMockito.*;

@ExtendWith(MockitoExtension.class)
class UsersServiceTest {

    @Mock UsersRepository usersRepository;
    @Mock PasswordEncoder passwordEncoder;
    @Mock MapStruct mapStruct;
    @Mock ErrorMsg errorMsg;

    @InjectMocks UsersService usersService;


    @BeforeEach
    void setUp() {
//        메세지 코드 그대로 반환(간편하게)
        lenient().when(errorMsg.getMessage(Mockito.anyString()))
                .thenAnswer(inv -> inv.getArgument(0));
    }


    @Test
//    회원가입 성공 테스트
    void signup_success() {
        UsersSignupDto usersSignupDto = UsersSignupDto.builder()
                .userId("dkseo").password("123456").name("덕규").build();

        Users mapped = new Users();
                  mapped.setUserId("dkseo");
        given(usersRepository.existsByUserId("dkseo")).willReturn(false);
        given(mapStruct.toEntity(usersSignupDto)).willReturn(mapped);
        given(passwordEncoder.encode("123456")).willReturn("ENC");
        given(usersRepository.save(Mockito.any(Users.class)))
                .willAnswer(inv ->inv.getArgument(0));

        Users saved = usersService.signup(usersSignupDto);

        assertThat(saved.getUserId()).isEqualTo("dkseo");
        assertThat(saved.getPassword()).isEqualTo("ENC");
        assertThat(saved.getRole()).isEqualTo("ROLE_USER");
    }

    // 1) 아이디 중복
    @Test
    void signup_fail_duplicate_userId() {
        UsersSignupDto usersSignupDto = UsersSignupDto.builder()
                .userId("dkseo").password("123456").name("덕규").build();

        given(usersRepository.existsByUserId("dkseo")).willReturn(true);
        given(errorMsg.getMessage("error.user.id.duplicate"))
                .willReturn("이미 사용 중인 아이디입니다.");

        assertThatThrownBy(() -> usersService.signup(usersSignupDto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("이미 사용 중인 아이디입니다.");
    }

    // 2) 비밀번호 누락/공백
    @Test
    void signup_fail_missing_password() {
        UsersSignupDto usersSignupDto = UsersSignupDto.builder()
                .userId("dkseo").password(" ").name("덕규").build();

        given(errorMsg.getMessage("error.user.password.required"))
                .willReturn("비밀번호는 필수입니다.");

        assertThatThrownBy(() -> usersService.signup(usersSignupDto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("비밀번호는 필수입니다.");
    }

    // 3) 요청 자체가 null
    @Test
    void signup_fail_null_request() {
        given(errorMsg.getMessage("error.user.request.null"))
                .willReturn("요청 데이터가 없습니다.");

        assertThatThrownBy(() -> usersService.signup(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("요청 데이터가 없습니다.");
    }
    // 4) 아이디/공백 누락
    @Test
    void signup_fail_missing_userId() {
        UsersSignupDto usersSignupDto = UsersSignupDto.builder()
                .userId(" ").password("123456").name("덕규").build();

        given(errorMsg.getMessage("error.user.id.required"))
                .willReturn("아이디는 필수입니다.");

        assertThatThrownBy(() -> usersService.signup(usersSignupDto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("아이디는 필수입니다.");
    }

//  로그인 테스트
//  성공 : 아이디 + 비밀번호 일치
    @Test
    void login_success() {
        UsersLoginDto usersLoginDto = UsersLoginDto.builder()
                .userId("dkseo").password("123456").build();

        Users users = new Users();
        users.setUserId("dkseo");
        users.setPassword("ENC");

        given(usersRepository.findById("dkseo")).willReturn(Optional.of(users));
        given(passwordEncoder.matches("123456", "ENC")).willReturn(true);

        Users result = usersService.login(usersLoginDto);

        assertThat(result.getUserId()).isEqualTo("dkseo");
    }
//    실패1) : 요청 null
    @Test
    void login_fail_null_request() {
        given(errorMsg.getMessage("error.user.request.null"))
                .willReturn("요청 데이터가 없습니다.");
        assertThatThrownBy(()-> usersService.login(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("요청 데이터가 없습니다.");
    }
//    실패2) : 아이디/비번 공백
    @Test
    void login_fail_required_fields(){
        UsersLoginDto usersLoginDto = UsersLoginDto.builder()
                .userId(" ").password(" ").build();
        given(errorMsg.getMessage("error.user.login.required"))
                .willReturn("아이디 / 비밀번호를 입력해주세요.");
        assertThatThrownBy(() -> usersService.login(usersLoginDto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("아이디 / 비밀번호를 입력해주세요.");
    }
    // 실패: 아이디 없음
    @Test
    void login_fail_not_found() {
        UsersLoginDto dto = UsersLoginDto.builder()
                .userId("nope").password("x").build();

        given(usersRepository.findById("nope")).willReturn(Optional.empty());
        given(errorMsg.getMessage("error.user.login.notfound"))
                .willReturn("존재하지 않는 아이디입니다.");

        assertThatThrownBy(() -> usersService.login(dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("존재하지 않는 아이디입니다.");
    }

    // 실패: 간편로그인 전용 계정 (비밀번호 없음)
    @Test
    void login_fail_oauth_only() {
        UsersLoginDto dto = UsersLoginDto.builder()
                .userId("social").password("x").build();

        Users u = new Users();
        u.setUserId("social");
        u.setPassword(null); // 소셜 전용

        given(usersRepository.findById("social")).willReturn(Optional.of(u));
        given(errorMsg.getMessage("error.user.login.oauth"))
                .willReturn("간편 로그인 전용 계정입니다.");

        assertThatThrownBy(() -> usersService.login(dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("간편 로그인 전용 계정입니다.");
    }

    // 실패: 비밀번호 불일치
    @Test
    void login_fail_password_mismatch() {
        UsersLoginDto dto = UsersLoginDto.builder()
                .userId("dkseo").password("wrong").build();

        Users u = new Users();
        u.setUserId("dkseo");
        u.setPassword("ENC");

        given(usersRepository.findById("dkseo")).willReturn(Optional.of(u));
        given(passwordEncoder.matches("wrong", "ENC")).willReturn(false);
        given(errorMsg.getMessage("error.user.login.password.mismatch"))
                .willReturn("비밀번호가 일치하지 않습니다.");

        assertThatThrownBy(() -> usersService.login(dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("비밀번호가 일치하지 않습니다.");
    }

// ========================
// OAuth 업서트 테스트
// ========================

    // 성공: 신규 사용자 생성
    @Test
    void upsertFromOAuth_create_new_user() {
        UsersOAuthUpsertDto dto = UsersOAuthUpsertDto.builder()
                .provider("kakao").providerId("123")
                .email("k@k.com").name("카카오유저").imgUrl("http://img").build();

        // 존재하지 않음 → 신규
        given(usersRepository.findById("kakao:123")).willReturn(Optional.empty());
        given(usersRepository.save(Mockito.any(Users.class)))
                .willAnswer(inv -> inv.getArgument(0));

        // MapStruct 부분 업데이트 흉내
        willAnswer(inv -> {
            UsersOAuthUpsertDto d = inv.getArgument(0);
            Users e = inv.getArgument(1);
            if (d.getEmail() != null) e.setEmail(d.getEmail());
            if (d.getName()  != null) e.setName(d.getName());
            if (d.getImgUrl()!= null) e.setImgUrl(d.getImgUrl());
            return null;
        }).given(mapStruct).updateFromOAuth(Mockito.any(), Mockito.any());

        Users saved = usersService.upsertFromOAuth(dto);

        assertThat(saved.getUserId()).isEqualTo("kakao:123");
        assertThat(saved.getRole()).isEqualTo("ROLE_USER");
        assertThat(saved.getGrade()).isEqualTo("BRONZE");
        assertThat(saved.getEmail()).isEqualTo("k@k.com");
        assertThat(saved.getName()).isEqualTo("카카오유저");
        assertThat(saved.getImgUrl()).isEqualTo("http://img");
    }

    // 성공: 기존 사용자 업데이트 (부분 업데이트)
    @Test
    void upsertFromOAuth_update_existing_user() {
        UsersOAuthUpsertDto dto = UsersOAuthUpsertDto.builder()
                .provider("google").providerId("abc")
                .imgUrl("http://new").build();

        Users existing = new Users();
        existing.setUserId("google:abc");
        existing.setRole("ROLE_USER");
        existing.setGrade("BRONZE");
        existing.setImgUrl("http://old");

        given(usersRepository.findById("google:abc")).willReturn(Optional.of(existing));
        given(usersRepository.save(Mockito.any(Users.class)))
                .willAnswer(inv -> inv.getArgument(0));

        willAnswer(inv -> {
            UsersOAuthUpsertDto d = inv.getArgument(0);
            Users e = inv.getArgument(1);
            if (d.getImgUrl() != null) e.setImgUrl(d.getImgUrl());
            return null;
        }).given(mapStruct).updateFromOAuth(Mockito.any(), Mockito.any());

        Users saved = usersService.upsertFromOAuth(dto);

        assertThat(saved.getUserId()).isEqualTo("google:abc");
        assertThat(saved.getImgUrl()).isEqualTo("http://new");
    }

    // 실패: 요청 null
    @Test
    void upsertFromOAuth_fail_null_request() {
        given(errorMsg.getMessage("error.oauth.request.null"))
                .willReturn("요청 데이터가 없습니다.");

        assertThatThrownBy(() -> usersService.upsertFromOAuth(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("요청 데이터가 없습니다.");
    }

    // 실패: provider/providerId 누락
    @Test
    void upsertFromOAuth_fail_missing_provider() {
        UsersOAuthUpsertDto dto = UsersOAuthUpsertDto.builder()
                .provider(" ").providerId(null).build();

        given(errorMsg.getMessage("error.oauth.provider.required"))
                .willReturn("provider/providerId는 필수입니다.");

        assertThatThrownBy(() -> usersService.upsertFromOAuth(dto))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("provider/providerId는 필수입니다.");
    }

//    ===========================================================
//    TODO : 로그인 / 회원가입 관련 성공 혹은 실패 단위 테스트 진행 한 것 9/11 17:00
//    ===========================================================

}