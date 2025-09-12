package com.Near.order;

import com.Near.order.feign.orderFeignClient;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.cloud.context.config.annotation.RefreshScope;

@SpringBootTest
public class FeignTest {

    @Resource
    orderFeignClient orderFeignClient;

    @Test
    @RefreshScope
    public void TestFeignTest() {
        System.out.printf("", orderFeignClient.getProduct(5));
    }
}
