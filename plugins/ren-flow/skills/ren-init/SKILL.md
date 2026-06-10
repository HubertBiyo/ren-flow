---
name: ren-init
description: 把代码接入 ren-flow 工作流，建立 .ren-flow/ 骨架。自动判形态：单仓库 / 多项目工作区；已有零散文档则走审计 + 迁移映射。触发：用户说「接入 ren-flow」「初始化 ren-flow」「搭 ren-flow 结构」「迁移到 ren-flow」。
---

# ren-init

把代码接入 ren-flow 工作流。只做两件事:**搭骨架**、**归旧档**。骨架就位后子流程即可运行。

## 两种形态（先判这个）

| 形态 | 适用 | 骨架 |
|---|---|---|
| **单仓库** | 一个独立代码仓库 | `.ren-flow/{specs,fixes,...}` 直接平铺 |
| **工作区** | 一个文件夹下装着多个项目 / 业务域 | `.ren-flow/domains/{域}/{specs,fixes,...}`,域分层 |

**工作区模式 = 域目录都收在 `domains/` 下,每个域一套完整的单仓库结构(含自己的 `_archive/`)**。只有 `journal/`、`inbox/`(及可选的 `templates/`)不分域,工作区根共享。

## 骨架

**单仓库:**

```
.ren-flow/
├── attention.md            启动必读(最小模板,owner 后续填)
├── arch/ARCHITECTURE.md                       架构现状(+ 可选 schemas/ indexes/ openapi/)
├── specs/ fixes/ refactors/ roadmap/ notes/   各含 .gitkeep
├── requirements/ deploy/                      需求文档(+RTM) / 上线物料(可选,按需建)
├── inbox/ journal/ templates/ _archive/       各含 .gitkeep(inbox=灵感收件箱 / journal=日志,templates 可选)
```

**工作区:**

```
.ren-flow/
├── attention.md            工作区级:mode / 域清单 / 跨域通用规则
├── journal/                每日工作日志,不分域,工作区共享
├── inbox/                  灵感收件箱,不分域,工作区共享
├── templates/              跨域脚手架(可选,见下方说明)
└── domains/
    └── {域}/               一个业务域一套(payment / order / user ...)
        ├── attention.md    该域:构建命令 / 栈约定 / 易错点
        ├── arch/           ARCHITECTURE.md + 可选 schemas/ indexes/ openapi/
        ├── requirements/   需求文档(PRD / US)+ 追溯矩阵(可选,按需建)
        ├── deploy/         上线 / 运维物料:域级上线清单 / K8s / 脚本(可选,按需建)
        └── specs/ fixes/ refactors/ roadmap/ notes/ _archive/
```

模板见同目录 `templates/`:`attention-workspace.md`(工作区根)、`attention.md`(单仓库 / 单域)、`ARCHITECTURE.md`。

**`_archive/` 内部布局**:归档 = 整目录**原名**移入 `_archive/{type}/{YYYYMM}/`(`YYYYMM` 取目录名日期所属月),`type` 与制品目录同名(`specs` / `fixes` / `refactors` / `roadmap` / `notes`)。制品目录只放**在途**制品,完结即归 —— spec 由 `ren-verify` 验收收尾或 `ren-spec` 开新闸门驱动,fix / refactor / roadmap 见各自技能。骨架阶段只建空 `_archive/`,子目录归档时按需创建。

**`templates/` 跨域脚手架**(可选,工作区根级,不分域):新应用立项 / CI 配置 / Jenkinsfile / K8s 部署清单 / 通用 Dockerfile 等可复用样板。建议子目录按用途分:`templates/cicd/`、`templates/app-skeleton/{lang}/`、`templates/k8s/` 等。骨架阶段不强制建,首次有样板要存档时再起。这是**给团队复用的**,与 ren-init 自带的 `templates/`(skill 内部模板)是两回事。

**`arch/indexes/` / `arch/schemas/`**(可选):索引清单 / 集合字段权威源,各集合一份 `{collection}.md`,都属架构现状。详见 `ren-arch`。

**`requirements/`**(可选,域级):需求文档(PRD / 用户故事 US)与需求↔字段追溯矩阵(RTM)。回答「要做什么」,与 `arch/`(现状)、`specs/`(单次设计)分开。**按业务模块分子目录防扁平堆积**:`requirements/{module}/{slug}.md` + 本模块 `requirements/{module}/_rtm.md`(RTM 拆到模块内,不留全局大矩阵)。模块名清单见域 `attention.md`。**按需沉淀,非每个 feature 必有**:只有「要长期反复改 / 多人反复核对」的**核心能力**才回填到这里 —— 联调完成后由 `ren-verify` 按需 backfill;日常小 spec 验收归档即可,不强制写 requirements。标准是 **rebuild-grade**(据此可重建代码 + 逐条核业务逻辑)、不留「见代码」黑洞。模块内**多能力共享的机制**(核心算法、状态机、发放 / 编排逻辑等)抽成 `requirements/{module}/_{topic}.md` 权威 doc,各能力文档引用它 —— 不重复。`arch/schemas/` 同理,文件多时按模块分 `arch/schemas/{module}/{collection}.md`。

