# 🦞 browser-capability

> OpenClaw 浏览器三层搜索+操作能力体系

[![GitHub Stars](https://img.shields.io/github/stars/tonyjianchina/browser-capability?style=flat)](https://github.com/tonyjianchina/browser-capability)
[![License](https://img.shields.io/github/license/tonyjianchina/browser-capability)](https://github.com/tonyjianchina/browser-capability)

## 📋 简介

这是一个 OpenClaw Skill，定义了浏览器搜索和操作的标准化三层能力体系。帮助 AI Agent 智能选择最适合的浏览器操作方式。

```
L0 (80%) ████████████████████  搜索 + 内容抓取
L1 (15%) ████                  无头浏览器 (JS渲染)
L2 (5%)  █                     有头浏览器 + DOM操作
```

## 🚀 快速开始

### 一键安装（推荐）

```bash
# 自动检测并安装所有依赖
curl -sSL https://raw.githubusercontent.com/tonyjianchina/browser-capability/main/setup.sh | bash
```

安装脚本会自动检测并安装：
- Node.js 和 npm
- Python 3.8+
- Chromium 浏览器
- Brave Search API 配置

### 手动安装

如果一键安装失败，请参考下面的手动安装步骤。

## 📦 依赖要求

### 必需软件

| 软件 | 最低版本 | 说明 | 安装命令 |
|------|----------|------|----------|
| **Node.js** | 18.0.0 | 运行 OpenClaw Gateway | `brew install node` |
| **Python** | 3.8 | 运行 Python 工具 | `brew install python3` |
| **Git** | - | 克隆代码 | `brew install git` |

### 浏览器（至少安装一个）

| 浏览器 | 说明 | 安装命令 |
|--------|------|----------|
| **Chrome** | 推荐，用于 L2 有头模式 | `brew install google-chrome` |
| **Chromium** | 开源替代 | `brew install chromium` |

### API 密钥（可选但推荐）

| API | 用途 | 获取方式 | 免费额度 |
|-----|------|----------|----------|
| **Brave Search API** | L0 网络搜索 | [brave.com/api](https://brave.com/api/) | 2000次/月免费 |

## ⚙️ 配置步骤

### 1. 安装 OpenClaw

如果没有安装 OpenClaw，请先安装：

```bash
# 安装 OpenClaw
npm install -g openclaw

# 初始化
openclaw init

# 启动 Gateway
openclaw gateway start
```

### 2. 安装本 Skill

```bash
# 克隆仓库
git clone https://github.com/tonyjianchina/browser-capability.git

# 复制到 OpenClaw skills 目录
cp -r browser-capability ~/.openclaw/workspace/skills/

# 重启 Gateway
openclaw gateway restart
```

### 3. 配置 API 密钥（可选）

Brave Search API 用于 L0 网络搜索：

```bash
# 编辑环境变量文件
nano ~/.openclaw/.env

# 添加以下内容（替换为你的 API Key）
BRAVE_API_KEY=your_brave_api_key_here
```

获取 Brave API Key：
1. 访问 [brave.com/api](https://brave.com/api/)
2. 注册账号
3. 创建 API Key
4. 免费额度：2000次/月

### 4. 配置浏览器

L1/L2 模式需要浏览器支持：

```bash
# 检查浏览器是否可用
browser --version

# 或通过 OpenClaw
browser(action="status")
```

## 📖 使用示例

### L0: 搜索和抓取（最快，80%场景）

适用于简单信息获取，不需要交互的场景。

```python
# 搜索互联网
web_search(query="特斯拉股票走势 2024")

# 抓取静态网页（新闻、博客等）
web_fetch(url="https://example.com")

# 带参数抓取
web_fetch(url="https://news.example.com", maxChars=5000)
```

**特点**：速度快，返回标题+摘要，不支持 JS 渲染

---

### L1: 无头浏览器（JS渲染）

适用于需要 JS 渲染但不需要可视化的场景。

```python
# 打开无头浏览器
browser(
    action="open",
    url="https://www.example.com",
    headless=True  # 关键：无头模式
)

# 获取页面快照（查看页面结构）
browser(action="snapshot")

# 截图
browser(action="screenshot")

# 关闭浏览器
browser(action="stop")
```

**特点**：后台运行，看不到浏览器窗口，支持 JS 渲染

---

### L2: 有头浏览器（完整交互）

适用于需要登录、填表、点击等交互操作。

```python
# 1. 启动浏览器（独立配置，隔离会话）
browser(action="start", profile="openclaw")

# 2. 打开目标页面
browser(action="open", url="https://github.com/login")

# 3. 获取页面结构（查看可交互元素）
browser(action="snapshot")

# 4. 点击登录按钮（ref 从 snapshot 获取）
browser(action="act", request={
    "kind": "click",
    "ref": "login-btn"
})

# 5. 输入用户名
browser(action="act", request={
    "kind": "type",
    "ref": "username-field",
    "text": "your-username"
})

# 6. 输入密码
browser(action="act", request={
    "kind": "type",
    "ref": "password-field",
    "text": "your-password"
})

# 7. 点击提交
browser(action="act", request={
    "kind": "click",
    "ref": "submit-btn"
})

# 8. 截图保存结果
browser(action="screenshot")

# 9. 关闭浏览器
browser(action="stop")
```

**特点**：可视化的浏览器窗口，支持所有交互

---

## 🔧 常用 act 操作

| 操作 | 用途 | 示例 |
|------|------|------|
| `click` | 点击按钮/链接 | `{"kind": "click", "ref": "login-btn"}` |
| `type` | 输入文本 | `{"kind": "type", "ref": "username", "text": "hello"}` |
| `hover` | 鼠标悬停 | `{"kind": "hover", "ref": "menu-item"}` |
| `select` | 下拉选择 | `{"kind": "select", "ref": "country", "value": "CN"}` |
| `fill` | 表单填充 | `{"kind": "fill", "fields": [{"ref": "email", "text": "test@test.com"}]}` |
| `press` | 键盘按键 | `{"kind": "press", "key": "Enter"}` |

## 🔌 Profile 说明

| Profile | 用途 | 场景 |
|---------|------|------|
| `openclaw` | 独立浏览器，隔离会话 | 推荐，避免 cookie 冲突 |
| `chrome` | 接管用户当前 Chrome | 需要登录态延续 |

## 📊 降级链路

当低层级失败时，自动尝试高层级：

```
L0 搜索失败 → L1 无头浏览器尝试
    ↓
L1 失败 → L2 有头浏览器尝试
```

## ❓ 故障排除

### 浏览器无法启动

```bash
# 检查 Chrome 是否安装
ls /Applications/Google\ Chrome.app

# 或安装 Chrome
brew install google-chrome
```

### API 密钥无效

```bash
# 验证 Brave API Key
curl -s "https://api.search.brave.com/reso/v1/web/search?q=test" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: YOUR_API_KEY"
```

### 权限问题

```bash
# macOS 可能需要允许 Chrome 无头运行
open -a "Google Chrome" --args --disable-blink-features=AutomationControlled
```

### 查看日志

```bash
# 查看 OpenClaw 日志
tail -f ~/.openclaw/logs/gateway.log

# 查看浏览器日志
tail -f /tmp/openclaw/browser.log
```

## 📁 项目结构

```
browser-capability/
├── README.md           # 本文件
├── SKILL.md           # OpenClaw Skill 定义
├── setup.sh           # 自动安装脚本
└── docs/
    ├── examples.md    # 更多示例
    └── troubleshooting.md  # 故障排除
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/xxx`)
3. 提交更改 (`git commit -m 'Add xxx'`)
4. 推送分支 (`git push origin feature/xxx`)
5. 打开 Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

**记住**：80% 的场景用 L0 就能解决，只有需要登录/复杂交互时才用 L2。
