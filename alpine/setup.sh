# basic packages
apk update && apk add --no-cache \
    bash \
    fish \
    supervisor \
    coreutils \
    util-linux \
    build-base \
    git \
    docker \
    python3 \
    curl \
    wget \
    net-tools \
    bind-tools \
    neovim \
    openssh \
    zip \
    unzip \
    tzdata \
    tmux

# docker compose
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.39.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# sshd
# PermitRootLogin yes
# AllowTCPForwarding yes

# .ssh/authorized_keys

# /etc/passwd chsh to /bin/bash

# git config
git config --global user.name wenzexu
git config --global user.email ricol.xwz@outlook.com

# edit .bashrc, ll, vi, PATH, super

# rc
rc-update add sshd default
rc-update add docker default
rc-update add supervisord default
rc-service sshd start
rc-service docker start
rc-service supervisord start

# supervisor
mkdir -p /etc/supervisord.d
# edit /etc/supervisord.conf, include /etc/supervisord.d/*.conf instead of *.ini
