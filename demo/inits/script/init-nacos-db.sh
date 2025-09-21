#!/bin/bash

# 等待MySQL服务启动完成
until mysql -h mysql -u root -proot123 -e "SELECT 1"; do
  echo "MySQL is unavailable - sleeping"
  sleep 5
done

echo "nacos 版本: ${NACOS_VERSION}"

# 检查是否已经初始化过
if mysql -h mysql -u root -proot123 -e "USE nacos_config; SELECT COUNT(*) FROM users WHERE username='nacos';" | grep -q "1"; then
  echo "Nacos database already initialized, skipping initialization..."
  exit 0
fi

>&2 echo "MySQL is up - executing command"

# 创建nacos_config数据库
echo "Creating nacos_config database..."
mysql -h mysql -u root -proot123 -e "CREATE DATABASE IF NOT EXISTS nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE=utf8mb4_unicode_ci;"

# 初始化Nacos数据库
echo "Initializing Nacos database..."

# 检查是否已经初始化过（检查nacos_config数据库中是否存在users表）
if mysql -h mysql -u root -proot123 -e "USE nacos_config; SHOW TABLES LIKE 'users';" | grep -q "users"; then
  echo "Nacos database already initialized, skipping initialization..."
else
  # 尝试下载Nacos数据库SQL文件
  echo "Downloading Nacos MySQL schema..."
  NACOS_VERSION=${NACOS_VERSION:-latest}
  if [ "$NACOS_VERSION" = "latest" ]; then
    SQL_FILE_URL="https://proxy.pipers.cn/https://raw.githubusercontent.com/alibaba/nacos/master/distribution/conf/mysql-schema.sql"
  else
    SQL_FILE_URL="https://proxy.pipers.cn/https://raw.githubusercontent.com/alibaba/nacos/${NACOS_VERSION}/distribution/conf/mysql-schema.sql"
  fi

  # 使用curl下载Nacos SQL文件，如果失败则使用本地文件
  curl -o /tmp/nacos-mysql.sql "$SQL_FILE_URL"

 # 如果下载失败，使用本地的SQL文件
  if [ $? -ne 0 ]; then
    echo "Failed to download Nacos SQL file, using local file instead..."

    # 确保本地路径正确
    LOCAL_SQL_FILE="/project-init-scripts/nacos-mysql.sql"
    if [ -f "$LOCAL_SQL_FILE" ]; then
      cp "$LOCAL_SQL_FILE" /tmp/nacos-mysql.sql
    else
      echo "Local SQL file not found, exiting..."
      exit 1
    fi
  fi

  # 检查SQL文件是否存在
  if [ -f "/tmp/nacos-mysql.sql" ]; then
    echo "Executing Nacos SQL file..."
    mysql -h mysql -u root -proot123 nacos_config < /tmp/nacos-mysql.sql
    if [ $? -ne 0 ]; then
      echo "Error executing Nacos SQL file, exiting..."
      exit 1
    else
      echo "Nacos SQL file executed successfully"
    fi
  else
    echo "No SQL file found, exiting..."
    exit 1
  fi
fi

# 如果Nacos数据库初始化成功，再继续初始化项目数据库
echo "Executing project initialization scripts..."

# 执行项目中的初始化脚本（如果存在），跳过nacos-mysql.sql
for file in /project-init-scripts/*.sql; do
  echo "当前文件路径: $file"  # 打印文件路径，调试用
  # 进行路径比较，避免路径不匹配

  if [ -f "$file" ]; then
    echo "Executing $file"
    # 使用IF NOT EXISTS来避免表已存在的错误
      if [[ "$file" == "/project-init-scripts/nacos-mysql.sql" ]]; then
        echo "Skipping $file to avoid re-execution..."
        continue
      else
        mysql -h mysql -u root -proot123 nacos_config < "$file"
      fi
    if [ $? -eq 0 ]; then
      echo "$file executed successfully"
    else
      echo "Error executing $file"
    fi
  else
    echo "No SQL file found in /project-init-scripts"
  fi
done

# 创建数据库用户并授权
echo "Creating user 'nacos' and granting privileges..."
mysql -h mysql -u root -proot123 -e "CREATE USER IF NOT EXISTS 'nacos'@'%' IDENTIFIED BY 'nacos';"
mysql -h mysql -u root -proot123 -e "GRANT ALL PRIVILEGES ON nacos_config.* TO 'nacos'@'%';"
mysql -h mysql -u root -proot123 -e "FLUSH PRIVILEGES;"

echo "Nacos database initialization completed!"
