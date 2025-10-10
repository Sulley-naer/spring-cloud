# 微服务分布式架构项目

## 项目概览

本项目是一个基于 Spring Cloud 生态的微服务分布式架构解决方案，集成了服务发现、配置管理、分布式事务、API 网关、熔断限流等企业级功能。

TODO:

现在的架构中 数据库采用本地方式 每个节点独立的数据 需要实现分布式数据库

并且这样的话 如果数据库掉了 整个节点的全部服务都会无法使用 带实现数据库检测

再使用 nacos 配置中心实现自动统一切换 服务的数据库源 换为其他正常节点数据库

nacos 异常，它会自动检测自己的可用性，检测异常如果是集群模式，它会自动转发到正常节点

如果还是不放心，配置中心写多连接节点  `nacos.server: 127.0.0.1:8848,ip:8848`

## 项目结构

```
.
├── demo/                           # 主项目目录
│   ├── gateway/                    # API 网关服务
│   ├── Model/                      # 共享数据模型模块
│   ├── nacos/                      # Nacos 配置模块
│   ├── seata/                      # 分布式事务管理模块
│   │   ├── business/               # 业务逻辑层（处理分布式事务）
│   │   ├── seata-order/            # 订单服务（带分布式事务支持）
│   │   └── seata-product/          # 产品服务（带分布式事务支持）
│   ├── services/                   # 普通微服务模块
│   │   ├── service-order/          # 订单服务（基础版）
│   │   └── service-product/        # 产品服务（基础版）
│   ├── inits/                      # 初始化脚本目录
│   │   ├── db/                     # 数据库初始化脚本
│   │   └── script/                 # 系统初始化脚本
│   ├── Sentinel/                   # Sentinel 控制台
│   ├── docker-compose.yml          # Docker 容器编排
│   └── pom.xml                     # Maven 父项目配置
```

## 核心技术栈

- **Spring Boot**: 3.4.8
- **Spring Cloud**: 2024.0.2
- **Spring Cloud Alibaba**: 2023.0.3.3
- **Nacos**: 服务发现与配置中心
- **Seata**: 分布式事务管理
- **Sentinel**: 流量控制与熔断降级
- **Spring Cloud Gateway**: API 网关
- **MyBatis**: 数据持久层框架
- **MySQL**: 9.4 数据库
- **Redis**: 缓存服务
- **Docker**: 容器化部署

## 服务模块说明

### 1. Model 模块

共享数据模型，包含：

- 订单模型 (`Orders`)
- 产品模型 (`Product`)
- 统一响应结果 (`Success`, `Bad`)

### 2. Services 模块

基础微服务，包含：

- **service-order**: 订单服务（基础版）
- **service-product**: 产品服务（基础版）

### 3. Seata 模块

支持分布式事务的微服务，包含：

- **seata-order**: 订单服务（分布式事务版）
- **seata-product**: 产品服务（分布式事务版）
- **business**: 业务逻辑层，处理跨服务分布式事务

### 4. Gateway 模块

API 网关，统一入口，处理前端路由转发。

## 初始化配置

### 1. 启动基础设施

在项目根目录下运行以下命令启动所有基础设施服务：

```bash
# 启动所有基础设施（MySQL, Redis, Nacos, Sentinel, Seata）
docker-compose up -d
```

### 2. 环境变量配置

项目使用 `.env` 文件管理 Docker 镜像版本，主要配置包括：

- `MYSQL_VERSION`: MySQL 数据库版本 (默认: 9.4)
- `SEATA_VERSION`: Seata 分布式事务版本 (默认: 2.1.0)
- `NACOS_VERSION`: Nacos 服务发现与配置中心版本 (默认: latest)
- `REDIS_VERSION`: Redis 缓存服务版本 (默认: 7-alpine)

如需修改版本，请编辑 `.env` 文件中的对应变量值。

### 2. 数据库初始化

系统自动执行以下初始化步骤：

- 创建 MySQL 数据库和表结构
- 初始化 Nacos 配置
- 初始化 Seata 分布式事务表

### 3. 服务启动顺序

1. **确保基础设施已启动**：
   ```bash
   # 检查基础设施状态
   docker-compose ps
   ```

2. **启动基础微服务**：
   ```bash
   # 启动订单服务
   cd services/service-order
   mvn spring-boot:run
   
   # 启动产品服务
   cd ../service-product
   mvn spring-boot:run
   ```

