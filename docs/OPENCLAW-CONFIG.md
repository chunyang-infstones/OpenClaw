# OpenClaw 配置架构说明

## 配置文件位置

```
~/.openclaw/
├── openclaw.json              # 主配置文件（全局）
└── agents/
    ├── main/
    │   └── agent/
    │       ├── models.json      # main 专属模型 provider 配置
    │       └── auth-profiles.json  # main 的 API Key 管理
    └── emma/
        └── agent/
            ├── models.json      # emma 专属模型 provider 配置
            └── auth-profiles.json  # emma 的 API Key 管理
```

---

## 配置文件详解

### 1. `openclaw.json` - 主配置

#### 1.1 `models.providers` - 全局 Model Provider 定义

定义可用的 AI API provider 和它们的配置：

```json
{
  "models": {
    "providers": {
      "zai": {
        "baseUrl": "https://open.bigmodel.cn/api/coding/paas/v4",
        "apiKey": "f765cb47beb64018bcf9001930155ffe.Kz7D8Tn4YAOSd3jR",
        "api": "openai-completions",  // API 兼容模式
        "models": [
          {
            "id": "glm-4.7",
            "name": "GLM-4.7",
            "contextWindow": 128000,
            "maxTokens": 16000
          }
        ]
      },
      "zai-emma": {
        "baseUrl": "https://open.bigmodel.cn/api/coding/paas/v4",
        "apiKey": "7f4325f9b4ab476f88d9cb66f976314c.LnIMm7RSu5dE1opk",
        "api": "openai-completions",
        "models": [...]
      }
    }
  }
}
```

**说明：**
- `providers` 下每个 key 是 **provider ID**（如 `zai`, `zai-emma`）
- `apiKey`: 该 provider 的 API Key
- `api`: API 兼容模式（`openai-completions` 表示兼容 OpenAI 格式）
- `models`: 该 provider 支持的模型列表

#### 1.2 `agents.defaults` - 默认 Model 配置

