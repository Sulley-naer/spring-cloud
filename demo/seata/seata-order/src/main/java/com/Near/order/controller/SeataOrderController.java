package com.Near.order.controller;

import com.Near.order.services.OrderService;
import jakarta.annotation.Resource;
import orders.Orders;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
public class SeataOrderController {

    @Resource
    private OrderService orderService;

    @GetMapping("/{id}")
    public Orders getOrder(@PathVariable Long id) {
        return orderService.findById(id);
    }

    @GetMapping
    public List<Orders> getAllOrders() {
        return orderService.findAll();
    }

    @PostMapping
    public Orders createOrder(@RequestBody Orders order) {
        return orderService.save(order);
    }

    @PutMapping("/{id}")
    public Orders updateOrder(@PathVariable Long id, @RequestBody Orders order) {
        order.setId(id);
        return orderService.update(order);
    }

    @DeleteMapping("/{id}")
    public void deleteOrder(@PathVariable Long id) {
        orderService.deleteById(id);
    }
}
