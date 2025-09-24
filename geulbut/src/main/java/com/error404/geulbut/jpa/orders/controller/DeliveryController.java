package com.error404.geulbut.jpa.orders.controller;

import com.error404.geulbut.jpa.orders.service.OrdersService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.core.Authentication;

@Controller
@RequestMapping("/orders")
@RequiredArgsConstructor
public class DeliveryController {

    private final OrdersService ordersService;

    // 정식 경로: /orders/{orderId}/delivery
    @GetMapping("/{orderId}/delivery")
    public String delivery(@PathVariable Long orderId, Model model, Authentication auth) {
        OrdersService.DeliveryView view = ordersService.buildDeliveryView(orderId);
        model.addAttribute("delivery", view);
        return "orders/track/delivery_info";
    }

    // 실수 방지: /orders/delivery -> 마이페이지로
    @GetMapping("/delivery")
    public String deliveryRedirect() {
        return "redirect:/mypage"; // ✅ 존재하는 경로
    }

    // 쿼리 허용: /orders/delivery?orderId=123 -> 정식 경로로
    @GetMapping(value = "/delivery", params = "orderId")
    public String deliveryWithParam(@RequestParam Long orderId) {
        return "redirect:/orders/" + orderId + "/delivery";
    }
}
