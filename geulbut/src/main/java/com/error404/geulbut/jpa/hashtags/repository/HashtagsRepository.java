package com.error404.geulbut.jpa.hashtags.repository;

import com.error404.geulbut.jpa.hashtags.entity.Hashtags;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HashtagsRepository extends JpaRepository<Hashtags,Long> {
}
