# ren-flow 工作流 —— 安装指南

ren-flow 以 **Claude Code 插件**形式分发。本仓库同时是一个 marketplace（插件目录）和其中的 `ren-flow` 插件。装好后会得到 16 个 `ren-*` 技能。

## 前置

- 已安装并登录 Claude Code（版本够新，能用 `/plugin` 命令；旧版本先升级）

## 安装（两步）

在 Claude Code 里执行：

```
/plugin marketplace add https://github.com/HubertBiyo/ren-flow.git
/plugin install ren-flow@ren-flow
```

第一行把本仓库注册为 marketplace；第二行从中安装 `ren-flow` 插件。`ren-flow` 既是 marketplace 名，也是其中唯一的插件名。

装完执行 `/reload-plugins` 加载技能（或重启 Claude Code）。

## 验证

`/help` 里能看到 `ren` 开头的技能即成功。试触发根路由：

```
/ren-flow:ren
```

它会介绍体系并根据你的诉求指路。

## 怎么用

- 新仓库先触发 `ren-init` 建 `.ren-flow/` 骨架
- 之后说人话即可，不确定用哪个就触发 `ren` 根路由
- 详细用法见 [`GUIDE.md`](./GUIDE.md)

> **技能命名空间**：插件技能带前缀，实际调用名是 `/ren-flow:ren-spec`、`/ren-flow:ren-fix` 等。多数情况 Claude 会按技能描述自动调用，不用手敲完整名字。

## 更新

维护者往本仓库推了新版本后，使用者刷新即可：

```
/plugin marketplace update ren-flow
```

## 卸载

```
/plugin uninstall ren-flow@ren-flow
```

## 常见问题

**Q：没有 `/plugin` 命令？**
Claude Code 版本太旧，升级到最新版。

**Q：装完 `/help` 看不到 ren-flow 技能？**
执行 `/reload-plugins`，仍没有就重启 Claude Code。

**Q：之前手动把 ren-flow 技能拷进过 `.claude/skills/`？**
会和插件版重复。删掉 `.claude/skills/` 下的 `ren-flow*` 目录，只留插件版。
