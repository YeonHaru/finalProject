package com.error404.geulbut.jpa.books.dto;

import com.error404.geulbut.jpa.hashtags.dto.HashtagsDto;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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

    // 해시태그 필드 추가
    private List<HashtagsDto> hashtags = new ArrayList<>();
}
