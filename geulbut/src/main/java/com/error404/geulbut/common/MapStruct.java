package com.error404.geulbut.common;

import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.entity.Authors;
import com.error404.geulbut.jpa.categories.dto.CategoriesDto;
import com.error404.geulbut.jpa.categories.entity.Categories;
import com.error404.geulbut.jpa.hashtags.dto.HashtagsDto;
import com.error404.geulbut.jpa.hashtags.entity.Hashtags;
import com.error404.geulbut.jpa.publishers.dto.PublishersDto;
import com.error404.geulbut.jpa.publishers.entity.Publishers;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

@Mapper(componentModel = "spring",
nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
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

    void updatFromDto(PublishersDto publishersDto, @MappingTarget Publishers publishers);

//    elasticsearch

}
