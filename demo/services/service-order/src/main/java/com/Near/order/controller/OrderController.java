package com.Near.order.controller;

import com.Near.order.Properties.OrderProperties;
import com.Near.order.common.Response.Success;
import com.Near.order.feign.ProductFeignClient;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import orders.order;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@Slf4j
@RequestMapping("/api/order/")
public class OrderController {

    @Resource
    ProductFeignClient productFeignClient;

    @Resource
    OrderProperties properties;

    @SentinelResource(value = "CreateOrder", blockHandler = "CreateOrderFallback")
    @GetMapping("/order/{id}")
    public ResponseEntity<Object> CreateOrder(@PathVariable int id) {
        // 创建一个 Map 来存储数据
        Map<String, Object> responseData = new HashMap<>();
        // 将这两个对象放入 Map 中
        responseData.put("order", new order(id, properties.getName()));
        responseData.put("product", productFeignClient.getProduct(3));
        // 返回封装好的 responseData
        return ResponseEntity.ok(new Success(responseData));
    }

    //兜底回调
    public ResponseEntity<Object> CreateOrderFallback(@PathVariable int id, BlockException blockException) {
        return ResponseEntity.ok(new Success(blockException));
    }
}
