package com.Near.order.controller;

import com.Near.order.Properties.OrderProperties;
import com.Near.order.common.Response.Success;
import com.Near.order.feign.ProductFeignClient;
import com.Near.order.mapper.OrdersMapper;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import orders.order;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@Slf4j
public class OrderController {

    @Resource
    ProductFeignClient productFeignClient;

    @Resource
    OrdersMapper ordersMapper;

    @Resource
    OrderProperties properties;

    @SentinelResource(value = "CreateOrder", blockHandler = "CreateOrderFallback")
    @GetMapping("/order/{id}")
    public ResponseEntity<Object> CreateOrder(@PathVariable int id) {
        // 创建一个 Map 来存储数据
        Map<String, Object> responseData = new HashMap<>();
        // 创建订单对象
        order order = new order();
        order.setId((long) id);
        order.setProductName("Sample Product");
        order.setQuantity(1);
        order.setPrice(java.math.BigDecimal.valueOf(99.99));
        // 将这两个对象放入 Map 中
        responseData.put("order", order);
        responseData.put("product", productFeignClient.getProduct(id));
        // 返回封装好的 responseData
        /*order.setUserId(6L);
        ordersMapper.insert(order);*/
        return ResponseEntity.ok(new Success(responseData));
    }

    //兜底回调
    public ResponseEntity<Object> CreateOrderFallback(@PathVariable int id, BlockException blockException) {
        return ResponseEntity.ok(new Success(blockException));
    }
}
