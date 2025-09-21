package org.Naer.business.feign.fallback;

import Product.Product;
import org.Naer.business.feign.ProductFeignClient;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class ProductFallback implements ProductFeignClient {

    @Override
    public Product getProductById(Long id) {
        Product product = new Product();
        product.setId(id);
        product.setName("未知商品");
        product.setPrice(BigDecimal.valueOf(0));
        product.setDescription("商品不存在");
        product.setStock(0);
        return product;
    }

    @Override
    public Product createProduct(Product product) {
        Product good = new Product();
        good.setName("未知商品");
        good.setStock(0);
        return good;
    }
    
    @Override
    public Product updateProduct(Long id, Product product) {
        Product good = new Product();
        good.setId(id);
        good.setName("未知商品");
        good.setStock(0);
        return good;
    }
}
