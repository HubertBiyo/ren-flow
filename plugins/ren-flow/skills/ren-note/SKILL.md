---
name: ren-note
description: 知识沉淀 —— 把踩过的坑、可复用做法、长期决策、调研结论写成可检索的笔记，存进 .ren-flow/notes/。四类合一，按内容定 kind。触发：用户说「记一下」「沉淀」「这个值得记下来」，或 ren-fix / ren-verify 收尾时推送。
---

# ren-note

## 启动必读

先 `Read .ren-flow/attention.md`。

**工作区模式**（根 `attention.md` 标 `mode: workspace`）：笔记按业务域分层 —— 落到 `.ren-flow/domains/{domain}/notes/` 下而非 `.ren-flow/notes/`。先确认本次业务域（域清单见根 attention）。

## 这个技能干什么

spec 和 fix 记录「做了什么」,但不记「踩了什么坑、发现了什么更好的做法、定了什么长期规矩」。没沉淀的团队和 AI 都在重复踩同一个坑。ren-note 把这些写成笔记存进 `.ren-flow/notes/`,命名 `YYYY-MM-DD-{kind}-{slug}.md`。

## 四类(kind)

| kind | 记什么 | 判别口诀 |
|---|---|---|
| `pitfall` | 踩过的坑:现象 / 根因 / 解法 | 回顾「做 X 时踩了 Y」 |
| `recipe` | 可复用做法 / 库用法 / 模式 | 处方「以后做 X 就这样」 |
| `decision` | 技术选型 / 长期规约 | 规定「全项目今后都按 X」 |
| `research` | 调研结论 / 现状存档 | 调查「X 现在是什么样」 |

判不出问用户:「这个想记成 踩坑 / 复用处方 / 长期规约 / 调研存档 哪一种?」

**特殊**:如果是一两行「每次 ren-flow 技能启动都该知道」的项目硬约束(构建前置 / 命令陷阱 / 目录禁区)→ 不写 note,直接追加到 `.ren-flow/attention.md`,并告诉用户。

## 流程

### 1. 定 kind 与来源

从对话上下文判 kind;来源是 spec 流程 / fix 流程 / 独立问题。

### 2. 查重叠

`Grep .ren-flow/notes/` 按关键词 / `tags` / `component` 扫一遍(笔记 frontmatter 的字段就是为检索存在的),命中相近旧笔记 → 走**更新**(读旧笔记,和用户对齐改哪几节,写回原文件 + `updated: YYYY-MM-DD`),不新建。

### 3. 提炼(一次一个问题)

- pitfall:观察到的现象?试过哪些没用的解法?最终怎么发现真因?下次怎么更早发现?
- recipe:这个做法在什么情境最有价值?不这样做会出什么问题?有没有不适用的反例?
- decision:定的是什么?为什么选它、否决了什么备选?适用边界?
- research:调研问题?现状结论?关键 file:line?

用户对某问题说「跳过」就跳过,宁可少一节不用空话填。

### 4. 起草 + review + 落盘

```markdown
---
doc_type: note
kind: pitfall | recipe | decision | research
slug: {英文连字符}
component: {关联模块}
tags: [关键词, 便于以后 Grep 检索]
created_at: YYYY-MM-DD
updated_at: YYYY-MM-DD
---

## {标题}
正文按 kind 提炼的要点组织。失败的尝试、否决的备选都值得写。
```

AI 一次性起草完整文档,给用户 review,放行后写入 `.ren-flow/notes/`。

## 触发时机

| 情境 | 说明 |
|---|---|
| ren-fix 收尾 | 主动问「这个坑要记下来吗?」 |
| ren-verify 收尾 | 主动问「这次有学习点要沉淀吗?」 |
| 用户主动 | 「记一下」「沉淀」 |
| 解决了一次性难题 | 不在流程内但花了大量时间 |

主动推一句话即可,用户说「不用」就跳过,别重复推。

## 退出条件

- [ ] kind 已定;一两行硬约束类的已改去 attention.md 而非建 note
- [ ] 查过重叠,命中旧笔记走更新而非新建
- [ ] 笔记可被检索(frontmatter 完整、有 component / kind)
- [ ] 用户 review 放行后落盘

## 容易踩的坑

- 把硬约束写成 note,而不是进 attention.md —— 那样启动时读不到
- 不查重叠就新建 —— 两份笔记冲突
- 空话填充 —— 没内容的节宁可删
- 把 note 放进 specs/ 或 fixes/ —— 沉淀类统一进 notes/
