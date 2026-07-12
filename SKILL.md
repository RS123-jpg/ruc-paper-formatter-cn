---
name: ruc-paper-formatter-cn
description: format and validate chinese academic papers in docx across agent runtimes for course assignments, competitions, general submissions, and journal-style manuscripts. use when an ai host needs to unify layout, apply renmin university journal-based formatting, standardize fonts, headings, abstracts, keywords, footnotes, figures, tables, references, or cross-references, optionally add the renmin university header, complete a missing chinese abstract or keywords, and return a formatted docx plus a concise modification report. support full agent execution when python and filesystem tools are available, and plan-plus-local-runner fallback otherwise. honor explicit formatting instructions from the current task before applying defaults. preserve existing substantive content except for explicitly permitted completion of missing abstract or keywords.
---

# 中文论文统一排版

## 首次调用说明

当用户首次调用、询问功能、只输入技能名称，或尚未上传 DOCX 时，先输出以下说明，不执行排版：

> **中文论文统一排版已启用。**
>
> 本 Skill 以《中国人民大学学报》格式为基础，适用于课程论文、比赛论文和一般投稿稿件。可统一页面、字体字号、标题层级、摘要与关键词、中文引号、脚注、图表、参考文献和交叉引用；当中文摘要或关键词完全缺失时，可依据全文补全，并在报告中明确标注 AI 生成内容。
>
> **中国人民大学校名标志页眉为可选项，默认不添加。**
>
> 典型提问方式：
> - “使用这个 Skill 修改我上传的论文，全部按默认规范处理。”
> - “按默认规范排版，并添加人大校名标志页眉。”
> - “正文改为小四号，其他项目按默认规范处理。”
> - “按我上传的比赛模板排版，模板未说明的部分按默认规范处理。”
>
> 请上传 `.docx` 文件。处理完成后返回排版稿和简明修改报告。

用户已上传 DOCX 并明确要求排版时，直接执行，不重复欢迎说明。


## 跨平台使用

本目录同时提供 `README.md`、`platforms/` 和 `scripts/portable_workflow.py`。宿主能够读取文件并运行 Python 时，直接执行本 SKILL；宿主不能执行脚本时，改用 `platforms/generic/MASTER_PROMPT.md` 或对应平台说明，让模型生成 `plan.json`，再用本地执行器写入 DOCX。不得把“生成排版计划”表述成“已经生成最终 DOCX”。

## 输入、输出与内容边界

只处理 `.docx`。每次返回：

1. `<原文件名>_formatted.docx`
2. `<原文件名>_format_report.md`

不得改写已有正文、数据、结论、引文、摘要、关键词或参考文献文字。仅当中文摘要或中文关键词完全缺失时，允许依据全文补全。保留原有粗体、斜体、上下标、下划线等有意义的局部强调。

修改报告只回答：

- 是否全部完成；
- 是否存在 AI 生成内容；
- 是否仍需手动处理，以及具体问题。

不得向用户输出段落数量、字段数量、脚本统计或内部检查清单。

## 规则优先级

先读取 [references/format-standard.md](references/format-standard.md)，再按以下顺序生成有效规范：

1. 当前消息及同一对话中对本次文档提出的明确要求；
2. 用户上传的课程、比赛或投稿模板；
3. 本 Skill 默认规范。

采用局部覆盖。用户只修改某个项目时，仅覆盖该项目，其余继续执行模板或默认规范。用户仅说“调用这个 Skill 修改”时，完整执行默认规范，不再次询问。

不可被覆盖的质量底线：不擅自改写内容；必须完成结构验证、内容完整性检查、字体与引号检查、交叉引用检查和页面复核。

## 默认规范要点

