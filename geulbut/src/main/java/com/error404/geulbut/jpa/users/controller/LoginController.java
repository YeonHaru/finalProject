package com.error404.geulbut.jpa.users.controller;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.jpa.users.dto.UsersSignupDto;
import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.service.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Log4j2
@Controller
@RequiredArgsConstructor
public class LoginController {

    private final UsersService usersService;
    private final ErrorMsg errorMsg;

//    회원가입 페이지입니다.
    @GetMapping("/signup")
    public String signupForm(Model model) {
        model.addAttribute("usersSignupDto", new UsersSignupDto());
        return "users/signUp/signup";
    }

//    회원가입 처리
    @PostMapping("/signup")
    public String signupForm(
            @ModelAttribute UsersSignupDto usersSignupDto,
            BindingResult bindingResult,
            Model model){
        try{
            usersService.signup(usersSignupDto);
            return "redirect:/login";                       // 성공 시 로그인 페이지로 이동?이 나을까

        }   catch (IllegalArgumentException e){
            model.addAttribute("signupError", e.getMessage());
            model.addAttribute("usersSignupDto", usersSignupDto);
            return "users/signUp/signup";

        }   catch (Exception e){
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
}
