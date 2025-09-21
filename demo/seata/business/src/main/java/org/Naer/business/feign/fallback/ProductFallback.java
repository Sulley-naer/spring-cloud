package org.Naer.business.feign.fallback;

import Product.Product;
import org.Naer.business.feign.ProductFeignClient;

public class ProductFallback implements ProductFeignClient {

    @Override
    public Product createProduct(Product product) {
        Product good = new Product();
        good.setName("未知商品");
        good.setStock(0);
        return good;
    }
}
