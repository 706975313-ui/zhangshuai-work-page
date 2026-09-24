$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot

function Assert-FileContains([string]$Path, [string]$Needle) {
    if (-not (Test-Path -LiteralPath $Path)) { throw "Missing file: $Path" }
    $content = Get-Content -LiteralPath $Path -Raw
    if (-not $content.Contains($Needle)) { throw "Missing '$Needle' in $Path" }
}

$androidAsset = Join-Path $siteRoot 'release-assets/road-maintenance-2.6.9.apk'
if (-not (Test-Path -LiteralPath $androidAsset)) { throw 'Missing Android release asset' }
if ((Get-Item -LiteralPath $androidAsset).Length -ne 10437889) { throw 'Android release asset size mismatch' }

$androidWorkflow = Join-Path $siteRoot '.github/workflows/publish-road-maintenance-android.yml'
Assert-FileContains $androidWorkflow 'road-maintenance-android-v2.6.9'
Assert-FileContains $androidWorkflow 'road-maintenance-2.6.9.apk'

$rishengWorkflow = Join-Path $siteRoot '.github/workflows/publish-risheng-20260924.yml'
Assert-FileContains $rishengWorkflow 'release-parts/risheng-20260924.zip.part011'
Assert-FileContains $rishengWorkflow 'risheng-latest-v1'

1..11 | ForEach-Object {
    $part = Join-Path $siteRoot ('release-parts/risheng-20260924.zip.part{0:D3}' -f $_)
    if (-not (Test-Path -LiteralPath $part)) { throw "Missing Risheng package part: $part" }
}

Write-Output 'Release configuration checks passed'
