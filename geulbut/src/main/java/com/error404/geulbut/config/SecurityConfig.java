package com.error404.geulbut.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

//    개발 중 임시 전체 오픈 스위치(true = 전체허용, false = 원래보안)
    private static final boolean DEV_BYPASS = true;

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        if (DEV_BYPASS) {
//            임시 전체 허용 모드
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
                        .requestMatchers("/", "/ping", "/login", "/oauth2/**", "/css/**", "/js/**", "/images/**").permitAll()
                        .anyRequest().authenticated()
                )
                .formLogin(form->form
                        .loginPage("/login")
                        .permitAll()
                )
                .oauth2Login(oauth->oauth
                        .loginPage("/login")
                        .defaultSuccessUrl("/", false)
                        .failureUrl("/login?error")
                )
                .logout(logout->logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                )

//                여기 반드시 확인!! 막혔다면 여기 임시로 비활성화 시켜놔서 그럴수도 있음
//                9/10 10:00 빠르게 확인할려는 목적으로 해놓은것
//                9/10 12:00 주석으로 막아서 풀어놨습니다. 활동로그 남기기위해서 해놓은거
                .csrf(csrf->csrf.disable());
        return http.build();
    }
}
