package com.near.product.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "order-service")
public interface orderFeignClient {

    @GetMapping("/order/{id}")
    public String getOrder(@PathVariable String id);
}