- 标题编号：`一、` → `（一）` → `1.` → `（1）`；删除自动列表编号和重复前缀。
- 摘要与关键词：`［摘要］正文`、`［关键词］词1；词2；词3`，标签与内容同段。
- 中文自然语言中的直双引号统一为 `“”`；代码、URL、JSON、XML、命令、公式和单位符号仅保护对应局部片段。
- 默认采用学报式注释体例：正文右上角脚注标记，出处置于当页页底；每处引用保留为真实 Word 脚注。
- 手工圈码或上标数字优先转换为真实脚注；低置信度可先转换，但必须在报告中标明。
- 图表题注使用 `SEQ`，正文引用使用 `REF`。
- 原稿已有文末参考文献时保留，并从“参考文献”标题处另起一页。
- 人大校名标志页眉默认关闭；用户明确要求时使用内置素材添加。

## 执行工作流

### 1. 检查输入与模板

只接受 DOCX。若用户同时上传模板，运行：

```bash
python scripts/extract_template_profile.py TEMPLATE.docx --out template_profile.json
```

提取当前对话中的明确格式覆盖项，并写入 `plan.json` 的 `request_overrides`；同时映射到实际执行字段，不得只记录而不执行。

### 2. 检查文档并生成计划

```bash
python scripts/inspect_docx.py INPUT.docx --out inventory.json
```

复核标题、作者、摘要、关键词、正文层级、图表题注、脚注、手工角标、表格和参考文献区域。逐表选择：

- `three_line`：普通数据表；
- `standard`：简单完整框线表；
- `preserve`：复杂合并表、问卷表、表单、多层表头、含图片或公式的表。

计划结构见 [references/plan-schema.md](references/plan-schema.md)。不确定的段落使用 `no_change`，不得猜测。

### 3. 补全缺失摘要或关键词

仅在完全缺失时执行。读取 [references/content-completion.md](references/content-completion.md)。摘要必须附原文证据段落；数字、方法和结论必须能在原稿中找到。已有摘要或关键词只调整格式，不润色、不覆盖。

### 4. 执行排版

```bash
python scripts/format_academic_docx.py \
  INPUT.docx OUTPUT_formatted.docx \
  --plan plan.json \
  --report OUTPUT_format_report.md
```

必须完成：页面与字体、前置区居中、标题层级、摘要关键词同段、中文引号、脚注与手工角标、图表题注与交叉引用、逐表处理、参考文献独立分页、可选人大页眉、WPS 兼容性稳定化、内容不变性和对象数量检查。

任何内容完整性、字段断链、字体或引号门禁失败时，不得交付输出稿。

### 5. 独立验证

```bash
python scripts/verify_formatted_docx.py OUTPUT_formatted.docx --out verify.json
```

验证失败时停止交付并修复。

### 6. 页面复核

优先使用运行环境可用的 DOCX 渲染工具。可运行：

```bash
python scripts/render_docx_local.py OUTPUT_formatted.docx --output_dir render_out --emit_pdf --engine auto
python scripts/qa_rendered_pages.py render_out --out render_qa.json
```

打开全部页面检查：标题、作者和副标题居中；无重复标题编号；摘要关键词同段；字体、分页、图表、脚注、页码和参考文献位置正常；启用人大页眉时标志居中且横线连续；不存在未找到引用源或未受保护的英文直双引号。

若当前运行环境无法实际调用 WPS，不得声称已通过 WPS 实机验证。仍须完成 OOXML 兼容性检查和可用渲染引擎检查；仅在检测到本地兼容风险时，才在简明报告中要求用户手动复核对应位置。

### 7. Skill 自身回归测试

修改本 Skill 后运行：

```bash
python scripts/test_formatter.py
python scripts/test_citations.py
```

两项测试均通过后再打包。

## 交付限制

- 不交付 inventory、plan、渲染 PNG 或 PDF，除非用户明确要求。
- 不声称参考文献书目信息已完全符合 GB/T 7714；默认仅统一外观并审计明显缺项。
- 无法建立可靠映射的 `[1]`、著者—年份式引文、“同注”或复杂公式编号，只报告，不凭空生成出处。
- 脚注到文末书目的内部链接必须保持黑色、无下划线。
- 人大校名标志页眉仅在用户明确要求或模板明确包含时添加。