3. **启动分布式事务微服务**：
   ```bash
   # 启动带分布式事务的订单服务
   cd seata/seata-order
   mvn spring-boot:run
   
   # 启动带分布式事务的产品服务
   cd ../seata-product
   mvn spring-boot:run
   ```

4. **启动业务服务**：
   ```bash
   # 启动业务逻辑服务
   cd seata/business
   mvn spring-boot:run
   ```

5. **启动网关服务**：
   ```bash
   # 启动 API 网关
   cd gateway
   mvn spring-boot:run
   ```

## 服务通信机制

### 网络通信方式

所有微服务之间的通信均通过真实网络请求实现：

- **服务注册与发现**：所有服务启动时向 Nacos 注册自己的信息，其他服务通过 Nacos 发现并定位目标服务
- **远程调用**：使用 OpenFeign 进行服务间 HTTP 网络调用
- **负载均衡**：通过 Spring Cloud LoadBalancer 实现客户端负载均衡

### 服务调用流程

1. **服务发起方** 通过服务名向 Nacos 查询目标服务地址
2. **负载均衡器** 从服务实例列表中选择一个可用实例
3. **发起真实 HTTP 请求** 到目标服务
4. **目标服务** 处理请求并返回响应

### 示例代码

```java

@FeignClient(name = "product-service", fallback = ProductFallback.class)
public interface ProductFeignClient {
    @GetMapping("/Product/{id}")
    Product getProduct(@PathVariable int id);
}
```

### 服务降级

每个 Feign 客户端都配置了降级处理，当服务不可用时返回默认值：

```java

@Component
public class ProductFallback implements ProductFeignClient {
    @Override
    public Product getProduct(int productId) {
        Product product = new Product();
        product.setId((long) productId);
        product.setName("未知商品");
        product.setPrice(BigDecimal.valueOf(0));
        return product;
    }
}
```

### 网络通信优势

- **松耦合**：服务间通过标准 HTTP 协议通信，降低耦合度
- **灵活性**：支持多种负载均衡策略
- **容错性**：通过降级机制保证系统可用性
- **可观测性**：支持链路追踪和监控

## 分布式事务管理

### Seata 事务机制

本项目使用 Seata 框架处理分布式事务，确保跨服务操作的数据一致性。Seata 提供了 AT 模式（自动事务模式），通过全局事务协调器（TC）管理全局事务。

### 事务表设计

Seata 需要额外的事务表来管理分布式事务状态，这些表在 `inits/db/seata-mysql.sql` 中定义，包括：

- `undo_log`: 用于记录本地事务的补偿逻辑
- Seata 全局事务和分支事务相关的系统表

### Seata 模块结构

- **seata-order**: 订单服务，为订单表提供完整的 CRUD 操作
- **seata-product**: 产品服务，为产品表提供完整的 CRUD 操作
- **business**: 业务编排服务，处理跨服务的分布式事务

### 事务处理流程

1. **简单操作**：对于单个服务内的操作，直接调用对应服务的 Seata 模块
2. **复杂事务**：对于跨服务的事务操作，在 `business` 模块中进行事务编排

### 事务代码示例

```java

@GlobalTransactional
public void processOrderTransaction(Long userId, Long productId, Integer quantity) {
    // 调用订单服务创建订单
    orderService.createOrder(userId, productId, quantity);

    // 调用产品服务扣减库存
    productService.reduceStock(productId, quantity);
}
```

### 事务管理配置

每个 Seata 服务都需要配置事务管理器：

```yaml
seata:
  enabled: true
  application-id: ${spring.application.name}
  tx-service-group: default_tx_group
  registry:
    type: nacos
    nacos:
      server-addr: ${nacos.server}
```

### 事务处理策略

1. **自动补偿**：当某个子事务失败时，Seata 会自动执行补偿逻辑
2. **全局锁**：防止并发事务修改相同数据
3. **异步处理**：事务日志异步处理，提高性能

## API 网关配置

### 网关架构

Spring Cloud Gateway 作为系统的统一入口，负责处理所有前端请求的路由和转发。

### 路由规则

