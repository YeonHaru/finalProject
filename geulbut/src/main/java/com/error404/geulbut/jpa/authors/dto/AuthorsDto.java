package com.error404.geulbut.jpa.authors.dto;


import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "authorId")
public class AuthorsDto {
    private Long authorId;
    private String name;
    private String description;
    private String imgUrl;
    private LocalDateTime createdAt;


    public AuthorsDto(Long authorId, String name, String description) {
        this.authorId = authorId;
        this.name = name;
        this.description = description;
    }


}
