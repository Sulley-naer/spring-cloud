package com.Near.order.services.impl;

import com.Near.order.mapper.OrdersMapper;
import com.Near.order.services.OrderService;
import jakarta.annotation.Resource;
import orders.Orders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    @Resource
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
