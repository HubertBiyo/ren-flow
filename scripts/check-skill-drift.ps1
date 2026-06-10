<#
.SYNOPSIS
  检查「对外发行源」与「本地运行副本」两份 ren-* 技能是否漂移。

.DESCRIPTION
  ren-flow 的技能可能同时存在两处:
    - 发行源(本仓库):  plugins/ren-flow/skills/ren-*/
    - 本地运行副本:    <workspace>/.claude/skills/ren-*/(若你把技能复制 / 链接到了本地)
  两份必须逐字一致。本脚本递归比对
  每个 ren-* 技能目录下所有文件的内容(SHA256),报告:
    - 内容不一致的文件
    - 只在一侧存在的文件 / 技能
  有任何漂移则以退出码 1 结束,便于挂 CI 或提交前自检。

.PARAMETER LocalSkillsDir
  本地运行副本目录。默认按本仓库所处工作区推断为 <workspace>/.claude/skills。

.EXAMPLE
  pwsh ./scripts/check-skill-drift.ps1
  pwsh ./scripts/check-skill-drift.ps1 -LocalSkillsDir C:\path\to\workspace\.claude\skills
#>
param(
    [string]$LocalSkillsDir
)

$ErrorActionPreference = 'Stop'

# 发行源:相对脚本位置(scripts/ 的上一级是仓库根)
$repoSkillsDir = Join-Path $PSScriptRoot '..\plugins\ren-flow\skills' | Resolve-Path | Select-Object -ExpandProperty Path

# 本地副本:默认推断 = 仓库所在工作区根(scripts/../../..)下的 .claude/skills
if (-not $LocalSkillsDir) {
    $workspaceRoot = Join-Path $PSScriptRoot '..\..\..' | Resolve-Path | Select-Object -ExpandProperty Path
    $LocalSkillsDir = Join-Path $workspaceRoot '.claude\skills'
}

Write-Host "发行源 : $repoSkillsDir"
Write-Host "本地副本: $LocalSkillsDir"
Write-Host ('-' * 60)

if (-not (Test-Path $LocalSkillsDir)) {
    Write-Host "本地副本目录不存在,跳过(可能未铺设本地运行副本): $LocalSkillsDir" -ForegroundColor Yellow
    exit 0
}

# 收集某目录下所有 ren-* 技能的「相对路径 -> 内容哈希」映射
function Get-SkillFileMap([string]$root) {
    $map = @{}
    Get-ChildItem -Path $root -Directory -Filter 'ren*' -ErrorAction SilentlyContinue | ForEach-Object {
        $skill = $_.Name
        $skillRoot = $_.FullName
        Get-ChildItem -Path $skillRoot -Recurse -File | ForEach-Object {
            $relFromSkill = $_.FullName.Substring($skillRoot.Length).TrimStart('\', '/') -replace '\\', '/'
            $rel = "$skill/$relFromSkill"
            $map[$rel] = (Get-FileHash -Path $_.FullName -Algorithm SHA256).Hash
        }
    }
    return $map
}

$repoMap  = Get-SkillFileMap $repoSkillsDir
$localMap = Get-SkillFileMap $LocalSkillsDir

$drifted    = [System.Collections.Generic.List[string]]::new()
$onlyInRepo = [System.Collections.Generic.List[string]]::new()
$onlyInLocal= [System.Collections.Generic.List[string]]::new()

foreach ($rel in $repoMap.Keys) {
    if (-not $localMap.ContainsKey($rel)) { $onlyInRepo.Add($rel) }
    elseif ($repoMap[$rel] -ne $localMap[$rel]) { $drifted.Add($rel) }
}
foreach ($rel in $localMap.Keys) {
    if (-not $repoMap.ContainsKey($rel)) { $onlyInLocal.Add($rel) }
}

$hasDrift = ($drifted.Count + $onlyInRepo.Count + $onlyInLocal.Count) -gt 0

if (-not $hasDrift) {
    Write-Host "✓ 两份完全一致($($repoMap.Count) 个文件)" -ForegroundColor Green
    exit 0
}

if ($drifted.Count)     { Write-Host "✗ 内容不一致 ($($drifted.Count)):" -ForegroundColor Red;    $drifted     | ForEach-Object { Write-Host "    $_" } }
if ($onlyInRepo.Count)  { Write-Host "✗ 只在发行源 ($($onlyInRepo.Count)):" -ForegroundColor Red;  $onlyInRepo  | ForEach-Object { Write-Host "    $_" } }
if ($onlyInLocal.Count) { Write-Host "✗ 只在本地副本 ($($onlyInLocal.Count)):" -ForegroundColor Red; $onlyInLocal | ForEach-Object { Write-Host "    $_" } }

Write-Host ''
Write-Host '修复:以发行源为准,把差异同步到本地副本(或反向),使两份逐字一致。' -ForegroundColor Yellow
exit 1
