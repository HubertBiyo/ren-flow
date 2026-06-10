# 贡献指南 / Contributing

> English speakers: contributions are welcome in English or Chinese. The rules below are short — the key ones are: read `AGENTS.md` before touching skills, and replay `evals/` after changing any skill `description:` or the `ren` routing table.

## 改之前

- **改技能前先读 [`AGENTS.md`](./AGENTS.md)** —— 技能的硬约束都在那里(单个 `SKILL.md` ≤ 300 行、技能间不互相引用文件、frontmatter 必含 `name` + `description`)。
- 新增技能门槛很高:模型反复犯同一类错 + `attention.md` 解决不了 + 触发场景不与现有技能歧义,**三条全满足**才值得新建。优先考虑并进现有技能。

## 改完之后

- 改了任何技能的 `description:` 或 `ren` 路由表 → **按 [`evals/README.md`](./evals/README.md) 重放路由语料**,确认路由没退化,PR 里说明重放结果。
- 改了技能正文 → 同步检查 `README.md` 技能表、`ren` 路由表、其他技能里的相关表述是否需要联动。
- 校验两份 manifest JSON 合法、技能目录名 = frontmatter `name` = 正文标题(CI 会检查)。

## 提交

- Commit 遵循 conventional commits:`{type}({scope}): {描述}`,type 取 `feat / fix / refactor / docs / chore`。
- 一次 PR 解决一件事;改动动机写清「模型在什么场景下会因此做得更好」。

## 不收什么

- 公司 / 团队专属的约定(命名规矩、内部平台步骤)—— 那属于使用者自己项目的 `.ren-flow/attention.md` 或 notes,不进通用技能。
- 模型本来就会的东西(语言语法、通用算法)—— 技能只补偿流程与项目专有知识,其余是熵。
