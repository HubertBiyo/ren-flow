---
name: ren-spec
description: 把一个新功能想法收敛成一份规格文件，作为后续 ren-build 实现和 ren-verify 验收的唯一输入。含讨论收敛与设计成文两段，按规模自动分快路 / 全程。触发：用户说「做个新功能」「加个 X」「实现 XX」「设计方案」。
---

# ren-spec

## 启动必读

先 `Read .ren-flow/attention.md`；缺失说明骨架不全，提示先 `ren-init`。

**工作区模式**（根 `attention.md` 标 `mode: workspace`）：制品按业务域分层 —— 本技能产物落到 `.ren-flow/domains/{domain}/` 下而非 `.ren-flow/`。先确认本次业务域（域清单见根 attention），再 `Read .ren-flow/domains/{domain}/attention.md` 取该域约定。

**加载设计能力技能**：attention.md 若声明了「栈规范技能」，方案涉及架构 / 索引 / 性能 / 容量、或要在改前评估复杂度风险时，加载其中对应的架构 / 熵控类技能辅助设计。ren-spec 自身只管「把方案钉清楚」，深度设计判断借力项目指定的能力技能。

## 这个技能干什么

Vibe Coding 最容易翻车的一步是「AI 拿到一句话需求直接写代码」—— 命名跟原仓库对不上、改着改着改出范围、改完没存档。ren-spec 在「想法」和「代码」之间塞一份规格，让人和 AI 在动手前确认的是**同一份方案**。

产出一份 `{slug}-spec.md`，落在 `.ren-flow/specs/{YYYY-MM-DD}-{slug}/`。目录命名 `YYYY-MM-DD-{英文 slug}`，日期取首次创建当天定了不动；slug 小写字母 / 数字 / 连字符。

## 先判规模：快路还是全程

| | 快路（fast spec） | 全程（full spec） |
|---|---|---|
| 适用 | 需求清楚、单 / 双文件、无跨模块影响、推进步骤 ≤ 4 | 跨多模块 / 有术语冲突风险 / 要多人对齐 / 步骤 > 4 |
| 流程 | 直接起草 4 节规格，用户一次确认 | 先讨论收敛，再起草完整规格，整体 review |

规模一眼难判时问用户一句。**更小的事**（30 分钟内、改个文案 / 调个参数）：告诉用户「这个不用 spec，直接说清楚我改即可」，本技能退出。

## 按路径取参考（渐进披露）

SKILL.md 只放任何规模都要的判断与契约；详细模板按路径现取，不常驻：

- **快路**：不读任何参考，直接按下面流程起草 4 节规格。
- **全程**：起草前 `Read references/full-spec.md` —— 取完整 spec 模板（含 2.5 结构健康度 / 2.6 接口契约 / 2.7 上线影响面）、起草纪律、踩坑清单。
- **PRD 模式**（跨角色 / 跨团队、SLA / 契约要冻结）：`Read references/prd-mode.md`，产出 `prd.md` 与 spec 并存。

## 流程

### 1. 启动检查

- **熵增闸门（开新前先清旧）**：`Glob .ren-flow/specs/` 扫一遍：① `status: done` 的目录批量归档（规则见下「归档」）；存量无 done 标记但 `{slug}-verify.md` 结论 pass 的，列清单请用户确认一次后批量归档；② 清完后在途（draft / approved）仍 > 3 个 → 先问：能合并进现有 spec？能延后？确认后再开新（阈值可由 attention.md 覆盖）。
- **续作检查**：`Glob .ren-flow/specs/` 看有没有相关目录。有 `{slug}-spec.md` 且 `status: draft` → 接着补；`status: approved` → 问用户接着改还是另起。
- **扫已有输入**：`Read .ren-flow/arch/ARCHITECTURE.md` 关注名词复用与模块归属；`Grep .ren-flow/notes/` 按关键词 / `tags` 搜相关决策 / 坑（命中冲突的决策必须正面回应）；`Grep .ren-flow/specs/` 看有没有同类历史规格可参考；`Glob .ren-flow/roadmap/` 看是否是某大需求的子项。
- **读需求相关的现有代码**：由需求线索决定读哪些。

### 2. 讨论收敛（仅全程；快路跳过）

需求模糊时,AI 当思考伙伴帮用户想清三件事 —— 要解决的**真问题** / **核心行为** / 一条明确的**不做什么**。三项有一项模糊就值得聊。

**一次只问一个问题**,用户答完再问下一个。用户说「想清楚了直接设计」就尊重,别强推发散。

### 3. 起草规格

- **快路**：直接按 spec 四节结构（1 要做什么 / 为什么、2 方案设计、3 验收契约、4 推进步骤）起草，frontmatter `status: draft`、`mode: fast`，用户一次确认。
- **全程 / PRD**：先按上节「按路径取参考」`Read` 对应参考文件，取完整模板与纪律再起草。

**整稿一次性给 review**,不分批 —— 分批用户看不出跨节不一致。

### 4. review 与定稿

整稿给用户 review,反复改到放行,`status` 改 `approved`。

### 5. 退出

引导用户「规格已定稿,接下来 `ren-build` 按它实现」。

## 归档

`specs/` 只放**在途**制品,完结即归。归档 = 整目录**原名**移入 `_archive/specs/{YYYYMM}/`(YYYYMM 取目录名日期所属月;工作区模式在 `domains/{域}/_archive/specs/{YYYYMM}/`),spec frontmatter `status` 改 `archived`、补 `archived_reason`。`status: done` 由 `ren-verify` 在验收 pass 时标,是「可归档」信号;归档动作由 verify 收尾当场做,或本技能开新时的熵增闸门批量收。

## 退出条件

- [ ] frontmatter 完整(`status: approved`、`mode` 已标)
- [ ] 第 1 节含「明确不做什么」,且可被反向核对
- [ ] 第 2 节数据 / 类型变化用「现状 → 变化」,接口有示例;模块归属有理由
- [ ] 第 2.5 节结构健康度有显式结论(不动 / 微重构 / 转 ren-refactor),含可卸载性回答 —— *全程必有;快路无结构影响时可在第 2 节一句话带过*
- [ ] 第 3 节验收契约覆盖正常 + 边界 + 错误
- [ ] 第 4 节推进步骤每步有「做完的标志」
- [ ] 用户已 review 放行

> 详细模板、起草纪律、容易踩的坑：`references/full-spec.md`；PRD 结构与写作硬约束：`references/prd-mode.md`。
