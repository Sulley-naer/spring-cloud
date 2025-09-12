package com.Near.order;

import com.Near.order.feign.orderFeignClient;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class FeignTest {

    @Resource
    private orderFeignClient orderFeignClient;

    @Test
    public void testFeignClient() {
        System.out.println(orderFeignClient.getProduct(5));
    }
}
