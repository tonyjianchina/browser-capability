# 使用示例

本文件提供更多详细的使用示例。

## 基础示例

### L0: 搜索天气

```python
# 搜索天气信息
web_search(query="上海天气")
```

返回：天气网站的标题和摘要

---

### L0: 获取新闻

```python
# 获取最新科技新闻
web_fetch(url="https://news.ycombinator.com/")
```

返回：网页的文本内容

---

## 中级示例

### L1: 抓取动态内容

需要 JavaScript 渲染的页面：

```python
# 抓取 SPA 应用（React/Vue/Angular）
browser(
    action="open",
    url="https://example-spa-app.com",
    headless=True
)

# 等待页面加载
browser(action="act", request={
    "kind": "wait",
    "timeMs": 3000
})

# 获取内容
browser(action="snapshot")

# 截图
browser(action="screenshot")

# 关闭
browser(action="stop")
```

---

### L1: 批量抓取多个页面

```python
# 定义要抓取的页面列表
urls = [
    "https://example.com/page1",
    "https://example.com/page2",
    "https://example.com/page3"
]

results = []
for url in urls:
    browser(action="open", url=url, headless=True)
    browser(action="snapshot")
    # 处理结果...
    results.append(result)

browser(action="stop")
```

---

## 高级示例

### L2: 自动登录 GitHub

```python
# 1. 启动有头浏览器
browser(action="start", profile="openclaw")

# 2. 打开登录页
browser(action="open", url="https://github.com/login")

# 3. 获取页面结构
browser(action="snapshot")

# 4. 输入用户名
browser(action="act", request={
    "kind": "type",
    "ref": "login_field",  # 从 snapshot 获取
    "text": "your-username"
})

# 5. 输入密码
browser(action="act", request={
    "kind": "type",
    "ref": "password_field",
    "text": "your-password"
})

# 6. 点击登录按钮
browser(action="act", request={
    "kind": "click",
    "ref": "submit"
})

# 7. 验证登录成功
browser(action="snapshot")

# 8. 关闭浏览器
browser(action="stop")
```

---

### L2: 填写并提交表单

```python
# 启动浏览器
browser(action="start", profile="openclaw")

# 打开表单页面
browser(action="open", url="https://example.com/form")

# 使用 fill 批量填充
browser(action="act", request={
    "kind": "fill",
    "fields": [
        {"ref": "name", "text": "张三"},
        {"ref": "email", "text": "test@example.com"},
        {"ref": "phone", "text": "13800138000"},
        {"ref": "message", "text": "这是一条测试消息"}
    ]
})

# 点击提交
browser(action="act", request={
    "kind": "click",
    "ref": "submit-btn"
})

# 截图保存结果
browser(action="screenshot")

browser(action="stop")
```

---

### L2: 处理下拉选择

```python
browser(action="start", profile="openclaw")
browser(action="open", url="https://example.com/select")

# 选择下拉选项
browser(action="act", request={
    "kind": "select",
    "ref": "country-select",
    "value": "CN"  # 选项值
})

# 或使用点击展开后再选择
browser(action="act", request={"kind": "click", "ref": "country-select"})
browser(action="act", request={"kind": "click", "ref": "option-CN"})

browser(action="stop")
```

---

### L2: 处理弹窗

```python
browser(action="start", profile="openclaw")
browser(action="open", url="https://example.com")

# 等待弹窗出现
browser(action="act", request={"kind": "wait", "timeMs": 2000})

# 关闭弹窗（多种方式）
# 方式1: 点击关闭按钮
browser(action="act", request={"kind": "click", "ref": "close-btn"})

# 方式2: 按 ESC 键
browser(action="act", request={"kind": "press", "key": "Escape"})

# 方式3: 点击弹窗外部关闭
browser(action="act", request={"kind": "click", "ref": "modal-backdrop"})

browser(action="stop")
```

---

### L2: 滚动页面

```python
browser(action="start", profile="openclaw")
browser(action="open", url="https://example.com/long-page")

# 滚动到页面底部
browser(action="act", request={
    "kind": "evaluate",
    "script": "window.scrollTo(0, document.body.scrollHeight)"
})

# 滚动到指定元素
browser(action="act", request={
    "kind": "evaluate",
    "script": "document.querySelector('#target').scrollIntoView()"
})

browser(action="stop")
```

---

## 错误处理

### 基本错误处理

```python
try:
    # 尝试 L0
    result = web_fetch(url="https://example.com")
except Exception as e:
    # 降级到 L1
    try:
        browser(action="open", url="https://example.com", headless=True)
        result = browser(action="snapshot")
    except:
        # 降级到 L2
        browser(action="start", profile="openclaw")
        browser(action="open", url="https://example.com")
        result = browser(action="snapshot")
finally:
    browser(action="stop")
```

---

### 重试机制

```python
def retry_browser_action(action, max_retries=3):
    for i in range(max_retries):
        try:
            return browser(action=action)
        except Exception as e:
            if i == max_retries - 1:
                raise e
            time.sleep(1)  # 等待后重试
```

---

## 最佳实践

### 1. 及时关闭浏览器

```python
# ✅ 正确：使用完关闭
browser(action="start")
# ... 操作 ...
browser(action="stop")

# ❌ 错误：不关闭会占用资源
browser(action="start")
# ... 操作 ...
# 忘记关闭
```

### 2. 使用合适的层级

```python
# ✅ 简单搜索用 L0
web_search(query="天气")

# ✅ 需要 JS 渲染用 L1
browser(action="open", url="spa-app.com", headless=True)

# ✅ 需要登录/交互用 L2
browser(action="start", profile="openclaw")
```

### 3. 添加适当的等待

```python
# ✅ 等待页面加载
browser(action="open", url="example.com")
browser(action="act", request={"kind": "wait", "timeMs": 2000})

# ❌ 立即获取可能获取不到
browser(action="open", url="example.com")
browser(action="snapshot")  # 可能页面还没加载完
```

### 4. 异常处理

```python
try:
    browser(action="open", url="https://example.com")
    browser(action="snapshot")
except Exception as e:
    print(f"操作失败: {e}")
finally:
    browser(action="stop")  # 确保关闭
```
