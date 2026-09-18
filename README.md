# Clash-CN Healthcheck

本机 Clash 节点测速与出口筛选工具。

## 功能

- **源聚合**：抓取多个源，指纹去重，按源轮流取样
- **可用性实测**：在本机用 mihomo 内核真实连接测试，绕过 TUN 避免虚高
- **出口检测**：淘汰出口在国内的节点，按出口 IP 去重
- **手机精简版**：按出口国家分组，每组只留最快几条

## 文件结构

```
deploy/                     # systemd 部署模板
├── clash-cn-healthcheck.sh    # 主脚本（systemd timer 调用）
├── clash-cn-healthcheck.service
└── clash-cn-healthcheck.timer
scripts/                    # Python 源代码
├── local_healthcheck.py      # 主测速逻辑
├── healthcheck.py            # 底层测速函数
├── exit_check.py             # 出口检测
├── update.py                 # 源聚合
├── sub_convert.py            # 分享链接转换
└── fetch_core.py             # mihomo 内核下载
README.md
