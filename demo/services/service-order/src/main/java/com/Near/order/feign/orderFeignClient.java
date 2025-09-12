package com.Near.order.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "product-service")
public interface orderFeignClient {
    /* 复制粘贴 控制器方法签名 快速声明 */
    @GetMapping("/Product/{productId}")
    String getProduct(@PathVariable int productId);
}
