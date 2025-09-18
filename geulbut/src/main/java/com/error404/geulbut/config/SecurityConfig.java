package com.error404.geulbut.config;

import com.error404.geulbut.jpa.users.service.CustomOAuth2UserService;
import com.error404.geulbut.jpa.users.service.SocialAuthService;
import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

// private final CustomOAuth2UserService customOAuth2UserService;

//    비밀번호 인코더 등록 9/11
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
    }

//    개발 중 임시 전체 오픈 스위치(true = 전체허용, false = 원래보안)
    private static final boolean DEV_BYPASS = false;


    @Bean
    SecurityFilterChain filterChain(HttpSecurity http,
                                    CustomOAuth2UserService customOAuth2UserService, SocialAuthService socialAuthService) throws Exception {
        // 👆 Bean 메서드 파라미터 주입 방식으로 변경

        if (DEV_BYPASS) {
            http
                    .authorizeHttpRequests(auth->auth
                            .requestMatchers("/oauth2/**").permitAll()
                            .anyRequest().permitAll()
                    )
                    .oauth2Login(oauth ->oauth
                            .loginPage("/login")
                    )
                    .csrf(AbstractHttpConfigurer::disable)
                    .headers(headers->headers.frameOptions(frame->frame.sameOrigin()))
                    .logout(logout -> logout
                            .logoutUrl("/logout")
                            .logoutSuccessUrl("/")
                            .invalidateHttpSession(true)
                            .deleteCookies("JSESSIONID")
                    );
            return http.build();
        }

        http
                .authorizeHttpRequests(auth->auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR)
                        .permitAll()
                        .dispatcherTypeMatchers(DispatcherType.INCLUDE).permitAll()

                        .requestMatchers(
                                "/", "/ping",
                                "/login", "/login/**", "/loginProc",
                                "/oauth2/**", "/login/oauth2/**", "/oauth2/authorization/**",
                                "/css/**", "/js/**", "/images/**", "/webjars/**",
                                "/favicon.ico", "/error",
                                "dustApi", "DustWeatherApi","/v/**", "/dust","weather","weatherApi",
                                "admin/css/admin-header.css", "/signup",
                                "/users/check-id","/users/check-email",
                                "/find-id","/find-password",
                                "/find-password/**", "/search"
                        ).permitAll()
                        .anyRequest().authenticated()
                )
                .formLogin(form->form
                        .loginPage("/login")
                        .loginProcessingUrl("/loginProc")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .defaultSuccessUrl("/", false)
                        .failureUrl("/login?error")
                        .permitAll()
                )
                .oauth2Login(oauth->oauth
                        .loginPage("/login")
                        .defaultSuccessUrl("/", false)
                        .failureUrl("/login?error")
                        .userInfoEndpoint(userInfo -> userInfo
//                                구글 경로 추가
                                .oidcUserService(googleOidcUserService(socialAuthService))
//                                네이버/카카오(일반OAuth2) 경로 나눠놨음
                                .userService(customOAuth2UserService)  //  여기서 파라미터로 받은 서비스 사용
                        )
                )
                .logout(logout->logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                )
                .csrf(csrf->csrf.disable())
                .headers(h->h.frameOptions(f->f.sameOrigin()));

        return http.build();
    }
    public OAuth2UserService<OidcUserRequest, OidcUser> googleOidcUserService(SocialAuthService socialAuthService) {
        OidcUserService delegate = new OidcUserService();
        return userRequest -> {
            OidcUser oidcUser = delegate.loadUser(userRequest);
            socialAuthService.upsertUser(
                    socialAuthService.buildUpsertDto("google", oidcUser.getClaims())
            );
            return oidcUser;
        };
    }
}
