# VMware VM DoD STIG Audit Tool

[![GitHub license](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-audit-dod-stig)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/uldyssian-sh/vmware-vm-audit-dod-stig)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)
[![GitHub stars](https://img.shields.io/github/stars/uldyssian-sh/vmware-vm-audit-dod-stig)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/stargazers)
[![Test](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/workflows/Test/badge.svg)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/actions)
[![PowerShell Gallery](https://img.shields.io/badge/PowerShell-Gallery-blue.svg)](https://www.powershellgallery.com/)
[![VMware Compatibility](https://img.shields.io/badge/VMware-vSphere%208.0-green.svg)](https://www.vmware.com/products/vsphere.html)
[![Security](https://img.shields.io/badge/Security-Enterprise-blue.svg)](SECURITY.md)

## 📋 Overview

PowerShell-based audit tool for VMware vSphere 8 Virtual Machine configurations against Department of Defense (DoD) Security Technical Implementation Guide (STIG) hardening recommendations. This read-only audit tool helps identify security compliance gaps without making any changes to your environment.

**Repository Type:** Security Audit Tool  
**Technology Stack:** PowerShell, VMware PowerCLI, vSphere API  
**Compliance Framework:** DoD STIG

## ✨ Features

- 🚀 **High Performance** - Optimized for enterprise environments
- 🔒 **Security First** - Built with security best practices
- 📊 **Monitoring** - Comprehensive logging and metrics
- 🔧 **Automation** - Fully automated deployment and management
- 📚 **Documentation** - Extensive documentation and examples
- 🧪 **Testing** - Comprehensive test coverage
- 🔄 **CI/CD** - Automated testing and deployment pipelines

## 🚀 Quick Start

## 📝 Prerequisites

### System Requirements
- **Operating System**: Windows 10/11, Windows Server 2016+, or PowerShell Core on Linux/macOS
- **PowerShell**: Version 5.1 or PowerShell Core 7.0+
- **Memory**: Minimum 2GB RAM (4GB recommended for large environments)
- **Disk Space**: 100MB free space for audit reports
- **Network**: HTTPS access to vCenter Server (port 443)

### VMware Environment
- **vSphere Version**: 8.0 or later
- **vCenter Server**: 8.0 or later
- **VMware PowerCLI**: Version 13.0 or later
- **Permissions**: Read-only access to vCenter (minimum required)

### Installation

```powershell
# Clone the repository
git clone https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig.git
cd vmware-vm-audit-dod-stig

# Install VMware PowerCLI (if not already installed)
Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force

# Run the audit script
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.lab.local"
```

### Basic Usage Examples

```powershell
# Audit all VMs in vCenter
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com"

# Audit specific VM
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com" -VMName "web-server-01"

# Include VM templates in audit
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com" -IncludeTemplates

# Exclude powered-off VMs
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com" -IncludePoweredOff:$false
```

## 📖 Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [API Reference](docs/API.md)
- [Examples](examples/README.md)
- [Wiki Home](wiki/Home.md)
- [Quick Start Tutorial](wiki/Quick-Start-Tutorial.md)

## 🔧 Script Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-vCenter` | String | Yes | vCenter Server FQDN or IP address |
| `-VMName` | String | No | Specific VM name to audit (default: all VMs) |
| `-IncludeTemplates` | Switch | No | Include VM templates in audit |
| `-IncludePoweredOff` | Switch | No | Include powered-off VMs (default: true) |

### DoD STIG Checks Performed

- **Console Security**: Copy/paste, drag-and-drop restrictions
- **Device Security**: Serial/parallel ports, floppy drives, CD/DVD
- **Firmware Security**: EFI firmware, Secure Boot, vTPM
- **Encryption**: VM home and disk encryption status
- **Remote Access**: VNC configuration
- **Tools Security**: VMware Tools restrictions

## 📊 Sample Output

```
VMName           PowerState  OS                    Firmware  SecureBoot  vTPM   VMEncrypted  NonCompliantReasons
------           ----------  --                    --------  ----------  ----   -----------  -------------------
web-server-01    PoweredOn   Microsoft Windows...  efi       True        True   True         
db-server-02     PoweredOn   Ubuntu Linux (64-bit) bios      False       False  False        Not EFI firmware; vTPM not present; Copy not disabled
test-vm-03       PoweredOff  CentOS 7 (64-bit)    efi       True        True   False        Serial port present; VNC enabled
```

### Compliance Status Interpretation

- ✅ **Compliant**: No issues found in NonCompliantReasons column
- ⚠️ **Partially Compliant**: Some security settings need attention
- ❌ **Non-Compliant**: Multiple security issues require remediation

## 🧪 Testing

Run the test suite:

```powershell
# Run all tests
.\tests\Run-Tests.ps1

# Run unit tests only
.\tests\Run-Tests.ps1 -TestType Unit

# Run integration tests
.\tests\Run-Tests.ps1 -TestType Integration

# Run with verbose output
.\tests\Run-Tests.ps1 -Verbose
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

### Development Setup

```powershell
# Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/vmware-vm-audit-dod-stig.git
cd vmware-vm-audit-dod-stig

# Install development dependencies
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Install-Module -Name Pester -Scope CurrentUser -MinimumVersion 5.0
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser

# Run development setup script
.\scripts\setup-dev.ps1
```

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to your branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📧 **Email**: [Create an issue](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues/new)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/discussions)
- 🐛 **Bug Reports**: [Issue Tracker](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)

## 🙏 Acknowledgments

- VMware Community
- Open Source Contributors
- Enterprise Automation Teams
- Security Research Community

## 📈 Project Stats

![GitHub repo size](https://img.shields.io/github/repo-size/uldyssian-sh/vmware-vm-audit-dod-stig)
![GitHub code size](https://img.shields.io/github/languages/code-size/uldyssian-sh/vmware-vm-audit-dod-stig)
![GitHub last commit](https://img.shields.io/github/last-commit/uldyssian-sh/vmware-vm-audit-dod-stig)
![GitHub contributors](https://img.shields.io/github/contributors/uldyssian-sh/vmware-vm-audit-dod-stig)

---

**Made with ❤️ by [uldyssian-sh](https://github.com/uldyssian-sh)**