---
icon: material/lan
---

## 启用IPv6服务

=== "deb"

    ``` sh
    echo "net.ipv6.conf.default.disable_ipv6 = 0
    net.ipv6.conf.all.disable_ipv6 = 0
    net.ipv6.conf.lo.disable_ipv6 = 0" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    ```

=== "rpm"

    ``` sh
    echo "net.ipv6.conf.default.disable_ipv6 = 0
    net.ipv6.conf.all.disable_ipv6 = 0
    net.ipv6.conf.lo.disable_ipv6 = 0" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    ```