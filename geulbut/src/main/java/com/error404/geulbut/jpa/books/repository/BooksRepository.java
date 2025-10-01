package com.error404.geulbut.jpa.books.repository;

import com.error404.geulbut.jpa.books.entity.Books;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BooksRepository extends JpaRepository<Books, Long> {
    boolean existsByIsbn(String isbn);

    //    관리자 책 페이지에서 검색기능
//    제목/저자/출판사/카테고리/isbn
    @Query("SELECT b FROM Books b " +  // 엔티티 이름 Books
            "LEFT JOIN b.author a " +
            "LEFT JOIN b.publisher p " +
            "LEFT JOIN b.category c " +
            "WHERE LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(b.isbn) LIKE CONCAT('%', :keyword, '%') " +
            "OR LOWER(a.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Books> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    // 카테고리별 조회 (저자/출판사/카테고리 포함)
    @EntityGraph(attributePaths = {"author", "publisher", "category"})
    List<Books> findByCategory_CategoryId(Long categoryId);

    // 작가별 책 조회 (저자/출판사/카테고리 포함)
    @EntityGraph(attributePaths = {"author", "publisher", "category"})
    List<Books> findByAuthor_AuthorId(Long authorId);


    @EntityGraph(attributePaths = {"author", "publisher", "category", "hashtags"})
    Optional<Books> findDetailByBookId(Long bookId);

    // 출판사별 책 조회 (저자/출판사/카테고리 포함)
    @EntityGraph(attributePaths = {"author", "publisher", "category"})
    List<Books> findByPublisher_PublisherId(Long publisherId);

    @EntityGraph(attributePaths = {"author"})
    @Query("""
  SELECT b FROM Books b
  WHERE COALESCE(b.orderCount,0) > 0
  ORDER BY b.orderCount DESC,
           COALESCE(b.updatedAt, b.createdAt) DESC,
           b.bookId
""")
    List<Books> findBestSellers(Pageable pageable);


//    메인페이지 이주의 특가
    @EntityGraph(attributePaths = {"author", "publisher", "category"})
    @Query("""
        SELECT b FROM Books b
        WHERE b.price > 0
          AND b.discountedPrice IS NOT NULL
          AND b.discountedPrice < b.price
          AND b.imgUrl IS NOT NULL
        ORDER BY ((b.price - b.discountedPrice) * 1.0 / b.price) DESC,
                 b.discountedPrice ASC
    """)
    List<Books> findTopDiscount(Pageable pageable);

    @EntityGraph(attributePaths = {"author"})
    @Query("SELECT b FROM Books b WHERE b.bookId IN :ids")
    List<Books> findByIds(@Param("ids") List<Long> ids);

    
//  작가 작품보기 버튼 클릭용
    @Query("SELECT b FROM Books b WHERE LOWER(b.author.name) LIKE LOWER(CONCAT('%', :authorName, '%'))")
    List<Books> findByAuthorNameContaining(@Param("authorName") String authorName);

    // 1) 활성화된 모든 책을 BookId 기준으로 정렬해서 가져오기
    List<Books> findByEsDeleteFlagOrderByBookIdAsc(String esDeleteFlag);

    // 2) Native Query로 랜덤 4권 가져오기 (DB 지원 시)
    @Query(value = "SELECT * FROM BOOKS WHERE ES_DELETE_FLAG = 'N' ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 4 ROWS ONLY", nativeQuery = true)
    List<Books> findRandom4Native();

}
