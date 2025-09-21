package com.Near.order.services;

import orders.Orders;

import java.util.List;

public interface OrderService {
    Orders findById(Long id);

    List<Orders> findAll();

    Orders save(Orders order);

    Orders update(Orders order);

    void deleteById(Long id);
}
