package com.error404.geulbut.es.searchAllBooks.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class SearchAllBooksDto {
    private Long bookId;
    private String title;
    private Long price;
    private Long discountedPrice;
    private Long stock;
    private String authorName;
    private String categoryName;
    private String publisherName;
    private String booksImgUrl;
    private String hashtags;
}
