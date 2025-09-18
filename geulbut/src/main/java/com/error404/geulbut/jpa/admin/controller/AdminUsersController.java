package com.error404.geulbut.jpa.admin.controller;

import com.error404.geulbut.jpa.admin.service.AdminUsersService;
import com.error404.geulbut.jpa.users.entity.Users;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AdminController
 *
 * 목적: 관리자용 회원 관리 기능 제공
 * - JSP 페이지 렌더링: 회원 검색/조회/페이징
 * - REST API 제공: 회원 CRUD 및 통계
 *
 * 접근 권한: ADMIN 전용 (@PreAuthorize("hasRole('ADMIN')"))
 */
@RequiredArgsConstructor
@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')") // ADMIN 권한만 접근 가능
public class AdminUsersController {

    private final AdminUsersService adminUsersService; // 비즈니스 로직 처리용 서비스aaaxxx

    // ====================================================
    // 1️⃣ JSP 페이지 렌더링 (회원 관리 페이지)
    // ====================================================
    @GetMapping("/users-info")
    public String usersInfoPage(
            Model model,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String roleFilter,
            @RequestParam(required = false) String statusFilter,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        // 1. 검색어 + 페이징 적용하여 회원 리스트 조회
        Page<Users> usersPage = adminUsersService.searchUsers(keyword, startDate, endDate, roleFilter, statusFilter, page, size);

        // 2. JSP에 데이터 전달
        model.addAttribute("usersPage", usersPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("roleFilter", roleFilter);
        model.addAttribute("statusFilter", statusFilter);

        // 3. 렌더링할 JSP 경로
        return "admin/admin_users_Info";
    }

    // ====================================================
    // 2️⃣ REST API: 전체 회원 조회 (JSON)
    // ====================================================
    @GetMapping("/api/users")
    @ResponseBody
    public List<Users> getAllUsersApi() {
        return adminUsersService.getAllUsers(); // DB에 저장된 모든 회원 반환
    }

    // ====================================================
    // 3️⃣ REST API: 특정 회원 조회 (JSON)
    // ====================================================
    @GetMapping("/api/users/{userId}")
    @ResponseBody
    public ResponseEntity<Users> getUserByIdApi(@PathVariable String userId) {
        return adminUsersService.getUserById(userId)
                .map(ResponseEntity::ok)                   // 회원 존재 시 200 OK + 데이터
                .orElse(ResponseEntity.notFound().build()); // 없으면 404 NOT FOUND
    }

    // ====================================================
    // 4️⃣ REST API: 회원 권한 변경
    // ====================================================
    @PutMapping("/api/users/{userId}/role")
    @ResponseBody
    public ResponseEntity<String> updateUserRoleApi(
            @PathVariable String userId,
            @RequestParam String newRole // 변경할 권한 (예: ADMIN, USER, MANAGER)
    ) {
        boolean result = adminUsersService.updateUserRole(userId, newRole);
        if (result) return ResponseEntity.ok("권한 변경 완료");
        else return ResponseEntity.badRequest().body("회원이 존재하지 않음");
    }

    // ====================================================
    // 5️⃣ REST API: 회원 삭제
    // ====================================================
    @DeleteMapping("/api/users/{userId}")
    @ResponseBody
    public ResponseEntity<String> deleteUserApi(@PathVariable String userId) {
        boolean result = adminUsersService.deleteUser(userId);
        if (result) return ResponseEntity.ok("회원 삭제 완료");
        else return ResponseEntity.badRequest().body("회원이 존재하지 않음");
    }

    // ====================================================
    // 6️⃣ REST API: 회원 통계 (총 회원수 + 오늘 가입자 수)
    // ====================================================
    @GetMapping("/api/users/stats")
    @ResponseBody
    public Map<String, Long> getUserStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("totalUsers", adminUsersService.getTotalUsers());       // 총 회원 수
        stats.put("todayNewUsers", adminUsersService.getTodayNewUsers()); // 오늘 가입한 회원 수
        return stats;
    }
    // 회원 계정 상태 변경
    @PutMapping("/api/users/{userId}/status")
    @ResponseBody
    public ResponseEntity<String> updateUserStatusApi(
            @PathVariable String userId,
            @RequestParam String newStatus // ACTIVE, INACTIVE
    ) {
        boolean result = adminUsersService.updateUserStatus(userId, newStatus);
        if (result) return ResponseEntity.ok("계정 상태 변경 완료");
        else return ResponseEntity.badRequest().body("회원이 존재하지 않음");
    }

}
