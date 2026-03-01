#!/bin/bash
#
# browser-capability 自动安装脚本
# 自动检测并安装所有依赖
#

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo ""
echo "============================================"
echo "  🦞 browser-capability 安装向导"
echo "============================================"
echo ""

# ============================================
# 1. 检测并安装 Homebrew
# ============================================
log_info "检查 Homebrew..."
if ! command_exists brew; then
    log_warn "Homebrew 未安装，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    log_success "Homebrew 安装完成"
else
    log_success "Homebrew 已安装"
fi

# ============================================
# 2. 检测并安装 Node.js
# ============================================
log_info "检查 Node.js..."
if ! command_exists node; then
    log_warn "Node.js 未安装，正在安装..."
    brew install node
    log_success "Node.js 安装完成"
else
    NODE_VERSION=$(node -v)
    log_success "Node.js 已安装: $NODE_VERSION"
fi

# ============================================
# 3. 检测并安装 Python
# ============================================
log_info "检查 Python..."
if ! command_exists python3; then
    log_warn "Python 未安装，正在安装..."
    brew install python3
    log_success "Python 安装完成"
else
    PYTHON_VERSION=$(python3 --version)
    log_success "Python 已安装: $PYTHON_VERSION"
fi

# ============================================
# 4. 检测并安装 Git
# ============================================
log_info "检查 Git..."
if ! command_exists git; then
    log_warn "Git 未安装，正在安装..."
    brew install git
    log_success "Git 安装完成"
else
    log_success "Git 已安装"
fi

# ============================================
# 5. 检测并安装 Chrome/Chromium
# ============================================
log_info "检查浏览器..."
CHROME_INSTALLED=false
if [ -d "/Applications/Google Chrome.app" ]; then
    CHROME_INSTALLED=true
    log_success "Google Chrome 已安装"
elif command_exists chromium; then
    CHROME_INSTALLED=true
    log_success "Chromium 已安装"
else
    log_warn "Chrome/Chromium 未安装"
    echo ""
    read -p "是否现在安装 Google Chrome? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install --cask google-chrome
        log_success "Google Chrome 安装完成"
        CHROME_INSTALLED=true
    else
        log_warn "跳过浏览器安装，部分功能可能无法使用"
    fi
fi

# ============================================
# 6. 检测并安装 OpenClaw（如果需要）
# ============================================
log_info "检查 OpenClaw..."
if ! command_exists openclaw; then
    log_warn "OpenClaw 未安装"
    echo ""
    read -p "是否现在安装 OpenClaw? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g openclaw
        log_success "OpenClaw 安装完成"
        
        log_info "正在初始化 OpenClaw..."
        openclaw init || true
    else
        log_warn "跳过 OpenClaw 安装"
    fi
else
    log_success "OpenClaw 已安装"
fi

# ============================================
# 7. 安装 Skill 到 OpenClaw
# ============================================
log_info "安装 browser-capability skill..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.openclaw/workspace/skills/browser-capability"

# 如果是克隆的仓库，直接使用
if [ -d "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/SKILL.md" ]; then
    log_info "从当前目录安装..."
    rm -rf "$TARGET_DIR"
    mkdir -p "$(dirname "$TARGET_DIR")"
    cp -r "$SCRIPT_DIR" "$TARGET_DIR"
else
    # 从 GitHub 克隆
    log_info "从 GitHub 克隆..."
    rm -rf "$TARGET_DIR"
    git clone https://github.com/tonyjianchina/browser-capability.git "$TARGET_DIR"
fi

log_success "Skill 安装完成: $TARGET_DIR"

# ============================================
# 8. 配置 API 密钥（可选）
# ============================================
echo ""
log_info "配置 API 密钥（可选）"
echo ""
read -p "是否配置 Brave Search API 密钥? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "请输入 Brave API Key: " BRAVE_API_KEY
    
    # 创建或更新 .env 文件
    ENV_FILE="$HOME/.openclaw/.env"
    if [ -f "$ENV_FILE" ]; then
        if ! grep -q "BRAVE_API_KEY" "$ENV_FILE"; then
            echo "BRAVE_API_KEY=$BRAVE_API_KEY" >> "$ENV_FILE"
            log_success "API Key 已添加到 $ENV_FILE"
        else
            log_warn "BRAVE_API_KEY 已存在，跳过"
        fi
    else
        echo "BRAVE_API_KEY=$BRAVE_API_KEY" > "$ENV_FILE"
        log_success "API Key 已创建: $ENV_FILE"
    fi
fi

# ============================================
# 9. 重启 OpenClaw Gateway
# ============================================
echo ""
log_info "重启 OpenClaw Gateway..."
if command_exists openclaw; then
    openclaw gateway restart || log_warn "Gateway 重启失败，请手动运行: openclaw gateway restart"
    log_success "Gateway 重启完成"
else
    log_warn "OpenClaw 未安装，跳过 Gateway 重启"
fi

# ============================================
# 完成
# ============================================
echo ""
echo "============================================"
echo -e "${GREEN}✅ 安装完成！"
echo "============================================"
echo ""
echo "下一步："
echo "  1. 打开 http://localhost:18789 查看 OpenClaw"
echo "  2. 测试浏览器功能："
echo "     - L0: web_search(query='hello')"
echo "     - L1: browser(action='open', url='https://example.com', headless=True)"
echo "     - L2: browser(action='start', profile='openclaw')"
echo ""
echo "文档: https://github.com/tonyjianchina/browser-capability"
echo ""
