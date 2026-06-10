---
name: ren
description: ren-flow 工作流的根入口，介绍体系全貌并把开放式诉求路由到对应 ren-* 子技能。触发：用户只输入 `ren`、说「介绍下 ren-flow」「该用哪个技能」「不知道用哪个」，或诉求还很开放。本技能只做路由不做事。
---

# ren

## 启动必读

回应前先 `Glob .ren-flow/`。存在 → `Read .ren-flow/attention.md`（缺失说明骨架不全，提示先跑 `ren-init`）。不存在 → 后面提示用户先 `ren-init`。

## 这个技能干什么

`ren` 是 Vibe Coding 工作流的统一入口。用户开口大概率不指名某个 `ren-xxx` —— 可能只说「我想加个权限校验」「这里有 bug」「介绍下 ren-flow」，甚至只发一个 `ren`。本技能接住开放式输入，弄清意图，路由到对的子技能。

**只做两件事：**

1. 用户带具体诉求 → 匹配路由表，告诉用户该触发哪个 `ren-*`，一句话说明为什么
2. 用户想了解体系 / 说不清想做什么 → 给精简速读 + 让用户挑

**不做的事**：不写代码 / 不写规格 / 不读写 `.ren-flow/` 下的内容产物 / 不替子技能跑流程。产出只有「建议触发哪个子技能」。

## 收到调用先做的扫描

1. `Glob .ren-flow/` 看仓库是否接入
2. 接入了 → `Read .ren-flow/attention.md`；`Glob` 一下 `specs/` `fixes/` `roadmap/` 看进行中的工作（拿目录名就够，不逐份读）
3. 没接入 → 提示先 `ren-init`
4. 看用户原话是开放式还是带具体诉求

扫完才回应。

## 体系速读（用户没具体诉求 / 让你介绍时讲这个）

ren-flow 编排的是**软件生命周期**，不是 Agent。产物聚在 `.ren-flow/`：

```
.ren-flow/
├── attention.md   启动必读：项目硬约束 / 命令 / 禁区
├── arch/          架构现状（ARCHITECTURE / schemas / indexes / openapi）
├── specs/         新增能力的规格（设计 + 验收）
├── fixes/         bug 修复记录
├── refactors/     重构记录（行为不变、结构变）
├── roadmap/       大需求拆解
├── requirements/  需求文档（PRD / US）与追溯矩阵（RTM）
├── notes/         知识沉淀（坑 / 处方 / 决策 / 调研）
├── deploy/        上线 / 运维物料（域级上线清单 / K8s / 脚本）
├── inbox/         灵感收件箱（月文件夹 + 一天一文件）
├── journal/       每日工作日志
├── templates/     跨域可复用脚手架(可选;新应用 / CI / Jenkinsfile / K8s 配置等)
└── _archive/      完结制品归档
```

**两种形态**：单仓库直接如上；多项目工作区则在 `specs/fixes/...` 上套一层业务域 `.ren-flow/domains/{domain}/specs/...`（`journal/` `inbox/` `templates/` 不分域留在工作区根；`_archive/` **每个域各有一份**，与制品目录平级）。根 `attention.md` 的 `mode` 字段标明走哪种。

**归档布局**：`_archive/{type}/{YYYYMM}/{slug}/`，`type` 与制品目录同名（specs / fixes / refactors / roadmap / notes）。具体见 `ren-init` 「`_archive/` 内部布局」一节。

**三条流程**：新增能力 `ren-spec → ren-build → ren-verify`；修 bug `ren-fix`；大需求 `ren-roadmap` 拆完再逐块 `ren-spec`。全新仓库另起一步:`ren-bootstrap`(搭应用骨架)→ `ren-init`(接工作流)→ 再进上面三条流程。

**核心理念**：人定意图与验收，AI 做执行体；小事走快路，大事才上规格。

## 路由表

匹配用户的话到表里某行，回「你这个诉求建议走 `ren-xxx`，因为 {一句话理由}」。

| 用户说什么 / 想做什么 | 路由到 |
|---|---|
| 仓库还没有 `.ren-flow/` | **先 `ren-init`** —— 其他 ren-* 都依赖它 |
| 全新仓库 / 服务立项 / 「搭个新 repo 骨架」/「初始化 xxx 服务」 | `ren-bootstrap`（搭应用代码骨架，再接 ren-init） |
| 新功能 / 「加个 X」/「实现 XX」/ 想法还要聊清楚 | `ren-spec` |
| 规格已写好、要写代码 | `ren-build` |
| 代码写完、要验收 / 「能提交了吗」 | `ren-verify` |
| BUG / 异常 / 报错 / 「这里不对」 | `ren-fix` |
| 优化 / 重构 / 拆文件 / 「太长了」/ 性能不行（行为不变） | `ren-refactor` |
| 评审代码 / 「review 一下」/ 主动扫问题 | `ren-review`（评审 / 审计模式） |
| 收到别人 / PR 的 review 意见 | `ren-review`（接收评审模式） |
| 摸代码 / 「X 怎么实现的」/ 调研提问 | `ren-explore` |
| 踩坑回顾 / 好做法 / 长期规约 / 「记一下」 | `ren-note` |
| 刷新 / 建立 / 体检架构文档 | `ren-arch` |
| 大需求 / 「我想要一个 X 系统」/ 排期规划 | `ren-roadmap` |
| 同步日志 / 写日报 / 今日总结 | `ren-log` |
| 「记个灵感」/ 插队的需求想法先记下 / 「消化 inbox」 | `ren-inbox`（capture / triage） |
| 生成 commit message / 提交 / PR 收尾 | `ren-ship` |
| 在流程中间问「下一步」 | 自己读 `.ren-flow/` 对应目录判断进度，指下一个技能 |

判不出来：「听起来像 {猜测}，但你描述里缺 {X}。是 {A} 还是 {B}？」让用户选，不硬猜。

## 几种要留心的情况

- **仓库没接入** → 任何流程都先 `ren-init`，不直接路由到 `ren-spec` / `ren-fix`。
- **大需求被当成普通功能** —— 「我想要一个权限系统 / 通知中心」这种一眼做不完一个 spec 的 → 路由 `ren-roadmap`，不要 `ren-spec`。
- **「改一下 X」但 X 是已有功能** → 先问是 bug（X 现在表现错了）还是需求变更（表现没错但策略变了）。bug → `ren-fix`；需求变更 → `ren-spec`。
- **进行中的工作** —— 扫到 `specs/` 或 `fixes/` 下有相关目录 → 问「看到 `specs/2026-05-20-xxx/` 已存在，是接着做吗？」
- **小事别上规格** —— 30 分钟内能改完、单文件、无跨模块影响的，直接告诉用户「这个不用走 spec，描述清楚直接让我改即可」。

## 退出

输出形如：

> 你这个诉求建议走 **`ren-xxx`** —— {一句话理由}。
> 触发后它会 {简述会发生什么}。现在切到 `ren-xxx` 吗？

退出条件：已告诉用户下一步触发哪个具体的 `ren-*`（或确认用户只是来了解）。

## 不做的事

- 不读写 `.ren-flow/` 下的内容产物 —— 子技能的事
- 不替子技能做决策
- 不一次推荐多个技能 —— 每次只指一条路
- 不绕过 `ren-init` —— 没接入就先接入
