param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl,
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path "SKILL.md")) {
    throw "请在仓库根目录运行此脚本；当前目录未找到 SKILL.md。"
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "未检测到 Git。请先安装 Git for Windows。"
}

if (-not (Test-Path ".git")) {
    git init
}

git add .
$changes = git status --porcelain
if ($changes) {
    git commit -m "feat: publish cross-ai paper formatter skill"
}

git branch -M $Branch
$origin = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0 -and $origin) {
    git remote set-url origin $RepoUrl
} else {
    git remote add origin $RepoUrl
}

git push -u origin $Branch
Write-Host "已推送到 $RepoUrl"
