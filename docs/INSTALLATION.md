# Installation Guide

## Prerequisites

### System Requirements
- **Operating System**: Windows 10/11, Windows Server 2016+, or PowerShell Core on Linux/macOS
- **PowerShell**: Version 5.1 or PowerShell 7+
- **Memory**: Minimum 4GB RAM recommended
- **Network**: Access to vCenter Server

### Required Modules
- VMware PowerCLI 13.0 or higher

## Installation Methods

### Method 1: Direct Download (Recommended)
1. Download the latest release from [GitHub Releases](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/releases)
2. Extract the archive to your desired location
3. Open PowerShell as Administrator
4. Navigate to the extracted directory

### Method 2: Git Clone
```powershell
git clone https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig.git
cd vmware-vm-audit-dod-stig
```

## PowerCLI Installation

### Automatic Installation
The script will attempt to install PowerCLI automatically if not present.

### Manual Installation
```powershell
# Install PowerCLI from PowerShell Gallery
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Verify installation
Get-Module -ListAvailable VMware.PowerCLI
```

### Offline Installation
For environments without internet access:
1. Download PowerCLI from [VMware Developer Portal](https://developer.vmware.com/powercli)
2. Follow VMware's offline installation guide

## Configuration

### PowerCLI Configuration
```powershell
# Set certificate policy (required for self-signed certificates)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

# Set participation in CEIP (optional)
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false
```

### Execution Policy
```powershell
# Check current execution policy
Get-ExecutionPolicy

# Set execution policy if needed (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Verification

### Test Installation
```powershell
# Test PowerCLI connectivity
Connect-VIServer -Server your-vcenter.domain.com

# Run basic script test
.\vmware-vm-audit-dod-stig.ps1 -vCenter your-vcenter.domain.com -VMName test-vm
```

### Troubleshooting
- **PowerCLI Import Error**: Ensure PowerShell execution policy allows module loading
- **Certificate Errors**: Use `-InvalidCertificateAction Ignore` parameter
- **Connection Timeout**: Verify network connectivity and firewall settings
- **Permission Denied**: Ensure vCenter user has read permissions on VMs

## Next Steps
- Review the [Quick Start Guide](../wiki/Quick-Start-Tutorial.md)
- Check [Configuration Examples](../examples/)
- Read [Best Practices](../docs/BEST_PRACTICES.md)# Updated Sun Nov  9 12:49:29 CET 2025
# Updated Sun Nov  9 12:52:36 CET 2025
