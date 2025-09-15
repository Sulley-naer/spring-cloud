package com.near.product;

import com.near.product.feign.OrderFeignClient;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class feignTest {

    @Resource
    OrderFeignClient orderFeignClient;

    @Test
    public void orderTest() {
        System.out.printf(orderFeignClient.getOrder(String.valueOf(2)));
    }
}
