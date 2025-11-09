$ErrorActionPreference = "Stop"
# Advanced Usage Examples for VMware DoD STIG Audit

# Advanced Example 1: Multi-vCenter audit with error handling
Write-Host "Advanced Example 1: Multi-vCenter audit" -ForegroundColor Green

$vCenters = @("vcenter1.example.com", "vcenter2.example.com", "vcenter3.example.com")
$allResults = @()

foreach ($vCenter in $vCenters) {
    try {
        Write-Host "Auditing $vCenter..." -ForegroundColor Yellow
        $results = .\vmware-vm-audit-dod-stig.ps1 -vCenter $vCenter -ErrorAction Stop
        $results | Add-Member -NotePropertyName "vCenterSource" -NotePropertyValue $vCenter
        $allResults += $results
        Write-Host "✓ Completed $vCenter" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to audit $vCenter`: $_"
    }
}

# Advanced Example 2: Scheduled audit with email reporting
Write-Host "`nAdvanced Example 2: Automated reporting" -ForegroundColor Green

$auditResults = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportPath = "reports/audit-report-$timestamp.html"

# Create HTML report
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>VMware DoD STIG Audit Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .compliant { background-color: #d4edda; }
        .non-compliant { background-color: #f8d7da; }
    </style>
</head>
<body>
    <h1>VMware DoD STIG Audit Report</h1>
    <p>Generated: $(Get-Date)</p>
    <p>Total VMs: $($auditResults.Count)</p>
    
    <table>
        <tr>
            <th>VM Name</th>
            <th>Power State</th>
            <th>OS</th>
            <th>Compliance Status</th>
            <th>Issues</th>
        </tr>
"@

foreach ($vm in $auditResults) {
    $cssClass = if ($vm.NonCompliantReasons -eq "") { "compliant" } else { "non-compliant" }
    $status = if ($vm.NonCompliantReasons -eq "") { "✓ Compliant" } else { "✗ Non-Compliant" }
    
    $html += @"
        <tr class="$cssClass">
            <td>$($vm.VMName)</td>
            <td>$($vm.PowerState)</td>
            <td>$($vm.OS)</td>
            <td>$status</td>
            <td>$($vm.NonCompliantReasons)</td>
        </tr>
"@
}

$html += @"
    </table>
</body>
</html>
"@

# Ensure reports directory exists
if (-not (Test-Path "reports")) {
    New-Item -ItemType Directory -Path "reports" -Force
}

$html | Out-File -FilePath $reportPath -Encoding UTF8
Write-Host "HTML report generated: $reportPath"

# Advanced Example 3: Integration with monitoring systems
Write-Host "`nAdvanced Example 3: Monitoring integration" -ForegroundColor Green

$auditResults = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"
$nonCompliantCount = ($auditResults | Where-Object { $_.NonCompliantReasons -ne "" }).Count

# Create metrics for monitoring systems (Prometheus format)
$metricsPath = "metrics/vmware_compliance_metrics.txt"
if (-not (Test-Path "metrics")) {
    New-Item -ItemType Directory -Path "metrics" -Force
}

$metrics = @"
# HELP vmware_total_vms Total number of VMs audited
# TYPE vmware_total_vms gauge
vmware_total_vms $($auditResults.Count)

# HELP vmware_non_compliant_vms Number of non-compliant VMs
# TYPE vmware_non_compliant_vms gauge
vmware_non_compliant_vms $nonCompliantCount

# HELP vmware_compliance_rate Compliance rate percentage
# TYPE vmware_compliance_rate gauge
vmware_compliance_rate $([math]::Round((($auditResults.Count - $nonCompliantCount) / $auditResults.Count) * 100, 2))
"@

$metrics | Out-File -FilePath $metricsPath -Encoding UTF8
Write-Host "Metrics exported: $metricsPath"

# Advanced Example 4: Remediation planning
Write-Host "`nAdvanced Example 4: Remediation planning" -ForegroundColor Green

$auditResults = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"
$remediationPlan = @{}

foreach ($vm in $auditResults) {
    if ($vm.NonCompliantReasons -ne "") {
        $issues = $vm.NonCompliantReasons -split "; "
        foreach ($issue in $issues) {
            if (-not $remediationPlan.ContainsKey($issue)) {
                $remediationPlan[$issue] = @()
            }
            $remediationPlan[$issue] += $vm.VMName
        }
    }
}

Write-Host "=== REMEDIATION PLAN ===" -ForegroundColor Yellow
foreach ($issue in $remediationPlan.Keys | Sort-Object) {
    Write-Host "`n$issue ($($remediationPlan[$issue].Count) VMs):" -ForegroundColor Red
    $remediationPlan[$issue] | ForEach-Object { Write-Host "  - $_" }
}

# Advanced Example 5: Trend analysis
Write-Host "`nAdvanced Example 5: Trend analysis" -ForegroundColor Green

# Store historical data
$historyPath = "history/compliance-history.json"
if (-not (Test-Path "history")) {
    New-Item -ItemType Directory -Path "history" -Force
}

$currentData = @{
    Timestamp = Get-Date
    TotalVMs = $auditResults.Count
    CompliantVMs = ($auditResults | Where-Object { $_.NonCompliantReasons -eq "" }).Count
    ComplianceRate = [math]::Round((($auditResults.Count - $nonCompliantCount) / $auditResults.Count) * 100, 2)
}

$history = @()
if (Test-Path $historyPath) {
    $history = Get-Content $historyPath | ConvertFrom-Json
}
$history += $currentData
$history | ConvertTo-Json | Out-File $historyPath

Write-Host "Historical data updated: $historyPath"