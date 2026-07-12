# GitHub 发布说明

## 推荐仓库

- 仓库名：`ruc-paper-formatter-cn`
- 仓库根目录应直接包含 `SKILL.md`、`README.md`、`scripts/`、`references/` 等文件。
- `dist/skill.zip` 是面向普通用户的安装包，可作为 GitHub Release 附件发布。

## 首次发布

1. 在 GitHub 创建一个空仓库，不要预先生成 README、`.gitignore` 或许可证。
2. 解压本仓库包并进入目录。
3. 运行以下任一脚本：

```powershell
.\publish_to_github.ps1 -RepoUrl "https://github.com/<用户名>/ruc-paper-formatter-cn.git"
```

或：

```bash
bash publish_to_github.sh "https://github.com/<用户名>/ruc-paper-formatter-cn.git"
```

4. 在 GitHub 仓库页面创建 Release，建议标签为 `v1.0.0`，并上传 `dist/skill.zip`。

## 发布前检查

```bash
python -m pip install -r scripts/requirements.txt
python scripts/test_formatter.py
python scripts/test_citations.py
```

## 重要说明

- 不要上传包含姓名、学号或未脱敏论文的测试文件。
- 本项目不是中国人民大学或《中国人民大学学报》官方工具。
- `assets/ruc-header-logo.png` 仅作为用户明确要求时启用的可选素材；公开传播前请自行确认相关标志使用要求。
- 仓库当前未预设开源许可证。公开发布前应根据传播方式选择合适许可证。