所有 Agent 的默认设置：

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "zai/glm-4.7",
        "fallbacks": ["anthropic/claude-sonnet-4-5"]
      },
      "models": {
        "anthropic/claude-opus-4-5": {"alias": "opus"},
        "zai/glm-4.7": {"alias": "GLM"},
        "anthropic/claude-sonnet-4-5": {"alias": "sonnet"}
      }
    }
  }
}
```

**说明：**
- `primary`: 默认使用的模型（格式：`<provider-id>/<model-id>`）
- `fallbacks`: 主要模型不可用时，依次尝试的备选模型
- `models.alias`: 模型别名（如在对话中用 "opus" 代表 "anthropic/claude-opus-4-5"）

#### 1.3 `agents.list` - Agent 列表

每个 Agent 的配置：

```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "workspace": "/Users/ludi/clawd",
        "model": {
          "primary": "zai/glm-4.7",
          "fallbacks": ["anthropic/claude-sonnet-4-5"]
        }
      },
      {
        "id": "emma",
        "name": "Emma AI",
        "workspace": "/Users/ludi/clawd-emma",
        "model": {
          "primary": "zai-emma/glm-4.7"
        }
      }
    ]
  }
}
```

**说明：**
- `model.primary`: 该 Agent 专属的主要模型
- 如果不设置，使用 `agents.defaults.model.primary`

---

### 2. `agents/<agent-id>/agent/models.json` - Agent 专属 Provider

可选。可以覆盖或扩展 `openclaw.json` 中的 provider 配置。

**用途：**
- 给不同 Agent 使用不同的 provider
- 给不同 Agent 使用同一 provider 的不同 API Key

**示例：**
```json
{
  "providers": {
    "zai-emma": {
      "baseUrl": "https://open.bigmodel.cn/api/coding/paas/v4",
      "apiKey": "7f4325f9b4ab476f88d9cb66f976314c.LnIMm7RSu5dE1opk",
      "api": "openai-completions",
      "models": [...]
    }
  }
}
```

---

### 3. `agents/<agent-id>/agent/auth-profiles.json` - API Key 管理

管理 API Key 和使用统计：

```json
{
  "version": 1,
  "profiles": {
    "anthropic:default": {
      "type": "api_key",
      "provider": "anthropic",
      "key": "sk-ant-api03-..."
    },
    "zai:default": {
      "type": "api_key",
      "provider": "zai",
      "key": "7f4325f9b4ab476f88d9cb66f976314c.LnIMm7RSu5dE1opk"
    }
  },
  "lastGood": {
    "anthropic": "anthropic:default",
    "zai": "zai:default"
  },
  "usageStats": {
    "anthropic:default": {
      "lastUsed": 1770877940071,
      "errorCount": 1,
      "lastFailureAt": 1770878280550,
      "disabledUntil": 1770896280550,
      "disabledReason": "billing"
    }
  }
}
```

**说明：**
- `profiles`: 定义 API Key（每个 key 是一个 profile）
- `lastGood`: 每个 provider 当前使用的 profile
- `usageStats`: 使用统计（错误计数、禁用时间、冷却时间）

---

## 模型标识规则

**格式：** `<provider-id>/<model-id>`

**示例：**
- `zai/glm-4.7` → 使用 `zai` provider 的 `glm-4.7` 模型
- `zai-emma/glm-4.7` → 使用 `zai-emma` provider 的 `glm-4.7` 模型
- `anthropic/claude-opus-4-5` → 使用 `anthropic` provider 的 `claude-opus-4-5` 模型

---

## 配置层级与覆盖

1. **全局设置** (`openclaw.json`) → 所有 Agent 共享
2. **Agent 专属设置** (`agents/<agent-id>/agent/models.json`) → 优先级更高

**示例：**
- `openclaw.json` 中定义了 `zai` provider
- `agents/main/agent/models.json` 可以定义 `zai` 并覆盖 apiKey

---

## API Key 存储位置

**两种方式：**

1. **在 `openclaw.json` 的 `models.providers` 中**
   ```json
   "zai": {
     "apiKey": "xxx"
   }
   ```

2. **在 `auth-profiles.json` 的 `profiles` 中**
   ```json
   "profiles": {
     "zai:default": {
       "provider": "zai",
       "key": "xxx"
     }
   }
   ```

**OpenClaw 会同时查找这两个位置，`auth-profiles.json` 优先。**

---

## 多 Agent API Key 隔离

**方案：** 给每个 Agent 使用不同的 provider ID

**示例：**
- `zai` → main 专属
- `zai-emma` → emma 专属

然后在 `agents.list` 中指定：
```json
{
  "id": "main",
  "model": {"primary": "zai/glm-4.7"}
},
{
  "id": "emma",
  "model": {"primary": "zai-emma/glm-4.7"}
}
```

---

## 完整流程示例

**用户发送消息给 Agent → OpenClaw 如何选择模型？**

1. 读取 `openclaw.json` 中的 `agents.list`，找到 Agent 的配置
2. 读取 `model.primary`（如 `zai/glm-4.7`）
3. 解析 provider ID: `zai`
4. 在 `openclaw.json` 的 `models.providers` 中查找 `zai`
5. 如果 `agents/<agent-id>/agent/models.json` 存在，优先查找
6. 获取 `zai` 的 `apiKey`、`baseUrl` 等配置
7. 调用 API

---

## 快速修改配置

**方式 1：手动编辑**
```bash
vim ~/.openclaw/openclaw.json
# 或
vim ~/.openclaw/agents/main/agent/models.json
```

**方式 2：使用管理脚本**（见下节）
```bash
./scripts/agent-model-manager.sh
```

---

## 注意事项

1. **修改后需要重启 OpenClaw Gateway**
   ```bash
   openclaw gateway restart
   ```

2. **API Key 不要直接提交到 Git**
   - `openclaw.json` 和 `auth-profiles.json` 通常在 `~/.openclaw/`，不在 workspace 内
   - 如果在 workspace 内，添加到 `.gitignore`

3. **Provider ID 必须唯一**
   - 不同 Agent 的 provider 使用不同 ID（如 `zai`, `zai-emma`）
