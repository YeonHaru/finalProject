package com.error404.geulbut.jpa.qna.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class QnaController {
    @GetMapping("/qna")
    public String notice() {
        return "qna/qna";
    }
}
