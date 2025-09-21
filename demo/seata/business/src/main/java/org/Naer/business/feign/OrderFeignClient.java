package org.Naer.business.feign;

import orders.Orders;
import org.Naer.business.feign.fallback.OrderFallback;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "seata-order-service", path = "", fallback = OrderFallback.class)
public interface OrderFeignClient {
    /* 复制粘贴 控制器方法签名 快速声明 */
    @PostMapping
    public Orders createOrder(@RequestBody Orders order);
}
