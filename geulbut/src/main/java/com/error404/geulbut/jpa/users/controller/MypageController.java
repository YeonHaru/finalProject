package com.error404.geulbut.jpa.users.controller;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.carts.dto.CartDto;
import com.error404.geulbut.jpa.carts.service.CartService;
import com.error404.geulbut.jpa.users.dto.UserMypageDto;
import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.service.UsersService;
import com.error404.geulbut.jpa.wishlist.dto.WishlistDto;
import com.error404.geulbut.jpa.wishlist.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@RequiredArgsConstructor
@Controller
@RequestMapping("/mypage")
public class MypageController {

    private final UsersService usersService;       // 사용자 서비스
    private final WishlistService wishlistService; // 위시리스트 서비스
    private final CartService cartService;
    private final MapStruct mapStruct;             // Entity ↔ DTO 변환 매퍼
    private final PasswordEncoder passwordEncoder; // BCryptPasswordEncoder

    /** 📌 마이페이지 메인 */
    @GetMapping
    public String mypage(Model model) {
        String loginUserId = getLoginUserId();
        if (loginUserId == null) {
            return "redirect:/login";
        }

        // 🔹 사용자 정보
        Users user = usersService.getUserById(loginUserId);
        if (user != null) {
            UserMypageDto dto = mapStruct.toMypageDto(user);
            model.addAttribute("user", dto);
        }

        // 🔹 위시리스트 (DB 연동)
        List<WishlistDto> wishlist = wishlistService.getWishlist(loginUserId);
        model.addAttribute("wishlist", wishlist);

        // 🔹 장바구니 (임시 데이터 → 나중에 CartService로 대체)
        List<CartDto> cartList = cartService.getCartList(loginUserId);
        long  cartTotal = cartList.stream()
                .mapToLong(CartDto::getTotalPrice)
                .sum();

        model.addAttribute("cart", cartList);
        model.addAttribute("cartTotal", cartTotal);
        // 🔹 주문 내역 (임시 데이터 → 나중에 OrderService로 대체)
        model.addAttribute("orders", List.of());

        return "users/mypage/mypage";  // ✅ JSP 경로 통일
    }

    /** 📌 비밀번호 변경 */
    @PostMapping("/change-password")
    public String changePassword(@RequestParam String currentPw,
                                 @RequestParam String newPw,
                                 @RequestParam String confirmPw,
                                 Model model) {
        String loginUserId = getLoginUserId();
        if (loginUserId == null) return "redirect:/login";

        try {
            usersService.changePassword(loginUserId, currentPw, newPw, confirmPw);
            model.addAttribute("successMsg", "비밀번호가 변경되었습니다.");
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", e.getMessage());
        }

        // 다시 mypage 데이터를 채워서 forward
        return mypage(model);
    }

    /** 📌 로그인 사용자 아이디 가져오기 */
    private String getLoginUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            Object principal = authentication.getPrincipal();
            if (principal instanceof UserDetails userDetails) {
                return userDetails.getUsername();
            }
        }
        return null;
    }
}
