@echo off
echo Stopping Seata Debug Environment...
echo ========================================

echo Stopping and removing containers...
docker-compose -f docker-compose-seata-debug.yml down

echo Removing volumes...
docker volume prune -f

echo ========================================
echo Debug environment stopped and cleaned.
echo ========================================