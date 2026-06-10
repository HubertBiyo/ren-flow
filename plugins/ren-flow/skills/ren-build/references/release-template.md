# ren-build · 上线物料清单（release.md）参考

> 何时读这份:本次改动涉及**代码之外的上线动作**(发服务 / 改配置中心 / 加调度任务 / 跑 DB 脚本)、要产出 `{slug}-release.md` 时。纯代码、无上线副作用的改动跳过本产物,不用读。

在该 spec 目录产出 `{slug}-release.md` —— 把这些动作收成一份可执行清单:上线照着做、verify 照着核、ship 附进 PR。模板(无的块写「无」,别留空占位):

```markdown
---
doc_type: release
slug: {slug}
status: pending | shipped
---
## 发布服务
- `{repo / 子应用}` —— {改了什么、为何要发}
## 配置中心变更
- AppId `{appId}` · key `{key}` = `{值}` · {新增 / 改} · {作用}
## 调度任务
- {job 名} · cron `{表达式}` · 所属 `{子应用}` · {开关 / 配置项}
## DB 脚本
- {建索引 / 迁移 / 补数} · 集合 `{collection}` · 执行序 {n} · 回滚 {方式}(建索引类执行后回写 `arch/indexes/{collection}.md`)
## 接口契约
- 指向 `arch/openapi/{slug}.openapi.json`(已发布到 `.ren-flow/openapi/` 供 Apifox 拉取)
```

字段骨架到此为止;**具体填法(AppId 命名规律、调度部署位置、容器平台 / 网关 发布步骤、谁建索引)以项目 `attention.md`、域级 `deploy/`(常驻上线全景)及 `notes/` 下的发布步骤清单为准** —— 不把某项目的内情写进通用技能。release.md 只记本 spec 的上线增量,引用 `deploy/` 里对应应用节(域级常驻清单与本产物分工见 `ren-init` 的 `deploy/` 说明)。
