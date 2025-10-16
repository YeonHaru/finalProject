package com.error404.geulbut.jpa.reviews.service;

import com.error404.geulbut.jpa.reviews.dto.ReviewsDto;
import com.error404.geulbut.jpa.reviews.entity.Reviews;
import com.error404.geulbut.jpa.reviews.repository.ReviewsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ReviewsService {
    private final ReviewsRepository reviewsRepository;

    public void saveReview(ReviewsDto dto) {
        Reviews review = new Reviews();
        review.setBookId(dto.getBookId());
        review.setUserId(dto.getUserId());
        review.setRating(dto.getRating());
        review.setContent(dto.getContent());
        review.setOrderedItemId(dto.getOrderedItemId());
        review.setCreatedAt(LocalDateTime.now());
        review.setUpdatedAt(LocalDateTime.now());

        reviewsRepository.save(review);
    }
}
