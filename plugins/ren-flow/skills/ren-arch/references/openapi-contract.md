# ren-arch · openapi/ 接口契约文件参考

> 何时读这份:本次是「导出接口到 Apifox / 生成 OpenAPI / 更新接口契约文件 / 接口要给前端联调」类任务。日常刷新 / 体检 ARCHITECTURE.md 不需要这份。

`openapi/{slug}.openapi.json` 是**手工编排**的 OpenAPI 3.x 契约,目的是**一键导入 Apifox**(导入数据 → OpenAPI → 选文件 / URL)给联调和测试用,免去手搓请求。

- 内容质量优先于全覆盖:按**调用顺序**组织 tags、写清每个接口的前置依赖、鉴权 header(如网关注入的 `x-userid`)、统一返回包裹(`{ code, msg, data }`),`servers` 用占位变量(导入后按环境改)。
- 来源:动态路由 / 动态 WebApi 的服务,运行时 swagger 常没开,且自动 dump 容易和真实路由对不上;**手工维护 + 按真实代码核对**比 swagger dump 更可靠可读。
- 维护时机:`ren-build` 新增 / 改动接口后同步更新本文件;`ren-verify` 收尾核对是否同步。
- 不强制建,仅当接口要交给前端 / 测试 / 跨团队联调时才有价值。

## 发布到集中契约仓库（供 Apifox 定时拉取）

各域的 `arch/openapi/{slug}.openapi.json` 是**编写源**;Apifox 的「Git 仓库」数据源拉的是一个**集中、扁平、独立 git 的发布面** —— `.ren-flow/openapi/`(与 `domains/` 同级)。两者**分散编写、集中发布**:

```
.ren-flow/
├── domains/{domain}/arch/openapi/{slug}.openapi.json   编写源(本技能产出)
└── openapi/                                              发布面(独立 git repo,Apifox 指这里)
    └── {slug}.openapi.json                               从各域收集而来的扁平副本
```

生成 / 改动某域的 `arch/openapi/{slug}.openapi.json` 后,**同步发布**:

1. 拷贝到 `.ren-flow/openapi/{slug}.openapi.json`(扁平,文件名带域前缀,如 `order-service.openapi.json`)
2. 在 `.ren-flow/openapi/` 内 `git add / commit / push`(这是独立 repo,**一个仓库容纳所有域**的契约,推到你们团队的集中契约仓库,如 `api-contracts`;Apifox 每个域建一个数据源、各指向该仓库对应文件)
3. Apifox 按其频率(如每 3 小时)自动拉取 —— 方向单向 Git → Apifox,Apifox 内手改会被覆盖

注意:`.ren-flow/openapi/` 是嵌在工作区里的**独立 git 仓库**,只跟踪契约文件本身;别把它当成 `.ren-flow/` 父仓库的一部分提交。
