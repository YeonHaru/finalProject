package com.error404.geulbut.common;

import com.error404.geulbut.es.searchAllBooks.dto.SearchAllBooksDto;
import com.error404.geulbut.es.searchAllBooks.entity.SearchAllBooks;
import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.bookhashtags.dto.BookHashtagsDto;
import com.error404.geulbut.jpa.bookhashtags.entity.BookHashtags;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.carts.dto.CartDto;
import com.error404.geulbut.jpa.carts.entity.Cart;
import com.error404.geulbut.jpa.categories.dto.CategoriesDto;
import com.error404.geulbut.jpa.categories.entity.Categories;
import com.error404.geulbut.jpa.hashtags.dto.HashtagsDto;
import com.error404.geulbut.jpa.hashtags.entity.Hashtags;
import com.error404.geulbut.jpa.orderitem.dto.OrderItemDto;
import com.error404.geulbut.jpa.orderitem.entity.OrderItem;
import com.error404.geulbut.jpa.orders.dto.OrdersDto;
import com.error404.geulbut.jpa.orders.entity.Orders;
import com.error404.geulbut.jpa.publishers.dto.PublishersDto;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import com.error404.geulbut.jpa.users.dto.UserMypageDto;
import com.error404.geulbut.jpa.users.dto.UsersLoginDto;
import com.error404.geulbut.jpa.users.dto.UsersOAuthUpsertDto;
import com.error404.geulbut.jpa.users.dto.UsersSignupDto;
import com.error404.geulbut.jpa.users.entity.Users;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface MapStruct {
    //    jpa
//    종일
//    Authors <-> AuthorsDto
    @Mapping(target = "createdAt", source = "createdAt")
    AuthorsDto toDto(Authors authors);

    Authors toEntity(AuthorsDto authorsDto);

    //    더티체킹: 수정시 사용
    void updateFromDto(AuthorsDto authorsDto, @MappingTarget Authors authors);

    //    Categories <-> CategoriesDto
    @Mapping(target = "createdAt", source = "createdAt")
    CategoriesDto toDto(Categories categories);

    Categories toEntity(CategoriesDto categoriesDto);

    void updateFromDto(CategoriesDto categoriesDto, @MappingTarget Categories categories);

    //    Hashtags <-> HashtagsDto
    HashtagsDto toDto(Hashtags hashtags);

    Hashtags toEntity(HashtagsDto hashtagsDto);

    void updateFromDto(HashtagsDto hashtagsDto, @MappingTarget Hashtags hashtags);

    //    Publishers <-> PublishersDto
    @Mapping(target = "createdAt", source = "createdAt")
    PublishersDto toDto(Publishers publishers);

    Publishers toEntity(PublishersDto publishersDto);

    void updateFromDto(PublishersDto publishersDto, @MappingTarget Publishers publishers);

    //    덕규9/11
//    로그인 매핑
    UsersLoginDto toDto(Users users);

    Users toEntity(UsersLoginDto usersLoginDto);

    //    회원가입 DTO -> Users (boolean -> char 명시적 매핑추가)
    @Mappings({
            @Mapping(target = "postNotifyAgree", expression = "java(usersSignupDto.isPostNotifyAgree() ? 'Y' : 'N')"),
            @Mapping(target = "promoAgree", expression = "java(usersSignupDto.isPromoAgree() ? 'Y' : 'N')")
    })
    Users toEntity(UsersSignupDto usersSignupDto);

    //    OAuth 업서트 DTO -> Users (부분 업데이트용)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateFromOAuth(UsersOAuthUpsertDto usersOAuthUpsertDto, @MappingTarget Users entity);

    //    ElasticSearch
    SearchAllBooksDto toDto(SearchAllBooks searchAllBooks);
    SearchAllBooks toEntity(SearchAllBooksDto searchAllBooksDto);

    //    더티체킹: 수정시 사용
    void updateFromDto(SearchAllBooksDto searchAllBooksDto, @MappingTarget SearchAllBooks searchAllBooks);


    BooksDto toDto(Books books);

    @Mapping(target = "author.authorId", source = "authorId")
    @Mapping(target = "publisher.publisherId", source = "publisherId")
    @Mapping(target = "category.categoryId", source = "categoryId")
    Books toEntity(BooksDto booksDto);

    void updateFromDto(BooksDto dto, @MappingTarget Books books);

    //  Mypage DTO 변환 승화
    @Mapping(target = "joinDate", source = "joinDate", dateFormat = "yyyy-MM-dd")
    UserMypageDto toMypageDto(Users users);

    // Orders 매핑
    @Mapping(target = "orderId", ignore = true)
    @Mapping(target = "memo", ignore = true)
    @Mapping(target = "recipient", ignore = true)
    @Mapping(target = "status", expression = "java(dto.getStatus() != null ? dto.getStatus() : \"PENDING\")")
    Orders toEntity(OrdersDto dto);

    @Mapping(
            target = "createdAt",
            expression = "java(entity.getCreatedAt() == null ? null : entity.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern(\"yyyy-MM-dd\")))"
    )
    @Mapping(target = "items", source = "items")
    OrdersDto toDto(Orders entity);

//    주문내역쪽 리스트 매핑
    List<OrderItemDto> toOrderItemDtos(List<OrderItem> items);

    // OrderItem 매핑
    @Mapping(target = "orderedItemId", ignore = true)
    @Mapping(target = "order", ignore = true)
    @Mapping(target = "book", ignore = true)
    OrderItem toEntity(OrderItemDto dto);

    @Mapping(target = "bookId", source = "book.bookId")
    @Mapping(target = "title", source = "book.title")
    @Mapping(target = "price", source = "book.price")
    @Mapping(target = "imageUrl", source = "book.imgUrl")
    OrderItemDto toDto(OrderItem entity);

//    cart
    @Mapping(target = "bookId", source = "book.bookId")
    @Mapping(target = "title", source = "book.title")
    @Mapping(target = "price", source = "book.price")
    @Mapping(target = "discountedPrice", source = "book.discountedPrice")
    @Mapping(target = "imgUrl", source = "book.imgUrl")
    @Mapping(
            target = "totalPrice",
            expression = "java(java.util.Objects.requireNonNullElse(cart.getBook().getDiscountedPrice(), cart.getBook().getPrice()) * cart.getQuantity())"
    )
    CartDto toDto(Cart cart);

    Cart toEntity(CartDto dto);

    List<CartDto> toCartDtos(List<Cart> carts);


    // BookHashtags <-> BookHashtagsDto
    BookHashtagsDto toDto(BookHashtags bookHashtags);

    BookHashtags toEntity(BookHashtagsDto dto);

    void updateFromDto(BookHashtagsDto dto, @MappingTarget BookHashtags entity);


}
