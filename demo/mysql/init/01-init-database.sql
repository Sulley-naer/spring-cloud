-- =============================================
-- MySQL 数据库初始化脚本
-- 创建数据库和用户
-- =============================================

-- 创建 nacos_config 数据库
CREATE DATABASE IF NOT EXISTS nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建 nacos 用户并授权
CREATE USER IF NOT EXISTS 'nacos'@'%' IDENTIFIED BY 'nacos';
GRANT ALL PRIVILEGES ON nacos_config.* TO 'nacos'@'%';
FLUSH PRIVILEGES;

-- 使用 nacos_config 数据库
USE nacos_config;

-- =============================================
-- config_info 表 - 配置信息主表
-- =============================================

CREATE TABLE config_info (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) DEFAULT NULL COMMENT 'group_id',
  content longtext NOT NULL COMMENT 'content',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  c_desc varchar(256) DEFAULT NULL COMMENT 'configuration description',
  c_use varchar(64) DEFAULT NULL COMMENT 'configuration usage',
  effect varchar(64) DEFAULT NULL COMMENT '配置生效的描述',
  type varchar(64) DEFAULT NULL COMMENT '配置的类型',
  c_schema text COMMENT '配置的模式',
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfo_datagrouptenant (data_id,group_id,tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

-- =============================================
-- config_info_aggr 表 - 聚合配置信息表
-- =============================================

CREATE TABLE config_info_aggr (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  datum_id varchar(255) NOT NULL COMMENT 'datum_id',
  content longtext NOT NULL COMMENT '内容',
  gmt_modified datetime NOT NULL COMMENT '修改时间',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfoaggr_datagrouptenantdatum (data_id,group_id,tenant_id,datum_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='增加租户字段';

-- =============================================
-- config_info_beta 表 - Beta配置信息表
-- =============================================

CREATE TABLE config_info_beta (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL COMMENT 'content',
  beta_ips varchar(1024) DEFAULT NULL COMMENT 'betaIps',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfobeta_datagrouptenant (data_id,group_id,tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_beta';

-- =============================================
-- config_info_tag 表 - 标签配置信息表
-- =============================================

CREATE TABLE config_info_tag (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  tenant_id varchar(128) DEFAULT '' COMMENT 'tenant_id',
  tag_id varchar(128) NOT NULL COMMENT 'tag_id',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL COMMENT 'content',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfotag_datagrouptenanttag (data_id,group_id,tenant_id,tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_tag';

-- =============================================
-- config_info_gray 表 - 灰度配置信息表
-- =============================================

CREATE TABLE config_info_gray (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  tenant_id varchar(128) DEFAULT '' COMMENT 'tenant_id',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL COMMENT 'content',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  gray_name varchar(128) DEFAULT NULL COMMENT '灰度名称',
  gray_rule text COMMENT '灰度规则',
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfogray_datagrouptenant (data_id,group_id,tenant_id,gray_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_gray';

-- =============================================
-- config_tags_relation 表 - 配置标签关系表
-- =============================================

CREATE TABLE config_tags_relation (
  id bigint(20) NOT NULL COMMENT 'id',
  tag_name varchar(128) NOT NULL COMMENT 'tag_name',
  tag_type varchar(64) DEFAULT NULL COMMENT 'tag_type',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  tenant_id varchar(128) DEFAULT '' COMMENT 'tenant_id',
  nid bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增长标识',
  PRIMARY KEY (nid),
  UNIQUE KEY uk_configtagrelation_configidtag (id,tag_name,tag_type),
  KEY idx_tenant_id (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tag_relation';

-- =============================================
-- group_capacity 表 - 集群、各Group容量信息表
-- =============================================

CREATE TABLE group_capacity (
  id bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  group_id varchar(128) NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  quota int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  max_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  max_aggr_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
  max_aggr_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  max_history_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_group_id (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、各Group容量信息表';

-- =============================================
-- his_config_info 表 - 多租户改造
-- =============================================

CREATE TABLE his_config_info (
  id bigint(20) unsigned NOT NULL COMMENT 'id',
  nid bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增长标识',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL COMMENT 'content',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  op_type char(10) DEFAULT NULL COMMENT 'operation type',
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  publish_type varchar(50) DEFAULT NULL COMMENT '发布类型',
  gray_name varchar(128) DEFAULT NULL COMMENT '灰度名称',
  ext_info text DEFAULT NULL COMMENT '扩展信息',
  PRIMARY KEY (nid),
  KEY idx_gmt_create (gmt_create),
  KEY idx_gmt_modified (gmt_modified),
  KEY idx_did (data_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';

-- =============================================
-- tenant_capacity 表 - 租户容量信息表
-- =============================================

CREATE TABLE tenant_capacity (
  id bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  tenant_id varchar(128) NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  quota int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  max_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  max_aggr_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  max_aggr_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  max_history_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_tenant_id (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';

-- =============================================
-- tenant_info 表 - 租户信息表
-- =============================================

CREATE TABLE tenant_info (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  kp varchar(128) NOT NULL COMMENT 'kp',
  tenant_id varchar(128) DEFAULT '' COMMENT 'tenant_id',
  tenant_name varchar(128) DEFAULT '' COMMENT 'tenant_name',
  tenant_desc varchar(256) DEFAULT NULL COMMENT 'tenant_desc',
  create_source varchar(32) DEFAULT NULL COMMENT 'create_source',
  gmt_create bigint(20) NOT NULL COMMENT '创建时间',
  gmt_modified bigint(20) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_tenant_info_kptenantid (kp,tenant_id),
  KEY idx_tenant_id (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

-- =============================================
-- users 表 - 用户表
-- =============================================

CREATE TABLE users (
  username varchar(50) NOT NULL COMMENT 'username',
  password varchar(500) NOT NULL COMMENT 'password',
  enabled tinyint(1) NOT NULL COMMENT 'enabled',
  PRIMARY KEY (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- =============================================
-- roles 表 - 角色表
-- =============================================

CREATE TABLE roles (
  username varchar(50) NOT NULL COMMENT 'username',
  role varchar(50) NOT NULL COMMENT 'role',
  UNIQUE KEY idx_user_role (username,role) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- =============================================
-- permissions 表 - 权限表
-- =============================================

CREATE TABLE permissions (
  role varchar(50) NOT NULL COMMENT 'role',
  resource varchar(255) NOT NULL COMMENT 'resource',
  action varchar(8) NOT NULL COMMENT 'action',
  UNIQUE KEY uk_role_permission (role,resource,action) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- =============================================
-- 插入默认数据
-- =============================================

-- 插入默认用户 nacos/nacos
INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', 1);

-- 插入默认角色
INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');