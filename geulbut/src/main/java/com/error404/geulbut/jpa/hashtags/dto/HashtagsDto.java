package com.error404.geulbut.jpa.hashtags.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "hashtagId")
public class HashtagsDto {
    private Long hashtagId;
    private String name;
    private LocalDateTime createdAt;
}
