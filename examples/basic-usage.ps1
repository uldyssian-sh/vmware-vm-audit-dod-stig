# Basic Usage Examples for VMware DoD STIG Audit

# Example 1: Audit all VMs in vCenter
Write-Output "Example 1: Basic audit of all VMs"
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"

# Example 2: Audit specific VM
Write-Output "`nExample 2: Audit specific VM"
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com" -VMName "web-server-01"

# Example 3: Audit with templates included
Write-Output "`nExample 3: Include templates in audit"
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com" -IncludeTemplates

# Example 4: Audit only powered-on VMs
Write-Output "`nExample 4: Exclude powered-off VMs"
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com" -IncludePoweredOff:$false

# Example 5: Store results in variable for further processing
Write-Output "`nExample 5: Store and process results"
$auditResults = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"

# Filter non-compliant VMs
$nonCompliantVMs = $auditResults | Where-Object { $_.NonCompliantReasons -ne "" }
Write-Output "Found $($nonCompliantVMs.Count) non-compliant VMs"

# Show VMs with encryption issues
$unencryptedVMs = $auditResults | Where-Object { -not $_.VMEncrypted }
Write-Output "Found $($unencryptedVMs.Count) unencrypted VMs"

# Example 6: Export results to CSV
Write-Output "`nExample 6: Export to CSV"
$auditResults | Export-Csv -Path "vm-audit-$(Get-Date -Format 'yyyy-MM-dd').csv" -NoTypeInformation
Write-Output "Results exported to CSV file"

# Example 7: Generate summary report
Write-Output "`nExample 7: Summary report"
$totalVMs = $auditResults.Count
$compliantVMs = ($auditResults | Where-Object { $_.NonCompliantReasons -eq "" }).Count
$complianceRate = [math]::Round(($compliantVMs / $totalVMs) * 100, 2)

Write-Output "=== COMPLIANCE SUMMARY ==="
Write-Output "Total VMs audited: $totalVMs"
Write-Output "Compliant VMs: $compliantVMs"
Write-Output "Non-compliant VMs: $($totalVMs - $compliantVMs)"
Write-Output "Compliance rate: $complianceRate%"# Updated Sun Nov  9 12:52:36 CET 2025
