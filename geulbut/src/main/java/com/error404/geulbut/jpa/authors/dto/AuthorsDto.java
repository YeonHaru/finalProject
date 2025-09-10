package com.error404.geulbut.jpa.authors.dto;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "authorId")
public class AuthorsDto {
    private String authorId;
    private String name;
    private String description;
    private String imgUrl;

    public AuthorsDto(String authorId, String name, String description) {
        this.authorId = authorId;
        this.name = name;
        this.description = description;
    }


}
