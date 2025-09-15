package com.Near.order;

import com.Near.order.feign.ProductFeignClient;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class FeignTest {

    @Resource
    private ProductFeignClient productFeignClient;

    @Test
    public void testFeignClient() {
        System.out.println(productFeignClient.getProduct(5));
    }
}
