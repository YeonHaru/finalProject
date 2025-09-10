package com.error404.geulbut.jpa.authors.service;

import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;


@Log4j2
@SpringBootTest
@EnableJpaAuditing
class AuthorsServiceTest {
    @Autowired
    private AuthorsService authorsService;

    @Test
    void findAllAuthors() {
        Pageable pageable = PageRequest.of(0,3);
        Page<AuthorsDto> page = authorsService.findAllAuthors(pageable);
        log.info("테스트" + page.getContent());
    }
}