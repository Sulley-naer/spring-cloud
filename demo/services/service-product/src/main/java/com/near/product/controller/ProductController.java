package com.near.product.controller;

import Product.good;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/product/")
public class ProductController {

    @GetMapping("/Product/{id}")
    public good get(@PathVariable String id) {
        good good = new good();
        good.setId(Long.parseLong(id));
        good.setName("苹果");
        good.setPrice(123.456);
//        TimeUnit.SECONDS.sleep(61);
        return good;
    }
}
