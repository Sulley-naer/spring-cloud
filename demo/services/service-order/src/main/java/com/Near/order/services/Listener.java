package com.Near.order.services;

import com.alibaba.cloud.nacos.NacosConfigManager;
import com.alibaba.nacos.api.config.ConfigService;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

@Configuration
public class Listener {
    @Bean
    ApplicationRunner applicationRunner(NacosConfigManager nacosConfigManager) {
        return args -> {
            ConfigService configuration = nacosConfigManager.getConfigService();
            configuration.addListener("demo", "DEFAULT_GROUP", new com.alibaba.nacos.api.config.listener.Listener() {
                @Override
                public Executor getExecutor() {
                    //线程池
                    return Executors.newFixedThreadPool(4);
                }

                @Override
                public void receiveConfigInfo(String configInfo) {
                    System.out.printf("配置更新:" + configInfo);
                }
            });
        };
    }
}
