---
name: ren-roadmap
description: 大需求拆解 —— 把「我想要一个 X 系统」这种做不完一个 spec 的诉求，拆成模块、定接口契约、排出可逐块推进的子需求。触发：用户说「我想要一个 X 系统」「这块很大要规划一下」「排个期」。
---

# ren-roadmap

## 启动必读

先 `Read .ren-flow/attention.md` 与 `arch/ARCHITECTURE.md`。

**工作区模式**（根 `attention.md` 标 `mode: workspace`）：制品按业务域分层 —— 本技能产物落到 `.ren-flow/domains/{domain}/roadmap/` 下，架构入口为 `.ren-flow/domains/{domain}/arch/ARCHITECTURE.md`。先确认本次业务域（域清单见根 attention）。

## 这个技能干什么

有些诉求一眼就做不完一个 spec —— 「权限系统」「通知中心」「接入 SSO」。直接开 `ren-spec` 会变成塞不下的巨型规格。ren-roadmap 在它前面:把大需求拆成**模块 + 接口契约 + 有依赖顺序的子需求**,之后每个子需求各走一次 `ren-spec`。

产出一个 roadmap 目录 `.ren-flow/roadmap/{YYYY-MM-DD}-{slug}/`,主文件 `{slug}-roadmap.md`;拆解图、items 清单等伴生文件一并放进去。

## 流程

### 1. 收敛大需求

和用户对齐:这个大需求要解决的核心问题、范围边界、明确不做什么、有没有硬性的时间 / 依赖约束。**一次问一个问题**。

### 2. 拆模块

把大需求切成内聚的模块 / 子系统:

- 每个模块职责单一、能独立推进
- 优先复用现有模块,新建模块要说明理由
- 想清模块间依赖方向 —— 谁依赖谁,有没有环

### 3. 定接口契约

模块之间怎么交互 —— 关键接口的输入 / 输出、共享的数据结构、事件 / 协议。这是后续各 spec 的硬约束:子需求实现时不能私自改契约,要改回到这里改。

### 4. 排子需求

把模块落成有顺序的子需求清单:

```markdown
---
doc_type: roadmap
slug: {slug}
status: planning | in-progress | done | archived
tags: [关键词, 便于以后 Grep 检索]
created_at: YYYY-MM-DD
---

## 大需求
核心问题、范围、明确不做。

## 模块拆分
| 模块 | 职责 | 依赖 |
|---|---|---|

## 接口契约
模块间关键接口 / 共享结构 / 事件。

## 子需求清单
| # | 子需求 | 对应模块 | 依赖项 | 状态 | 对应 spec |
|---|---|---|---|---|---|
| 1 | ... | ... | 无 | planned / in-progress / done | specs/xxx |
```

### 5. review 与衔接

整份给用户 review 放行。之后每个子需求启动时:走 `ren-spec`,规格 frontmatter 标明出自哪个 roadmap;子需求做完回写本表状态。

## 归档

roadmap 的所有子需求 done、能力上线后,整目录**原名**归档到 `_archive/roadmap/{YYYYMM}/`,YYYYMM 取目录名日期所属月(工作区模式 `domains/{域}/_archive/roadmap/{YYYYMM}/`),frontmatter `status` 改 `archived`,补 `archived_reason`。

## 与 ren-spec 的边界

- 一个 spec 装得下(单一功能、推进步骤 ≤ 5)→ 直接 `ren-spec`,不必 roadmap
- 装不下(多模块、要定模块间契约)→ ren-roadmap 先拆
- 拆完的每一个子需求,本身就是一次正常的 `ren-spec`

## 退出条件

- [ ] 大需求的范围和「明确不做」已确认
- [ ] 模块拆分内聚、依赖方向无环
- [ ] 接口契约明确到能作为子 spec 的硬约束
- [ ] 子需求清单有依赖顺序和状态字段
- [ ] 用户 review 放行
- [ ] roadmap 记录落在 `roadmap/{YYYY-MM-DD}-{slug}/{slug}-roadmap.md`,frontmatter 含 tags

## 容易踩的坑

- 把能装进一个 spec 的需求也拿来 roadmap —— 过度规划
- 模块拆分有循环依赖
- 接口契约含糊 —— 子 spec 实现时各写各的对不上
- 子需求没有依赖顺序 —— 不知道先做哪个
- 在 roadmap 里写实现细节 —— 那是各子 spec 的事
