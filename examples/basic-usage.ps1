# Basic Usage Examples for VMware DoD STIG Audit

# Example 1: Audit all VMs in vCenter
Write-Host "Example 1: Basic audit of all VMs" -ForegroundColor Green
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"

# Example 2: Audit specific VM
Write-Host "`nExample 2: Audit specific VM" -ForegroundColor Green
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com" -VMName "web-server-01"

# Example 3: Audit with templates included
Write-Host "`nExample 3: Include templates in audit" -ForegroundColor Green
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com" -IncludeTemplates

# Example 4: Audit only powered-on VMs
Write-Host "`nExample 4: Exclude powered-off VMs" -ForegroundColor Green
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com" -IncludePoweredOff:$false

# Example 5: Store results in variable for further processing
Write-Host "`nExample 5: Store and process results" -ForegroundColor Green
$auditResults = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"

# Filter non-compliant VMs
$nonCompliantVMs = $auditResults | Where-Object { $_.NonCompliantReasons -ne "" }
Write-Host "Found $($nonCompliantVMs.Count) non-compliant VMs"

# Show VMs with encryption issues
$unencryptedVMs = $auditResults | Where-Object { -not $_.VMEncrypted }
Write-Host "Found $($unencryptedVMs.Count) unencrypted VMs"

# Example 6: Export results to CSV
Write-Host "`nExample 6: Export to CSV" -ForegroundColor Green
$auditResults | Export-Csv -Path "vm-audit-$(Get-Date -Format 'yyyy-MM-dd').csv" -NoTypeInformation
Write-Host "Results exported to CSV file"

# Example 7: Generate summary report
Write-Host "`nExample 7: Summary report" -ForegroundColor Green
$totalVMs = $auditResults.Count
$compliantVMs = ($auditResults | Where-Object { $_.NonCompliantReasons -eq "" }).Count
$complianceRate = [math]::Round(($compliantVMs / $totalVMs) * 100, 2)

Write-Host "=== COMPLIANCE SUMMARY ===" -ForegroundColor Yellow
Write-Host "Total VMs audited: $totalVMs"
Write-Host "Compliant VMs: $compliantVMs"
Write-Host "Non-compliant VMs: $($totalVMs - $compliantVMs)"
Write-Host "Compliance rate: $complianceRate%"