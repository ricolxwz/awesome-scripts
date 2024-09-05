# 服务

## 迁移

0. 备份Gitlab, 手动备份 `gitlab.rb` 和 `gitlab-secrets.json` 文件, 详情见gitlab
1. 下载.env文件: 非常重要! 包含数据库的密码之类的信息, 不然在新机器上无法恢复
2. 压缩app文件夹: 删掉gitlab和gitlab-runner文件夹, `tar -czvf app.tar.gz app`, 下载文件夹
3. 在新机器上, 上传app文件夹, 解压app文件夹: ``tar -xzvf app.tar.gz`
4. 新建`docker-compose.yaml`文件
5. 新建`.env`文件
6. 恢复gitlab文件夹, 详情见gitlab

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
6. 配置完成会生成配置文件, 在`./app/gitlab-runner/config/config.toml`中, 以后可以自行修改
7. 可以通过`docker compose exec -it gitlab-runner gitlab-runner unregister`取消注册

### 备份

0. (可选)配置对象存储服务, 自动上传: 
1. 备份文件中不包含 `gitlab.rb` 和 `gitlab-secrets.json` 这两个文件，这两个文件包含了敏感数据，例如配置信息和加密密钥，因此在恢复备份时需要手动备份这两个文件。
为了确保完整的备份和恢复过程，请务必手动备份 `gitlab.rb` 和 `gitlab-secrets.json` 文件。
2. 备份:
  ```
  docker compose exec -t gitlab gitlab-backup create
  docker compose cp gitlab:/var/opt/gitlab/backups/*backup.tar  ./gitlab-bak/
  docker compose cp gitlab:/etc/gitlab/gitlab.rb  ./gitlab-bak/
  docker compose cp gitlab:/etc/gitlab/gitlab-secrets.json  ./gitlab-bak/
  ```
3. 恢复:
  ```
  docker compose cp ./gitlab-bak/*backup.tar  gitlab:/var/opt/gitlab/backups/
  docker compose cp ./gitlab-bak/gitlab-secrets.json   gitlab:/etc/gitlab/
  docker compose cp ./gitlab-bak/gitlab.rb   gitlab:/etc/gitlab/
  docker exec -it gitlab bash
  gitlab-rake gitlab:backup:restore BACKUP=<_gitlab_backup.tar文件的前缀>
  gitlab-ctl reconfigure 
  gitlab-ctl restart 
  ```  


## Easyimage

到配置目录, 编辑config.php, 里面的domain和imgurl改成自己的域名, 记得加s, 然后重启容器
