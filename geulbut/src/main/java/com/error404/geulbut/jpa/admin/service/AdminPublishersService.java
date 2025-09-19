package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.publishers.dto.PublishersDto;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import com.error404.geulbut.jpa.publishers.repository.PublishersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminPublishersService {

    private final PublishersRepository publishersRepository;
    private final MapStruct mapStruct;
    private ErrorMsg errorMsg;


//    전체조회
    public Page<PublishersDto> getAllPublishers(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return publishersRepository.findAll(pageable)
                .map(mapStruct::toDto);
    }

    // 단일 조회
    public PublishersDto getPublisherById(Long publisherId) {
        Publishers publisher = publishersRepository.findById(publisherId)
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.publishers.notfound")));
        return mapStruct.toDto(publisher);
    }

}
