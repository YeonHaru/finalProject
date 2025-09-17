package com.error404.geulbut.jpa.hashtags.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@EqualsAndHashCode(of = "hashtagId")
public class HashtagsDto {
    private String hashtagId;
    private String name;
}
