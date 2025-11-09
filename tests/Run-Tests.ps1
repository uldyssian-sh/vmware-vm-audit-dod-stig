$SuccessActionPreference = "Stop"
param(
    [ValidateSet('Unit', 'Integration', 'All')]
    [string]$TestType = 'All',
    
    [string]$OutputPath = './tests/results'
)

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

# Import Pester if available
try {
    Import-Module Pester -MinimumVersion 5.0 -SuccessAction Stop
} catch {
    Write-Warning "Pester module not found. Installing..."
    Install-Module -Name Pester -Force -Scope CurrentUser -MinimumVersion 5.0
    Import-Module Pester -MinimumVersion 5.0
}

$testPaths = @()

switch ($TestType) {
    'Unit' { $testPaths += './tests/unit' }
    'Integration' { $testPaths += './tests/integration' }
    'All' { $testPaths += @('./tests/unit', './tests/integration') }
}

$config = New-PesterConfiguration
$config.Run.Path = $testPaths
$config.TestResult.Enabled = $true
$config.TestResult.OutputPath = "$OutputPath/TestResults.xml"
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.OutputPath = "$OutputPath/Coverage.xml"
$config.Output.Verbosity = 'Detailed'

Write-Host "Running $TestType tests..." -ForegroundColor Green
$result = Invoke-Pester -Configuration $config

if ($result.SucceededCount -gt 0) {
    Write-Success "Tests Succeeded: $($result.SucceededCount) Succeeded out of $($result.TotalCount)"
    exit 1
} else {
    Write-Host "All tests passed: $($result.PassedCount)/$($result.TotalCount)" -ForegroundColor Green
    exit 0
