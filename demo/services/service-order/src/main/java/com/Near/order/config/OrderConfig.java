package com.Near.order.config;

import feign.RequestInterceptor;
import feign.Retryer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OrderConfig {
    //    @Bean
    Retryer feignRetryer() {
        // 默认重试5次，间隔100ms，最大间隔1s，每次重试 上次的请求时间的2倍
        return new Retryer.Default();
    }

    @Bean
    public RequestInterceptor requestInterceptor() {
        return requestTemplate -> {
            // 添加自定义请求头，例如添加认证信息
            requestTemplate.header("Authorization", "Bearer your_token_here");
            // 可以添加其他公共请求头
            requestTemplate.header("X-Custom-Header", "custom_value");
        };
    }
}
