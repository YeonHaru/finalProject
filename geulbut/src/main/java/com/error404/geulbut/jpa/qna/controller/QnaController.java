package com.error404.geulbut.jpa.qna.controller;

import com.error404.geulbut.jpa.qna.dto.QnaDto;
import com.error404.geulbut.jpa.qna.entity.QnaEntity;
import com.error404.geulbut.jpa.qna.service.QnaService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class QnaController {
    private final QnaService qnaService;

    // QnA 목록
    @GetMapping("/qna")
    public String qna(Model model) {

        return "qna/qna";
    }

    // QnA 상세보기
    @GetMapping("/qnaText")
    public String qnaText(@RequestParam("id") Long id, Model model) {
        QnaEntity qna = qnaService.findById(id);
        model.addAttribute("qna", qna);
        return "qna/qnaText";
    }

    // QnA 글쓰기 페이지
    @GetMapping("/qnaWrite")
    public String qnaWrite() {
        return "qna/qnaWrite";
    }

    // QnA 글쓰기 제출
    @PostMapping("/qnaSubmit")
    public String submitQna(QnaDto qnaDto) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        qnaDto.setUserId(userId);
        qnaService.saveQna(qnaDto);
        return "redirect:/qna";
    }
}
