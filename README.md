# browser-capability

> OpenClaw 浏览器三层搜索+操作能力体系

## 📋 简介

这是一个 OpenClaw Skill，定义了浏览器搜索和操作的标准化三层能力体系。

## 🎯 功能

| 层级 | 能力 | 占比 | 工具 |
|------|------|------|------|
| **L0** | 搜索 + 内容抓取 | 80% | `web_search`, `web_fetch` |
| **L1** | 无头浏览器 (JS渲染) | 15% | `browser` (headless) |
| **L2** | 有头浏览器 + DOM操作 | 5% | `browser` (headed) |

## 🚀 安装

### 方式一：命令行

```bash
# 克隆仓库
git clone https://github.com/tonyjianchina/browser-capability.git

# 复制到 OpenClaw skills 目录
cp -r browser-capability ~/.openclaw/workspace/skills/

# 重启 Gateway
openclaw gateway restart
```

### 方式二：手动复制

```bash
# 直接复制
cp -r browser-capability ~/.openclaw/workspace/skills/
openclaw gateway restart
```

## 📖 使用示例

### L0: 搜索和抓取

```python
# 搜索互联网
web_search(query="特斯拉股票走势")

# 抓取静态网页
web_fetch(url="https://example.com")
```

### L1: 无头浏览器

```python
# 打开无头浏览器
browser(
    action="open",
    url="https://example.com",
    headless=True
)

# 获取页面快照
browser(action="snapshot")
```

### L2: 有头浏览器（登录、填表等）

```python
# 启动浏览器
browser(action="start", profile="openclaw")

# 打开页面
browser(action="open", url="https://example.com")

# 点击按钮
browser(action="act", request={
    "kind": "click",
    "ref": "login-btn"  # 从 snapshot 获取
})

# 输入文本
browser(action="act", request={
    "kind": "type",
    "ref": "username",
    "text": "your-username"
})

# 截图
browser(action="screenshot")
```

## 🔧 常用 act 操作

| 操作 | 用途 |
|------|------|
| `click` | 点击按钮/链接 |
| `type` | 输入文本 |
| `hover` | 悬停 |
| `select` | 下拉选择 |
| `fill` | 表单填充 |

## 📊 降级链路

```
L0 失败 → L1 无头浏览器
    ↓
L1 失败 → L2 有头浏览器
```

## 🔌 Profile 说明

| Profile | 用途 |
|---------|------|
| `openclaw` | 独立浏览器，隔离会话 |
| `chrome` | 接管用户当前 Chrome |

## 📦 依赖

- OpenClaw Gateway 运行中
- Chrome 或 Chromium 浏览器已安装

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 License

MIT
