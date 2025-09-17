package com.error404.geulbut.jpa.notice.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class NoticeController {
    @GetMapping("/notice")
    public String notice() {
        return "notice/notice2";
    }

    @GetMapping("/noticeText")
    public String noticeText() {
        return "notice/notice-text";
    }
}
