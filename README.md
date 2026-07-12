# ruc-paper-formatter-cn
这是一个面向中文课程论文、比赛论文和一般投稿稿件的 DOCX 排版包，以《中国人民大学学报》的主要体例为默认基线，并支持用户在本次对话中提出局部覆盖要求。
主要能力
统一 A4 页面、页边距、字体、字号、行距、缩进和页码；
统一主标题、副标题、作者信息、摘要、关键词和章节层级；
使用 `一、—（一）—1.—（1）` 标题体系，并清除重复编号；
检查中文自然语言中的直双引号并改为 `“”`；
读取真实 Word 脚注、手工角标、图表题注和交叉引用；
将可确认的手工角标转换为真实脚注，并在低置信度时写入报告；
原稿已有参考文献时保留并从“参考文献”处另起一页；
中文摘要或关键词完全缺失时，可依据全文补全并标明 AI 生成内容；
可选添加中国人民大学校名标志页眉，默认关闭；
输出排版后的 DOCX 和只包含结论、AI 生成内容、人工复核项的简明报告。
兼容模式
A. 支持 `SKILL.md` 且能运行 Python 的智能体
可获得完整能力。将整个 `ruc-paper-formatter-cn` 文件夹安装到该智能体的技能目录，或放入其可访问的工作区，然后安装：
```bash
python -m pip install -r scripts/requirements.txt
```
让智能体先读取 `SKILL.md`，再处理 DOCX。
B. Gemini Gems、普通聊天机器人等不能直接运行技能脚本的平台
使用“提示词 + 本地执行器”模式：
按 `platforms/gemini/README.md` 或 `platforms/generic/README.md` 配置助手；
本地运行 `portable_workflow.py prepare`，生成可上传给 AI 的文本、清单和计划骨架；
让 AI 完成 `plan.json`；
本地运行 `portable_workflow.py apply` 生成最终 DOCX。
C. 仅支持文本指令、无法写入二进制 DOCX 的平台
可用于内容审计、角色识别、摘要补全和生成 `plan.json`，但不能保证直接返回完成排版的 DOCX。此时必须使用本包的本地执行器完成最后写入。
便携命令
准备 AI 任务包：
```bash
python scripts/portable_workflow.py prepare input.docx --job-dir paper_job
```
AI 修改 `paper_job/plan.json` 后，执行排版：
```bash
python scripts/portable_workflow.py apply input.docx --job-dir paper_job --output output_formatted.docx
```
单独验证：
```bash
python scripts/portable_workflow.py verify output_formatted.docx --out verify.json
```
规则优先级
用户在当前任务中的明确要求；
用户提供的课程、比赛或投稿模板；
本包的默认规范。
仅覆盖用户明确改变的项目，其余项目继续使用模板或默认规范。
人大页眉
默认不添加。用户明确要求时启用。该功能使用居中行内图片和页眉段落下边框，避免 Tab、文本框和浮动对象导致 Word/WPS 版式漂移。
重要限制
只有能运行 Python 且能读写本地文件的宿主，才能完整执行 DOCX 修改和验证；
Gemini Gem、普通网页聊天等平台通常需要配合本地执行器；
WPS、Word 和其他渲染引擎可能存在轻微分页差异，必须以用户最终打开环境进行复核；
本项目非中国人民大学或《中国人民大学学报》官方工具，详见 `BRANDING_NOTICE.md`。
