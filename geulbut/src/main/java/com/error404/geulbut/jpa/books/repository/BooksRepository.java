package com.error404.geulbut.jpa.books.repository;

import com.error404.geulbut.jpa.books.entity.Books;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BooksRepository extends JpaRepository<Books, Long> {
    boolean existsByIsbn(String isbn);
}
