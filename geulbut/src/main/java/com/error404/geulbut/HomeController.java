package com.error404.geulbut;


import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.service.BooksService;
import com.error404.geulbut.jpa.choice.dto.ChoiceDto;
import com.error404.geulbut.jpa.choice.service.ChoiceService;
import com.error404.geulbut.jpa.event.entity.EventContents;
import com.error404.geulbut.jpa.event.service.EventContentsService;
import com.error404.geulbut.jpa.hotdeal.dto.HotdealDto;
import com.error404.geulbut.jpa.hotdeal.service.HotdealService;
import com.error404.geulbut.jpa.introduction.dto.IntroductionDto;
import com.error404.geulbut.jpa.introduction.service.IntroductionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Log4j2
@Controller
@RequiredArgsConstructor
public class HomeController {
    private final IntroductionService introductionService;
    private final BooksService booksService;
    private final ChoiceService choiceService;
    private final HotdealService hotdealService;
    private final EventContentsService eventContentsService;

    @GetMapping("/")
    public String home(Model model, @PageableDefault(page = 0, size = 4) Pageable pageable) {
//        신간소개
        Page<IntroductionDto> pages = introductionService.getAllIntroductions(pageable);

//        메인페이지 화제의소식 (bookId로 넘김)
        model.addAttribute("hotNews", booksService.getHotNewsBooks(

                List.of(154L, 24L, 519L, 2L, 10L, 155L, 532L, 35L, 157L, 13L)
        ));

//        메인페이지 배너 2개짜리
        model.addAttribute("promoBooks", booksService.findPromoBooks(
                501L, 155L, 514L, 27L
        ));

        model.addAttribute("introductions", pages.getContent());
        model.addAttribute("featuredBooks", pages.getContent());
//        편집장의 선택

        Page<ChoiceDto> pages2 = choiceService.getAllChoice(pageable);
        model.addAttribute("choice", pages2.getContent());
        model.addAttribute("bestSellers", booksService.getBestSellersTop10());

//       이주간 책
        List<BooksDto> weeklyBooks = booksService.getWeeklyRandom4Books();
        model.addAttribute("weeklyBooks", weeklyBooks);

//        핫딜
        Page<HotdealDto> pages3 = hotdealService.getAllHotdeal(pageable);
        model.addAttribute("hotdeal", pages3.getContent());


        // 이달의 주목도서 → BooksDto
        List<BooksDto> featuredBooks = booksService.getFeaturedBooks();
        model.addAttribute("featuredBooks", featuredBooks);

        //  오디오북에 책 데이터 집어넣기
        List<BooksDto> audiobooks = booksService.getTopAudiobooks(5);
        model.addAttribute("audiobooks", audiobooks);


//        이주의 특가
        List<BooksDto> weeklySpecials = booksService.findTopDiscount(5);

        for (BooksDto b : weeklySpecials) {
            if (b.getPrice() != null && b.getDiscountedPrice() != null && b.getPrice() > 0) {
                double rate = ((b.getPrice() - b.getDiscountedPrice()) * 100.0) / b.getPrice();
                b.setDiscountRate((double) Math.round(rate));
            } else {
                b.setDiscountRate(0.0);
            }
        }

        model.addAttribute("weeklySpecials", weeklySpecials);
//       추천 이벤트
        List<BooksDto> randomBooks = booksService.getRandomBooks();
        model.addAttribute("randomBooks", randomBooks);
//        추천 이벤트
        Page<EventContents> pagesA=eventContentsService.selectEventContentsListA(pageable);
        model.addAttribute("eventcontentsA", pagesA.getContent());
        return "home";
    }
}
