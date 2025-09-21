package com.near.product.mapper;

import Product.good;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ProductsMapper {

    @Select("SELECT * FROM products WHERE id = #{id}")
    good findById(Long id);

    @Select("SELECT * FROM products")
    List<good> findAll();

    @Insert("INSERT INTO products(name, description, price, stock) VALUES(#{name}, #{description}, #{price}, #{stock})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(good product);

    @Update("UPDATE products SET name = #{name}, description = #{description}, price = #{price}, stock = #{stock} WHERE id = #{id}")
    int update(good product);

    @Delete("DELETE FROM products WHERE id = #{id}")
    int deleteById(Long id);
}