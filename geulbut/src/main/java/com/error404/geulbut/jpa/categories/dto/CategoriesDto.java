package com.error404.geulbut.jpa.categories.dto;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "categoryId")
public class CategoriesDto {
    private Long categoryId;
    private String name;

}
