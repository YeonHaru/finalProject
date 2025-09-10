package com.error404.geulbut.jpa.categories.repository;

import com.error404.geulbut.jpa.categories.entity.Categories;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoriesRepository extends JpaRepository<Categories,Long> {

}