**`deploy/`**(可选,域级):上线 / 运维物料 —— 域级常驻上线清单(所有应用的固定发布 + 配置)、K8s / 容器平台配置、DB 脚本等。与 per-spec 的 `{slug}-release.md`(单次上线增量,见 `ren-build`)分工:deploy/ 是全景常驻,release.md 引用它。**凭证 / 密钥不进此目录**,放密钥管理,文档只留指针。

## 启动检查

1. 检查 `.ren-flow/`:不存在 → 新建;存在但不全 → 补齐
2. **判形态**:`Glob` 子目录里的 `.git` / `package.json` / `*.sln` —— 当前文件夹本身是单一项目 → 单仓库;装着多个各自独立的项目 → 工作区。拿不准就把判断依据说出来问用户。
3. `Glob` 全仓库 `*.md`(排除 `node_modules/` `.git/` `dist/`)找现有零散文档
4. 汇报:形态判断 + 找到的文档 + 走新建还是迁移 + 不确定项

## 新建骨架

**单仓库**:确认项目名 / 简介 → 一次性建单仓库骨架(9 个目录:specs/fixes/refactors/roadmap/notes/inbox/journal/templates/_archive + `.gitkeep` + `attention.md` + `arch/ARCHITECTURE.md`),模板从 `templates/` 复制。

**工作区**:

1. 和用户确认这是工作区,并列出**先建哪些域**(如 payment / order / user;域名用英文,作目录名)
2. 建工作区根:`attention.md`(用 `attention-workspace.md` 模板,填入域清单)+ `journal/` + `inbox/`
3. 每个确认的域:建 `.ren-flow/domains/{域}/` 下整套(`attention.md` + `arch/ARCHITECTURE.md` + specs/fixes/refactors/roadmap/notes/_archive 的 `.gitkeep`)
4. **新域不必一次建全** —— 以后第一次用到时由对应技能现建即可

骨架一次性建,不逐步确认。`attention.md` 只建空模板,实质内容由 owner 填或后续 `ren-note` 追加。

## 迁移路径（已有零散文档时）

1. **生成审计报告**:表格列「现有文件 | 推测内容类型 | 建议归入 | 置信度(高/中/低)」
2. **逐条对齐**:中 / 低置信度用 `AskUserQuestion` 问;高置信度不逐条问但在汇报里列出供复审
3. **补齐缺失骨架**:对照对应形态的骨架补齐用户确认后仍缺的目录,已有内容不覆盖
4. **不迁移的文件**:用户选「跳过」的 —— 不移动 / 不删除 / 不重命名,标「保留原位」。**绝不未经确认就动**
5. **验收汇报**:迁移清单(from → to)、新建骨架、未迁移文件、下一步建议

## attention.md 该装什么（提示用户）

- 构建 / 测试 / lint 命令
- 目录禁区与不可入 git 的产物
- 各技术栈的命名规矩、分层约束、易错点
- 凭证 / 环境 / 部署规则
- 工作区根的 attention 另加:`mode: workspace`、`domains:` 域清单、跨域通用规则

ren-flow 各子技能启动都读它 —— 写得越准 AI 越少踩坑。**实质内容必须 owner 定**,本技能只给模板。

## 退出条件

- [ ] 形态已判定(单仓库 / 工作区)并与用户确认
- [ ] 对应骨架目录都已建;工作区模式下根 `attention.md` 含 `mode` 与 `domains`
- [ ] `attention.md` 与 `arch/ARCHITECTURE.md` 已建(工作区模式:每个已建域各一份)
- [ ] 迁移路径:每条映射有明确处理结果,无未经确认就移动的文件
- [ ] 验收汇报已给出

## 容易踩的坑

- 把多项目工作区当单仓库建 —— 所有域的制品会糊在一个 `.ren-flow/specs/` 里
- 工作区模式一次把所有域都建全 —— 用不到的域空着是噪声,按需建
- 未经确认就移动 / 删除已有文件 —— 迁移核心原则是用户拍板
- 替用户填 `attention.md` 实质内容 —— 必须 owner 定
- 建完骨架立刻开始 spec / fix —— init 是搭环境不是开始干活
- `Glob` 忘记排除 `node_modules/` `.git/` —— 扫描结果充斥噪声
