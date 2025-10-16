package com.error404.geulbut.jpa.reviews.repository;

import com.error404.geulbut.jpa.reviews.entity.Reviews;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReviewsRepository extends JpaRepository<Reviews, Long> {
}
