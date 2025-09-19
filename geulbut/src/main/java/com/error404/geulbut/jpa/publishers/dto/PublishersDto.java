package com.error404.geulbut.jpa.publishers.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "publisherId")
public class PublishersDto {
    private Long publisherId;
    private String name;
    private String description;
    private LocalDateTime createdAt;
}
