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

    // QnA 목록 - 페이징 적용
    @GetMapping("/qna")
    public String qnaList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            Model model) {

        var pageQnas = qnaService.getQnas(page, size); // Page<QnaDto>
        model.addAttribute("qnas", pageQnas.getContent()); // 현재 페이지 글 목록
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", pageQnas.getTotalPages());

        return "qna/qna";
    }


    // QnA 상세보기
    @GetMapping("/qnaText")
    public String qnaText(@RequestParam("id") Long id, Model model) {
        QnaDto qna = qnaService.findById(id);  // 해당 글 가져오기
        model.addAttribute("qna", qna);
        return "qna/qnaText";  // /WEB-INF/views/qna/qnaText.jsp
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

        if (qnaDto.getId() == null) {
            // 새 글 작성
            qnaService.saveQna(qnaDto);
        } else {
            // 기존 글 수정
            qnaService.updateQna(qnaDto);
        }

        return "redirect:/qna";
    }

    // Qna 수정페이지 이동
    @GetMapping("/qnaUpdate")
    public String qnaUpdate(@RequestParam("id") Long id, Model model) {
        QnaDto qna = qnaService.findById(id);  // 기존 글 가져오기
        model.addAttribute("qna", qna);        // JSP에서 qna로 사용
        return "qna/qnaWrite";                 // 수정 JSP
    }

    // 삭제 처리
    @PostMapping("/qnaDelete")
    public String deleteQna(@RequestParam("id") Long id) {
        // 로그인한 사용자 정보 가져오기
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();

        QnaDto qna = qnaService.findById(id);

        // 작성자와 로그인 사용자 일치 확인
        if (!qna.getUserId().equals(userId)) {
            throw new RuntimeException("본인이 작성한 글만 삭제할 수 있습니다.");
        }

        // 삭제
        qnaService.deleteQna(id);

        return "redirect:/qna";
    }

}
