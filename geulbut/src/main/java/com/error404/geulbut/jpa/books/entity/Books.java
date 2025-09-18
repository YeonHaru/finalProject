package com.error404.geulbut.jpa.books.entity;


import com.error404.geulbut.common.BaseTimeEntity;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.categories.entity.Categories;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;


@Entity
@Table(name = "BOOKS")
@SequenceGenerator(
        name = "SEQ_BOOKS_JPA",
        sequenceName = "SEQ_BOOKS",
        allocationSize = 1
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "bookId", callSuper = false)
public class Books extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_BOOKS_JPA")
    private Long bookId;
    private String title;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id", nullable = false)
    private Authors author;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "publisher_id", nullable = false)
    private Publishers publisher;

    @Lob
    private byte[] bookImg;
    private String imgUrl;
    private String nation;


    private LocalDate publishedDate;

    private Long price;
    private Long discountedPrice;
    private Long stock;
    private Long orderCount;
    private Long wishCount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Categories category;

    @Lob
    private String description;

    private String isbn;

    //    ES_DELETE_FLAG
//   어노테이션 지정한건 도서등록할 때 db에 null 값이 못들어가게 설정
//    새로 등록되는 데이터는 N이 들어가도록 지정
    @Column(name = "es_delete_flag", nullable = false, columnDefinition = "CHAR(1) DEFAULT 'N'")
    private String esDeleteFlag = "N";


}


