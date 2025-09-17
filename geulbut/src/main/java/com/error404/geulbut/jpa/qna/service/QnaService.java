package com.error404.geulbut.jpa.qna.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.qna.dto.QnaDto;
import com.error404.geulbut.jpa.qna.entity.QnaEntity;
import com.error404.geulbut.jpa.qna.repository.QnaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class QnaService {

    private final QnaRepository qnaRepository;
    private final MapStruct mapStruct;

    public void saveQna(QnaDto qnaDto) {
        QnaEntity entity = QnaEntity.builder()
                .title(qnaDto.getTitle())
                .qContent(qnaDto.getQContent())  // 여기 값이 제대로 들어가야 함
                .userId(qnaDto.getUserId())
                .qAt(new Date())
                .createdAt(new Date())
                .updatedAt(new Date())
                .build();

        qnaRepository.save(entity);
    }
    // 전체 QnA 조회
    public List<QnaEntity> findAll() {
        return qnaRepository.findAll();
    }

    // 특정 QnA 조회
    public QnaEntity findById(Long id) {
        return qnaRepository.findById(id).orElse(null);
    }
}


