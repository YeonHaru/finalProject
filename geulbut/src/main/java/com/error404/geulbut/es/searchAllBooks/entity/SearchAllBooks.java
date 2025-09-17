package com.error404.geulbut.es.searchAllBooks.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

@Document(indexName = "search-all-books")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@JsonIgnoreProperties(ignoreUnknown = true) //@Timestamp 등 회피용
public class SearchAllBooks {


    @Id
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
