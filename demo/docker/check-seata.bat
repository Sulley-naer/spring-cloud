@echo off
echo Checking Seata Environment...
echo ================================

echo 1. Checking if MySQL container is running...
docker ps | findstr mysql-db
if %errorlevel% == 0 (
    echo MySQL container is running.
) else (
    echo MySQL container is not running.
)

echo.
echo 2. Checking if Seata container is running...
docker ps | findstr seata-server
if %errorlevel% == 0 (
    echo Seata container is running.
) else (
    echo Seata container is not running.
)

echo.
echo 3. Testing MySQL connection...
docker exec -i mysql-db mysql -u seata -pseata -e "SELECT 1;" seata 2>nul
if %errorlevel% == 0 (
    echo MySQL connection successful.
) else (
    echo MySQL connection failed.
)

echo.
echo 4. Checking Seata logs...
docker logs seata-server | findstr -i "error\|exception\|fail" 2>nul
if %errorlevel% == 0 (
    echo Seata logs contain errors. Check full logs for details.
) else (
    echo No errors found in Seata logs.
)

echo ================================
echo Check complete.