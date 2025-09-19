package com.Near.order.feign;

import Product.good;
import com.Near.order.feign.fallback.ProductFallback;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "product-service", path = "/api/product", fallback = ProductFallback.class)
public interface ProductFeignClient {
    /* 复制粘贴 控制器方法签名 快速声明 */
    @GetMapping("/Product/{productId}")
    good getProduct(@PathVariable int productId);
}
