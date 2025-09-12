package com.near.product;

import com.near.product.feign.orderFeignClient;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class feignTest {

    @Resource
    orderFeignClient orderFeignClient;

    @Test
    public void orderTest() {
        System.out.printf(orderFeignClient.getOrder(String.valueOf(2)));
    }
}
