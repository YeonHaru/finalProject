package com.error404.geulbut.jpa.reviews.controller;

import com.error404.geulbut.jpa.orderitem.dto.OrderItemDto;
import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.service.OrdersService;
import com.error404.geulbut.jpa.reviews.dto.ReviewsDto;
import com.error404.geulbut.jpa.reviews.service.ReviewsService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/reviews")
public class ReviewsController {
    private final OrdersService ordersService;
    private final ReviewsService reviewsService;

    // 리뷰 작성 페이지
    @GetMapping("/write")
    public String goToReviewWritePage(@RequestParam Long orderId, Model model) {
        OrdersDto order = ordersService.getOrder(orderId);

        if (order.getItems() == null || order.getItems().isEmpty()) {
            throw new IllegalArgumentException("해당 주문에 책이 없습니다.");
        }

        // 첫 번째 책 정보만 전달
        OrderItemDto item = order.getItems().get(0);
        model.addAttribute("item", item);
        model.addAttribute("orderId", orderId);

        return "users/mypage/reviews";
    }

    // Ajax로 리뷰 저장
    @PostMapping("/save")
    @ResponseBody
    public String saveReview(@RequestBody ReviewsDto reviewsDto) {
        // 현재 로그인한 유저 정보 가져오기 (Spring Security)
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName(); // 로그인한 아이디

        reviewsDto.setUserId(userId);
        reviewsService.saveReview(reviewsDto);

        return "success";
    }
}
