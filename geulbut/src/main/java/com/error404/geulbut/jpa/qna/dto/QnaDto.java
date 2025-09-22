package com.error404.geulbut.jpa.qna.dto;

import lombok.*;

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
    private Date  qAt;
    private String aId;//로그인 된 유저 아이디
    private String aContent;//로그인 된 유저가 단 댓글
    private Date  aAt; // 로그인 된 유저가 댓글 단 시간
    private Long viewCount;
    private String userId;
}

