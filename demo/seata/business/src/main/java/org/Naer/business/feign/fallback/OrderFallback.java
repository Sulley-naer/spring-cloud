package org.Naer.business.feign.fallback;

import orders.Orders;
import org.Naer.business.feign.OrderFeignClient;

public class OrderFallback implements OrderFeignClient {
    @Override
    public Orders createOrder(Orders order) {
        Orders orders = new Orders();
        orders.setProductName("未知订单");
        orders.setQuantity(0);
        return orders;
    }
}
