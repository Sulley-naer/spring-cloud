package com.Near.order.feign.fallback;

import Product.good;
import com.Near.order.feign.ProductFeignClient;
import org.springframework.stereotype.Component;

@Component
public class ProductFallback implements ProductFeignClient {

    @Override
    public good getProduct(int productId) {
        good good = new good();
        good.setId(productId);
        good.setName("未知商品");
        good.setPrice(0);
        good.setDescription("无商品描述");
        return good;
    }
}
