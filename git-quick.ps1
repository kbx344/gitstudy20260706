# Git Quick - 一键 git 提交推送小工具
# 用法: .\git-quick.ps1 "提交信息"

param(
    [string]$Message = ""
)

$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Git Quick - 快速提交推送" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 查看状态
Write-Host "`n[1/4] 当前状态:" -ForegroundColor Yellow
git status

# 如果没有变更，直接退出
$hasChanges = git status --porcelain
if (-not $hasChanges) {
    Write-Host "`n没有需要提交的变更，退出。" -ForegroundColor Green
    exit 0
}

# 2. 确认提交
if (-not $Message) {
    $files = (git diff --name-only) + (git ls-files --others --exclude-standard)
    $Message = "update: " + ($files -join ", ")
}

Write-Host "`n[2/4] 提交信息: $Message" -ForegroundColor Yellow

# 3. 暂存 + 提交
Write-Host "`n[3/4] 暂存并提交..." -ForegroundColor Yellow
git add .
git commit -m $Message

if ($LASTEXITCODE -ne 0) {
    Write-Host "提交失败！" -ForegroundColor Red
    exit $LASTEXITCODE
}

# 4. 推送
Write-Host "`n[4/4] 推送到远程..." -ForegroundColor Yellow
$branch = git branch --show-current
git push origin $branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  ✅ 推送成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "`n推送失败，请检查网络或权限。" -ForegroundColor Red
}
