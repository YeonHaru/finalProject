package com.error404.geulbut.jpa.carts.repository;

import com.error404.geulbut.jpa.carts.dto.CartDto;

import java.util.List;

public interface CartQueryRepositoryCustom {
    List<CartDto> findCartWithBookInfo(String userId);
}
