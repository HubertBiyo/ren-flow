# ren-refactor · 重构记录格式与归档参考

> 何时读这份:阶段 3 写 refactor 记录、或重构稳定后要归档时。前面扫描 / 定方案不需要这份。

## refactor 记录格式

```markdown
---
doc_type: refactor
slug: {slug}
scope: {扫描范围一句话}
status: done | archived
tags: [关键词, 便于以后 Grep 检索]
done_at: YYYY-MM-DD
---

## 范围
扫了哪些、做了哪几条、明确没做哪几条(及理由)。

## 执行记录
每步:改了什么文件、怎么验证行为不变、结果。

## 偏离
执行中发现的方案外情况(无则写无)。
```

## 归档

refactor 完成上线、长期稳定后可归档:整目录**原名**移入 `_archive/refactors/{YYYYMM}/`,YYYYMM 取目录名日期所属月(工作区模式在 `domains/{域}/_archive/refactors/{YYYYMM}/`),frontmatter `status` 改 `archived`,补 `archived_reason`。
