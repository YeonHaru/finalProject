package com.error404.geulbut.jpa.reviews.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "REVIEWS")
public class Reviews {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long reviewId;

    private Long bookId;
    private String userId;
    private int rating;

    @Column(length = 2000)
    private String content;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private Long orderedItemId;
}