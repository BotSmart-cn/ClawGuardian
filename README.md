# ClawGuardian

**中文** | [English](#english)

---

## 中文

### 项目简介

ClawGuardian 是由 **博特智能（Botsmart）** 开发的大模型内容安全插件，专为 [OpenClaw](https://openclaw.ai) LLM 网关设计。当前版本在用户请求到达大模型之前实施实时内容审核，将有害请求拦截在源头，同时保护发往安全分类服务的数据不含敏感信息。

ClawGuardian 不改变 OpenClaw 的核心流程，以插件方式无侵入地接入，开箱即用，支持灵活配置。

---

### 核心能力

#### 1. 入站内容审核

在大模型响应之前，对用户输入及近期对话历史进行安全评估。检测到风险内容时，立即终止本次请求并向用户返回拦截提示，支持展示风险分类标签。

#### 2. 工具调用链拦截

当某次请求被判定为不安全后，后续该会话中所有工具调用（如代码执行、联网搜索等）将同步被阻断，防止通过工具侧信道绕过拦截。

#### 3. 历史对话清洗

自动识别并移除对话历史中曾被拦截的消息记录，防止历史污染导致后续正常请求被误判拦截。进程重启后依然有效，无需额外持久化状态。

#### 4. PII 脱敏

在将对话内容发送给外部安全分类服务之前，自动识别并遮蔽敏感信息，包括：

- 邮箱地址、信用卡号、IP 地址
- API Key、Token 等高熵字符串
- 支持通过配置自定义规则

#### 5. 多用户频道封禁

针对 DingTalk、飞书、企业微信、Telegram、Slack 等群聊场景，支持跨 Session 的 **TTL 自动解封** 封禁机制，被封禁用户无法通过重置会话来绕过拦截。

---

### 快速上手

#### 前置条件

- Node.js >= 18
- OpenClaw gateway 已安装并运行
- 可访问的安全内容分类服务端点

#### 安装

**方式一：通过npm安装（推荐）**

```bash
npm install @botsmart-cn/clawguardian
```

然后在 OpenClaw 配置中引用该插件。

**方式二：从项目源码安装**

```bash
# 从项目根目录执行
./scripts/install.sh
```

安装脚本将自动完成：依赖安装 → TypeScript 编译 → 注册并启用插件。

安装后，重启 OpenClaw gateway：

```bash
openclaw gateway restart
```

#### 验证

```bash
./scripts/verify.sh
```

脚本将发送安全/不安全示例请求，验证端到端拦截是否正常工作，并将结果写入 `scripts/verify-report.json`。

#### 卸载

```bash
./scripts/uninstall.sh
```

卸载脚本将禁用并删除插件、清理配置项。

---

<a name="english"></a>

## English

### Overview

**ClawGuardian** is a content safety plugin for the [OpenClaw](https://openclaw.ai) LLM gateway, developed by **Botsmart**. In its current version, it intercepts user requests before they reach the language model — classifying content in real time and blocking harmful inputs at the gateway layer, while ensuring that data sent to the external guard service is first stripped of sensitive information.

ClawGuardian integrates non-invasively as an OpenClaw plugin with zero changes to the core gateway flow.

---

### Key Features 

#### 1. Inbound Content Guard

User inputs and recent conversation history are evaluated for safety before the LLM generates a response. On an unsafe decision, the request is immediately terminated and the user receives a configurable block message, optionally including risk category labels.

#### 2. Tool Call Chain Gate

Once a session is flagged as unsafe, all subsequent tool calls within that session (code execution, web search, etc.) are blocked, closing the tool side-channel bypass vector.

#### 3. History Sanitization

Previously blocked message pairs are automatically detected and removed from conversation history, preventing contamination from causing false-positive blocks on subsequent benign messages. Works across process restarts with no extra persistent state.

#### 4. PII Redaction

Before sending conversation content to the external classification service, sensitive information is automatically masked, including:

- Email addresses, credit card numbers, IP addresses
- API keys, tokens, and other high-entropy strings
- Custom patterns via configuration

#### 5. Multi-User Channel Ban

For group-chat environments (DingTalk, Feishu, WeCom, Telegram, Slack, etc.), a cross-session **TTL-based auto-expiry ban** prevents blocked users from bypassing the block by resetting their session.

---

### Getting Started

#### Prerequisites

- Node.js >= 18
- OpenClaw gateway installed and running
- An accessible content classification service endpoint

#### Install

**Option 1: Install via npm (Recommended)**

```bash
npm install @botsmart-cn/clawguardian
```

Then reference the plugin in your OpenClaw configuration.

**Option 2: Install from source**

```bash
# Run from the project root
./scripts/install.sh
```

The install script handles: dependency installation → TypeScript compilation → plugin registration and activation.

After installation, restart the OpenClaw gateway:

```bash
openclaw gateway restart
```

#### Verify

```bash
./scripts/verify.sh
```

The script sends safe and unsafe sample messages, verifies that end-to-end blocking works correctly, and writes results to `scripts/verify-report.json`.

#### Uninstall

```bash
./scripts/uninstall.sh
```

The uninstall script disables and removes the plugin and cleans up configuration entries.

---
*Developed and maintained by [Botsmart](https://botsmart.cn)*
