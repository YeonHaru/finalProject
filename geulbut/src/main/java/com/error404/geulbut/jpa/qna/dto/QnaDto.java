package com.error404.geulbut.jpa.qna.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QnaDto {
    private Long id;
    private String title;
    private String qContent;
    private LocalDateTime qAt;
    private String aId;
    private String aContent;
    private LocalDateTime aAt;
    private String userId;
}

