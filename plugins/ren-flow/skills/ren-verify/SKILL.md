---
name: ren-verify
description: 交付验收 —— 逐条核对规格的验收契约，运行命令收集证据，判断这次改动能不能交。触发：用户说「验收」「能提交了吗」「做完了」「检查一下交付」，或 ren-build 实现完成后进入。
---

# ren-verify

## 启动必读

先 `Read .ren-flow/attention.md` 拿构建 / 测试 / 检查命令。

**工作区模式**（根 `attention.md` 标 `mode: workspace`）：verify 记录跟随对应 spec，落在 `.ren-flow/domains/{domain}/specs/...`；构建 / 测试命令读对应域的 `.ren-flow/domains/{domain}/attention.md`。

## 这个技能干什么

ren-build 说「实现完了」不等于「能交了」。ren-verify 独立核对:**规格的验收契约逐条满足了吗?证据呢?** 侧重「能不能跑通、符不符合契约」,不是「代码好不好看」(那是 `ren-review`)。

产出一份 `{slug}-verify.md` 落在该 spec 目录下,作为交付凭证。

**铁律**:未在本轮对话中**实际执行**验证命令并阅读完整输出,**不得**声称成功——证据先于结论,无例外。

**常见反借口**(都不算证据):

| 声称 | 不够的理由 | 真正的证据 |
|---|---|---|
| 测试过了 | "上一轮跑过""应该过" | 本轮 test 命令输出 + 0 failed |
| Lint 干净 | "改的地方没动 lint 配置" | lint 命令输出 + 0 errors |
| 构建 OK | "日志看着没问题" | build 命令 exit 0 |
| Bug 修了 | "代码改了就应该好了" | 原复现步骤跑一遍 + 现象消失 |

## 流程

### 1. 接规格

`Glob .ren-flow/specs/` 找到对应 `{slug}-spec.md`,读第 3 节「验收契约」和第 1 节「明确不做什么」。无规格(快路 / 小改动)→ 让用户口述验收点,或直接核对改动是否达成目标。

### 2. 逐条核对验收契约

规格第 3 节每一条「输入 / 触发 → 期望结果」,逐条验证:

- 能跑命令验证的 —— 跑(单测 / 构建 / 接口调用),贴**真实输出**作证据
- 不能自动验证的 —— 说明需要人工怎么验,别假装验过

**正常 + 边界 + 错误三类都要碰**,不能只验 happy path。

### 3. 反向核对「明确不做」

规格说了不做的东西,确认这次真没做进去 —— Vibe Coding 下 AI 容易顺手多做。

### 4. 跑交付检查

attention.md 里的构建、静态检查、相关测试 —— 跑一遍,收集结果。**失败就如实报失败并贴输出**,不掩盖、不跳过。

该 spec 若有 `{slug}-release.md`,逐项核对上线物料是否可执行:发哪些服务、配置中心 key / 值、调度任务、DB 脚本(含执行序与回滚)—— 缺漏或写不清的回 `ren-build` 补,不在 verify 里替它填。

### 5. 写 verify 记录并定论

```markdown
---
doc_type: verify
slug: {slug}
status: pass | fail | partial
verified_at: YYYY-MM-DD
---

## 验收契约核对
| 契约条目 | 验证方式 | 结果 | 证据 |
|---|---|---|---|

## 交付检查
构建 / 检查 / 测试命令的真实输出摘要。

## 结论
pass —— 可交付 / fail —— 待修(列问题)/ partial —— 部分通过(列哪些没过、是否阻塞)
```

定论必须基于证据。没验通的不许写 pass。

## 反向沉淀 requirements(按需,不是每次必做)

**先判要不要做**:本次交付的是「要长期反复改 / 多人会反复核对」的**核心能力**吗?是 → 沉淀;**日常小 spec 不回填** —— spec 自身的验收契约 + 归档已是凭证,再写一份 requirements 是重复劳动。

为什么核心能力要单独留:spec 是一次性设计、验收后会归档,能力的精确业务口径(算法、状态判定、操作时序)需要一个**不随归档消失的长期落点**,这就是 `requirements/{module}/{slug}.md`。

要做时,收尾提示用户走这步,核心标准三条(详细写法见项目 `requirements/` 目录约定):**rebuild-grade**(据此能重建代码 + 逐条核业务逻辑)、**不留「见代码」黑洞**(细节要么 inline 写精确、要么链 `arch/openapi` `arch/schemas` 或模块共享 doc `requirements/{module}/_{topic}.md`)、**同步本模块 `_rtm.md`**(需求↔字段↔接口)。

## 与其他技能的边界

- 不改代码 —— 发现问题列出来,回 `ren-build` 修;是 bug 性质走 `ren-fix`
- 不做代码质量评审 —— 那是 `ren-review`(规范 / 架构 / 可维护性)
- 验收通过后,值得沉淀的坑提示 `ren-note`,要提交提示 `ren-ship`
- 验收 pass → 把 spec frontmatter `status` 改 `done`(「可归档」信号)。已上线 / 用户确认完结的**当场归档**(见下方「归档布局」);暂不归档的留给下次 `ren-spec` 开新时的熵增闸门批量收 —— 别让完结 spec 长期堆在 `specs/`

## 退出条件

- [ ] 规格验收契约每条都有验证结果 + 证据
- [ ] 正常 / 边界 / 错误三类都核对过
- [ ] 「明确不做」已反向核对
- [ ] 构建 / 检查 / 测试命令已跑,结果如实记录
- [ ] 若本次动了对外接口且该域维护 `arch/openapi/{slug}.openapi.json` —— 契约文件已同步(Apifox 可导入联调)
- [ ] 若有 `{slug}-release.md` —— 上线物料逐项已确认可执行(发服务 / 配置中心 / 调度 / DB 脚本含执行序与回滚)
- [ ] **若本次是需长期维护的核心能力** —— 已提示 / 已沉淀到 `requirements/{module}/` 并更新 `_rtm.md`;日常小 spec 不强制(spec 验收契约 + 归档即凭证)
- [ ] `{slug}-verify.md` 已落盘,结论有证据支撑
- [ ] 验收 pass 的 spec 已标 `status: done`(确认完结的已归档)

## 归档布局

通用规则:**整目录原名移入 `_archive/{type}/{YYYYMM}/`**,`YYYYMM` 取目录名日期所属月(如 `specs/2026-06-01-foo/` → `_archive/specs/202606/2026-06-01-foo/`)—— 按制品类型分层 + 月份子目录。

- 单仓库模式:`.ren-flow/_archive/{type}/{YYYYMM}/{原目录名}/`
- 工作区模式:`.ren-flow/domains/{域}/_archive/{type}/{YYYYMM}/{原目录名}/`

`type` 取值与制品目录同名:`specs` / `fixes` / `refactors` / `roadmap` / `notes`。归档时一并把 frontmatter `status` 改 `archived`,补 `archived_reason` 说明为何归档(完结上线 / 排查后非 bug / 废弃方案等)。制品目录只放**在途**制品 —— 完结即归,由本技能收尾当场做,或 `ren-spec` 开新闸门批量收。

## 容易踩的坑

- 只验 happy path,不碰边界和错误
- 没跑命令就写「通过」 —— 结论必须有证据
- 测试失败了含糊带过 —— 必须如实报 + 贴输出
- 顺手改代码 —— 验收和修复要分开,改了再验才算数
- 把代码风格问题当验收项 —— 那是 ren-review 的范围
