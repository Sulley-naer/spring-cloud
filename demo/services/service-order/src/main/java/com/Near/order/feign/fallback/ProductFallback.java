package com.Near.order.feign.fallback;

import Product.good;
import com.Near.order.feign.ProductFeignClient;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class ProductFallback implements ProductFeignClient {

    @Override
    public good getProduct(int productId) {
        good good = new good();
        good.setId((long) productId);
        good.setName("未知商品");
        good.setPrice(BigDecimal.valueOf(0));
        good.setDescription("无商品描述");
        good.setStock(0);
        return good;
    }
}
