package com.error404.geulbut.jpa.qna.service;

import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.qna.dto.QnaDto;
import com.error404.geulbut.jpa.qna.entity.QnaEntity;
import com.error404.geulbut.jpa.qna.repository.QnaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.ZoneId;
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
    public QnaDto findById(Long id) {
        QnaEntity entity = qnaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("해당 글을 찾을 수 없습니다."));
        return QnaDto.builder()
                .id(entity.getQnaId())
                .title(entity.getTitle())
                .qContent(entity.getQContent())
                .qAt(entity.getQAt())      // Date 타입 그대로
                .aId(entity.getAId())
                .aContent(entity.getAContent())
                .aAt(entity.getAAt())      // Date 타입 그대로
                .userId(entity.getUserId())
                .build();
    }
    // 특정 Qna 수정
    public void updateQna(QnaDto qnaDto) {
        QnaEntity entity = qnaRepository.findById(qnaDto.getId())
                .orElseThrow(() -> new RuntimeException("글 없음"));
        entity.setTitle(qnaDto.getTitle());
        entity.setQContent(qnaDto.getQContent());
        entity.setUpdatedAt(new Date());
        qnaRepository.save(entity);
    }
    // 삭제
    public void deleteQna(Long id) {
        QnaEntity entity = qnaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("글을 찾을 수 없습니다."));
        qnaRepository.delete(entity);
    }



}


