#!/bin/bash
#运行容器必须要一个前台进程。-consul

nginx &
docker-php-entrypoint &
php-fpm &
#获取本机IP
ip=$(ifconfig eth0|sed -n '2p'|sed -n 's#^.*et ##gp'|sed -n 's#n.*$##gp')
curl $ip/index.php/_api/Register_service/register
#判断是否加入集群
if [ ! $CONSUL_LEADER ]; then
  echo "consul集群服务地址为NULL"
else
  echo "consul 加入集群"
  consul join $CONSUL_LEADER
fi 
#ping $ip 
consul agent -dev -client 0.0.0.0

