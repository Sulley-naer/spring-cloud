package com.near.product.controller;

import Product.good;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.TimeUnit;

@Slf4j
@RestController
public class ProductController {

    @SneakyThrows
    @GetMapping("/Product/{id}")
    public good get(@PathVariable String id) {
        good good = new good();
        good.setId(Long.parseLong(id));
        good.setName("苹果");
        good.setPrice(123.456);
        TimeUnit.SECONDS.sleep(61);
        return good;
    }
}
