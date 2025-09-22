package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.publishers.dto.PublishersDto;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import com.error404.geulbut.jpa.publishers.repository.PublishersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminPublishersService {

    private final PublishersRepository publishersRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;


    // 전체 조회 (페이징)
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

    //    출판사 등록
    public PublishersDto savePublisher(PublishersDto publishersDto) {
        Publishers publisher = mapStruct.toEntity(publishersDto);
        Publishers saved = publishersRepository.save(publisher);
        return mapStruct.toDto(saved);
    }

    // 출판사 수정
    public PublishersDto updatePublisher(PublishersDto publishersDto) {
        if (publishersDto.getPublisherId() == null) {
            throw new IllegalArgumentException(errorMsg.getMessage("error.publishers.id.required"));
        }

        Publishers existing = publishersRepository.findById(publishersDto.getPublisherId())
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.publishers.notfound")));

        mapStruct.updateFromDto(publishersDto, existing);
        Publishers saved = publishersRepository.save(existing);
        return mapStruct.toDto(saved);
    }

    //    삭제
    public boolean deletePublisher(Long publisherId) {
        if (publishersRepository.existsById(publisherId)) {
            publishersRepository.deleteById(publisherId);
            return true;
        }
        return false;
    }

    // 검색
    public Page<PublishersDto> searchPublishers(String search, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

        if (search == null || search.isEmpty()) {
            return getAllPublishers(page, size);
        }

        Long id = null;
        try {
            id = Long.parseLong(search);
        } catch (NumberFormatException ignored) {
            // 숫자가 아니면 id는 null
        }

        return publishersRepository.searchByIdOrName(id, search.toLowerCase(), pageable)
                .map(mapStruct::toDto);
    }


}
