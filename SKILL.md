---
name: browser-capability
description: |
  浏览器三层搜索+操作能力体系。用于：(1) 获取网页信息 (2) 自动化浏览器操作 (3) 截图/视觉识别。
  触发场景：用户需要搜索、抓取、登录、填表、截图等浏览器操作时。
---

# 浏览器三层能力体系

## 整体架构

```
L0 (80%)  ████████████████████  搜索 + 内容抓取
L1 (15%)  ████                   无头浏览器 (JS渲染)
L2 (5%)   █                       有头浏览器 + DOM操作
```

## L0: 搜索 + 内容抓取 (最快)

**适用场景**：简单信息获取，不需要交互

| 工具 | 用法 | 局限 |
|------|------|------|
| `web_search` | 搜索互联网 | 返回标题+摘要 |
| `web_fetch` | 抓取网页内容 | 抓不到JS渲染 |

```python
# 搜索
web_search(query="特斯拉股票走势")

# 抓取静态页面
web_fetch(url="https://example.com")
```

## L1: 无头浏览器 (静默运行)

**适用场景**：JS 渲染的页面，不需要可视化交互

```python
browser(
    action="open",
    url="https://example.com",
    headless=True  # 关键：无头
)
browser(action="snapshot")  # 获取页面结构
browser(action="screenshot")  # 截图
```

## L2: 有头浏览器 (完整交互)

**适用场景**：需要登录、填表、点击验证码等

```python
# 1. 启动浏览器
browser(action="start", profile="openclaw")

# 2. 打开页面
browser(action="open", url="https://example.com")

# 3. 获取页面结构
browser(action="snapshot")

# 4. 交互操作
browser(action="act", request={
    "kind": "click",
    "ref": "login-btn"  # 从 snapshot 获取的 ref
})

browser(action="act", request={
    "kind": "type",
    "ref": "username",
    "text": "账号"
})

# 5. 截图
browser(action="screenshot")
```

### 常用 act 操作

| kind | 用途 |
|------|------|
| `click` | 点击按钮/链接 |
| `type` | 输入文本 |
| `hover` | 悬停 |
| `select` | 下拉选择 |
| `fill` | 表单填充 |

## 降级链路

```
L0 失败 → L1 无头浏览器
    ↓
L1 失败 → L2 有头浏览器
```

## 状态检查

```python
browser(action="status")  # 查看浏览器状态
browser(action="tabs")    # 查看所有标签页
browser(action="stop")   # 停止浏览器
```

## Profile 说明

| profile | 用途 |
|---------|------|
| `openclaw` | 独立浏览器，隔离会话 |
| `chrome` | 接管用户当前 Chrome |

---

**记住**：80% 场景用 L0 就能解决，只有需要登录/交互时才用 L2。
