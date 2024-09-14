# 服务

## 用户

```
useradd -mG docker -d /home/wenzexu -s /bin/bash wenzexu
passwd wenzexu
```

## 时区

```
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

## 备份

```bash
# 请使用root备份, 因为使用普通用户备份有可能无法访问由容器创建的文件夹
# chown -R wenzexu:wenzexu /home/wenzexu/app && chown -R wenzexu:wenzexu /home/wenzexu/man && chown wenzexu:wenzexu /home/wenzexu/.env && chown wenzexu:wenzexu /home/wenzexu/app.yaml && chown wenzexu:wenzexu /home/wenzexu/man.yaml & chown wenzexu:wenzexu /home/wenzexu/backup.sh
# chmod -R 777 /home/wenzexu/app && chmod -R 777 /home/wenzexu/man && chmod 600 /home/wenzexu/.env && chmod 600 /home/wenzexu/app.yaml && chmod 600 /home/wenzexu/man.yaml && chmod 600 /home/wenzexu/backup.sh
timestamp=$(TZ='Asia/Shanghai' date +%Y-%m-%d)
cd /home/wenzexu
tar -czvf /home/wenzexu/backup-script.tar.gz backup.sh --absolute-names
tar -czvf /home/wenzexu/env.tar.gz .env --absolute-names
tar -czvf /home/wenzexu/man.tar.gz man.yaml --absolute-names
tar -czvf /home/wenzexu/app.tar.gz app.yaml --absolute-names
cd /home/wenzexu/man
tar -czvf /home/wenzexu/npm.tar.gz nginx --absolute-names
cd /home/wenzexu/app
tar -czvf /home/wenzexu/memos.tar.gz memos --absolute-names
tar -czvf /home/wenzexu/umami.tar.gz umami --absolute-names
tar -czvf /home/wenzexu/umami-db.tar.gz umami-db --absolute-names
tar -czvf /home/wenzexu/uptime-kuma.tar.gz uptime-kuma --absolute-names
tar -czvf /home/wenzexu/yourls.tar.gz yourls --absolute-names
tar -czvf /home/wenzexu/yourls-db.tar.gz yourls-db --absolute-names
tar -czvf /home/wenzexu/nav.tar.gz nav --absolute-names
tar -czvf /home/wenzexu/easyimage.tar.gz easyimage --absolute-names
tar -czvf /home/wenzexu/flare.tar.gz flare --absolute-names
tar -czvf /home/wenzexu/pingvin-share.tar.gz pingvin-share --absolute-names
tar -czvf /home/wenzexu/moments.tar.gz moments --absolute-names
tar -czvf /home/wenzexu/freshrss.tar.gz freshrss --absolute-names
cd /home/wenzexu
aws s3 cp /home/wenzexu/env.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/man.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/app.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/backup-script.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/npm.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/memos.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/umami.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/umami-db.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/uptime-kuma.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/yourls.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/yourls-db.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/nav.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/easyimage.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/flare.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/pingvin-share.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/moments.tar.gz s3://ricolxwz-backup/${timestamp}/
aws s3 cp /home/wenzexu/freshrss.tar.gz s3://ricolxwz-backup/${timestamp}/
rm /home/wenzexu/*.tar.gz
rm /root/*.tar.gz
```

```
0 0 */5 * * /root/backup.sh
```

## 网络

在使用之前, 请先建立网络`app`: `docker network create app`

## 迁移

简单直接的方法: 备份app文件夹, man文件夹, .env文件. 

1. `/home/wenzexu/gitlab-backup.sh`, 备份alist, 备份halo
2. 下载.env文件: 非常重要! 包含数据库的密码之类的信息, 不然在新机器上无法恢复
3. 压缩app文件夹: 单独备份gitlab文件夹, `tar -czvf gitlab-aux.tar.gz /home/wenzexu/app/gitlab`, 然后`rm -rf /home/wenzexu/app/gitlab`, 最后`tar -czvf app.tar.gz app`, 下载两个文件夹
4. 压缩man文件夹: `tar -czvf man.tar.gz man`
6. 在新机器上, 上传app文件夹, 解压app文件夹: `tar -xzvf app.tar.gz`, 解压man文件夹: `tar -xzvf man.tar.gz`, gitlab-aux暂时不需要, 是以防万一用的
7. 新建`man.yaml`文件
8. `docker compose -f /home/wenzexu/man.yaml up -d`
9. 新建.env文件, 输入密钥
10. 新建`app.yaml`文件
11. `docker compose -f /home/wenzexu/app.yaml up -d`
12. 执行gitlab迁移教程中的6-8步, 或者使用刚才的`gitlab-aux.tar.gz`

## 默认用户名密码

### Nginx Proxy Manager

默认用户名密码:

- Email:    admin@example.com
- Password: changeme

登录之后修改.

### Alist

需要手动设置密码:

```
docker compose exec -it alist ./alist admin set <密码>
```

### 3x-ui

- Username:    admin
- Password: admin

### Umami

- Username: admin
- Password: umami

### Gitlab

Gitlab容器启动大概需要5-6分钟, 请耐心等待. SSH端口在Nginx Proxy Manager里面设置stream, 转发7750端口到gitlab:22

其他, 请参考https://misc.ricolxwz.de/

### Easyimage

到配置目录, 编辑config.php, 里面的domain和imgurl改成自己的域名, 记得加s, 然后重启容器

### Nextcloud

```
sudo cat /var/lib/docker/volumes/nextcloud_aio_mastercontainer/_data/data/configuration.json | grep password
```

### Moments

admin/a123456

### Qbittorrent

- username: admin
- password: `docker logs qbittorrent`

### Stirling pdf

admin/stirling

### artalk

```
docker compose -f app.yaml exec -it artalk artalk admin
```

## 配置

### MinIO

awscli参考:

```
[profile minio]
s3 =
	addressing_style = path
endpoint_url = https://s3.ricolxwz.io
```

```
[minio]
aws_access_key_id = xxx
aws_secret_access_key = xxx
```
