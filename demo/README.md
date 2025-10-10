# 微服务项目 - 数据库配置说明

## 项目结构

- `service-order`: 订单服务 (端口: 8001)
- `service-product`: 产品服务 (端口: 8002)

## 数据库配置

### 使用 Docker Compose 启动数据库服务

本项目使用 MySQL 和 Redis 作为数据存储，通过 Docker Compose 进行管理。

#### 启动服务

```bash
# 在 demo 目录下执行
docker-compose up -d
```

#### 停止服务

```bash
docker-compose down
```

#### 查看服务状态

```bash
docker-compose ps
```

### 数据库信息

#### MySQL

- **端口**: 3305
- **Root密码**: root123
- **用户名**: cloud_user
- **密码**: cloud_pass
- **数据库**:
    - order_service (订单服务)
    - product_service (产品服务)

#### Redis

- **端口**: 6379
- **密码**: redis123

#### Nacos 注册中心

- **控制台端口**: 8848
- **gRPC端口**: 9848, 9849
- **控制台地址**: http://localhost:8848/nacos
- **用户名**: nacos
- **密码**: nacos
- **数据存储**: 使用MySQL数据库持久化

#### seata 数据中心

- **控制台端口**: 7091
- **gRPC端口**: 8091
- **控制台地址**: http://localhost:7091/
- **用户名**: seata
- **密码**: seata
- **数据存储**: 使用MySQL数据库持久化

### 数据持久化

- MySQL数据存储在 Docker volume: `mysql_data`
- Redis数据存储在 Docker volume: `redis_data`

### 初始化数据

- MySQL会自动执行 `mysql/init/init.sql` 中的初始化脚本
- 包含数据库创建和示例数据插入

## 启动应用服务

1. 确保数据库服务已启动
2. 启动订单服务:

   ```bash
   cd services/service-order
   mvn spring-boot:run
   ```

3. 启动产品服务:

   ```bash
   cd services/service-product
   mvn spring-boot:run
   ```

## 注意事项

- 首次启动时，MySQL会自动创建数据库和表结构
- 确保Docker Desktop已启动
- 如需修改端口或密码，请同时更新 `docker-compose.yml` 和各服务的 `application.properties` 文件
