## 安装
### x86-64安装

```
# 执行自动化脚本
cd ~
wget -O setup.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/setup.sh"
chmod a+x setup.sh
./setup.sh
```

## 问题

### 无法使用剪切板

Debian下, 必须安装所有open-vm-tools-*包: `sudo apt install open-vm-tools-*`
