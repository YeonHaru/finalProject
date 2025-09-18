package com.error404.geulbut.jpa.carts.repository;

import com.error404.geulbut.jpa.books.entity.QBooks;
import com.error404.geulbut.jpa.carts.dto.CartDto;
import com.error404.geulbut.jpa.carts.entity.QCart;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class CartRepositoryImpl implements CartQueryRepositoryCustom  {
    private final JPAQueryFactory queryFactory;

    QCart cart=QCart.cart;
    QBooks book=QBooks.books;

    @Override
    public List<CartDto> findCartWithBookInfo(String userId) {
        return queryFactory
                .select(Projections.constructor(CartDto.class,
                        cart.cartId,
                        book.bookId,
                        book.title,
                        book.author.name,
                        book.publisher.name,
                        book.price,
                        book.imgUrl,
                        cart.quantity,
                        book.price.multiply(cart.quantity)))
                .from(cart)
                .join(cart.book, book)
                .where(cart.userId.eq(userId))
                .fetch();
    }
}
