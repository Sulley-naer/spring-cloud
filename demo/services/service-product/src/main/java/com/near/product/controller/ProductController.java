package com.near.product.controller;

import Product.Product;
import com.near.product.services.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;

@Slf4j
@RestController
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping("/Product/{id}")
    public Product get(@PathVariable String id) {
        Product product = productService.findById(Long.parseLong(id));
        if (product == null) {
            product = new Product();
            product.setId(Long.parseLong(id));
            product.setName("苹果");
            product.setPrice(BigDecimal.valueOf(123.456));
            product.setDescription("新鲜苹果");
            product.setStock(100);
        }
        return product;
    }
}
