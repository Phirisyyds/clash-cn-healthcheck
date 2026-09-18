#!/usr/bin/env bash
# 本机每小时：抓源聚合 → 用真实校园网视角实测 → 上传结果（由 systemd user timer 调用）
set -uo pipefail
REPO_DIR="$HOME/projects/free-vpn-clash-aggregator"
PY="/usr/bin/python3"
LOG="$HOME/.local/state/clash-cn-healthcheck.log"
mkdir -p "$(dirname "$LOG")"
{
  echo "===== $(date '+%F %T') 开始（本机聚合模式）====="
  cd "$REPO_DIR" || exit 1

  # 1) 聚合：抓源 + 指纹去重 + 按源轮流取样；测速/出口筛选留给下一步（本机视角才准）
  HEALTH_CHECK=0 EXIT_CHECK=0 "$PY" scripts/update.py
  agg_rc=$?
  nodes=$("$PY" -c "import yaml;print(len((yaml.safe_load(open('output/clash.yaml')) or {}).get('proxies') or []))" 2>/dev/null || echo 0)
  echo "聚合完成 rc=$agg_rc 候选节点=$nodes"

  # 2) 实测 + 上传（候选 >=50 才算聚合成功；否则回退用仓库里的候选表）
  if [ "${nodes:-0}" -ge 50 ]; then
    "$PY" scripts/local_healthcheck.py --input output/clash.yaml --push --push-candidates --concurrency 32
    rc=$?
  else
    echo "候选太少，回退为「读仓库候选表」模式"
    "$PY" scripts/local_healthcheck.py --from-repo --push --concurrency 32
    rc=$?
  fi
  echo "===== $(date '+%F %T') 结束，退出码 $rc ====="
} >>"$LOG" 2>&1
tail -n 600 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
