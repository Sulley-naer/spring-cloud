package com.Near.order.controller;

import com.Near.order.Properties.orderProperties;
import lombok.extern.slf4j.Slf4j;
import orders.order;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class main {

    public main(orderProperties orderProperties) {
        log.info(orderProperties.getName());
    }

    @GetMapping("/order/{id}")
    public order getOrder(@PathVariable String id) {
        order order = new order();
        order.setOrderId(Long.parseLong(id));
        order.setDescription("11111");
        return order;
    }
}
