# 故障排除指南

## 常见问题

### 1. 浏览器无法启动

**症状**：`browser(action="start")` 报错或无响应

**解决方案**：

```bash
# 检查 Chrome 是否安装
ls /Applications/Google\ Chrome.app

# 或检查 Chromium
which chromium

# macOS 需要允许运行
sudo spctl --master-disable
```

### 2. Brave Search API 返回错误

**症状**：`web_search` 返回空结果或报错

**解决方案**：

```bash
# 验证 API Key
curl -s "https://api.search.brave.com/reso/v1/web/search?q=test" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: YOUR_API_KEY"

# 检查 .env 文件配置
cat ~/.openclaw/.env | grep BRAVE
```

### 3. 页面截图是空白的

**症状**：`browser(action="screenshot")` 返回空白图片

**解决方案**：

```bash
# 使用有头模式
browser(action="start", profile="openclaw")
browser(action="open", url="https://example.com")
browser(action="screenshot")
```

### 4. 无法点击元素

**症状**：`browser(action="act")` 报错找不到元素

**解决方案**：

```python
# 1. 先获取页面快照查看可用元素
browser(action="snapshot")

# 2. 使用正确的 ref（从 snapshot 结果中获取）
# ref 应该是元素的 role:name 或 aria-label
browser(action="act", request={
    "kind": "click",
    "ref": "button:login"  # 从 snapshot 获取
})
```

### 5. 登录态无法保持

**症状**：每次都需要重新登录

**解决方案**：

```python
# 使用 chrome profile 而非 openclaw
browser(action="start", profile="chrome")

# 登录一次后，之后的操作都会保持登录态
```

### 6. 内存占用过高

**症状**：浏览器占用大量内存

**解决方案**：

```python
# 1. 使用完后及时关闭
browser(action="stop")

# 2. 使用无头模式（内存占用更少）
browser(action="open", url="https://example.com", headless=True)

# 3. 限制并发标签页数量
```

### 7. 页面加载超时

**症状**：`browser(action="open")` 超时

**解决方案**：

```python
# 增加超时时间
browser(action="open", url="https://slow-site.com", timeoutMs=60000)

# 或分步加载
browser(action="open", url="https://example.com")
# 等待加载完成
browser(action="act", request={"kind": "wait", "timeMs": 5000})
```

### 8. L0/L1/L2 降级不生效

**症状**：低层级失败时没有自动尝试高层级

**解决方案**：手动指定层级：

```python
# 强制使用 L2
browser(action="start", profile="openclaw")
browser(action="open", url="https://example.com", headless=False)
```

## 性能优化

### 减少内存占用

1. **及时关闭浏览器**：
   ```python
   browser(action="stop")  # 用完后关闭
   ```

2. **使用无头模式**：
   ```python
   browser(action="open", url="...", headless=True)
   ```

3. **限制截图频率**：
   ```python
   # 不要在循环中频繁截图
   # 只在必要时截图
   ```

### 加速页面加载

1. **禁用图片加载**（可选）：
   ```python
   # 目前不支持，建议通过其他方式优化
   ```

2. **使用缓存**：
   ```python
   # 同一个页面多次操作时，避免重复打开
   # 保持浏览器实例
   ```

## 日志查看

### OpenClaw 日志

```bash
# 实时查看日志
tail -f ~/.openclaw/logs/gateway.log

# 查看错误日志
grep -i error ~/.openclaw/logs/gateway.log
```

### 浏览器日志

```bash
# macOS Console.app 查看浏览器进程日志
# 或通过 OpenClaw 查看
```

## 获取帮助

如果以上方法无法解决问题：

1. 查看 [GitHub Issues](https://github.com/tonyjianchina/browser-capability/issues)
2. 提交新 Issue，包含：
   - 错误信息
   - 复现步骤
   - 环境信息（OS、浏览器版本等）
