#!/usr/bin/env bash
# 服务启动脚本 server.sh 服务名称 start|stop|status|restart （默认 start）

# 定义函数
# 函数1: 操作zookeeper服务
function zookeeper() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2
    # 定义zookeeper服务目录
    ZOOKEEPER_HOME=/data/tools/zookeeper
    # 定义zookeeper服务启动脚本
    ZOOKEEPER_BIN=$ZOOKEEPER_HOME/bin/zkServer.sh

    # 启动zookeeper服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting zookeeper service..."
        $ZOOKEEPER_BIN start
    # 停止zookeeper服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping zookeeper service..."
        $ZOOKEEPER_BIN stop
    # 重启zookeeper服务
    elif [ "$ACTION" == "restart" ]; then
        echo "Restarting zookeeper service..."
        $ZOOKEEPER_BIN restart
    elif [ "$ACTION" == "status" ]; then
        echo "Checking zookeeper service status...【ps -ef | grep zookeeper】"
        ps -ef | grep zookeeper
    else
        echo "Usage: $0 zookeeper start|stop|restart"
    fi
}

# 函数2: 操作kafka服务
function kafka() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 定义kafka服务目录
    KAFKA_HOME=/data/tools/kafka
    # 定义kafka服务启动脚本
    KAFKA_BIN=$KAFKA_HOME/bin/kafka-server-start.sh

    # 启动kafka服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting kafka service..."
        $KAFKA_BIN -daemon $KAFKA_HOME/config/server.properties
    # 停止kafka服务 TODO 实践没作用
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping kafka service..."
        $KAFKA_BIN stop
    # 重启kafka服务
    elif [ "$ACTION" == "restart" ]; then
        echo "Restarting kafka service..."
        $KAFKA_BIN restart
    elif [ "$ACTION" == "status" ]; then
        echo "Checking kafka service status... 【ps -ef | grep kafka"
        ps -ef | grep kafka
    else
        echo "Usage: $0 kafka start|stop|restart"
    fi
}

# 函数3: mysql 启动: /usr/local/mysql8/bin/mysqld_safe --defaults-file=/usr/local/etc/my.cnf &
function mysql() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动mysql服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting mysql service..."
        /usr/local/mysql8/bin/mysqld_safe --defaults-file=/usr/local/etc/my.cnf &
        echo "mysql service started."
    # 停止mysql服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping mysql service..."
        /usr/local/mysql8/bin/mysqladmin -uroot -proot shutdown
        echo "mysql service stopped."
    elif [ "$ACTION" == "status" ]; then
        echo "Checking mysql service status...【ps -ef | grep mysql】"
        ps -ef | grep mysql
    else
        echo "Usage: $0 mysql start|stop"
    fi
}

# 函数4: nacos 启动 cd /data/tools/cloud/nacos && sh bin/startup.sh
function nacos() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动nacos服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting nacos service..."
        cd /data/tools/cloud/nacos && sh bin/startup.sh
    # 停止nacos服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping nacos service..."
        cd /data/tools/cloud/nacos && sh bin/shutdown.sh
    elif [ "$ACTION" == "status" ]; then
        echo "Checking nacos service status...【ps -ef | grep nacos】"
        ps -ef | grep nacos
    else
        echo "Usage: $0 nacos start|stop"
    fi
}

# 函数5: seata. 启动: cd /data/tools/cloud/seata/bin && sh seata-server.sh
function seata() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动seata服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting seata service..."
        cd /data/tools/cloud/seata/bin && sh seata-server.sh
    # 停止seata服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping seata service..."
        cd /data/tools/cloud/seata/bin && sh seata-server.sh
    elif [ "$ACTION" == "status" ]; then
        echo "Checking seata service status...【ps -ef | grep seata】"
        ps -ef | grep seata
    else
        echo "Usage: $0 seata start|stop"
    fi
}

