-- =============================================
-- MySQL 数据库初始化脚本
-- 用于初始化 cloud_db 相关表
-- =============================================

USE cloud_db;

-- =============================================
-- 示例表 - 可以根据实际需求添加更多表
-- =============================================

-- 这里可以添加 cloud_db 相关的表结构
-- 例如用户表、订单表等业务相关表

-- 示例：
CREATE TABLE IF NOT EXISTS users
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders
(
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id      BIGINT         NOT NULL,
    product_name VARCHAR(255)   NOT NULL,
    quantity     INT            NOT NULL,
    price        DECIMAL(10, 2) NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)   NOT NULL UNIQUE,
    description TEXT,
    price       DECIMAL(10, 2) NOT NULL,
    stock       INT            NOT NULL DEFAULT 0,
    created_at  TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP               DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

# seata 事务表
CREATE TABLE undo_log
(
    id            bigint(20)   NOT NULL AUTO_INCREMENT,
    branch_id     bigint(20)   NOT NULL,
    xid           varchar(100) NOT NULL,
    context       varchar(128) NOT NULL,
    rollback_info longblob     NOT NULL,
    log_status    int(11)      NOT NULL,
    log_created   datetime     NOT NULL,
    log_modified  datetime     NOT NULL,
    ext           varchar(100) DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY ux_undo_log (xid, branch_id)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8;