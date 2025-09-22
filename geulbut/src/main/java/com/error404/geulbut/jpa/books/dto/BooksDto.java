package com.error404.geulbut.jpa.books.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "bookId")
public class BooksDto {
    private Long bookId;
    private String title;
    private Long authorId;
    private String authorName;
    private Long publisherId;
    private String publisherName;
    private String imgUrl;
    private String nation;
    private String publishedDate;
    private Long price;
    private Long discountedPrice;
    private Long stock;
    private Long orderCount;
    private Long wishCount;
    private Long categoryId;
    private String categoryName;
    private String description;
    private String isbn;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    //    ES_DELETE_FLAG
    private String esDeleteFlag= "N";            // Y or N  디폴트 N
}
