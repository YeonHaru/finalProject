package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.authors.repository.AuthorsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminAuthorsService {

    private final AuthorsRepository authorsRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;

//    작가 전체 조회(페이징)
    public Page<AuthorsDto> getAllAuthors(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return authorsRepository.findAll(pageable)
                .map(mapStruct::toDto);
    }

//    작가 단일 조회
    public AuthorsDto getAuthorById(Long authorId) {
        Authors authors = authorsRepository.findById(authorId)
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.authors.notfound")));
        return mapStruct.toDto(authors);
    }

//    작가 등록
    public AuthorsDto saveAuthor(AuthorsDto authorsDto) {
        Authors authors = mapStruct.toEntity(authorsDto);
        Authors savedAuthors = authorsRepository.save(authors);
        return mapStruct.toDto(savedAuthors);
    }

//    작가 수정
    public AuthorsDto updateAuthor(AuthorsDto authorsDto) {
        Authors existing = authorsRepository.findById(authorsDto.getAuthorId())
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.authors.notfound")));
        mapStruct.updateFromDto(authorsDto, existing);
        Authors savedAuthors = authorsRepository.save(existing);
        return mapStruct.toDto(savedAuthors);
    }

//    작가 삭제 (db를 바로 삭제)
    public boolean deleteAuthor(Long authorId) {
        if (authorsRepository.existsById(authorId)) {
            authorsRepository.deleteById(authorId);
            return true;
        }
        return false;
    }
//    작가 검색
    public Page<AuthorsDto> searchAuthors(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());

        if (keyword == null || keyword.isEmpty()) {
            return authorsRepository.findAll(pageable).map(mapStruct::toDto);
        } else {
            return authorsRepository.findByNameContainingIgnoreCase(keyword, pageable)
                    .map(mapStruct::toDto);
        }
    }
}
