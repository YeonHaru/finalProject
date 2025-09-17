package com.error404.geulbut.jpa.publishers.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "publisherId")
public class PublishersDto {
    private String publisherId;
    private String name;
    private String description;
}
