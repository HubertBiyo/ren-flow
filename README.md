# ren-flow — Vibe Coding 工作流

> 中文 | [English](./README.en.md)

**ren = 人（rén, human）** —— 整套工作流的内核是「人在环」：人定意图与验收，AI 做高效执行体。

一套面向团队的 Vibe Coding AI 编码工作流技能集，以 Claude Code 插件形式分发。三个设计取向：**精简**（16 个技能，角色无关共用一套）、**角色无关**（前端 / 后端 / 客户端不按角色拆技能）、**偏速度**（小事走快路，大事才上规格）。

## 它解决什么

Vibe Coding 的常态是「程序员口述意图 → AI 高速执行」。爽，但放任不管会反复制造同一批麻烦：

- 需求只在脑子里，改完就忘，三个月后没人说得清当时为什么这么做
- AI 拿到需求直接写代码 —— 命名跟原仓库对不上、改着改着改出范围
- 修 bug 改了表面现象，根因没碰，下次照爆
- 踩过的坑不沉淀，团队和 AI 都在重复踩

ren-flow 不编排 Agent，**编排软件本身的生命周期**：意图 → 规格 → 代码 → 验收 → 沉淀。人定意图与验收，AI 做高效执行体。

## 三条核心原则

1. **人在环** —— 程序员对意图和验收负责，AI 不替你拍板。拿不准就停下来问。
2. **结构服务于速度** —— 30 分钟内能改完的小事走快路，不立规格；只有「跨多文件 / 要留档 / 多人对齐」的事才上完整流程。
3. **知识复利** —— 每次踩坑和好做法都沉淀进 `.ren-flow/notes/`，AI 越用越懂这个项目。

## 体系：6 类制品 + 3 条流程

所有产物聚在仓库根的 `.ren-flow/`：

```
.ren-flow/
├── attention.md          每次启动必读：项目硬约束 / 构建命令 / 目录禁区
├── arch/                 架构现状（ARCHITECTURE.md + 可选 schemas/ indexes/ openapi/）
├── specs/                规格聚合根（新增能力的设计 + 验收）
├── fixes/                bug 修复记录
├── refactors/            重构记录（行为不变、结构变）
├── roadmap/              大需求拆解与排期
├── requirements/         需求文档（PRD / US）+ 追溯矩阵 RTM（可选，按模块分子目录）
├── notes/                知识沉淀（坑 / 处方 / 决策 / 调研）
├── deploy/               上线 / 运维物料（域级常驻上线清单 / K8s / 脚本，可选）
├── inbox/                灵感收件箱（月文件夹 + 一天一文件）
├── journal/              每日工作日志（月文件夹 + 一天一文件）
├── templates/            跨域可复用脚手架（新应用 / CI / K8s，可选）
└── _archive/             完结制品归档（`_archive/{type}/{YYYYMM}/{slug}/`）
```

检索：制品 frontmatter 带 `tags` / `summary` / `kind` 等字段，用 `Grep` 扫这些字段即可定位历史 spec / fix / 决策，无需额外索引。

**两种形态**：单仓库直接如上；一个文件夹下装多个项目（多业务域工作区）时，在 `specs/fixes/...` 上套一层业务域 —— `.ren-flow/domains/{domain}/specs/...`，每个域一套（含各自的 `_archive/`）。只有 `journal/` `inbox/`（及可选的 `templates/`）不分域、留在工作区根。`ren-init` 自动判形态，根 `attention.md` 的 `mode` 字段标明。

**三条流程：**

- **新增能力**：`ren-spec`（规格）→ `ren-build`（实现）→ `ren-verify`（验收）
- **修 bug**：`ren-fix`（记录 → 定位 → 修复，单技能内分阶段）
- **大需求**：`ren-roadmap` 先拆模块定接口，再逐块走 `ren-spec`

