# browser-capability

OpenClaw 浏览器三层搜索+操作能力体系

## 功能

| 层级 | 能力 | 占比 |
|------|------|------|
| L0 | 搜索 + 内容抓取 | 80% |
| L1 | 无头浏览器 | 15% |
| L2 | 有头浏览器 + DOM操作 | 5% |

## 安装

### 方式一：命令行（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/openclaw-skills.git
cd openclaw-skills

# 2. 复制 skill 到 OpenClaw
cp -r browser-capability ~/.openclaw/workspace/skills/

# 3. 重启 OpenClaw Gateway
openclaw gateway restart
```

### 方式二：手动安装

```bash
# 直接复制到 skills 目录
cp -r browser-capability ~/.openclaw/workspace/skills/
openclaw gateway restart
```

## 使用

安装后，OpenClaw 会自动在需要浏览器操作时使用这个 skill。

### 示例

```python
# L0: 搜索
web_search(query="特斯拉股票走势")

# L0: 抓取静态页面
web_fetch(url="https://example.com")

# L1: 无头浏览器
browser(action="open", url="https://...", headless=True)

# L2: 有头浏览器
browser(action="start", profile="openclaw")
browser(action="open", url="https://...")
browser(action="act", request={"kind": "click", "ref": "login-btn"})
```

## 依赖

- OpenClaw Gateway 运行中
- Chrome 或 Chromium 浏览器已安装

## License

MIT
