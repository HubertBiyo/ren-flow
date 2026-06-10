# ren-log · journal 文件格式参考

> 何时读这份:实际写入 capture bullet 或 rollup 日报、需要确认排版与示例时。SKILL.md 的流程与大白话铁律已够判断「写什么」;这份给「长什么样」。

## capture 期（未 rollup）

```markdown
# 2026-05-21 (周四)

- 14:30 异常监控页改造:毫秒改秒、修滚动失效、三 tab 分页;抽 AdminPager 迁移 UserList。
- 18:05 启动新应用迭代:商城首页节点配置写入生产 node_config。
```

## rollup 后（结构化日报）

```markdown
# 2026-05-21 (周四)

## 🎯 今日重点 (Focus)

- [x] 后台 工作流配置完善、列表筛选调整
- [x] 商城 首页节点配置写入生产

## 📝 任务清单 (Tasks)

### 后台迭代

- [x] 规则配置页改造、国家配置调整
- [x] 新增多业务域工作区模式:.ren-flow/domains/{域}/ 分层

### 新应用接入

- [x] 商城 首页 node_config 新增节点写入生产

## 💡 备忘/会议 (Notes)

- 旧 docs/iterations/journal/ 成过期副本,待决定删除

## 🕐 原始记录 (Raw)

- 14:30 异常监控页改造……
- 18:05 启动新应用迭代……
```

## 格式要点

- 标题 `# {YYYY-MM-DD} ({周几})`
- 三节固定 emoji 标题:`🎯 今日重点 (Focus)` / `📝 任务清单 (Tasks)` / `💡 备忘/会议 (Notes)`
- 今日重点、任务清单条目用 `- [x]` checkbox;任务清单按 `###` 子标题分组
- 备忘、原始记录用普通 `- ` bullet
- 每条 capture bullet:`- HH:MM ` 开头,≤100 字
- **纯文字,不用 markdown 加粗** —— 这份常复制到 IM / 日报工具,加粗符号会带过去碍眼
