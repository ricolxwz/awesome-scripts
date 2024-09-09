# 服务

## 备份

```bash
timestamp=$(date +%Y)-$(date +%m)-$(date +%d)
cd /root/man
tar -czvf /root/npm.tar.gz nginx --absolute-names
cd /root/app
tar -czvf /root/memos.tar.gz memos --absolute-names
tar -czvf /root/umami.tar.gz umami --absolute-names
tar -czvf /root/umami-db.tar.gz umami-db --absolute-names
tar -czvf /root/uptime-kuma.tar.gz uptime-kuma --absolute-names
tar -czvf /root/yourls.tar.gz yourls --absolute-names
tar -czvf /root/yourls-db.tar.gz yourls-db --absolute-names
tar -czvf /root/nav.tar.gz nav --absolute-names
tar -czvf /root/easyimage.tar.gz easyimage --absolute-names
cd /root
aws s3 cp /root/npm.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/memos.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/umami.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/umami-db.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/uptime-kuma.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/yourls.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/yourls-db.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/nav.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /root/easyimage.tar.gz s3://ricolxwz-backup/${timestamp}/
rm /root/*.tar.gz
```

```
0 0 */5 * * /root/backup.sh
```

## 网络

在使用之前, 请先建立网络`app`: `docker network create app`

## 迁移

简单直接的方法: 备份app文件夹, man文件夹, .env文件. 

1. `/root/gitlab-backup.sh`
2. 下载.env文件: 非常重要! 包含数据库的密码之类的信息, 不然在新机器上无法恢复
3. 压缩app文件夹: 单独备份gitlab文件夹, `tar -czvf gitlab-aux.tar.gz /root/app/gitlab`, 然后`rm -rf /root/app/gitlab`, 最后`tar -czvf app.tar.gz app`, 下载两个文件夹
4. 压缩man文件夹: `tar -czvf man.tar.gz man`
6. 在新机器上, 上传app文件夹, 解压app文件夹: `tar -xzvf app.tar.gz`, 解压man文件夹: `tar -xzvf man.tar.gz`, gitlab-aux暂时不需要, 是以防万一用的
7. 新建`man.yaml`文件
8. `docker compose -f /root/man.yaml up -d`
9. 新建.env文件, 输入密钥
10. 新建`app.yaml`文件
11. `docker compose -f /root/app.yaml up -d`
12. 执行gitlab迁移教程中的6-8步, 或者使用刚才的`gitlab-aux.tar.gz`

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

## Nextcloud

```
sudo cat /var/lib/docker/volumes/nextcloud_aio_mastercontainer/_data/data/configuration.json | grep password
```
