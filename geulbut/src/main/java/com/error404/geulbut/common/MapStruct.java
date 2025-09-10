package com.error404.geulbut.common;

import com.error404.geulbut.jpa.authors.dto.AuthorsDto;
import com.error404.geulbut.jpa.authors.entity.Authors;
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
    void updateFromDto(AuthorsDto authorsDto, @MappingTarget Authors authors);

//    elasticsearch

}
