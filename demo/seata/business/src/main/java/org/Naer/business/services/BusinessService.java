package org.Naer.business.services;

import Product.Product;
import jakarta.annotation.Resource;
import orders.Orders;
import org.Naer.business.feign.OrderFeignClient;
import org.Naer.business.feign.ProductFeignClient;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BusinessService {

    @Resource
    private ProductFeignClient productService;

    @Resource
    private OrderFeignClient orderService;

    @Transactional
    public Orders createOrder(@NotNull Orders order) {
        // 1. 先根据商品ID获取商品信息，检查库存
        Product product = productService.getProductById(order.getProductId());

        // 2. 检查库存是否足够
        if (product.getStock() <= 0) {
            throw new RuntimeException("商品库存不足");
        }

        // 3. 减少商品库存
        Product updatedProduct = new Product();
        updatedProduct.setId(product.getId());
        updatedProduct.setName(product.getName());
        updatedProduct.setPrice(product.getPrice());
        updatedProduct.setDescription(product.getDescription());
        updatedProduct.setStock(product.getStock() - 1);
        productService.updateProduct(product.getId(), updatedProduct);

        // 4. 创建订单
        Orders newOrder = new Orders();
        newOrder.setUserId(order.getUserId());
        newOrder.setProductId(order.getProductId());
        newOrder.setProductName(product.getName());
        newOrder.setQuantity(1);
        newOrder.setPrice(product.getPrice());

        return orderService.createOrder(newOrder);
    }
}
