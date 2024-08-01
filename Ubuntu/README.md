
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

# 修改btrfs自动创建配置(用于uniquity安装软件自动创建btrfs子卷, 其中包含若干参数)
vim /usr/lib/partman/mount.d/70btrfs
  # 1. 找到/中的options, 修改如下: options="${options:+$options,}subvol=@,noatime,space_cache,compress=zstd,discard=async"
  # 2. 找到/home中的options, 修改如下: options="${options:+$options,}subvol=@home,noatime,space_cache,compress=zstd,discard=async"
vim /usr/lib/partman/fstab.d/btrfs
  # 1. 找到/中的pass, 修改如下: pass=0
  # 2. 找到/中的home_options, 修改如下: home_options="{options:+$options,}subvol=@home,noatime,space_cache,compress=zstd,discard=async"
  # 3. 找到/中的options, 修改如下: options="{options:+$options,}subvol=@,noatime,space_cache,compress=zstd,discard=async"
  # 4. 找到/home中的pass, 修改如下: pass=0 (一共有2处pass都要改)
  # 5. 找到/home中的options, 修改如下: options="{options:+$options,}subvol=@home,noatime,space_cache,compress=zstd,discard=async"
  # 6. 找到echo "$home_path" "$home_mp" btrfs "$home_options" 0 2, 修改如下: echo "$home_path" "$home_mp" btrfs "$home_options" 0 0

# 启动ubiquity安装程序
  # 1. 创建磁盘的时候选择something else
  # 2. 选择创建好的/dev/vda2分区, 下拉列表选择btrfs日志文件系统, 格式化此分区, 挂载点为/
  # 3. 选择创建好的/dev/vda1分区, 下拉列表选择用于EFI系统分区
  

# 执行自动化脚本
cd ~
wget -O setup.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/setup.sh"
chmod a+x setup.sh
./setup.sh
```
