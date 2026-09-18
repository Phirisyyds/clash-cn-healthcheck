# Clash-CN Healthcheck

本机 Clash 节点测速与出口筛选工具。

## 功能

- 抓取源聚合 → 指纹去重 → 按源轮流取样
- 本机实测节点可用性（绕过 TUN）
- 出口检测：淘汰出口在国内的节点，按出口 IP 去重
- 生成手机精简版配置（按出口国家分组）

## 文件结构

```
deploy/
├── clash-cn-healthcheck.sh    # 主脚本（systemd timer 调用）
├── clash-cn-healthcheck.service
└── clash-cn-healthcheck.timer
```

## 安装（systemd user service）

```bash
sudo mkdir -p /home/$USER/.local/bin
sudo cp deploy/clash-cn-healthcheck.sh /home/$USER/.local/bin/
sudo chmod +x /home/$USER/.local/bin/clash-cn-healthcheck.sh
systemctl --user daemon-reload
systemctl --user enable --now clash-cn-healthcheck.timer
```

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| GITHUB_TOKEN | GitHub API 令牌（推送用） | `~/.git-credentials-hermes` |
| MIHOMO_BIN | mihomo 内核路径 | 自动探测 |

## 注意事项

- 需要 mihomo 内核（带 `cap_net_admin` 能力以绕过 TUN）
- 校园网下 git push 走 API（pack 会失败）
