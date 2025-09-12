#!/bin/bash

# 等待MySQL服务启动完成
until mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1"; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 5
done

>&2 echo "MySQL is up - executing command"

# 检查是否已经初始化过
if mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "USE nacos_config; SELECT COUNT(*) FROM users WHERE username='nacos';" | grep -q "1"; then
  echo "Nacos database already initialized, skipping initialization..."
  exit 0
fi

# 创建数据库
mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 执行项目中的初始化脚本（如果存在）
echo "Executing project initialization scripts..."
for file in /project-init-scripts/*.sql; do
  if [ -f "$file" ]; then
    echo "Executing $file"
    # 使用 < 操作符执行SQL文件
    mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" nacos_config < "$file"
  fi
done

# 根据Nacos版本下载对应的数据库初始化脚本
NACOS_VERSION=${NACOS_VERSION:-latest}
if [ "$NACOS_VERSION" = "latest" ]; then
  SQL_FILE_URL="https://raw.githubusercontent.com/alibaba/nacos/master/distribution/conf/nacos-mysql.sql"
else
  SQL_FILE_URL="https://raw.githubusercontent.com/alibaba/nacos/${NACOS_VERSION}/distribution/conf/nacos-mysql.sql"
fi

# 下载SQL文件
wget -O /tmp/nacos-mysql.sql "$SQL_FILE_URL"

# 检查SQL文件是否下载成功
if [ -f "/tmp/nacos-mysql.sql" ]; then
  echo "Executing Nacos SQL file..."
  # 使用 < 操作符执行SQL文件
  mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" nacos_config < /tmp/nacos-mysql.sql
else
  echo "Failed to download Nacos SQL file"
fi

# 创建用户并授权
mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS 'nacos'@'%' IDENTIFIED BY 'nacos';"
mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON nacos_config.* TO 'nacos'@'%';"
mysql -h mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "Nacos database initialization completed!"