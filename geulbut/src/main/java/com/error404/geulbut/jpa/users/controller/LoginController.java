package com.error404.geulbut.jpa.users.controller;


import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.jpa.users.dto.PasswordRecoveryDto;
import com.error404.geulbut.jpa.users.dto.PasswordRecoveryDto.VerifyEmailAndResetRequest;
import com.error404.geulbut.jpa.users.dto.UsersSignupDto;
import com.error404.geulbut.jpa.users.service.UsersService;
import com.error404.geulbut.jpa.users.service.PasswordRecoveryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Log4j2
@Controller
@RequiredArgsConstructor
public class LoginController {

    private final UsersService usersService;
    private final ErrorMsg errorMsg;
    private final PasswordRecoveryService passwordRecoveryService;

    //    회원가입 페이지입니다.
    @GetMapping("/signup")
    public String signupForm(Model model) {
        model.addAttribute("usersSignupDto", new UsersSignupDto());
        return "users/signUp/signup";
    }

    //    회원가입 처리
    @PostMapping("/signup")
    public String signupForm(@Valid
                             @ModelAttribute UsersSignupDto usersSignupDto,
                             BindingResult bindingResult,
                             Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("usersSignupDto", usersSignupDto);
            return "users/signUp/signup";
        }
        try {
            usersService.signup(usersSignupDto);
            return "redirect:/login";                       // 성공 시 로그인 페이지로 이동?이 나을까

        } catch (IllegalArgumentException e) {
            model.addAttribute("signupError", e.getMessage());
            model.addAttribute("usersSignupDto", usersSignupDto);
            return "users/signUp/signup";

        } catch (Exception e) {
//            예기치 못한 오류 -> 공통 메시지를 활용 할 것
            model.addAttribute("signupError", errorMsg.getMessage("error.common.server"));
            model.addAttribute("usersSignupDto", usersSignupDto);
            return "users/signUp/signup";
        }
    }

    @GetMapping("/login")
    public String login(@RequestParam(required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("loginError", "로그인 중 오류가 발생했습니다. 다시 시도해주세요.");
        }
        return "users/login/login";
    }

    //    회원가입 유효성 검사 (AJAX용 API)
    @GetMapping("/users/check-id")
    @ResponseBody
    public boolean checkUserId(@RequestParam String userId) {
        return usersService.isUserIdAvailable(userId);
    }

    @GetMapping("/users/check-email")
    @ResponseBody
    public boolean checkEmail(@RequestParam String email) {
        return usersService.isEmailAvailable(email);
    }

    //    아디찾기
    @GetMapping("/find-id")
    public String findIdForm() {
        return "users/find/findId";
    }

    @PostMapping("/find-id")
    public String findId(@RequestParam String name,
                         @RequestParam String email,
                         Model model) {
        usersService.findUserId(name, email)
                .ifPresentOrElse(
                        r -> {
                            model.addAttribute("foundUserId", r.getMaskedUserId());
                            model.addAttribute("isSocial", r.isSocial());
                            model.addAttribute("provider", r.getProvider()); //카카오구글네이버
                        },
                        () -> model.addAttribute("findIdError", "일치하는 회원이 없습니다.")
                );
        return "users/find/findId";
    }

    //    비번찾기
    @GetMapping("/find-password")
    public String findPasswordForm() {
        return "users/find/findPassword";
    }


    //    이메일: 인증코드 전송 (AJAX, JSON)
    @PostMapping("/find-password/email/code")
    @ResponseBody
    public ResponseEntity<?> sendEmailCode(@RequestBody @Valid
                                           PasswordRecoveryDto.SendEmailCodeRequest req) {
        try {
            passwordRecoveryService.sendEmailCode(req);
            return ResponseEntity.ok("OK");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            log.error("sendEmailCode error", e);
            return ResponseEntity.internalServerError().body(errorMsg.getMessage("error.common.server"));
        }
    }

    //    이메일 : 코드검증 + 임시비번 발급 (폼 서브밋)
    @PostMapping("/find-password/email/verify")
    public String verifyEmail(@ModelAttribute @Valid VerifyEmailAndResetRequest req,
                              BindingResult bindingResult,
                              Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("resetPwError", "입력값을 확인해 주세요.");
            return "users/find/findPassword";
        }
        try {
            String temp = passwordRecoveryService.verifyEmailAndReset(req);
            model.addAttribute("resetPw", temp);
            model.addAttribute("resetPwMsg", "임시 비밀번호를 이메일로 발송했습니다.");
        } catch (IllegalArgumentException e) {
            model.addAttribute("resetPwError", e.getMessage());
        } catch (Exception e) {
            log.error("verifyEmail error", e);
            model.addAttribute("resetPwError", errorMsg.getMessage("error.common.server"));
        }
        return "users/find/findPassword";
    }

}
