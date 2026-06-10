# ren-fix · 修复记录格式与归档参考

> 何时读这份:阶段 3 写 fix 记录、或修复稳定后要归档时。前面定位根因不需要这份。

## fix 记录格式

```markdown
---
doc_type: fix
slug: {slug}
severity: high | mid | low
status: fixed | archived
tags: [关键词, 便于以后 Grep 检索]
summary: {一句话:什么坏了}
fixed_at: YYYY-MM-DD
---

## 现象
观察到什么 + 复现步骤 + 影响范围。

## 根因
真正的原因,定位到 file:line。试过但排除的假设也写。

## 修复
改了什么、为什么这样改、改动范围。

## 验证
怎么确认修好了(贴复现步骤的前后对比)。
```

快路也要出这份记录,只是「现象 / 根因」两节可以简短。

## 归档

fix 修复完上线一段时间稳定、或排查后确认非 bug,可归档:

- 路径:整目录**原名**移入 `_archive/fixes/{YYYYMM}/`,YYYYMM 取目录名日期所属月(工作区模式在 `domains/{域}/_archive/fixes/{YYYYMM}/`)
- frontmatter `status` 改 `archived`,补一行 `archived_reason` 说明缘由(已上线 / 非 bug / 转 spec 等)
