package com.error404.geulbut.jpa.admin.service;

import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.authors.repository.AuthorsRepository;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.categories.entity.Categories;
import com.error404.geulbut.jpa.categories.repository.CategoriesRepository;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import com.error404.geulbut.jpa.publishers.repository.PublishersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AdminBooksService {

    private final BooksRepository booksRepository;
    private final AuthorsRepository authorsRepository;
    private final CategoriesRepository categoriesRepository;
    private final PublishersRepository publishersRepository;

    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ISO_DATE;

    // 1️⃣ 전체 도서 조회 (페이징)
    public Page<Books> getAllBooks(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return booksRepository.findAll(pageable);
    }

    // 2️⃣ 단일 도서 조회
    public Optional<Books> getBookById(Long bookId) {
        return booksRepository.findById(bookId);
    }

    // 3️⃣ 도서 등록
    public Books saveBook(Books book) {
        if (book.getIsbn() != null && booksRepository.existsByIsbn(book.getIsbn())) {
            throw new IllegalArgumentException("이미 존재하는 ISBN입니다.");
        }
        setRelations(book);
        return booksRepository.save(book);
    }

    // 4️⃣ 도서 수정
    public Books updateBook(Books book) {
        Books existingBook = booksRepository.findById(book.getBookId())
                .orElseThrow(() -> new IllegalArgumentException("도서가 존재하지 않습니다."));

        setRelations(book, existingBook);

        // 나머지 필드 업데이트
        existingBook.setTitle(book.getTitle());
        existingBook.setDescription(book.getDescription());
        existingBook.setPrice(book.getPrice());
        existingBook.setDiscountedPrice(book.getDiscountedPrice());
        existingBook.setStock(book.getStock());
        existingBook.setImgUrl(book.getImgUrl());
        existingBook.setIsbn(book.getIsbn());
        existingBook.setNation(book.getNation());
        existingBook.setPublishedDate(book.getPublishedDate()); // LocalDate
        existingBook.setOrderCount(book.getOrderCount());
        existingBook.setWishCount(book.getWishCount());

        return booksRepository.save(existingBook);
    }

    // 5️⃣ 도서 삭제
    public boolean deleteBook(Long bookId) {
        if (booksRepository.existsById(bookId)) {
            booksRepository.deleteById(bookId);
            return true;
        }
        return false;
    }

    // 6️⃣ 검색 기능 (임시)
    public Page<Books> searchBooks(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        // TODO: 실제 검색 로직 구현
        return booksRepository.findAll(pageable);
    }

    // ==============================
    // 🔹 Author, Category, Publisher 세팅
    // ==============================
    private void setRelations(Books book) {
        if (book.getAuthor() != null && book.getAuthor().getAuthorId() != null) {
            Authors author = authorsRepository.findById(book.getAuthor().getAuthorId())
                    .orElseThrow(() -> new IllegalArgumentException("저자가 존재하지 않습니다."));
            book.setAuthor(author);
        } else book.setAuthor(null);

        if (book.getCategory() != null && book.getCategory().getCategoryId() != null) {
            Categories category = categoriesRepository.findById(book.getCategory().getCategoryId())
                    .orElseThrow(() -> new IllegalArgumentException("카테고리가 존재하지 않습니다."));
            book.setCategory(category);
        } else book.setCategory(null);

        if (book.getPublisher() != null && book.getPublisher().getPublisherId() != null) {
            Publishers publisher = publishersRepository.findById(book.getPublisher().getPublisherId())
                    .orElseThrow(() -> new IllegalArgumentException("퍼블리셔가 존재하지 않습니다."));
            book.setPublisher(publisher);
        } else book.setPublisher(null);
    }

    // Overload: 기존 Book과 매핑 (수정용)
    private void setRelations(Books source, Books target) {
        if (source.getAuthor() != null && source.getAuthor().getAuthorId() != null) {
            Authors author = authorsRepository.findById(source.getAuthor().getAuthorId())
                    .orElseThrow(() -> new IllegalArgumentException("저자가 존재하지 않습니다."));
            target.setAuthor(author);
        } else target.setAuthor(null);

        if (source.getCategory() != null && source.getCategory().getCategoryId() != null) {
            Categories category = categoriesRepository.findById(source.getCategory().getCategoryId())
                    .orElseThrow(() -> new IllegalArgumentException("카테고리가 존재하지 않습니다."));
            target.setCategory(category);
        } else target.setCategory(null);

        if (source.getPublisher() != null && source.getPublisher().getPublisherId() != null) {
            Publishers publisher = publishersRepository.findById(source.getPublisher().getPublisherId())
                    .orElseThrow(() -> new IllegalArgumentException("퍼블리셔가 존재하지 않습니다."));
            target.setPublisher(publisher);
        } else target.setPublisher(null);
    }

    // 7️⃣ 모달용 전체 조회
    public List<Authors> getAllAuthors() { return authorsRepository.findAll(Sort.by("name").ascending()); }
    public List<Publishers> getAllPublishers() { return publishersRepository.findAll(Sort.by("name").ascending()); }
    public List<Categories> getAllCategories() { return categoriesRepository.findAll(Sort.by("name").ascending()); }

    // 🔹 수정 모달용
    public Map<String, Object> getBookAndRelations(Long bookId) {
        Books book = booksRepository.findById(bookId)
                .orElseThrow(() -> new IllegalArgumentException("도서가 존재하지 않습니다."));
        Map<String, Object> map = new HashMap<>();
        map.put("book", book);
        map.put("authors", getAllAuthors());
        map.put("publishers", getAllPublishers());
        map.put("categories", getAllCategories());
        return map;
    }

    // 단일 조회
    public Authors getAuthorById(Long authorId) {
        return authorsRepository.findById(authorId)
                .orElseThrow(() -> new IllegalArgumentException("저자가 존재하지 않습니다."));
    }
    public Publishers getPublisherById(Long publisherId) {
        return publishersRepository.findById(publisherId)
                .orElseThrow(() -> new IllegalArgumentException("퍼블리셔가 존재하지 않습니다."));
    }
    public Categories getCategoryById(Long categoryId) {
        return categoriesRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("카테고리가 존재하지 않습니다."));
    }

    // ==============================
    // 🔹 DTO ↔ Entity 변환 (publishedDate 처리)
    // ==============================
    public Books fromDto(BooksDto dto) {
        Books book = new Books();
        book.setTitle(dto.getTitle());
        book.setIsbn(dto.getIsbn());
        book.setPrice(dto.getPrice());
        book.setDiscountedPrice(dto.getDiscountedPrice());
        book.setStock(dto.getStock());
        book.setImgUrl(dto.getImgUrl());
        book.setDescription(dto.getDescription());
        book.setNation(dto.getNation());

        // ✅ String -> LocalDate 변환
        if(dto.getPublishedDate() != null && !dto.getPublishedDate().isEmpty()) {
            book.setPublishedDate(LocalDate.parse(dto.getPublishedDate(), dateFormatter));
        }

        book.setOrderCount(dto.getOrderCount());
        book.setWishCount(dto.getWishCount());

        if(dto.getAuthorId() != null) book.setAuthor(getAuthorById(dto.getAuthorId()));
        if(dto.getPublisherId() != null) book.setPublisher(getPublisherById(dto.getPublisherId()));
        if(dto.getCategoryId() != null) book.setCategory(getCategoryById(dto.getCategoryId()));

        return book;
    }

    public void updateFromDto(BooksDto dto, Books book) {
        book.setTitle(dto.getTitle());
        book.setIsbn(dto.getIsbn());
        book.setPrice(dto.getPrice());
        book.setDiscountedPrice(dto.getDiscountedPrice());
        book.setStock(dto.getStock());
        book.setImgUrl(dto.getImgUrl());
        book.setDescription(dto.getDescription());
        book.setNation(dto.getNation());

        // ✅ String -> LocalDate 변환
        if(dto.getPublishedDate() != null && !dto.getPublishedDate().isEmpty()) {
            book.setPublishedDate(LocalDate.parse(dto.getPublishedDate(), dateFormatter));
        } else {
            book.setPublishedDate(null);
        }

        book.setOrderCount(dto.getOrderCount());
        book.setWishCount(dto.getWishCount());

        if(dto.getAuthorId() != null) book.setAuthor(getAuthorById(dto.getAuthorId()));
        if(dto.getPublisherId() != null) book.setPublisher(getPublisherById(dto.getPublisherId()));
        if(dto.getCategoryId() != null) book.setCategory(getCategoryById(dto.getCategoryId()));
    }

    public BooksDto toDto(Books book) {
        BooksDto dto = new BooksDto();
        dto.setBookId(book.getBookId());
        dto.setTitle(book.getTitle());
        dto.setIsbn(book.getIsbn());
        dto.setPrice(book.getPrice());
        dto.setDiscountedPrice(book.getDiscountedPrice());
        dto.setStock(book.getStock());
        dto.setImgUrl(book.getImgUrl());
        dto.setDescription(book.getDescription());
        dto.setNation(book.getNation());

        // ✅ LocalDate -> String 변환
        if(book.getPublishedDate() != null) {
            dto.setPublishedDate(book.getPublishedDate().format(dateFormatter));
        }

        dto.setOrderCount(book.getOrderCount());
        dto.setWishCount(book.getWishCount());

        if(book.getAuthor() != null) {
            dto.setAuthorId(book.getAuthor().getAuthorId());
            dto.setAuthorName(book.getAuthor().getName());
        }
        if(book.getPublisher() != null) {
            dto.setPublisherId(book.getPublisher().getPublisherId());
            dto.setPublisherName(book.getPublisher().getName());
        }
        if(book.getCategory() != null) {
            dto.setCategoryId(book.getCategory().getCategoryId());
            dto.setCategoryName(book.getCategory().getName());
        }
        return dto;
    }
}
