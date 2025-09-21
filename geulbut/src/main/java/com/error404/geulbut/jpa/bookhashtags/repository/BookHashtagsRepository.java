package com.error404.geulbut.jpa.bookhashtags.repository;

import com.error404.geulbut.jpa.bookhashtags.entity.BookHashtags;
import com.error404.geulbut.jpa.bookhashtags.entity.BookHashtagsId;
import com.error404.geulbut.jpa.books.entity.Books;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookHashtagsRepository extends JpaRepository<BookHashtags, BookHashtagsId> {
//    JpaRepository<BookHashtags, BookHashtagsId> << pk로 받아서 조회/삭제가 좀 변경됨

    // 특정 책에 연결된 해시태그 조회
    List<BookHashtags> findByBook_BookId(Long bookId);

    // 특정 해시태그가 연결된 책 조회
    List<BookHashtags> findByHashtag_HashtagId(Long hashtagId);

    // 필요하면 삭제도 가능
    void deleteByBook_BookIdAndHashtag_HashtagId(Long bookId, Long hashtagId);

    Long book(Books book);
}
