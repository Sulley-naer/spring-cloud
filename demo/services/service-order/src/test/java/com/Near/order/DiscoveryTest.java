package com.Near.order;

import com.Near.order.Properties.orderProperties;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.test.context.ActiveProfiles;


@Slf4j
@ActiveProfiles("test")
@SpringBootTest()
public class DiscoveryTest {

    @Resource
    DiscoveryClient discovery;

    @Resource
    orderProperties orderProperties;

    @Test
    @RefreshScope
    public void FinderTest() {
        log.info("orderProperties object: {}", orderProperties);
        log.info("orderProperties.getName(): {}", orderProperties.getName());
        log.info("orderProperties.getKfz(): {}", orderProperties.getKfz());
    }

    @Test
    public void avg() {
        String server = "http://order_service/order/get";
//        System.out.println(restTemplate.getForObject(server, order.class));
    }
}
