package com.error404.geulbut.jpa.authors.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.authors.repository.AuthorsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthorsService {
    private final AuthorsRepository authorsRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;

    public Page<AuthorsDto> findAllAuthors(Pageable pageable) {
        Page<Authors> page = authorsRepository.findAll(pageable);
        return page.map(authors ->  mapStruct.toDto(authors));
    }

}