主流程收尾用 `ren-ship`（提交 / commit message / PR）。横切随时可用：`ren-explore`（摸代码）、`ren-review`（评审 / 接收评审）、`ren-refactor`（重构）、`ren-note`（沉淀）、`ren-arch`（架构文档）、`ren-log`（每日日志）、`ren-inbox`（灵感收件箱）。

## 16 个技能（按使用阶段）

技能名不带序号 —— 流程是一张图(三条线 + 横切),不是一条线。顺序由 `ren` 根路由按上下文动态指,下面按阶段分组让你看清典型先后。

**入口** —— 不知道用哪个,从这开始

| 技能 | 职责 |
|---|---|
| `ren` | 根路由,把开放式诉求导到对应子技能(也介绍体系) |
| `ren-bootstrap` | 全新仓库 / 服务冷启动:拉脚手架模板 + 建可编译骨架(再交给 `ren-init`) |
| `ren-init` | 把仓库 / 工作区接入 ren-flow,建 `.ren-flow/` 骨架 |

**主流程:新增能力** —— 一条线走下来

```
ren-spec  →  ren-build  →  ren-verify  →  ren-ship
出规格     写代码      验收        提交收尾
```

**修 bug** —— `ren-fix`,单技能内三阶段:记录现象 → 回溯根因 → 定点修复验证

**大需求** —— `ren-roadmap`,拆模块定接口契约;拆出的每个子需求再走一遍「主流程」

**横切** —— 任何阶段都可随时插入

| 技能 | 职责 |
|---|---|
| `ren-explore` | 摸代码 / 调研,不改动 |
| `ren-refactor` | 重构(行为不变、结构变):扫描 → 选定 → 逐步改 |
| `ren-review` | 代码评审 / 主动审计 / 接收评审意见 |
| `ren-note` | 知识沉淀(坑 / 处方 / 决策 / 调研) |
| `ren-arch` | 架构现状文档的建立与刷新 |
| `ren-log` | 每日工作日志,汇总当天迭代功能点 |
| `ren-inbox` | 灵感收件箱:随手捕获插队需求 / 灵感,定期 triage 路由到对应技能 |

## 安装

本仓库是一个 Claude Code 插件 + marketplace。安装步骤见 [`INSTALL.md`](./INSTALL.md)，两条命令即可：

```
/plugin marketplace add https://github.com/HubertBiyo/ren-flow.git
/plugin install ren-flow@ren-flow
```

## 怎么用

1. 新仓库先跑 `ren-init` 建骨架
2. 之后说人话即可，不确定走哪个就触发 `ren` 根路由，它会指路
3. 角色不影响技能选择 —— 前端、后端、客户端都走同一套；技术栈差异由项目自己的 `.ren-flow/attention.md` 承载

> 插件技能带命名空间：实际调用名是 `/ren-flow:ren-spec`、`/ren-flow:ren-fix` 等（前缀 `ren-flow` 是插件名）。多数情况下 Claude 会按技能描述自动调用，不用手敲。

## 与角色无关的设计

不设 `ren-build-frontend` / `ren-build-backend`。理由：技能要补偿的是**流程**和**项目专有知识**，不是语言语法 —— 后者模型本就会。各栈的硬约束（命名、构建命令、分层规矩、易错点）写进项目的 `.ren-flow/attention.md`，`ren-build` 启动时读它，对前端后端客户端一视同仁。

## 维护

技能维护规范见 `AGENTS.md`。两条结构约定:

- **技能渐进披露** —— 每个 `SKILL.md` 是常驻的薄 manifest(触发判断 + 流程骨架);模式专属的模板 / 示例 / 长清单拆进该技能的 `references/`,由模型按路径按需 `Read`,常见路径不为重路径的细节买单。
- **路由回归 eval** —— `evals/` 收「用户原话 → 期望路由」语料 + 重放流程。改了任何技能 `description:` 或 `ren` 路由表后重放一遍,确认路由没退化(尤其 log / inbox / note 这类触发词易撞车处)。详见 `evals/README.md`。

## License

[MIT](./LICENSE)
