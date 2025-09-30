package com.error404.geulbut.jpa.books.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BooksService {
    private final BooksRepository booksRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;

    public BooksDto findDetailByBookId(long bookId) {
        Books books = booksRepository.findDetailByBookId(bookId)
                .orElseThrow(() -> new IllegalArgumentException("book not found"));
        return mapStruct.toDto(books);
    }

    @Transactional(readOnly = true)
    public List<BooksDto> getBestSellersTop10() {
        var page = PageRequest.of(0, 10);
        return  booksRepository.findBestSellers(page)
                .stream()
                .map(mapStruct::toDto)
                .toList();
    }
}
