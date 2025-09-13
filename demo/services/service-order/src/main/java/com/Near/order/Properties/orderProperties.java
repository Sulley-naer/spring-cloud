package com.Near.order.Properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
// 自动刷新无需配置注解
@ConfigurationProperties(prefix = "")
public class orderProperties {
    //对应配置文件中 order.name
    String name;
    String kfz;
}
