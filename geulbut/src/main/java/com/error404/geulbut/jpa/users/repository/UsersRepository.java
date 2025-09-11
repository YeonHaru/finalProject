package com.error404.geulbut.jpa.users.repository;

import com.error404.geulbut.jpa.users.entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsersRepository extends JpaRepository<Users, String> {
    // 이메일 중복 체크용 메서드
    Optional<Users> findByEmail(String email);

    // 아이디 중복 체크용 메서드
    boolean existsByUserId(String userId);
}
