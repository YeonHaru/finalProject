package com.error404.geulbut.jpa.notice.repository;

import com.error404.geulbut.jpa.notice.entity.NoticeEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoticeRepository extends JpaRepository<NoticeEntity, Long> {
}
