package org.Naer.business.services;

import jakarta.annotation.Resource;
import org.Naer.business.feign.OrderFeignClient;
import org.Naer.business.feign.ProductFeignClient;
import org.springframework.stereotype.Service;

@Service
public class BusinessService {

    @Resource
    private ProductFeignClient productService;
    @Resource
    private OrderFeignClient orderService;

    public boolean pay() {
        return false;
    }
}
