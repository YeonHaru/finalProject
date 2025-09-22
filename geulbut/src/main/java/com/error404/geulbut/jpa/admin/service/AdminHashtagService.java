package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.bookhashtags.entity.BookHashtags;
import com.error404.geulbut.jpa.bookhashtags.repository.BookHashtagsRepository;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.hashtags.dto.HashtagsDto;
import com.error404.geulbut.jpa.hashtags.entity.Hashtags;
import com.error404.geulbut.jpa.hashtags.repository.HashtagsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminHashtagService {

    private final HashtagsRepository hashtagsRepository;
    private final ErrorMsg errorMsg;
    private final MapStruct mapStruct;
    private final BookHashtagsRepository bookHashtagsRepository;

    // 전체조회(페이징)
    public Page<HashtagsDto> getAllHashtags(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return hashtagsRepository.findAll(pageable)
                .map(mapStruct::toDto);
    }

    // 단일 조회
    public HashtagsDto getHashtagById(Long hashtagId) {
        Hashtags hashtags = hashtagsRepository.findById(hashtagId)
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.hashtag.notfound")));
        return mapStruct.toDto(hashtags);
    }

    // 등록
    public HashtagsDto createHashtag(HashtagsDto hashtagsDto) {
        Hashtags hashtags = mapStruct.toEntity(hashtagsDto);
        Hashtags saved = hashtagsRepository.save(hashtags);
        return mapStruct.toDto(saved);
    }

    // 수정
    public HashtagsDto updateHashtag(Long hashtagId, HashtagsDto hashtagsDto) {
        Hashtags existing = hashtagsRepository.findById(hashtagId)
                .orElseThrow(() -> new IllegalArgumentException(errorMsg.getMessage("error.hashtag.notfound")));

        existing.setName(hashtagsDto.getName()); // 이름만 업데이트
        Hashtags saved = hashtagsRepository.save(existing);
        return mapStruct.toDto(saved);
    }

    // 삭제
    @Transactional
    public boolean deleteHashtag(Long hashtagId) {
        if (!hashtagsRepository.existsById(hashtagId)) {
            return false;
        }

        // 연결된 도서-해시태그 관계 먼저 삭제
        bookHashtagsRepository.deleteByHashtag_HashtagId(hashtagId);

        // 해시태그 삭제
        hashtagsRepository.deleteById(hashtagId);

        return true;
    }

    // 검색 기능
    public Page<HashtagsDto> searchHashtags(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        List<HashtagsDto> results = new ArrayList<>();

        // 숫자로 변환 가능하면 ID 검색
        try {
            Long id = Long.parseLong(keyword);
            hashtagsRepository.findById(id)
                    .ifPresent(hashtag -> results.add(mapStruct.toDto(hashtag)));
        } catch (NumberFormatException ignored) {
        }

        // 이름 검색
        hashtagsRepository.findByNameContainingIgnoreCase(keyword, pageable)
                .getContent()
                .forEach(h -> {
                    if (results.stream().noneMatch(r -> r.getHashtagId().equals(h.getHashtagId()))) {
                        results.add(mapStruct.toDto(h));
                    }
                });

        return new PageImpl<>(results, pageable, results.size());
    }

    // 해시태그별 도서 조회
    public List<BooksDto> getBooksByHashtag(Long hashtagId) {
        List<BookHashtags> bookHashtagsList = bookHashtagsRepository.findAllByHashtag_HashtagId(hashtagId);

        // 중복된 Books 제거를 위해 bookId 기준 그룹핑
        return bookHashtagsList.stream()
                .collect(Collectors.groupingBy(bh -> bh.getBook().getBookId()))
                .values().stream()
                .map(group -> {
                    Books book = group.get(0).getBook();
                    BooksDto dto = mapStruct.toDto(book);
                    // 해당 책에 연결된 해시태그만 dto에 담기
                    List<HashtagsDto> hashtags = group.stream()
                            .map(bh -> mapStruct.toDto(bh.getHashtag()))
                            .toList();
                    dto.setHashtags(hashtags);
                    return dto;
                })
                .toList();
    }
}