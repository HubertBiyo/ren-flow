---
name: ren-ship
description: 提交收尾 —— 生成规范的 commit message、整理改动范围、按需起 PR 描述。触发：用户说「提交」「commit message」「给我提交说明」「准备 PR」。
---

# ren-ship

## 启动必读

先 `Read .ren-flow/attention.md` —— 项目可能有自己的分支 / commit / PR 约定,以它为准。本技能给的是默认约定。

## 这个技能干什么

把一次做完的改动收尾成可提交的形态:生成 commit message、确认改动范围干净、按需写 PR 描述。**不替用户执行 `git commit` / `git push`** —— 除非用户明确要求;默认只产出文案,提交动作由用户拍板。

## 流程

### 1. 看改动

`git status` / `git diff` 看这次改了什么。如果改动里夹着不相关的东西(顺手改的别处)→ 提醒用户,建议拆成多次提交。

### 2. 生成 commit message

默认 conventional commits 格式,中文描述:

```
{type}({scope}): {中文描述}
```

| type | 用途 |
|---|---|
| `feat` | 新功能、新接口 |
| `fix` | bug 修复 |
| `refactor` | 重构(不改行为) |
| `perf` | 性能优化 |
| `docs` | 文档、注释 |
| `chore` | 构建、依赖、配置 |
| `test` | 测试 |

`scope` 可选,填模块名。描述讲清「做了什么」,必要时正文补「为什么」。一次提交对应一个内聚的改动 —— 范围混杂就是该拆。

### 3. PR 描述(用户要 PR 时)

- 标题:`[模块] 功能描述`
- 正文:做了什么、为什么、影响范围;涉及 DB / 配置 / 接口契约 / 调度等变更要显式说明 —— 该 spec 有 `{slug}-release.md` 时,直接照搬其上线物料摘要,别让 reviewer 自己去翻
- 关联对应的 `.ren-flow/specs/` 或 `fixes/` 目录,方便回溯

### 4. 提交前自检

- 改动范围内聚,没夹带不相关改动
- 构建 / 检查命令通过(没跑过提醒用户先走 `ren-verify`)
- commit message 类型和范围准确

## 与其他技能的边界

- 不做交付验证 —— 那是 `ren-verify`,ship 假设已验过
- 遇到次要的提交异常(如 hook 警告)别钻牛角尖,跳过或如实告知即可

## 退出条件

- [ ] commit message 已生成,格式 / 类型 / scope 准确
- [ ] 改动范围确认内聚,夹带的不相关改动已提醒拆分
- [ ] 用户要 PR 时,PR 描述已给出并关联 spec / fix
- [ ] 默认不替用户执行 git 提交动作(除非明确要求)

## 容易踩的坑

- 一次提交塞多个不相关改动 —— 该拆
- commit type 用错(refactor 改了行为、feat 其实是 fix)
- 未经要求就 `git commit` / `git push`
- PR 描述漏说 DB / 契约变更
- 为次要的提交告警反复深挖 —— 跳过即可
