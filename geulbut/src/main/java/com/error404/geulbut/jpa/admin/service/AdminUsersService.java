package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.jpa.users.entity.Users;
import com.error404.geulbut.jpa.users.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class AdminUsersService {

    private final UsersRepository usersRepository;

    /**
     * 1. 전체 회원 조회
     *
     * @return DB에 저장된 모든 Users 엔티티 리스트
     */
    public List<Users> getAllUsers() {
        return usersRepository.findAll();
    }

    /**
     * 2. 회원 ID로 조회
     *
     * @param userId 조회할 회원 ID
     * @return Optional<Users>
     */
    public Optional<Users> getUserById(String userId) {
        return usersRepository.findById(userId);
    }

    /**
     * 3. 회원 권한 변경
     *
     * @param userId  권한 변경 대상 회원 ID
     * @param newRole 변경할 권한
     * @return true: 변경 성공, false: 회원 없음
     */
    public boolean updateUserRole(String userId, String newRole) {
        Optional<Users> optionalUsers = usersRepository.findById(userId);
        if (optionalUsers.isPresent()) {
            Users users = optionalUsers.get();
            users.setRole(newRole);  // ADMIN, USER, MANAGER
            usersRepository.save(users);
            return true;
        }
        return false;
    }

    /**
     * 4. 회원 삭제
     *
     * @param userId 삭제할 회원 ID
     * @return true: 삭제 성공, false: 회원 없음
     */
    public boolean deleteUser(String userId) {
        if (usersRepository.existsById(userId)) {
            usersRepository.deleteById(userId);
            return true;
        }
        return false;
    }

    /**
     * 5. 회원 검색 + 필터 + 페이징
     *
     * @param keyword      검색어 (회원ID, 이름, 이메일)
     * @param startDate    가입일 시작
     * @param endDate      가입일 끝
     * @param roleFilter   권한 필터
     * @param statusFilter 상태 필터
     * @param page         페이지 번호 (0부터 시작)
     * @param size         페이지당 표시 건수
     * @return 검색 결과 포함 Page<Users>
     */
    public Page<Users> searchUsers(String keyword,
                                   String startDate,
                                   String endDate,
                                   String roleFilter,
                                   String statusFilter,
                                   int page,
                                   int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("joinDate").descending());

        LocalDate start = (startDate != null && !startDate.isEmpty()) ? LocalDate.parse(startDate) : null;
        LocalDate end = (endDate != null && !endDate.isEmpty()) ? LocalDate.parse(endDate) : null;

//        덕규 : 마찬가지로 String을 Enum으로 변환
//        if와 try 조건문 추가만 했습니다.
        Users.UserStatus statusEnum = null;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            try{
                statusEnum = Users.UserStatus.valueOf(statusFilter.toUpperCase());
            } catch (IllegalArgumentException e){
                statusEnum = null;  // 잘못된 값이면 필터링 안 함
            }
        }

        return usersRepository.searchByKeyword(
                (keyword == null || keyword.trim().isEmpty()) ? null : keyword,
                start,
                end,
                (roleFilter == null || roleFilter.isEmpty()) ? null : roleFilter,
                (statusFilter == null || statusFilter.isEmpty()) ? null : statusFilter,
                pageable
        );
    }

    /**
     * 총 회원 수
     */
    public Long getTotalUsers() {
        return usersRepository.count();
    }

    /**
     * 오늘 가입한 회원 수
     */
    public long getTodayNewUsers() {
        LocalDate today = LocalDate.now();
        return usersRepository.countByJoinDateBetween(today, today.plusDays(1));
    }
//     계정 상태 변경
    public boolean updateUserStatus(String userId, String newStatus) {
        Optional<Users> optionalUsers = usersRepository.findById(userId);
        if (optionalUsers.isPresent()) {
            Users user = optionalUsers.get();
//            덕규 : 구글쪽 데이터 베이스를 받아오기 위해 수정 좀 했습니다. 수정한부분 표시
//                      try 조건문 추가 하고 스트링을 이넘변환만 줬음.
            try{
//                String 을 Enum 변환
                Users.UserStatus statusEnum = Users.UserStatus.valueOf(newStatus.toUpperCase());
//                user.setStatus(newStatus); // ACTIVE / INACTIVE -- 이걸 바꿨습니다.
                user.setStatus(statusEnum);
                usersRepository.save(user);
                return true;
            } catch (IllegalArgumentException e) {
//                잘못된 값 들어오면 false 리턴
            }
        }
        return false;
    }

}
