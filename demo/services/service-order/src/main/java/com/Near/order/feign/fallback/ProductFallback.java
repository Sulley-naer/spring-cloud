package com.Near.order.feign.fallback;

import Product.Product;
import com.Near.order.feign.ProductFeignClient;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class ProductFallback implements ProductFeignClient {

    @Override
    public Product getProduct(int productId) {
        Product Product = new Product();
        Product.setId((long) productId);
        Product.setName("未知商品");
        Product.setPrice(BigDecimal.valueOf(0));
        Product.setDescription("无商品描述");
        Product.setStock(0);
        return Product;
    }
}
