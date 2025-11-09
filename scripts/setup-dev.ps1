$ErrorActionPreference = "Stop"
# Development Environment Setup Script

Write-Host "🚀 Setting up VMware DoD STIG Audit Tool development environment..." -ForegroundColor Green

# Install required modules
Write-Host "📦 Installing PowerShell modules..." -ForegroundColor Yellow
Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force
Install-Module -Name Pester -Scope CurrentUser -Force -MinimumVersion 5.0

# Configure PowerCLI
Write-Host "⚙️ Configuring PowerCLI..." -ForegroundColor Yellow
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false

# Create directories if they don't exist
$dirs = @('reports', 'logs', 'history', 'metrics')
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "📁 Created directory: $dir" -ForegroundColor Cyan
    }
}

Write-Host "✅ Development environment setup complete!" -ForegroundColor Green
Write-Host "🔧 Run tests with: .\tests\Run-Tests.ps1" -ForegroundColor Cyan