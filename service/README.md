# 服务

## 迁移

1. 下载.env文件: 非常重要! 包含数据库的密码之类的信息, 不然在新机器上无法恢复
2. 压缩app文件夹: `tar -czvf app.tar.gz app`, 下载文件夹
3. 在新机器上, 上传app文件夹, 解压app文件夹: ``tar -xzvf app.tar.gz`
4. 新建`docker-compose.yaml`文件
5. 新建`.env`文件

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
