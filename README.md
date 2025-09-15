# VMware VM DoD STIG Audit Tool

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Prerequisites

Before using this project, ensure you have:
- Required tools and dependencies
- Proper access credentials
- System requirements met


[![GitHub release](https://img.shields.io/github/release/uldyssian-sh/vmware-vm-audit-dod-stig.svg)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/releases)
[![GitHub issues](https://img.shields.io/github/issues/uldyssian-sh/vmware-vm-audit-dod-stig.svg)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)
[![GitHub license](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-audit-dod-stig.svg)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/blob/main/LICENSE)
[![PowerShell Gallery](https://img.shields.io/badge/PowerShell-Gallery-blue.svg)](https://www.powershellgallery.com/)
[![CI/CD](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/actions)

**Author**: LT - [GitHub Profile](https://github.com/uldyssian-sh)
**Version**: 1.1.0
**Target**: VMware vSphere 8.x

## 🚀 Overview

A comprehensive PowerShell tool for auditing VMware virtual machine configurations against **Department of Defense Security Technical Implementation Guide (DoD STIG)** and **VMware vSphere 8 hardening recommendations**.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           VMware vSphere Environment                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                        vCenter Server                                  │    │
│  │                    • Management Interface                              │    │
│  │                    • API Endpoints                                     │    │
│  │                    • Configuration Database                            │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                       │                                         │
│                                       ▼                                         │
│  ┌─────────────────┬─────────────────┬─────────────────────────────────────┐    │
│  │   ESXi Host 1   │   ESXi Host 2   │   ESXi Host 3                       │    │
│  │                 │                 │                                     │    │
│  │ ┌─────────────┐ │ ┌─────────────┐ │ ┌─────────────┐                     │    │
│  │ │ Virtual     │ │ │ Virtual     │ │ │ Virtual     │                     │    │
│  │ │ Machines    │ │ │ Machines    │ │ │ Machines    │                     │    │
│  │ │             │ │ │             │ │ │             │                     │    │
│  │ │ • Security  │ │ │ • Security  │ │ │ • Security  │                     │    │
│  │ │ • Config    │ │ │ • Config    │ │ │ • Config    │                     │    │
│  │ │ • Compliance│ │ │ • Compliance│ │ │ • Compliance│                     │    │
│  │ └─────────────┘ │ └─────────────┘ │ └─────────────┘                     │    │
│  └─────────────────┴─────────────────┴─────────────────────────────────────┘    │
│                                       │                                         │
│                                       ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                      Audit & Compliance Engine                         │    │
│  │              • Security Checks • Configuration Validation              │    │
│  │              • Compliance Reports • Remediation Guidance               │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### ✨ Key Features

- 🔍 **Comprehensive Security Auditing** - 20+ security controls checked
- 📊 **Detailed Compliance Reporting** - Clear pass/fail status with remediation guidance
- 🛡️ **Read-Only Operation** - No modifications to your environment
- ⚡ **Batch Processing** - Audit single VMs or entire vCenter inventories
- 🔄 **CI/CD Integration** - Automated compliance monitoring
- 📈 **Multiple Output Formats** - Console, CSV, JSON, HTML reports
- 🌐 **Cross-Platform** - Windows, Linux, macOS support

### 🎯 Security Controls Audited

| Category | Controls |
|----------|----------|
| **Console Security** | Copy/Paste restrictions, Drag & Drop controls, GUI options |
| **Remote Access** | VNC access, console connections, remote display settings |
| **Device Security** | Removable devices, serial/parallel ports, floppy drives |
| **Firmware Security** | EFI Secure Boot, vTPM configuration, firmware type |
| **Encryption** | VM encryption, disk encryption, key management |
| **Advanced Settings** | VMware-specific security configurations |

## 📋 Requirements

- **PowerShell**: 5.1+ or PowerShell 7+ (recommended)
- **VMware PowerCLI**: 13.0 or higher
- **vCenter Access**: Read permissions on target VMs
- **Network**: Connectivity to vCenter Server (port 443)

## 🚀 Quick Start

### 1. Install PowerCLI
```powershell
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
```

### 2. Download and Run
```powershell
# Clone repository
git clone https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig.git
cd vmware-vm-audit-dod-stig

# Run audit
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.example.com"
```

### 3. View Results
```
VMName      PowerState  Firmware  SecureBoot  vTPM  VMEncrypted  NonCompliantReasons
----------  ----------  --------  ----------  ----  -----------  -------------------
web-srv-01  PoweredOn   efi       True        True  True
db-srv-02   PoweredOn   efi       True        False True         vTPM not present
test-vm     PoweredOff  bios      False       False False        Not EFI firmware; vTPM not present; VM not encrypted
```

## 📖 Documentation

### 📚 User Guides
- [📥 Installation Guide](docs/INSTALLATION.md) - Complete setup instructions
- [⚡ Quick Start Tutorial](wiki/Quick-Start-Tutorial.md) - Get running in 5 minutes
- [🔧 API Reference](docs/API.md) - Function and parameter documentation
- [💡 Usage Examples](examples/) - Basic and advanced usage scenarios

### 🏗️ Advanced Topics
- [🏢 Enterprise Deployment](wiki/Advanced-Scenarios.md) - Large-scale implementations
- [🔄 CI/CD Integration](wiki/Advanced-Scenarios.md#cicd-integration) - Automated compliance monitoring
- [📊 Custom Reporting](examples/advanced-usage.ps1) - Report customization and automation
- [🛠️ Troubleshooting](wiki/Troubleshooting.md) - Common issues and solutions

## 🎯 Usage Examples

### Basic Usage
```powershell
# Audit all VMs
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.company.com"

# Audit specific VM
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.company.com" -VMName "web-server-01"

# Include templates and powered-off VMs
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.company.com" -IncludeTemplates -IncludePoweredOff
```

### Advanced Usage
```powershell
# Export to CSV
$results = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcenter.company.com"
$results | Export-Csv -Path "compliance-report.csv" -NoTypeInformation

# Filter non-compliant VMs
$results | Where-Object { $_.NonCompliantReasons -ne "" } | Format-Table

# Generate compliance summary
$compliant = ($results | Where-Object { $_.NonCompliantReasons -eq "" }).Count
$total = $results.Count
Write-Host "Compliance Rate: $([math]::Round(($compliant/$total)*100,2))%"
```

## 🏗️ Project Structure

```
vmware-vm-audit-dod-stig/
├── 📁 .github/              # GitHub workflows and templates
│   ├── workflows/           # CI/CD pipelines
│   └── ISSUE_TEMPLATE/      # Issue templates
├── 📁 docs/                 # Documentation
├── 📁 examples/             # Usage examples
├── 📁 tests/                # Test suites
│   ├── unit/               # Unit tests
│   └── integration/        # Integration tests
├── 📁 wiki/                 # Wiki documentation
├── 📄 vmware-vm-audit-dod-stig.ps1  # Main script
├── 📄 README.md             # This file
├── 📄 CHANGELOG.md          # Version history
├── 📄 CONTRIBUTING.md       # Contribution guidelines
├── 📄 SECURITY.md           # Security policy
└── 📄 LICENSE               # MIT License
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Ways to Contribute
- 🐛 Report bugs and issues
- 💡 Suggest new features
- 📝 Improve documentation
- 🧪 Add tests and examples
- 🔧 Submit bug fixes and enhancements

## 📊 Compliance Standards

This tool helps ensure compliance with:
- **DoD STIG** - Department of Defense Security Technical Implementation Guide
- **VMware vSphere 8** - VMware security hardening guidelines
- **NIST Cybersecurity Framework** - Industry standard security controls
- **CIS Controls** - Center for Internet Security benchmarks

## 🔒 Security

Security is our top priority. Please see our [Security Policy](SECURITY.md) for:
- Vulnerability reporting process
- Security best practices
- Supported versions
- Contact information

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This script is provided "as is", without any warranty of any kind.
Use it at your own risk.
You are solely responsible for reviewing, testing, and implementing it in your own environment.

## 🙏 Acknowledgments

- VMware for PowerCLI and vSphere APIs
- DoD for STIG security guidelines
- Community contributors and testers
- Security researchers and feedback providers

---

**⭐ Star this repository if you find it useful!**

**🔗 [Documentation](wiki/Home.md) | [Examples](examples/) | [Issues](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues) | [Discussions](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/discussions)**

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- How to submit issues
- How to propose changes
- Code style guidelines
- Review process

## Support

- 📖 [Wiki Documentation](../../wiki)
- 💬 [Discussions](../../discussions)
- 🐛 [Issue Tracker](../../issues)
- 🔒 [Security Policy](SECURITY.md)

---
**Made with ❤️ for the community**
