# ren-flow 工作流使用指南

这份文件讲**怎么用** ren-flow 干活。想看体系设计和理念,看 `README.md`;想维护技能,看 `AGENTS.md`。

---

## 一、ren-flow 是什么(30 秒)

ren-flow 是一套 AI 编码工作流技能。你用自然语言说意图,AI 高速执行——但 ren-flow 给这个过程加了结构,让它不至于失控:

- 改完不留档、三个月后没人说得清为什么 → ren-flow 让每次改动都有规格 / 修复记录
- AI 拿到需求直接写、改出范围 → ren-flow 在「需求」和「代码」之间塞一份要双方确认的规格
- 修 bug 只治标 → ren-flow 强制回溯根因
- 踩过的坑不沉淀 → ren-flow 把坑写进 `.ren-flow/notes/`,AI 越用越懂你的项目

一句话:**人定意图与验收,AI 做执行体;小事走快路,大事才上规格。**

---

## 二、第一次用:接入项目

任何仓库第一次用 ren-flow,先接入:

```
你:在这个项目用 ren-flow
→ 触发 ren-init,自动建好 .ren-flow/ 骨架
```

`ren-init` 会扫一遍仓库:空仓库直接搭骨架;已有 `docs/` 之类零散文档的,会给你一份迁移建议逐条确认。

接入后**第一件该做的事**:把项目硬约束填进 `.ren-flow/attention.md`——构建/测试命令、目录禁区、各技术栈的命名规矩、踩过的坑。这个文件 ren-flow 每个技能启动都读,写得越准 AI 越少翻车。不用一次写全,后面随时说「记一下 XX」让 `ren-note` 追加。

---

## 三、日常怎么用

### 不知道用哪个?直接喊 `ren`

```
你:ren
你:我想给订单加个导出功能
→ ren-flow 路由:这个走 ren-spec,因为是新增能力
```

`ren` 是根路由,接住任何开放式诉求,告诉你下一步该触发哪个技能。记不住 16 个技能没关系,记住 `ren` 一个就够。

### 三条主流程

**① 新增能力(最常用)**

```
ren-spec   把想法收敛成一份规格(需求+设计+验收契约+推进步骤)
   ↓       —— 你和 AI 在这里确认的是同一份方案
ren-build  按规格分步写代码,核心逻辑先写测试
   ↓
ren-verify 逐条核对验收契约,跑命令收证据,判断能不能交
```

**② 修 bug**

```
ren-fix    单技能内三阶段:记录现象 → 回溯根因 → 定点修复+验证
```

**③ 大需求**

```
ren-roadmap  先拆模块、定接口契约、排子需求
   ↓
对每个子需求各走一次 ren-spec → ren-build → ren-verify
```

### 横切技能(随时插入)

| 想做什么 | 喊 |
|---|---|
| 摸代码 / 「X 怎么实现的」 | `ren-explore` |
| 重构 / 优化 / 拆文件(行为不变) | `ren-refactor` |
| 评审代码 / 收到别人的 review 意见 | `ren-review` |
| 记一个坑 / 决策 / 好做法 | `ren-note` |
| 刷新架构文档 | `ren-arch` |
| 同步日志 / 写日报 / 今日总结 | `ren-log` |
| 生成 commit message / 收尾 | `ren-ship` |

---

## 四、完整走一遍:加一个「订单导出」功能

```
1. 你:我想给订单加个导出 CSV 的功能
   ren-spec 启动 → 判规模(单页面、步骤少)→ 走快路
   → 直接起草 4 节规格,你 review 一次 → 定稿
   产物:.ren-flow/specs/2026-05-20-order-export/order-export-spec.md

2. 你:开始实现
   ren-build → 读规格推进步骤 → 核心导出逻辑先写测试看它失败 → 实现 → 跑构建检查

3. 你:验收一下
   ren-verify → 逐条核对规格的验收契约(正常/边界/错误)→ 跑命令收证据
   产物:同目录下 order-export-verify.md,结论 pass

4. 你:提交
   ren-ship → 生成 commit message:feat(order): 新增订单 CSV 导出
```

整个过程:你只说了 4 句话,但留下了规格、验收记录、规范的提交——三个月后回头查,一切有据可循。

---

## 五、心法:三件别忘的事

**1. 快路 vs 慢路,你不用自己选**
`ren-spec` / `ren-fix` / `ren-refactor` 都会先判规模。30 分钟内的小事(改文案、调参数)技能会直接说「不用走流程,直接说我改」。别为小事上规格,也别让大事走快路。

**2. AI 拿不准会停下来问**
ren-flow 的技能被设计成「碰到你没说清的角落就停下来问 / 写成假设让你反驳」,不自己硬猜。看到它问问题,是它在守纪律,不是卡住了。

