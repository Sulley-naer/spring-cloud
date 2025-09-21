package com.Near.order.services.impl;

import com.Near.order.mapper.OrdersMapper;
import com.Near.order.services.OrderService;
import orders.Orders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrdersMapper ordersMapper;

    @Override
    public Orders findById(Long id) {
        return ordersMapper.findById(id);
    }

    @Override
    public List<Orders> findAll() {
        return ordersMapper.findAll();
    }

    @Override
    public Orders save(Orders order) {
        ordersMapper.insert(order);
        return order;
    }

    @Override
    public Orders update(Orders order) {
        ordersMapper.update(order);
        return order;
    }

    @Override
    public void deleteById(Long id) {
        ordersMapper.deleteById(id);
    }
}
