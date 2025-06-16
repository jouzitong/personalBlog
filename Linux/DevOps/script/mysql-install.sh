#!/usr/bin/env bash

# 切换到安装目录 /usr/local
cd /usr/local/src
# 下载安装包
wget https://dev.mysql.com/get/Downloads/MySQL-8.3/mysql-8.3.0-linux-glibc2.17-x86_64.tar.xz
# 解压
tar -Jxvf mysql-8.3.0-linux-glibc2.17-x86_64.tar.xz
# 重命名
mv mysql-8.3.0-linux-glibc2.17-x86_64 ../mysql8
# 进入mysql目录
cd ../mysql8
# 配置 path 环境变量
echo "export PATH=\$PATH:/usr/local/mysql8/bin" >> /etc/profile
# 使配置生效
source /etc/profile
# 确认是否安装成功
mysql --version
# 创建用户组和用户
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
# 创建数据目录
mkdir -p /data/mysql8_data
# 修改目录权限
chown -R mysql:mysql /data/mysql8_data
# 配置文件
tee /usr/local/etc/my.cnf <<-'EOF'
[mysql]
# 默认字符集
default-character-set=utf8mb4
[client]
port       = 3306
socket     = /tmp/mysql.sock
[mysqld]
port       = 3306
server-id  = 3306
user       = mysql
socket     = /tmp/mysql.sock
# 安装目录
basedir    = /usr/local/mysql8
# 数据存放目录
datadir    = /data/mysql8_data/mysql
log-bin    = /data/mysql8_data/mysql/mysql-bin
innodb_data_home_dir      =/data/mysql8_data/mysql
innodb_log_group_home_dir =/data/mysql8_data/mysql
# 日志及进程数据的存放目录
log-error =/data/mysql8_data/mysql/mysql.log
pid-file  =/data/mysql8_data/mysql/mysql.pid
# 服务端字符集
character-set-server=utf8mb4
lower_case_table_names=1
autocommit =1
##### 以上涉及文件夹明，注意修改
skip-external-locking
key_buffer_size = 256M
max_allowed_packet = 1M
table_open_cache = 1024
sort_buffer_size = 4M
net_buffer_length = 8K
read_buffer_size = 4M
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 64M
thread_cache_size = 128
#query_cache_size = 128M
tmp_table_size = 128M
explicit_defaults_for_timestamp = true
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535
binlog_format=mixed
binlog_expire_logs_seconds =864000
# 创建表时使用的默认存储引擎
default_storage_engine = InnoDB
innodb_data_file_path = ibdata1:10M:autoextend
innodb_buffer_pool_size = 1024M
innodb_log_file_size = 256M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50
transaction-isolation=READ-COMMITTED
[mysqldump]
quick
max_allowed_packet = 16M
[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 4M
read_buffer = 2M
write_buffer = 2M
[mysqlhotcopy]
interactive-timeout

EOF

# 初始化数据库
/usr/local/mysql8/bin/mysqld  --defaults-file=/usr/local/etc/my.cnf --basedir=/usr/local/mysql8 --datadir=/data/mysql8_data/mysql --user=mysql --initialize-insecure

# 启动mysql
/usr/local/mysql8/bin/mysqld  --defaults-file=/usr/local/etc/my.cnf --basedir=/usr/local/mysql8 --datadir=/data/mysql8_data/mysql --user=mysql &
