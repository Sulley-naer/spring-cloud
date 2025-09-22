#!/bin/bash

# 等待MySQL服务启动完成
until mysql -h mysql -u root -proot123 -e "SELECT 1" &> /dev/null; do
  echo "MySQL is unavailable - sleeping"
  sleep 5
done

echo "nacos 版本: ${NACOS_VERSION}"
echo "seata 版本: ${SEATA_VERSION}"

############################################
# 初始化 Nacos 数据库
############################################
if mysql -h mysql -u root -proot123 -e "USE nacos_config; SELECT COUNT(*) FROM users WHERE username='nacos';" | grep -q "1"; then
  echo "Nacos database already initialized, skipping initialization..."
else
  echo "Creating nacos_config database..."
  mysql -h mysql -u root -proot123 -e "CREATE DATABASE IF NOT EXISTS nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE=utf8mb4_unicode_ci;"

  echo "Initializing Nacos database..."
  if mysql -h mysql -u root -proot123 -e "USE nacos_config; SHOW TABLES LIKE 'users';" | grep -q "users"; then
    echo "Nacos database already initialized, skipping initialization..."
  else
    echo "Downloading Nacos MySQL schema..."
    NACOS_VERSION=${NACOS_VERSION:-master}
    SQL_FILE_URL="https://proxy.pipers.cn/https://raw.githubusercontent.com/alibaba/nacos/${NACOS_VERSION}/distribution/conf/mysql-schema.sql"

    curl -o /tmp/nacos-mysql.sql "$SQL_FILE_URL"
    if [ $? -ne 0 ]; then
      echo "Failed to download Nacos SQL file, using local file instead..."
      LOCAL_SQL_FILE="/project-init-scripts/nacos-mysql.sql"
      [ -f "$LOCAL_SQL_FILE" ] && cp "$LOCAL_SQL_FILE" /tmp/nacos-mysql.sql || { echo "Local Nacos SQL file not found, exiting..."; exit 1; }
    fi

    mysql -h mysql -u root -proot123 nacos_config < /tmp/nacos-mysql.sql
    [ $? -ne 0 ] && { echo "Error executing Nacos SQL file, exiting..."; exit 1; }
    echo "Nacos SQL file executed successfully"
  fi
fi

############################################
# 初始化 Seata 数据库
############################################
echo "Creating seata database..."
mysql -h mysql -u root -proot123 -e "CREATE DATABASE IF NOT EXISTS seata DEFAULT CHARACTER SET utf8mb4 COLLATE=utf8mb4_unicode_ci;"

if mysql -h mysql -u root -proot123 -e "USE seata; SHOW TABLES LIKE 'global_table';" | grep -q "global_table"; then
  echo "Seata database already initialized, skipping initialization..."
else
  echo "Initializing Seata database..."
  SEATA_VERSION=${SEATA_VERSION:-2.x}
  
  # 首先尝试从本地文件初始化
  LOCAL_SQL_FILE="/project-init-scripts/seata-mysql.sql"
  if [ -f "$LOCAL_SQL_FILE" ]; then
    echo "Using local Seata SQL file..."
    mysql -h mysql -u root -proot123 seata < "$LOCAL_SQL_FILE"
    [ $? -eq 0 ] && echo "Local Seata SQL file executed successfully" || { echo "Error executing local Seata SQL file, exiting..."; exit 1; }
  else
    echo "Local Seata SQL file not found, trying to download..."
    SEATA_SQL_URL="https://proxy.pipers.cn/https://raw.githubusercontent.com/apache/incubator-seata/${SEATA_VERSION}/script/server/db/mysql.sql"
    curl -o /tmp/seata-mysql.sql "$SEATA_SQL_URL"
    if [ $? -ne 0 ]; then
      echo "Failed to download Seata SQL file, exiting..."
      exit 1
    fi
    mysql -h mysql -u root -proot123 seata < /tmp/seata-mysql.sql
    [ $? -ne 0 ] && { echo "Error executing Seata SQL file, exiting..."; exit 1; }
    echo "Seata SQL file executed successfully"
  fi
fi

############################################
# 初始化项目自带脚本
############################################
echo "Executing project initialization scripts..."
for file in /project-init-scripts/*.sql; do
  echo "当前文件路径: $file"
  if [ -f "$file" ]; then
    if [[ "$file" == "/project-init-scripts/nacos-mysql.sql" ]] || [[ "$file" == "/project-init-scripts/seata-mysql.sql" ]]; then
      echo "Skipping $file to avoid re-execution..."
      continue
    fi
    mysql -h mysql -u root -proot123 nacos_config < "$file"
    [ $? -eq 0 ] && echo "$file executed successfully" || echo "Error executing $file"
  fi
done

############################################
# 创建数据库用户并授权
############################################
echo "Creating user 'nacos' and granting privileges..."
mysql -h mysql -u root -proot123 -e "CREATE USER IF NOT EXISTS 'nacos'@'%' IDENTIFIED BY 'nacos';"
mysql -h mysql -u root -proot123 -e "GRANT ALL PRIVILEGES ON nacos_config.* TO 'nacos'@'%';"
mysql -h mysql -u root -proot123 -e "FLUSH PRIVILEGES;"

echo "Creating user 'seata' and granting privileges..."
mysql -h mysql -u root -proot123 -e "CREATE USER IF NOT EXISTS 'seata'@'%' IDENTIFIED BY 'seata';"
mysql -h mysql -u root -proot123 -e "GRANT ALL PRIVILEGES ON seata.* TO 'seata'@'%';"
mysql -h mysql -u root -proot123 -e "FLUSH PRIVILEGES;"

echo "Granting cloud_user access to seata database..."
mysql -h mysql -u root -proot123 -e "GRANT SELECT, INSERT, UPDATE, DELETE ON seata.* TO 'cloud_user'@'%';"
mysql -h mysql -u root -proot123 -e "FLUSH PRIVILEGES;"

echo "Database initialization completed!"
