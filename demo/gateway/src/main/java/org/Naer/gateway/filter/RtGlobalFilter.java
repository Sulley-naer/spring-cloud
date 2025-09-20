package org.Naer.gateway.filter;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.text.SimpleDateFormat;

@Slf4j
@Component
public class RtGlobalFilter implements GlobalFilter, Ordered {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        // =============== 前置 =============== \\
        ServerHttpRequest request = exchange.getRequest();
        ServerHttpResponse response = exchange.getResponse();

        String uri = request.getURI().getPath();
        long start = System.currentTimeMillis();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

        log.info("请求：{} 开始时间：{}", uri, dateFormat.format(new java.util.Date(start)));

        Mono<Void> filter = chain.filter(exchange).doFinally(Result -> {
            // =============== 后置 =============== \\
            long end = System.currentTimeMillis();
            log.info("请求: {} 结束时间: {},耗时: {}ms", uri, dateFormat.format(new java.util.Date(end)), end - start);
        });
        return filter;
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
