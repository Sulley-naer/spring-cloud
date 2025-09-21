package com.Near.order.mapper;

import orders.order;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface OrdersMapper {

    @Select("SELECT * FROM orders WHERE id = #{id}")
    order findById(Long id);

    @Select("SELECT * FROM orders")
    List<order> findAll();

    @Insert("INSERT INTO orders(user_id, product_name, quantity, price) VALUES(#{userId}, #{productName}, #{quantity}, #{price})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(order order);

    @Update("UPDATE orders SET user_id = #{userId}, product_name = #{productName}, quantity = #{quantity}, price = #{price} WHERE id = #{id}")
    int update(order order);

    @Delete("DELETE FROM orders WHERE id = #{id}")
    int deleteById(Long id);
}