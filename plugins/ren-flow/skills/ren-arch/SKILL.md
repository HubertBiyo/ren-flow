---
name: ren-arch
description: 建立、刷新、体检架构现状文档 .ren-flow/arch/ARCHITECTURE.md(含数据库索引清单 arch/indexes/{collection}.md、接口契约文件 arch/openapi/{slug}.openapi.json)—— 只记「系统现在长什么样」。触发：用户说「刷新架构 doc」「架构体检」「补一份架构文档」「架构对不上代码了」「记录索引 / 补索引清单 / 加了个索引到 X 集合 / DBA 新建了索引 / 索引清单更新」「导出接口到 Apifox / 生成 OpenAPI / 更新接口契约文件 / 接口要给前端联调」。
---

# ren-arch

## 启动必读

先 `Read .ren-flow/attention.md` 与现有 `arch/ARCHITECTURE.md`。

**工作区模式**（根 `attention.md` 标 `mode: workspace`）：架构文档按业务域分 —— 维护的是 `.ren-flow/domains/{domain}/arch/ARCHITECTURE.md`，一个域一份。先确认本次业务域（域清单见根 attention）。

## 这个技能干什么

维护 `.ren-flow/arch/ARCHITECTURE.md` —— 架构现状的总入口。它只回答「系统**现在**长什么样」:

- 不记规划(规划在 `roadmap/`)
- 不记历史决策的来龙去脉(决策在 `notes/` 的 `decision`)
- 不记需求(那是 spec 的事)

架构 doc 准,后续 `ren-spec` 设计时才有可靠的名词复用与模块归属依据。

## 三种模式

| 模式 | 触发 | 做什么 |
|---|---|---|
| **建立** | 文档还是占位模板 | 扫代码,首次填实 |
| **刷新** | 代码已演进,文档滞后 | 比对差异,更新滞后部分 |
| **体检** | 「架构体检」「对不对得上」 | 逐节核对文档与代码,出差异清单 |

启动先看现有 `ARCHITECTURE.md` 是占位还是已填实,自动判建立 / 刷新。

## 流程

### 1. 扫现状

按需 `Glob` / `Grep` / 读代码,搞清:有哪些模块、各自路径与职责、依赖方向、关键技术选型、跨模块边界。模块多时优先看目录结构和入口文件,不逐行读。

### 2. 比对(刷新 / 体检模式)

现有文档每一节对照代码现状,列出:已过时的描述、缺失的新模块、依赖关系的变化。

### 3. 更新文档

按 `ARCHITECTURE.md` 模板结构写 / 改:一句话定位、系统全景图、模块清单、技术选型、跨模块约束、子系统文档索引。

纪律:

- **只写现状,不写理想态** —— 「应该重构成 X」属于 `ren-note` 的 decision 或 `ren-roadmap`
- **大改先给用户 review** —— 结构性重写不直接落盘
- 模块 ≤ 2 个、关系简单时不强行画图

### 4. 体检模式产出差异清单

体检不一定改文档,先出清单:`{文档说的} vs {代码实际}`,让用户决定改文档还是改代码。

## arch/ 内部布局

```
arch/
├── ARCHITECTURE.md         系统现状总入口(必备)
├── schemas/                集合字段权威源(可选,每集合一份)
│   └── {collection}.md     字段名 / 类型 / 必填 / 默认 / 含义约束 / 多态分支 + 变更日志
├── indexes/                数据库索引清单(可选,每集合一份)
│   └── {collection}.md     该集合的索引、用途、命中场景、变更历史
├── data-model.md           全域 ERD / 集合关系图(可选)
└── openapi/                接口契约文件(可选,供 Apifox / Postman 导入联调)
    └── {slug}.openapi.json OpenAPI 3.x,可一键导入 Apifox 测试
```

`indexes/{collection}.md` 内容建议:索引列表(字段 / 单复合 / 唯一 / TTL / 名称)、用途说明(哪条查询在用)、当前命中情况(可选)、变更记录。新加 / 改索引时同步更新。

`indexes/` 不强制建,仅当某个域索引数量多 / 性能敏感 / 多人协作时才有价值。

`schemas/{collection}.md` 是集合 / 表的**字段权威源**(只记「现在有哪些字段、长什么样」):存储侧字段名(如 BSON / 列名,含大小写风格)+ 语言侧类型 + 必填 + 默认 + 含义/约束 + 多态字段分支,末尾带变更日志。字段变更的 PR 必须同步改本文件。**「为什么这次加这个字段」属于 spec 设计意图,不写进 schemas**;`schemas` 只回答现状。不强制建,字段多 / 多态复杂 / 多人协作的域才有价值。可选 `data-model.md` 放全域 ERD / 集合关系。

**arch/ 只装「系统现在长什么样」** —— ARCHITECTURE.md / schemas / indexes / openapi / data-model。不属于现状的别塞进来:需求文档进域级 `requirements/`、技术决策(ADR)进 `notes/`、上线 / 部署 / 运维物料进域级 `deploy/`(见 `ren` 骨架图与 `ren-init`)。arch/ 当杂物间是常见熵增。

### openapi/ 接口契约文件

本次任务是导出接口 / 生成 OpenAPI / 给前端联调时,`Read references/openapi-contract.md` —— 手工编排 OpenAPI 3.x 的内容要点、Apifox 导入方式、以及「分散编写(各域 arch/openapi/)→ 集中发布(`.ren-flow/openapi/` 独立 git repo)」的同步流程都在那里。日常刷新 / 体检架构文档不涉及接口契约时跳过。

## 退出条件

- [ ] 文档反映的是代码当前现状,不含规划 / 理想态
- [ ] 模块清单、依赖方向、技术选型与代码一致
- [ ] 体检模式:差异清单已给出
- [ ] 大改已经用户 review

## 容易踩的坑

- 把规划 / 理想态写进架构 doc —— 那是 roadmap / notes
- 逐行读完所有代码才动笔 —— 先看结构和入口
- 结构性重写不给 review 直接落盘
- 文档跟代码不一致还标「current」 —— 体检要如实列差异
