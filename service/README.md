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

## Gitlab

Gitlab容器启动大概需要5-6分钟, 请耐心等待. SSH端口在Nginx Proxy Manager里面设置stream, 转发7750端口到gitlab:22

`docker compose exec -it gitlab /bin/bash`

![image](https://github.com/user-attachments/assets/087aaf26-c723-42d1-912d-5e46940ef0fa)

`docker compose exec -it gitlab-runner gitlab-runner register`

0. 取gitlab界面注册一个runner, 保存好token
1. 输入Gitlab的URL: https://git.ricolxwz.io
2. 输入刚才的token
3. 输入runner的名字, 随便写
4. 输入executor, 选择docker
5. 输入默认的docker image: ubuntu:latest
6. 配置完成会生成配置文件, 在`./app/gitlab-runner/config`文件夹下

## Easyimage

到配置目录, 编辑config.php, 里面的domain和imgurl改成自己的域名, 记得加s, 然后重启容器
