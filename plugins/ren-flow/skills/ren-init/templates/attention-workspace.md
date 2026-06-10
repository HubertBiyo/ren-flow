# attention.md — ren-flow 工作区根

> 本文件是 ren-flow 工作区模式的根注意事项,各子技能每次启动都会读。
> 本工作区下有多个业务域,制品按域分层:`.ren-flow/domains/{domain}/specs|fixes|...`。
> 各域自己的构建命令、栈约定写在 `.ren-flow/domains/{domain}/attention.md`。

mode: workspace
domains: [{域1}, {域2}, {域3}]

## 工作区简介

{一句话:这个工作区装了哪些项目 / 业务}

## 域清单说明

| 域 | 对应代码位置 | 一句话职责 |
|---|---|---|
| {域1} | {路径} | {职责} |

> 新域用到时由技能现建 `.ren-flow/{新域}/`,并在上表和 `domains:` 补一行。

## 跨域通用规则

> 所有域都适用的硬约束:命名规则、git 约定、市场 / 语言约束等。各域特有的写到该域 attention。

- {如:所有上报字段值用英文 ASCII}
- {如:commit 格式 `{type}({scope}): {中文描述}`}

## 上下文压缩保留优先级（Compact Instructions）

> 触发自动压缩或手动 `/compact` 时，按此保留信息。工作区跨域，"当前在哪个域、哪个制品"尤其不能丢。

**必须完整保留：** 当前域 + 作业坐标（目录 / 分支 / 部署目标）、制品 slug 与进度及落点（`domains/{域}/specs|fixes/...`）、已对齐的接口字段与类型与时间戳单位、用户本会话的纠正与特例、未跑通的命令与报错原文及根因结论。
**可丢弃：** 读过没改的文件全文、已通过命令的完整输出、被否决方案的细节（各留一句结论）。

## journal

- `journal:` —— ren-log 日志落点。`.ren-flow`(默认,写工作区级 `.ren-flow/journal/`,不分域)/ `external`(已有别的日志系统,ren-log 让位)。本工作区:{`.ren-flow` 或 `external`}
