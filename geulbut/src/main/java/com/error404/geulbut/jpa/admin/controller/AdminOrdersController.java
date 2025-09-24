package com.error404.geulbut.jpa.admin.controller;


import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.jpa.admin.service.AdminOrdersService;
import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/admin/orders")
@PreAuthorize("hasRole('ADMIN')")
public class AdminOrdersController {

    private final AdminOrdersService adminOrdersService;
    private final ErrorMsg errorMsg;

    //    주문 목록 페이지(페이징+필터)
    @GetMapping
    public String listOrdersPage(Model model,
                                 @RequestParam(defaultValue = "0") int page,
                                 @RequestParam(defaultValue = "10") int size,
                                 @RequestParam(required = false) String status,
                                 @RequestParam(required = false) String userId) {

        Page<OrdersDto> ordersPage;

        if ((status == null || status.isEmpty()) && (userId == null || userId.isEmpty())) {
            ordersPage = adminOrdersService.getAllOrders(page, size);
        } else {
            List<OrdersDto> filteredOrders = adminOrdersService.getAllOrdersWithItems()
                    .stream()
                    .filter(o -> (status == null || status.isEmpty() || o.getStatus().equalsIgnoreCase(status)) &&
                            (userId == null || userId.isEmpty() || o.getUserId().equalsIgnoreCase(userId)))
                    .collect(Collectors.toList());
            model.addAttribute("ordersList", filteredOrders);
            model.addAttribute("status", status);
            model.addAttribute("userId", userId);
            return "admin/admin_orders_list";
        }

        model.addAttribute("ordersPage", ordersPage);
        model.addAttribute("status", status);
        model.addAttribute("userId", userId);
        return "admin/admin_orders_list";
    }

    //    단일 주문 조회
    @GetMapping("/{orderId}")
    @ResponseBody
    public OrdersDto getOrderById(@PathVariable Long orderId) {
        return adminOrdersService.getOrderById(orderId);
    }

    //    전체 주문 조회(items + books 포함)
    @GetMapping("/all")
    @ResponseBody
    public List<OrdersDto> getAllOrdersWithItems() {
        return adminOrdersService.getAllOrdersWithItems();
    }

//    상태 변경
    @PostMapping("/{orderId}/status")
    @ResponseBody
    public OrdersDto changeStatus(@PathVariable Long orderId, @RequestParam String status) {
        return adminOrdersService.updateOrderStatus(orderId, status);
    }

}
