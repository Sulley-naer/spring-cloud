#!/bin/bash
# Seata 健康检查脚本

echo "================================"
echo "Seata Health Check"
echo "================================"

# 检查容器是否运行
echo "1. Checking container status..."
if docker ps | grep -q "seata-server"; then
    echo "✓ Seata server is running"
else
    echo "✗ Seata server is not running"
    exit 1
fi

if docker ps | grep -q "mysql-db"; then
    echo "✓ MySQL is running"
else
    echo "✗ MySQL is not running"
    exit 1
fi

# 检查端口是否开放
echo "2. Checking ports..."
if nc -z localhost 8091; then
    echo "✓ Seata service port (8091) is open"
else
    echo "✗ Seata service port (8091) is not accessible"
fi

if nc -z localhost 3306; then
    echo "✓ MySQL port (3306) is open"
else
    echo "✗ MySQL port (3306) is not accessible"
fi

# 检查数据库连接
echo "3. Checking database connectivity..."
if docker exec mysql-db mysql -u seata -pseata -e "USE seata; SHOW TABLES;" > /dev/null 2>&1; then
    echo "✓ Database connection successful"
else
    echo "✗ Database connection failed"
fi

# 检查 Seata 表是否存在
echo "4. Checking Seata tables..."
if docker exec mysql-db mysql -u seata -pseata -e "USE seata; SELECT COUNT(*) FROM global_table;" > /dev/null 2>&1; then
    echo "✓ Seata tables exist"
else
    echo "✗ Seata tables do not exist"
fi

echo "================================"
echo "Health check completed"
echo "================================"