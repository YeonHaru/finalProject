package com.error404.geulbut.jpa.qna.repository;

import com.error404.geulbut.jpa.qna.entity.QnaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QnaRepository extends JpaRepository<QnaEntity, Long> {
}

