echo "--- 1. 开始终极清理（包括.sources文件）... ---"
# 再次备份主配置文件，以防万一
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak_final 2>/dev/null || echo "主配置文件已备份。"

# 确保备份目录存在
sudo mkdir -p /etc/apt/sources.list.d.bak

# 将附加配置目录中的【所有文件】（无论后缀名是什么）全部移动到备份目录
sudo mv /etc/apt/sources.list.d/* /etc/apt/sources.list.d.bak/ 2>/dev/null || echo "附加配置目录已清空。"

echo "--- 2. 清理完成！正在创建符合新格式的阿里云镜像配置... ---"
# 我们将创建一个新的 .sources 文件，这是现代Ubuntu的推荐做法
sudo tee /etc/apt/sources.list.d/aliyun-mirror.sources > /dev/null <<'EOF'
Types: deb
URIs: https://mirrors.aliyun.com/ubuntu/
Suites: noble noble-updates noble-backports noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

echo "--- 3. 终极验证！检查目录是否已彻底清空并只包含新文件... ---"
# 这个命令的输出中，应该只看到我们刚刚创建的 aliyun-mirror.sources 文件
ls -l /etc/apt/sources.list.d/

echo "--- 4. 完美！现在，执行决定性的最终更新... ---"
sudo apt-get update
