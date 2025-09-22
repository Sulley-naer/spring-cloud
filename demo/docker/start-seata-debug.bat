@echo off
echo Starting Seata Debug Environment...
echo ========================================

echo 1. Creating docker directory if not exists...
mkdir seata-config 2>nul

echo 2. Starting MySQL and Seata containers...
docker-compose -f docker-compose-seata-debug.yml up -d

echo 3. Waiting for containers to start...
timeout /t 10 /nobreak >nul

echo 4. Checking container status...
docker-compose -f docker-compose-seata-debug.yml ps

echo ========================================
echo Debug environment started.
echo MySQL is running on port 3307
echo Seata Server is running on port 8092
echo ========================================