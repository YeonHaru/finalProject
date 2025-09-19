package com.error404.geulbut.jpa.publishers.repository;

import com.error404.geulbut.jpa.publishers.entity.Publishers;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PublishersRepository extends JpaRepository<Publishers,Long> {

    Page<Publishers> findByNameContainingIgnoreCase(String name, Pageable pageable);

}
