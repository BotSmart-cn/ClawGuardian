#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR/../plugin"

echo "═══════════════════════════════════════════"
echo "  ClawGuardian — 安装脚本"
echo "═══════════════════════════════════════════"

# 1. 安装依赖 & 构建
echo "[1/4] 安装依赖..."
cd "$PLUGIN_DIR"
npm install

echo "[2/4] 构建插件..."
npm run build

# 3. 安装到 OpenClaw
echo "[3/4] 安装到 OpenClaw..."
if command -v openclaw &>/dev/null; then
  openclaw plugins install "$PLUGIN_DIR"
  openclaw config set plugins.entries.clawguardian.enabled true
  openclaw config set plugins.entries.clawguardian.config.guard.allowedRiskCategories '["S18"]'
  echo "  ✓ 已在 OpenClaw 中启用 clawguardian"
else
  echo "  ⚠ 未检测到 openclaw CLI，请手动安装插件"
  echo "    openclaw plugins install $PLUGIN_DIR"
fi

# 4. 提示验证
echo "[4/4] 安装完毕"
echo ""
echo "下一步："
echo "  1. 配置环境变量 CLAWGUARDIAN_GUARD_ENDPOINT / CLAWGUARDIAN_GUARD_API_KEY"
echo "  2. 重启 OpenClaw gateway"
echo "  3. 执行 scripts/verify.sh 进行冒烟检查"
echo ""
