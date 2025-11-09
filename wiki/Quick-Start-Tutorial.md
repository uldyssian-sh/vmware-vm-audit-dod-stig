# Quick Start Tutorial

Get up and running with the VMware DoD STIG Audit Tool in just 5 minutes!

## Step 1: Prerequisites Check ✅

Before starting, ensure you have:
- PowerShell 5.1+ or PowerShell 7+
- Network access to your vCenter Server
- vCenter user account with VM read permissions

## Step 2: Download the Tool 📥

### Option A: Download Release (Recommended)
1. Go to [Releases](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/releases)
2. Download the latest release ZIP file
3. Extract to your preferred directory

### Option B: Clone Repository
```powershell
git clone https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig.git
cd vmware-vm-audit-dod-stig
```

## Step 3: Install PowerCLI 🔧

The script will attempt to install PowerCLI automatically, but you can install it manually:

```powershell
# Install PowerCLI (run as Administrator if needed)
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Verify installation
Get-Module -ListAvailable VMware.PowerCLI
```

## Step 4: Configure PowerShell 🛠️

Set the execution policy to allow script execution:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy if needed (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Step 5: Run Your First Audit 🚀

### Basic Audit - All VMs
```powershell
.\vmware-vm-audit-dod-stig.ps1 -vCenter "your-vcenter.domain.com"
```

### Single VM Audit
```powershell
.\vmware-vm-audit-dod-stig.ps1 -vCenter "your-vcenter.domain.com" -VMName "test-vm"
```

## Step 6: Understanding the Output 📊

The tool displays a table with compliance information:

| Column | Description |
|--------|-------------|
| VMName | Virtual machine name |
| PowerState | Current power state |
| OS | Guest operating system |
| Firmware | Firmware type (bios/efi) |
| SecureBoot | EFI Secure Boot status |
| vTPM | Virtual TPM presence |
| VMEncrypted | Encryption status |
| NonCompliantReasons | List of compliance issues |

### Sample Output
```
VMName      PowerState  Firmware  SecureBoot  vTPM  VMEncrypted  NonCompliantReasons
----------  ----------  --------  ----------  ----  -----------  -------------------
web-srv-01  PoweredOn   efi       True        True  True
test-vm     PoweredOn   bios      False       False False        Not EFI firmware; vTPM not present; VM not encrypted
```

## Step 7: Export Results 💾

Save results for reporting or analysis:

```powershell
# Run audit and store results
$results = .\vmware-vm-audit-dod-stig.ps1 -vCenter "your-vcenter.domain.com"

# Export to CSV
$results | Export-Csv -Path "audit-results.csv" -NoTypeInformation

# Export to JSON
$results | ConvertTo-Json | Out-File "audit-results.json"
```

## Common Use Cases 🎯

### 1. Daily Compliance Check
```powershell
# Quick check of critical VMs
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.company.com" |
    Where-Object { $_.NonCompliantReasons -ne "" } |
    Format-Table VMName, NonCompliantReasons
```

### 2. Generate Compliance Report
```powershell
$results = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.company.com"
$compliant = ($results | Where-Object { $_.NonCompliantReasons -eq "" }).Count
$total = $results.Count
$rate = [math]::Round(($compliant / $total) * 100, 2)

Write-Host "Compliance Rate: $rate% ($compliant/$total VMs compliant)"
```

### 3. Focus on Specific Issues
```powershell
# Find VMs without encryption
$results | Where-Object { -not $_.VMEncrypted } |
    Select-Object VMName, PowerState, OS

# Find VMs with VNC enabled
$results | Where-Object { $_.VNCEnabled } |
    Select-Object VMName, NonCompliantReasons
```

## Troubleshooting 🔧

### Common Issues

**PowerCLI Not Found**
```powershell
Install-Module -Name VMware.PowerCLI -Force -Scope CurrentUser
```

**Certificate Successs**
```powershell
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
```

**Connection Timeout**
- Verify vCenter FQDN/IP is correct
- Check firewall settings (port 443)
- Ensure network connectivity

**Permission Denied**
- Verify vCenter user has read permissions
- Check if account is locked or expired

## Next Steps 📚

Now that you're up and running:

1. **Explore Advanced Features**: Check [Advanced Scenarios](Advanced-Scenarios.md)
2. **Automate Audits**: Set up scheduled tasks or CI/CD integration
3. **Customize Reports**: Learn about output formatting and filtering
4. **Understand Controls**: Review [DoD STIG Controls](DoD-STIG-Controls.md)

## Need Help? 🆘

- **Documentation**: Browse this wiki for detailed guides
- **Examples**: Check the [examples](../examples/) directory
- **Issues**: Report problems on [GitHub Issues](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)
- **Discussions**: Ask questions on [GitHub Discussions](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/discussions)

---