# 函数6: redis. 启动: systemctl start redis
function redis() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动redis服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting redis service..."
        systemctl start redis
        # 查看redis服务状态
        systemctl status redis
    # 停止redis服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping redis service..."
        systemctl stop redis
    elif [ "$ACTION" == "status" ]; then
        echo "Checking redis service status...【ps -ef | grep redis】"
        ps -ef | grep redis
    else
        echo "Usage: $0 redis start|stop"
    fi
}

# 函数7: es 启动: su elasticsearch & /usr/local/tools/elasticSearch/elasticsearch-7.10.0/bin/elasticSearch -d
function es() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动es服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting es service..."
        su -l elasticsearch -c "/usr/local/tools/elasticSearch/elasticsearch-7.10.0/bin/elasticsearch -d"
    # 停止es服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping es service..."
        kill -9 $(ps -ef | grep elasticsearch | grep -v grep | awk '{print $2}')
    elif [ "$ACTION" == "status" ]; then
        echo "Checking es service status...【ps -ef | grep elasticsearch】"
        ps -ef | grep elasticsearch
    else
        echo "Usage: $0 es start|stop"
    fi
}

# 函数8: clash 启动: cd /usr/local/clash & sh start.sh
function clash() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动es服务
    if [ "$ACTION" == "start" ]; then
        echo "Starting clash service..."
        cd /usr/local/clash & sh start.sh
    # 停止es服务
    elif [ "$ACTION" == "stop" ]; then
        echo "Stopping clash service..."
        cd /usr/local/clash & sh shutdown.sh
    elif [ "$ACTION" == "status" ]; then
        echo "Checking clash service status...【netstat -tln | grep -E '9090|789.'】"
        netstat -tln | grep -E '9090|789.'
    else
        echo "Usage: $0 es start|stop"
    fi
}

# 函数9: OKX 脚本启动: cd /data/okx-market & sh bin/OKX start
function okx() {
    # 获取启动参数
    SERVICE_NAME=$1
    # 获取操作参数, 默认 start
    ACTION=$2

    # 启动OKX服务
    if [ "$ACTION" == "start" ]; then
      echo "Starting OKX service..."
      cd /data/okx-market & sh bin/OKX start
    elif [ "$ACTION" == "stop" ]; then
      echo "Stopping OKX service..."
      cd /data/okx-market & sh bin/OKX stop
    elif [ "$ACTION" == "status" ]; then
      echo "Checking OKX service status...【ps -ef | grep OKX】"
      cd /data/okx-market & sh bin/OKX status
    else
      echo "Usage: $0 es start|stop"
    fi
}

# 获取启动参数
SERVICE_NAME=$1
# 获取操作参数, 默认 start
ACTION=$2
if [ -z "$ACTION" ]; then
    ACTION="start"
fi

# 启动 (zk) 服务
if [ "$SERVICE_NAME" == "zk" ]; then
    zookeeper $SERVICE_NAME $ACTION
# 启动 (kafka) 服务
elif [ "$SERVICE_NAME" == "kafka" ]; then
    kafka $SERVICE_NAME $ACTION
# 启动 (mysql) 服务
elif [ "$SERVICE_NAME" == "mysql" ]; then
    mysql $SERVICE_NAME $ACTION
# 启动 (nacos) 服务
elif [ "$SERVICE_NAME" == "nacos" ]; then
    nacos $SERVICE_NAME $ACTION
# 启动 (seata) 服务
elif [ "$SERVICE_NAME" == "seata" ]; then
    seata $SERVICE_NAME $ACTION
# 启动 (redis) 服务
elif [ "$SERVICE_NAME" == "redis" ]; then
    redis $SERVICE_NAME $ACTION
# 启动 (es) 服务
elif [ "$SERVICE_NAME" == "es" ]; then
    es $SERVICE_NAME $ACTION
# 启动 clash 服务
elif [ "$SERVICE_NAME" == "clash" ]; then
    clash $SERVICE_NAME $ACTION
# 启动 OKX 服务
elif [ "$SERVICE_NAME" == "okx" ]; then
    okx $SERVICE_NAME $ACTION
else
    echo "Usage: $0 [zk|kafka|mysql|redis|nacos|seata|es] [start|stop|restart]"
fi



