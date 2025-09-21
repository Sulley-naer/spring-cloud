package org.Naer.business.controller;

import common.Response.Success;
import jakarta.annotation.Resource;
import orders.Orders;
import org.Naer.business.services.BusinessService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/business")
public class OrderController {

    @Resource
    BusinessService businessService;

    @PostMapping("/order")
    public ResponseEntity<Object> createOrder(@RequestBody Orders order) {
        try {
            Orders createdOrder = businessService.createOrder(order);
            return ResponseEntity.ok(new Success(createdOrder));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new Success(500, "下单失败: " + e.getMessage(), null));
        }
    }
}
