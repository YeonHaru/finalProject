package com.error404.geulbut.jpa.reviews.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import com.error404.geulbut.jpa.reviews.dto.ReviewsDto;
import com.error404.geulbut.jpa.reviews.entity.Reviews;
import com.error404.geulbut.jpa.reviews.repository.ReviewsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ReviewsService {
    private final ReviewsRepository reviewsRepository;
    private final BooksRepository booksRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;


    @Transactional
    public void saveReview(ReviewsDto reviewsDto) {
//        JPA 저장 함수 실행 : return 값 : 저장된 객체
        Reviews reviews=mapStruct.toEntity(reviewsDto);
        reviewsRepository.save(reviews);
        Books books = booksRepository.findById(reviewsDto.getBookId())
                .orElseThrow(() -> new RuntimeException(errorMsg.getMessage("errors.not.found")));
        BooksDto booksDto = mapStruct.toDto(books);
                long count = booksDto.getReviewCount();
                double newRating = ((booksDto.getRating() * count) + reviewsDto.getRating()) / (count + 1);
                booksDto.setReviewCount(count + 1);
                booksDto.setRating(newRating);

                mapStruct.updateFromDto(booksDto, books);

    }

//    public void saveReview(ReviewsDto dto) {
////        Reviews review = new Reviews();
////        review.setBookId(dto.getBookId());
////        review.setUserId(dto.getUserId());
////        review.setRating(dto.getRating());
////        review.setContent(dto.getContent());
////        review.setOrderedItemId(dto.getOrderedItemId());
////        review.setCreatedAt(LocalDateTime.now());
////        review.setUpdatedAt(LocalDateTime.now());
//
//
////        reviewsRepository.save(review);
//
////        int count = booksDto.getReviewCount();
////        double newRating = ((booksDto.getRating() * count) + reviewsDto.getRating()) / (count + 1);
////        booksDto.setReviewCount(count + 1);
////        booksDto.setRating(newRating);
//
//    }
}