网关根据请求路径将流量路由到对应的服务：

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: order-service
          uri: lb://order-service
          predicates:
            - Path=/order/**
        - id: product-service
          uri: lb://product-service
          predicates:
            - Path=/product/**
        - id: seata-order-service
          uri: lb://seata-order-service
          predicates:
            - Path=/seata/order/**
        - id: seata-product-service
          uri: lb://seata-product-service
          predicates:
            - Path=/seata/product/**
        - id: business-service
          uri: lb://business-service
          predicates:
            - Path=/business/**
```

### 路由配置说明

- **lb://**: 表示使用负载均衡方式访问服务，网关会自动从 Nacos 获取服务实例列表
- **Predicates**: 定义路由匹配规则，支持路径、请求头、参数等多种匹配方式
- **Filters**: 可配置请求/响应过滤器，实现认证、限流等功能

### 网关功能

- **统一入口**：所有外部请求统一通过网关进入系统，简化客户端调用
- **动态路由**：根据 Nacos 中的服务注册信息动态更新路由规则
- **负载均衡**：集成 Ribbon 或 Spring Cloud LoadBalancer 实现负载均衡
- **安全控制**：统一处理认证和授权逻辑
- **流量控制**：集成 Sentinel 实现限流、熔断等功能
- **跨域处理**：统一处理 CORS 跨域问题
- **请求聚合**：可聚合多个后端服务的响应
- **监控统计**：提供请求统计和监控信息

### 网关配置示例

```yaml
spring:
  cloud:
    gateway:
      default-filters:
        - name: RequestRateLimiter
          args:
            key-resolver: "#{@ipKeyResolver}"
            redis-rate-limiter.replenishRate: 10
            redis-rate-limiter.burstCapacity: 20
      globalcors:
        cors-configurations:
          '[/**]':
            allowedOriginPatterns: "*"
            allowedMethods: "*"
            allowedHeaders: "*"
            allowCredentials: true
```

### 路由处理流程

1. **请求到达**：前端请求发送到网关
2. **路由匹配**：根据配置的路由规则匹配目标服务
3. **负载均衡**：从服务实例列表中选择一个实例
4. **请求转发**：将请求转发到目标服务
5. **响应返回**：将目标服务响应返回给前端

## 业务流程

### 正常业务流程

1. **前端请求** → **Gateway 网关** → **Nacos 服务发现** → **目标服务**
2. 服务间通过 Feign 进行网络调用
3. 对于简单操作，直接返回结果
4. 对于分布式事务，通过 Business 模块协调

### 分布式事务流程

1. **前端请求** → **Gateway 网关** → **Business 服务**
2. **Business 服务** 启动全局事务
3. **调用 Seata 服务** 执行子事务
4. **全局提交/回滚** 根据各子事务结果

## 配置管理

### Nacos 配置

所有服务的配置信息统一存储在 Nacos 配置中心：

- **公共配置**: `common.properties`
- **服务配置**: `{service-name}.properties`
- **环境配置**: 通过 profile 区分不同环境

### 配置加载

服务启动时自动从 Nacos 加载配置：

```yaml
spring:
  config:
    import:
      - nacos:common.properties?group=DEFAULT_GROUP
      - nacos:${spring.application.name}.properties?group=${spring.application.name}
```

## 监控与运维

### 服务监控

- **Nacos**: 服务注册状态、配置中心
- **Sentinel**: 流量控制、熔断降级监控
- **Seata**: 分布式事务监控

### 环境变量

- `NACOS_SERVER`: Nacos 服务器地址 (默认: 127.0.0.1:8848)
- `NACOS_NAMESPACE`: Nacos 命名空间 (默认: dev)
- `SPRING_PROFILES_ACTIVE`: 激活的环境配置

## 部署说明

### 本地开发环境

1. 启动 Docker Compose 基础设施
2. 按顺序启动各微服务
3. 访问各服务进行开发测试

### 生产环境

1. 修改配置文件中的敏感信息（用户名、密码等）
2. 配置外部数据库集群
3. 设置合适的资源配置和健康检查
4. 配置日志收集和监控系统

## 注意事项

1. **启动顺序**：必须先启动基础设施，再启动业务服务
2. **事务处理**：只有涉及多个服务的数据一致性操作才使用分布式事务
3. **服务命名**：保持服务名称与 Nacos 注册名称一致
4. **配置管理**：重要配置信息不要硬编码在代码中
5. **安全考虑**：生产环境必须修改默认的用户名和密码