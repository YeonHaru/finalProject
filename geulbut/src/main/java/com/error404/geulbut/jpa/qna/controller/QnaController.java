package com.error404.geulbut.jpa.qna.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class QnaController {
    @GetMapping("/qna")
    public String qna() {
        return "qna/qna";
    }

    @GetMapping("/qnaText")
    public String qnaText() {
        return "qna/qnaText";
    }

    @GetMapping("/qnaWrite")
    public String qnaWrite() {
        return "qna/qnaWrite";
    }
}
