# VMware VM DoD STIG Audit Tool

Welcome to the comprehensive wiki for the VMware Virtual Machine DoD STIG Audit Tool. This tool provides automated security compliance auditing for VMware vSphere environments against Department of Defense Security Technical Implementation Guide (DoD STIG) standards.

## 🚀 Quick Navigation

### Getting Started
- [Installation Guide](Installation-Guide.md) - Complete setup instructions
- [Quick Start Tutorial](Quick-Start-Tutorial.md) - Get up and running in 5 minutes
- [Configuration Guide](Configuration-Guide.md) - Customize the tool for your environment

### User Guides
- [Basic Usage](Basic-Usage.md) - Common use cases and examples
- [Advanced Scenarios](Advanced-Scenarios.md) - Complex deployments and automation
- [Best Practices](Best-Practices.md) - Recommended approaches and tips

### Reference
- [DoD STIG Controls](DoD-STIG-Controls.md) - Complete list of security controls checked
- [API Reference](../docs/API.md) - Function and parameter documentation
- [Troubleshooting](Troubleshooting.md) - Common issues and solutions

### Development
- [Contributing](../CONTRIBUTING.md) - How to contribute to the project
- [Development Setup](Development-Setup.md) - Setting up development environment
- [Testing Guide](Testing-Guide.md) - Running and writing tests

## 📋 What This Tool Does

The VMware VM DoD STIG Audit Tool performs comprehensive security compliance checks on VMware virtual machines, including:

### Security Controls Audited
- **Console Data Movement**: Copy/paste, drag & drop restrictions
- **Remote Access**: VNC and console access controls
- **Device Security**: Removable devices, serial/parallel ports
- **Firmware Security**: EFI Secure Boot, vTPM configuration
- **Encryption**: VM and disk encryption status
- **Advanced Settings**: VMware-specific security configurations

### Key Features
- ✅ **Read-Only Operation** - No modifications to your environment
- ✅ **Comprehensive Reporting** - Detailed compliance status for each VM
- ✅ **Batch Processing** - Audit multiple VMs or entire vCenter
- ✅ **Export Capabilities** - CSV, JSON, and HTML report formats
- ✅ **PowerShell Integration** - Native Windows automation support
- ✅ **Cross-Platform** - Works on Windows, Linux, and macOS

## 🎯 Compliance Standards

This tool helps ensure compliance with:
- **DoD STIG** - Department of Defense Security Technical Implementation Guide
- **VMware vSphere 8** - Latest VMware security recommendations
- **NIST Cybersecurity Framework** - Industry standard security controls
- **CIS Controls** - Center for Internet Security benchmarks

## 📊 Sample Output

```
VMName      PowerState  OS                    Firmware  SecureBoot  vTPM  VMEncrypted  NonCompliantReasons
----------  ----------  --------------------  --------  ----------  ----  -----------  -------------------
web-srv-01  PoweredOn   Windows Server 2022   efi       True        True  True
db-srv-02   PoweredOn   RHEL 8.5             efi       True        False True         vTPM not present
test-vm     PoweredOff  Windows 10           bios      False       False False        Not EFI firmware; vTPM not present; VM not encrypted
```

## 🔧 System Requirements

- **PowerShell**: 5.1 or PowerShell 7+
- **VMware PowerCLI**: 13.0 or higher
- **vCenter Access**: Read permissions on target VMs
- **Network**: Connectivity to vCenter Server

## 🆘 Getting Help

- **Issues**: Report bugs and request features on [GitHub Issues](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)
- **Discussions**: Join community discussions on [GitHub Discussions](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/discussions)
- **Documentation**: Browse this wiki for comprehensive guides
- **Examples**: Check the [examples](../examples/) directory for code samples

## 📈 Project Stats

![GitHub stars](https://img.shields.io/github/stars/uldyssian-sh/vmware-vm-audit-dod-stig)
![GitHub forks](https://img.shields.io/github/forks/uldyssian-sh/vmware-vm-audit-dod-stig)
![GitHub issues](https://img.shields.io/github/issues/uldyssian-sh/vmware-vm-audit-dod-stig)
![GitHub license](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-audit-dod-stig)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](../CONTRIBUTING.md) for details on:
- Reporting bugs
- Suggesting enhancements
- Submitting pull requests
- Code style guidelines

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

---

