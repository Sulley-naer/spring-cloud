package org.Naer.business.controller;

import com.alibaba.csp.sentinel.slots.block.BlockException;
import common.Response.Success;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import orders.Orders;
import org.Naer.business.services.BusinessService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class OrderController {

    @Resource
    BusinessService businessService;

    @GetMapping("/business/{id}")
    public ResponseEntity<Orders> CreateOrder(@PathVariable int id) {
        return ResponseEntity.ok(new Orders(businessService.pay()));
    }

    //兜底回调
    public ResponseEntity<Object> CreateOrderFallback(@PathVariable int id, BlockException blockException) {
        return ResponseEntity.ok(new Success(blockException));
    }
}
