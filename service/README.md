# 服务

## 迁移

迁移教程: https://misc.ricolxwz.de/software/misc/gitlab/migrate.html

1. 执行gitlab迁移教程中的1-4步
2. 下载.env文件: 非常重要! 包含数据库的密码之类的信息, 不然在新机器上无法恢复
3. 压缩app文件夹: 删去gitlab文件夹, `tar -czvf app.tar.gz app`, 下载文件夹
4. 在新机器上, 上传app文件夹, 解压app文件夹: ``tar -xzvf app.tar.gz`
5. 新建`docker-compose.yaml`文件
6. 新建`.env`文件
7. 执行gitlab迁移教程中的6-7步
8. `docker compose up -d`

## Nginx Proxy Manager

默认用户名密码:

- Email:    admin@example.com
- Password: changeme

登录之后修改.

## Alist

需要手动设置密码:

```
docker compose exec -it alist ./alist admin set <密码>
```

## 3x-ui

- Username:    admin
- Password: admin

## Umami

- Username: admin
- Password: umami

## Gitlab

Gitlab容器启动大概需要5-6分钟, 请耐心等待. SSH端口在Nginx Proxy Manager里面设置stream, 转发7750端口到gitlab:22

其他, 请参考https://misc.ricolxwz.de/

## Easyimage

到配置目录, 编辑config.php, 里面的domain和imgurl改成自己的域名, 记得加s, 然后重启容器