**3. 知识要沉淀**
踩了坑、定了个规矩、调研出一个结论——喊 `ren-note` 记进 `.ren-flow/notes/`。这是 ren-flow 跟「每次从零开始的 AI」最大的区别:知识跨会话累积。

---

## 六、`.ren-flow/` 里有什么

```
.ren-flow/
├── attention.md   项目硬约束,每个技能启动必读
├── arch/          架构现状文档(ARCHITECTURE.md + 可选 schemas/ indexes/ openapi/)
├── specs/         新增能力(=feature)的规格 + 验收,一个功能一个目录
├── fixes/         bug 修复记录(一个 bug 一个文件夹)
├── refactors/     重构记录(一个重构一个文件夹)
├── roadmap/       大需求拆解(一个 roadmap 一个文件夹)
├── requirements/  需求文档(PRD / US)+ 追溯矩阵 RTM,按模块分子目录(可选)
├── notes/         知识沉淀:坑 / 处方 / 决策 / 调研
├── deploy/        上线 / 运维物料:域级常驻上线清单 / K8s / 脚本(可选)
├── inbox/         灵感收件箱,月文件夹 + 一天一文件
├── journal/       每日工作日志,月文件夹 + 一天一文件
├── templates/     跨域可复用脚手架(新应用 / CI / K8s,可选)
└── _archive/      完结制品归档,`_archive/{type}/{YYYYMM}/{slug}/`
```

这个目录建议**入 git**——它是项目记忆,团队共享。

**检索**:制品的 frontmatter 带 `tags` / `summary` / `kind` 等字段,要找「这个 bug 以前修过吗」「有没有相关决策」,直接 `Grep` 扫这些字段就行,不需要额外的索引文件。

**归档**:`specs/` `fixes/` 只进不出会越攒越多。一个 spec 验收通过、功能上线后,或一个 fix 长期不再相关,就把它移到 `.ren-flow/_archive/{type}/{YYYYMM}/{slug}/`(`type` 与制品目录同名:specs / fixes / refactors / roadmap / notes),frontmatter 的 `status` 改成 `archived`。归档是手动动作——你说一句「把 X 归档」即可。这样活跃目录里只剩在做的事。

**两种形态**:上面是单仓库的样子。如果你是「一个文件夹下装多个项目」(多业务域工作区),`.ren-flow/` 会在 `specs/fixes/...` 上多套一层业务域:

```
.ren-flow/
├── attention.md          工作区级:域清单 + 跨域规则
├── journal/  inbox/       日志 / 收件箱,不分域,工作区共享
├── templates/             跨域脚手架,工作区共享(可选)
└── domains/
    ├── payment/           一个业务域一套
    │   ├── attention.md   该域的构建命令 / 栈约定
    │   └── arch/  specs/  fixes/  refactors/  roadmap/  requirements/  notes/  deploy/  _archive/
    ├── order/  ...
    └── user/   ...
```

`ren-init` 接入时自动判断你是单仓库还是工作区,选对形态建骨架。工作区模式下做事时 ren-flow 会先确认「这次属于哪个域」,把制品落到对应 `domains/{域}/` 下。

---

## 七、常见问题

**Q:feature 放哪?没有 features/ 目录?**
对,ren-flow 把 feature 的产物放在 `specs/`。一个 feature = 一个 spec 目录(含 spec.md + verify.md)。

**Q:前端 / 后端 / 客户端要用不同技能吗?**
不用。`ren-build` 角色无关,前后端客户端共用一套。各栈的差异(命名、构建命令、易错点)写在项目的 `.ren-flow/attention.md` 里,技能启动时读它。

**Q:改一个已有功能,走 spec 还是 fix?**
先分清:它现在表现**错了** → bug,走 `ren-fix`;它表现**没错,只是策略要变** → 需求变更,走 `ren-spec`。

**Q:小改动也要建文档吗?**
不要。30 分钟内、单文件、无跨模块影响的,直接说清楚让 AI 改。ren-flow 的原则是结构服务于速度。

**Q:monorepo 怎么办?`.ren-flow/` 放仓库根还是每个服务一份?**
看迭代时改动通常落在哪。各子服务独立开发、独立部署(大多数 monorepo 是这样)→ **每个子服务一份 `.ren-flow/`**,制品贴着服务走,互不干扰。整个仓库其实是一个内聚项目、只是物理分目录 → 根目录一份。`ren-init` 接入时检测到 monorepo 会主动问你。

**Q:ren-flow 和我项目里已有的其它工作流 / 技能冲突吗?**
功能上可能有重叠。建议选定 ren-flow 当主力后,把重叠的旧技能逐步退役,别让多套工作流长期并存——那是熵增。

---

## 八、记不住就记这一条

**有事先喊 `ren`,它会告诉你接下来该用哪个。**
