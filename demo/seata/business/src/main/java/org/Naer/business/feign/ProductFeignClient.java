package org.Naer.business.feign;

import Product.Product;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(name = "seata-product-service", path = "/products")
public interface ProductFeignClient {

    @GetMapping("/{id}")
    Product getProductById(@PathVariable("id") Long id);

    @PostMapping
    Product createProduct(@RequestBody Product product);

    @PutMapping("/{id}")
    Product updateProduct(@PathVariable("id") Long id, @RequestBody Product product);
}
