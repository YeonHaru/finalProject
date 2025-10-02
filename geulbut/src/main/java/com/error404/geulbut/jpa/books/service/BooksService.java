package com.error404.geulbut.jpa.books.service;

import com.error404.geulbut.common.ErrorMsg;
import com.error404.geulbut.common.MapStruct;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.books.repository.BooksRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.IsoFields;
import java.time.temporal.WeekFields;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BooksService {
    private final BooksRepository booksRepository;
    private final MapStruct mapStruct;
    private final ErrorMsg errorMsg;

    private List<BooksDto> weeklyBooksCache; // 현재 주 추천 4권
    private int cachedWeek = -1;             // 캐시된 주 번호

    public BooksDto findDetailByBookId(long bookId) {
        Books books = booksRepository.findDetailByBookId(bookId)
                .orElseThrow(() -> new IllegalArgumentException("book not found"));
        return mapStruct.toDto(books);
    }

    @Transactional(readOnly = true)
    public List<BooksDto> getBestSellersTop10() {
        var page = PageRequest.of(0, 10);
        return booksRepository.findBestSellers(page)
                .stream()
                .map(mapStruct::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<BooksDto> findTopDiscount(int limit) {
        int size = Math.max(1, Math.min(limit, 12));
        Pageable page = PageRequest.of(0, size);
        return booksRepository.findTopDiscount(page)
                .stream()
                .map(mapStruct::toDto)
                .toList();
    }

    public List<BooksDto> getHotNewsBooks(List<Long> ids) {
        List<Books> found = booksRepository.findByIds(ids);

        Map<Long, Integer> order = new HashMap<>();
        for (int i = 0; i < ids.size(); i++) order.put(ids.get(i), i);

        return found.stream()
                .sorted(Comparator.comparing(b -> order.getOrDefault(b.getBookId(), Integer.MAX_VALUE)))
                .map(mapStruct::toDto)
                .toList();
    }

    /**
     * 매주 다른(같은 주에 고정) 4권 추천 반환
     */
    @Transactional(readOnly = true)
    public List<BooksDto> getWeeklyRandom4Books() {
        int currentWeek = LocalDate.now().get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);

        // 1. 캐시된 주와 같으면 그대로 반환
        if (weeklyBooksCache != null && cachedWeek == currentWeek) {
            return weeklyBooksCache;
        }

        // 2. 새로운 주이면 랜덤 4권 생성
        List<Books> allBooks = booksRepository.findByEsDeleteFlagOrderByBookIdAsc("N");
        if (allBooks.size() <= 4) {
            weeklyBooksCache = allBooks.stream().map(mapStruct::toDto).toList();
        } else {
            Random random = new Random(currentWeek); // 주 번호 기반 시드
            List<Books> shuffled = new ArrayList<>(allBooks);
            Collections.shuffle(shuffled, random);
            weeklyBooksCache = shuffled.stream()
                    .limit(4)
                    .map(mapStruct::toDto)
                    .toList();
        }

        cachedWeek = currentWeek; // 캐시된 주 갱신
        return weeklyBooksCache;
    }

    //    이달의 주목도서 → 오늘 기준 랜덤
    @Transactional(readOnly = true)
    public List<BooksDto> getFeaturedBooks() {
        List<Books> allBooks = booksRepository.findByEsDeleteFlagOrderByBookIdAsc("N");
        if (allBooks.isEmpty()) return List.of();

        // 오늘 날짜 기준 시드 (하루마다 랜덤)
        int seed = LocalDate.now().getDayOfYear(); // 1~365
        Random random = new Random(seed);

        List<Books> shuffled = new ArrayList<>(allBooks);
        Collections.shuffle(shuffled, random);

        return shuffled.stream()
                .limit(Math.min(4, shuffled.size()))
                .map(mapStruct::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getBooksForAudiobookCards(int limit) {
        // DB에서 삭제되지 않은 책 조회
        List<Books> allBooks = booksRepository.findByEsDeleteFlagOrderByBookIdAsc("N");

        // limit 만큼만 가져오기
        List<Books> selectedBooks = allBooks.stream()
                .limit(limit)
                .toList();

        // BooksDto → 카드용 Map 변환
        return selectedBooks.stream()
                .map(book -> {
                    BooksDto dto = mapStruct.toDto(book);
                    Map<String, Object> map = new HashMap<>();
                    map.put("title", dto.getTitle());
                    map.put("authorName", dto.getAuthorName());
                    map.put("categoryName", dto.getCategoryName());
                    map.put("imgUrl", dto.getImgUrl());

                    // 오디오북 카드 전용 필드 (임시)
                    map.put("badge", "");          // NEW/인기 표시 없거나 조건부 설정 가능
                    map.put("playTime", "0시간 0분"); // 임시 값
                    map.put("narrator", "");       // 임시 값

                    return map;
                })
                .toList();
    }

    @Transactional(readOnly = true)
    public List<BooksDto> findPromoBooks(Long... ids) {
        List<Long> idList = Arrays.stream(ids)
                .filter(Objects::nonNull)
                .distinct()
                .toList();
        if(idList.isEmpty()) return List.of();

        Map<Long, Integer> order = new HashMap<>();
        for (int i = 0; i < idList.size(); i++) order.put(idList.get(i), i);

        return booksRepository.findAllById(idList).stream()
                .map(mapStruct::toDto)
                .sorted(Comparator.comparingInt(b -> order.getOrDefault(b.getBookId(), Integer.MAX_VALUE)))
                .toList();
    }
}
