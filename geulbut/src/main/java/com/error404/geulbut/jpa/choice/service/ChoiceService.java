package com.error404.geulbut.jpa.choice.service;

import com.error404.geulbut.jpa.introduction.dto.IntroductionDto;
import com.error404.geulbut.jpa.introduction.repository.IntroductionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChoiceService {

    private final IntroductionRepository introductionRepository;

    // 전체 조회 (검색/페이징 없음)
    public Page<IntroductionDto> getAllIntroductions(Pageable pageable) {
        return introductionRepository.findIntroductionList(pageable);
    }
}
