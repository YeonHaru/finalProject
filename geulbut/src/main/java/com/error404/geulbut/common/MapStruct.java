package com.error404.geulbut.common;

import com.error404.geulbut.es.searchAllBooks.dto.SearchAllBooksDto;
import com.error404.geulbut.es.searchAllBooks.entity.SearchAllBooks;
import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.books.dto.BooksDto;
import com.error404.geulbut.jpa.books.entity.Books;
import com.error404.geulbut.jpa.categories.dto.CategoriesDto;
import com.error404.geulbut.jpa.categories.entity.Categories;
import com.error404.geulbut.jpa.hashtags.dto.HashtagsDto;
import com.error404.geulbut.jpa.hashtags.entity.Hashtags;
import com.error404.geulbut.jpa.publishers.dto.PublishersDto;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import com.error404.geulbut.jpa.users.dto.UsersLoginDto;
import com.error404.geulbut.jpa.users.dto.UsersOAuthUpsertDto;
import com.error404.geulbut.jpa.users.dto.UsersSignupDto;
import com.error404.geulbut.jpa.users.entity.Users;
import org.mapstruct.*;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface MapStruct {
    //    jpa
//    종일
//    Authors <-> AuthorsDto
    AuthorsDto toDto(Authors authors);

    Authors toEntity(AuthorsDto authorsDto);

    //    더티체킹: 수정시 사용
    void updateFromDto(AuthorsDto authorsDto, @MappingTarget Authors authors);

    //    Categories <-> CategoriesDto
    CategoriesDto toDto(Categories categories);

    Categories toEntity(CategoriesDto categoriesDto);

    void updateFromDto(CategoriesDto categoriesDto, @MappingTarget Categories categories);

    //    Hashtags <-> HashtagsDto
    HashtagsDto toDto(Hashtags hashtags);

    Hashtags toEntity(HashtagsDto hashtagsDto);

    void updateFromDto(HashtagsDto hashtagsDto, @MappingTarget Hashtags hashtags);

    //    Publishers <-> PublishersDto
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

}
