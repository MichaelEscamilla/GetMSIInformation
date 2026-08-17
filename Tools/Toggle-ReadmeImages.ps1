<#
.SYNOPSIS
    Toggles README.md image references between local relative paths and absolute GitHub raw URLs.

.DESCRIPTION
    The published README uses absolute raw.githubusercontent.com URLs so images render everywhere
    (GitHub, PowerShell Gallery, external embeds). Those URLs point at the committed 'main' branch,
    so local/uncommitted image edits won't show in a preview.

    Run with -Mode Local to rewrite the image links to relative paths (./Images/...) so a local
    Markdown previewer shows your working-copy images. Run with -Mode Absolute (or before committing)
    to switch them back to the raw URLs.

.PARAMETER Mode
    Local    - rewrite absolute raw URLs to relative ./Images/ paths for local preview.
    Absolute - rewrite relative paths back to absolute raw URLs for publishing.

.PARAMETER Path
    Path to the README file. Defaults to README.md in the repository root (one level up from this script's Tools folder).

.PARAMETER Branch
    Branch segment used in the absolute URLs. Defaults to 'main'.

.EXAMPLE
    ./Toggle-ReadmeImages.ps1 -Mode Local
    Switch to relative paths, preview locally, then switch back.

.EXAMPLE
    ./Toggle-ReadmeImages.ps1 -Mode Absolute
    Restore absolute URLs before committing.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Local', 'Absolute')]
    [string]$Mode,

    [string]$Path = (Join-Path (Split-Path -Parent $PSScriptRoot) 'README.md'),

    [string]$Branch = 'main'
)

if (-not (Test-Path -LiteralPath $Path)) {
    throw "README not found: $Path"
}

$owner = 'MichaelEscamilla'
$repo = 'GetMSIInformation'
$rawBase = "https://raw.githubusercontent.com/$owner/$repo/$Branch/Images/"

$content = Get-Content -LiteralPath $Path -Raw

if ($Mode -eq 'Local') {
    # Absolute raw URL (any branch) -> relative ./Images/
    $pattern = "https://raw\.githubusercontent\.com/$owner/$repo/[^/]+/Images/"
    $updated = [regex]::Replace($content, $pattern, './Images/')
}
else {
    # Relative (./Images/ or /Images/) -> absolute raw URL
    $pattern = '\((?:\./|/)?Images/'
    $updated = [regex]::Replace($content, $pattern, "($rawBase")
}

if ($updated -eq $content) {
    Write-Host "No changes needed. README image links already in '$Mode' form." -ForegroundColor Yellow
    return
}

Set-Content -LiteralPath $Path -Value $updated -NoNewline -Encoding utf8
Write-Host "README image links switched to '$Mode' form." -ForegroundColor Green
