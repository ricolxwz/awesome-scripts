
```
# 分区
lsblk
parted /dev/vda
mktable gpt
mkpart EFI 0% 800MB
mkpart PRI 800MB 100%
print
quit
fdisk -l
  
# 执行自动化脚本
cd ~
wget -O setup.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/setup.sh"
chmod a+x setup.sh
./setup.sh
```
