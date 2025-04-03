#!/bin/bash

# 定义颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 显示警告横幅
echo -e "${RED}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
echo -e "${RED}▓ WARNING: 此脚本专用于Termux环境 ▓${NC}"
echo -e "${RED}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
echo ""
echo -e "${YELLOW}继续执行将执行以下操作：${NC}"
echo "1. 备份当前 ~/.bashrc 文件"
echo "2. 从远程服务器下载新的 .bashrc 文件"
echo "3. 替换您的现有配置"
echo ""
echo -e "${RED}请确保您：${NC}"
echo "• 已了解脚本功能"
echo "• 正在Termux环境中运行"
echo ""

# 通过/dev/tty获取用户输入
read -p "是否继续？(y/N): " choice </dev/tty

if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    echo -e "${YELLOW}操作已取消${NC}"
    exit 1
fi

# 备份函数
backup_bashrc() {
    local backup_file="$HOME/.bashrc.bak"
    
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$backup_file"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ 备份成功: ${backup_file}${NC}"
        else
            echo -e "${RED}✗ 备份失败，请检查权限${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⚠ 未找到原有.bashrc文件${NC}"
    fi
}

# 下载函数
download_new_bashrc() {
    echo -e "${GREEN}▶ 开始下载新的.bashrc文件...${NC}"
    curl -sL -o ~/.bashrc https://raw.githubusercontent.com/mmxdxmm/termux_bashrc/bashrc
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 下载并替换成功${NC}"
        
        # 检查文件是否非空
        if [ -s "$HOME/.bashrc" ]; then
            echo -e "${GREEN}✓ 文件验证通过${NC}"
        else
            echo -e "${RED}✗ 下载的文件为空，请检查远程资源${NC}"
            exit 1
        fi
    else
        echo -e "${RED}✗ 下载失败，请检查网络连接${NC}"
        exit 1
    fi
}

# 执行备份和下载
backup_bashrc
download_new_bashrc

# 完成提示
echo ""
echo -e "${GREEN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
echo -e "${GREEN}▓ 操作成功完成! ▓${NC}"
echo -e "${GREEN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
echo ""
echo -e "请执行以下操作之一使更改生效："
echo -e "1. ${YELLOW}重启Termux${NC}"
echo -e "2. 运行命令: ${YELLOW}source ~/.bashrc${NC}"
echo ""
echo -e "如需恢复备份，请执行:"
echo -e "${YELLOW}cp ~/.bashrc.bak ~/.bashrc${NC}"
echo ""
echo -e "${RED}注意：此脚本仅适用于Termux环境${NC}"
exit 0
