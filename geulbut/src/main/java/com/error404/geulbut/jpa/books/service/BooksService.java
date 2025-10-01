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

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    @Transactional(readOnly = true)
    public List<BooksDto> getHotNewsBooks(List<Long> ids) {
        List<Books> found = booksRepository.findByIds(ids);

        Map<Long, Integer> order = new HashMap<>();
        for ( int i = 0; i < ids.size(); i++ ) order.put(ids.get(i), i);

        return found.stream()
                .sorted(Comparator.comparing(b -> order.getOrDefault(b.getBookId(), Integer.MAX_VALUE)))
                .map(mapStruct::toDto)
                .toList();
    }
}
