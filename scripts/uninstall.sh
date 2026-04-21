#!/usr/bin/env bash
set -euo pipefail

echo "═══════════════════════════════════════════"
echo "  ClawGuardian — 卸载脚本"
echo "═══════════════════════════════════════════"

# 1. 禁用插件
echo "[1/5] 禁用插件..."
if command -v openclaw &>/dev/null; then
  openclaw config set plugins.entries.clawguardian.enabled false 2>/dev/null || true
  echo "  ✓ 已禁用 clawguardian"
else
  echo "  ⚠ 未检测到 openclaw CLI，请手动禁用插件"
fi

# 2. 卸载插件
echo "[2/5] 卸载插件..."
if command -v openclaw &>/dev/null; then
  echo "y" | openclaw plugins uninstall clawguardian 2>/dev/null || true
  echo "  ✓ 已卸载 clawguardian"
else
  echo "  ⚠ 请手动执行: openclaw plugins uninstall clawguardian"
fi

# 3. 删除插件目录（彻底清除 auto-load 的插件文件）
echo "[3/5] 删除插件目录..."
PLUGIN_DIR="$HOME/.openclaw/extensions/clawguardian"
if [ -d "$PLUGIN_DIR" ]; then
  rm -rf "$PLUGIN_DIR"
  echo "  ✓ 已删除 $PLUGIN_DIR"
else
  echo "  ✓ 插件目录不存在（已清理）"
fi

# 4. 清理配置
echo "[4/5] 清理 clawguardian 配置..."
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
if [ -f "$CONFIG_FILE" ]; then
  if command -v jq &>/dev/null; then
    jq 'del(.plugins.entries.clawguardian)' "$CONFIG_FILE" > /tmp/openclaw.json.tmp && \
      mv /tmp/openclaw.json.tmp "$CONFIG_FILE"
    echo "  ✓ 已清理配置项"
  else
    echo "  ⚠ jq not found, using openclaw config unset"
    openclaw config unset plugins.entries.clawguardian 2>/dev/null || true
  fi
else
  echo "  ✓ 配置文件不存在（已清理）"
fi

# 5. 提示重启
echo "[5/5] 卸载完毕"
echo ""
echo "下一步："
echo "  1. 重启 OpenClaw gateway: openclaw gateway restart"
echo "  2. 可选：清理环境变量 CLAWGUARDIAN_GUARD_ENDPOINT / CLAWGUARDIAN_GUARD_API_KEY"
echo ""
