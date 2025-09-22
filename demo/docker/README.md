# Seata Server 启动指南

## 目录结构
```
demo/
├── docker/
│   ├── docker-compose-seata-debug.yml  # 调试图
│   ├── seata-config/                   # Seata 配置文件
│   │   ├── file.conf                   # Seata 核心配置
│   │   └── registry.conf               # 注册中心配置
│   ├── start-seata-debug.bat           # 启动脚本
│   ├── stop-seata-debug.bat            # 停止脚本
│   ├── logs-seata.bat                  # 查看日志脚本
│   └── check-seata.bat                 # 检查脚本
├── seata/
│   └── config/                         # Seata 配置文件（主环境）
│       ├── file.conf
│       └── registry.conf
└── docker-compose.yml                  # 主环境配置
```

## 启动步骤

### 1. 启动完整环境（推荐）
```bash
# 在项目根目录执行
docker-compose up -d
```

### 2. 仅调试 Seata（独立环境）
```bash
# 进入 docker 目录
cd docker

# Windows 系统执行
start-seata-debug.bat

# 或者直接使用 docker-compose
docker-compose -f docker-compose-seata-debug.yml up -d
```

## 常见问题排查

### 1. MySQL 连接问题
- 检查 MySQL 是否正常启动：`docker ps | grep mysql`
- 检查网络连接：`docker exec -it seata-server ping mysql`
- 检查数据库用户权限：`docker exec -it mysql mysql -u seata -pseata -e "SHOW DATABASES;"`

### 2. Seata 启动失败
- 查看日志：`docker logs seata-server`
- 检查配置文件语法
- 确认端口未被占用

### 3. 配置文件问题
- file.conf：核心配置，包括存储模式、数据库连接等
- registry.conf：注册中心配置，当前使用 file 模式

## 验证步骤

1. 检查容器状态：
   ```bash
   docker-compose ps
   ```

2. 检查 Seata 日志：
   ```bash
   docker logs seata-server
   ```

3. 验证数据库表：
   ```bash
   docker exec -it mysql mysql -u seata -pseata seata -e "SHOW TABLES;"
   ```

## 端口说明

- MySQL: 3306 (主环境) / 3307 (调试环境)
- Seata Server: 8091 (服务端口)
- Seata Console: 7091 (管理界面端口)

## 停止环境

### 完整环境
```bash
docker-compose down
```

### 调试环境
```bash
# Windows 系统执行
stop-seata-debug.bat

# 或者直接使用 docker-compose
docker-compose -f docker-compose-seata-debug.yml down
```