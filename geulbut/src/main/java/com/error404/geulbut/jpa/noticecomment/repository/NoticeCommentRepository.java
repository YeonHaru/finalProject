package com.error404.geulbut.jpa.noticecomment.repository;

import com.error404.geulbut.jpa.notice.entity.NoticeEntity;
import com.error404.geulbut.jpa.noticecomment.entity.NoticeCommentEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface NoticeCommentRepository extends JpaRepository<NoticeCommentEntity, Long> {

    List<NoticeCommentEntity> findByNoticeOrderByCreatedAtAsc(NoticeEntity notice);
}
