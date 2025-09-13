# Nacos配置同步解决方案

## 目录结构
```
.
├── docker-compose.yml              # Docker编排文件
├── nacos-config/                   # Nacos配置文件目录
│   └── config-data.json           # 配置数据文件
├── inits/
│   ├── db/                        # 数据库初始化脚本
│   │   └── nacos-mysql.sql       # Nacos数据库表结构
│   └── script/                    # 配置管理脚本
│       ├── init-nacos-db.sh      # 数据库初始化脚本
│       ├── nacos-config-backup.sh # 配置备份脚本
│       ├── nacos-config-restore.sh # 配置恢复脚本
│       ├── nacos-config-sync.sh   # 配置自动同步脚本
│       └── nacos-config-manager.sh # 配置管理工具
```

## 使用说明

### 1. 备份现有配置
```bash
# 备份Nacos配置到JSON文件
./inits/script/nacos-config-manager.sh backup
```

### 2. 恢复配置
```bash
# 从JSON文件恢复Nacos配置
./inits/script/nacos-config-manager.sh restore
```

### 3. Docker部署时自动同步配置
在新机器上使用Docker部署时，配置会自动同步：

1. 确保`nacos-config/config-data.json`文件中包含要同步的配置
2. 运行docker-compose:
```bash
docker-compose up -d
```

系统会自动启动以下服务：
- MySQL数据库
- Nacos服务
- 配置同步服务（在Nacos启动后自动同步配置）

## 配置文件格式

`nacos-config/config-data.json`文件格式如下：
```json
[
  {
    "dataId": "配置ID",
    "group": "配置组",
    "content": "配置内容",
    "type": "配置类型(yaml/properties等)",
    "desc": "配置描述"
  }
]
```

## 环境变量

配置同步脚本支持以下环境变量：
- `NACOS_SERVER`: Nacos服务器地址 (默认: http://nacos-server:8848)
- `NACOS_USERNAME`: Nacos用户名 (默认: nacos)
- `NACOS_PASSWORD`: Nacos密码 (默认: nacos)
- `SYNC_ON_STARTUP`: 是否在启动时同步配置 (默认: true)

## 注意事项

1. 确保`nacos-config/config-data.json`文件存在且格式正确
2. 在生产环境中，请修改默认的用户名和密码
3. 建议定期备份Nacos配置，防止数据丢失