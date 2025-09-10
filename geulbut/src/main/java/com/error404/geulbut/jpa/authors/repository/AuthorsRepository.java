package com.error404.geulbut.jpa.authors.repository;


import com.error404.geulbut.jpa.authors.entity.Authors;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthorsRepository extends JpaRepository<Authors, Long> {
}
