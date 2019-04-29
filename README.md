# Kong Plugin 1.x 开发指南

> 我已经做过简单测试，目的在于1.x前版本往后迁移的一些问题排查。案例中有缺陷勿怪，毕竟是个案例。

## 简介
Kong是一个云原生、高效、可扩展的分布式 API 网关。

- 支持 Service Mesh
Kong 1.0 通过在 Kong 实例之间添加 Mutual Transport Layer Security（MTLS）和修改插件运行循环来支持 Service Mesh 部署模式。通过这些更改，可以将 Kong 与服务的每个实例部署在一起，代理服务之间的信息流，并随服务的伸缩而自动伸缩。

- 迁移
Kong 1.0 的第二个增强功能是一个新的数据库抽象对象（Database Abstraction Object，DAO）。在升级到最新版的 Kong 时，它可以在停机时间几乎为零的情况下简化从一个数据库模式到另一个数据库模式的迁移过程。新的 DAO 还允许用户一次性升级他们的 Kong 集群，不需要手动逐个升级每个节点。

## 调试

> 事前准备（Docker环境,`docker-compose`也需要安装!!!）

开启开发环境
```
docker-compose up -d
```

进入开发环境
```
$ docker-compose exec kong sh
或者
$ docker exec -it {kong container id} sh
```

查看插件
```
$ ls /etc/kong/plugins`
```
查看kong环境
```
KONG_PROXY_LISTEN=0.0.0.0:8000
KONG_VERSION=1.1.2
HOSTNAME=ea5308cf67b2
SHLVL=1
HOME=/root
KONG_PG_HOST=kong-database
KONG_DATABASE=postgres
TERM=xterm
KONG_ADMIN_LISTEN=0.0.0.0:8001
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KONG_SHA256=0d7509fa2ef653b4aba14a1a1fd20339bccb4f8d386429102c42b7af6d8b6bdb
KONG_PROXY_LISTEN_SSL=0.0.0.0:8443
PWD=/
KONG_LOG_LEVEL=debug
KONG_LUA_PACKAGE_PATH=/etc/kong/plugins/?.lua
KONG_PLUGINS=bundled,header-echo,hello-world, key-auth-redis
```

重新加载kong配置文件
```
$ kong reload
```

查看日志消息
```
$ tail -f /usr/local/kong/logs/error.log
```

## 测试插件(可用性)

> 在这里创建名为`mock-service`的service,并以此做案例分析。

### 创建service
```
curl -i -X POST \
--url http://localhost:8001/services/ \
--data 'name=mock-service' \
--data 'url=http://sample.com/v1/accounts'
```

### 创建routes
```
curl -i -X POST \
--url http://localhost:8001/services/mock-service/routes \
--data 'hosts[]=sample.com' \
--data 'methods[]=POST' \
--data 'name=my-route'
```

### 绑定plugin
```
curl -X POST \
--url "http://localhost:8001/services/mock-service/plugins" \
--data "name=hello-world"
或者
--data "name=key-auth-redis"
```

### 测试请求
```
curl -i -X POST --url http://localhost:8000/mock-service/v1/accounts -H 'Host: sample.com'

或者
curl -i -X POST --url http://localhost:8000/v1/accounts -H 'Host: sample.com'
```

## 参考

[Kong Plugin 开发文档](https://docs.konghq.com/1.1.x/plugin-development/)

[How to Design a Scalable Rate Limiting Algorithm](https://konghq.com/blog/how-to-design-a-scalable-rate-limiting-algorithm/)