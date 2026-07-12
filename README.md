# ruc-paper-formatter-cn

面向中文课程论文、比赛论文和一般投稿论文的 DOCX 排版 Skill。默认格式以《中国人民大学学报》体例为基础，并针对课程论文和比赛论文场景作了适配；它不是官方投稿模板，用户的明确要求和所上传模板优先。

> 非官方声明：本项目为个人开发的非官方工具，与中国人民大学及《中国人民大学学报》编辑部不存在隶属、授权或合作关系。

## 核心功能

- 仅处理 `.docx`，输出排版后的 DOCX 和简明报告；
- 统一 A4 页面、页边距、字体、字号、行距、缩进和页码；
- 统一主标题、副标题、作者信息、摘要、关键词及 `一、`、`（一）`、`1.`、`（1）` 标题层级，并消除重复编号；
- 处理 Word/WPS 常见的标题窜行、重复列表编号与隐藏制表符；
- 将中文正文、标题、摘要和关键词中的直双引号转换为中文引号 `“”`；
- 支持真实 Word 脚注、可确认的手工角标转换、`SEQ` 图表题注、`REF` 交叉引用，以及“脚注引用 + 文末参考文献表”并存；
- 将摘要与关键词分别规范为 `［摘要］摘要正文`、`［关键词］关键词1；关键词2；关键词3` 的同段形式；
- 仅在中文摘要或关键词完全缺失时，依据全文生成补全建议，并在报告中标明 AI 生成内容；
- 将已有“参考文献”标题设为独立分页；
- 可选添加中国人民大学校名标志页眉，默认关闭。

默认报告只说明：是否完成、是否存在 AI 生成内容、是否仍需人工处理，以及具体人工处理事项。

## 默认格式与优先级

默认规范以《中国人民大学学报》格式为基础，但经过课程论文和比赛论文适配。优先级依次为：

1. 本次任务中的明确要求；
2. 用户上传的课程、比赛或投稿模板；
3. 本项目默认规范。

人大校名标志页眉是可选功能，默认关闭；使用时请自行确认场景是否符合学校标识管理、比赛或投稿要求。详见 [BRANDING_NOTICE.md](BRANDING_NOTICE.md)。

## 安装与使用

先下载 Release 中的 `skill.zip`，解压后得到唯一的 `ruc-paper-formatter-cn/` Skill 目录。需要本地执行脚本时，在该目录运行：

```bash
python -m pip install -r scripts/requirements.txt
```

### ChatGPT

在支持上传或管理自定义 Skill 的 ChatGPT 工作区上传 `skill.zip`（或按该工作区的 Skill 导入界面选择已解压目录）。上传论文后，让助手先读取 `SKILL.md` 再执行排版。若该工作区不能运行 Python，则按“通用 AI”模式生成计划并在本地完成写入。

### Codex

将已解压的 `ruc-paper-formatter-cn/` 放到**当前项目工作区**或 Codex 可访问的临时目录中，让 Codex 读取其中的 `SKILL.md`。本项目不会安装、覆盖或自动修改任何本地 AI Skill 目录。

### Gemini、WorkBuddy、Claude 和其他 AI

- Gemini：遵循 [platforms/gemini/README.md](platforms/gemini/README.md)；
- WorkBuddy：遵循 [platforms/workbuddy/README.md](platforms/workbuddy/README.md)；
- Claude：遵循 [platforms/claude/README.md](platforms/claude/README.md)；
- 其他 AI：使用 [platforms/generic/README.md](platforms/generic/README.md) 与 [platforms/generic/MASTER_PROMPT.md](platforms/generic/MASTER_PROMPT.md)。

这些平台若无法直接读写二进制 DOCX，可用本地执行器完成最后写入：

```bash
python scripts/portable_workflow.py prepare input.docx --job-dir paper_job
python scripts/portable_workflow.py apply input.docx --job-dir paper_job --output output_formatted.docx
python scripts/portable_workflow.py verify output_formatted.docx --out verify.json
```

外部 AI 能否直接执行 Python 脚本取决于该平台权限。

## 提问示例

- 使用这个 Skill 修改我上传的论文，全部按默认规范处理。
- 按默认规范排版，并添加人大校名标志页眉。
- 正文改为小四号，其余采用默认规范。
- 按我上传的比赛模板排版，模板未说明部分采用默认规范。

## 已知限制

- WPS 与 Word 可能存在少量分页差异；
- 复杂公式、复杂表格和关系不明的引用可能需要人工复核；
- 外部 AI 是否可以直接执行 Python 脚本取决于平台权限。

## 反馈

请通过 GitHub Issues 反馈问题，并附上已脱敏的最小复现 DOCX、平台/Word/WPS 版本、操作步骤及预期结果。不要上传真实课程论文、姓名、学号或其他个人信息。
