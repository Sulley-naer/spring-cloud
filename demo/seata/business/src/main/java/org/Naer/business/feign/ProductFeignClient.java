package org.Naer.business.feign;

import Product.Product;
import org.Naer.business.feign.fallback.OrderFallback;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "seata-product-service", path = "", fallback = OrderFallback.class)
public interface ProductFeignClient {

    @PostMapping
    Product createProduct(@RequestBody Product product);
}
