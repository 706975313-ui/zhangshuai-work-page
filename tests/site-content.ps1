$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$html = Get-Content -LiteralPath (Join-Path $siteRoot 'index.html') -Raw

function Assert-Contains([string]$Text, [string]$Needle, [string]$Message) {
    if (-not $Text.Contains($Needle)) { throw $Message }
}

Assert-Contains $html 'Android 2.6.9' 'Missing Android version label'
Assert-Contains $html 'road-maintenance-android-v2.6.9/road-maintenance-2.6.9.apk?updated=20260924' 'Missing Android download link'
Assert-Contains $html 'risheng-latest.zip?updated=20260924' 'Risheng download link is not current'
Assert-Contains $html 'templates/monthly-plan.xlsx' 'Missing monthly plan template link'

$androidImages = @(
    'assets/android-visual.png',
    'assets/android-issues.png',
    'assets/android-workbench.jpg'
)

foreach ($relativePath in $androidImages) {
    Assert-Contains $html $relativePath "Page does not reference Android image: $relativePath"
    if (-not (Test-Path -LiteralPath (Join-Path $siteRoot $relativePath))) {
        throw "Android image is missing: $relativePath"
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $siteRoot 'templates/monthly-plan.xlsx'))) {
    throw 'Monthly plan template file is missing'
}

$toolCardCount = ([regex]::Matches($html, 'class="tool-card"')).Count
if ($toolCardCount -ne 2) { throw "Expected 2 tool cards, found $toolCardCount" }

Write-Output 'Site content checks passed'
