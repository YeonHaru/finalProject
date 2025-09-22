package com.error404.geulbut.es.searchAllBooks.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.util.List;

@Document(indexName = "search-all-books")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@JsonIgnoreProperties(ignoreUnknown = true) //@Timestamp 등 회피용
public class SearchAllBooks {


    @Id
    @JsonProperty("book_id")
    private Long bookId;
    private String title;
    private Long price;
    @JsonProperty("discounted_price")
    private Long discountedPrice;
    private Long stock;
    @JsonProperty("author_name")
    private String authorName;
    @JsonProperty("category_name")
    private String categoryName;
    @JsonProperty("publisher_name")
    private String publisherName;
    @JsonProperty("books_img_url")
    private String booksImgUrl;
    private List<String> hashtags;
}
