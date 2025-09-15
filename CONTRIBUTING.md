# Contributing to VMware DoD STIG Audit Tool

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## 🤝 Ways to Contribute

- **Bug Reports**: Help us identify and fix issues
- **Feature Requests**: Suggest new functionality
- **Code Contributions**: Submit bug fixes and enhancements
- **Documentation**: Improve guides, examples, and wiki content
- **Testing**: Help test new features and report issues

## 🐛 Reporting Bugs

Before submitting a bug report:
1. Check existing [issues](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)
2. Ensure you're using the latest version
3. Test with minimal configuration

### Bug Report Template
Use our [bug report template](.github/ISSUE_TEMPLATE/bug_report.yml) and include:
- Script version
- PowerShell version
- vSphere version
- Detailed steps to reproduce
- Expected vs actual behavior
- Error messages or logs

## 💡 Feature Requests

We welcome feature suggestions! Use our [feature request template](.github/ISSUE_TEMPLATE/feature_request.yml) and include:
- Clear description of the problem
- Proposed solution
- Alternative approaches considered
- Use cases and benefits

## 🔧 Development Setup

### Prerequisites
- PowerShell 7+ (recommended)
- VMware PowerCLI 13+
- Git
- Code editor (VS Code recommended)

### Setup Steps
```powershell
# Clone the repository
git clone https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig.git
cd vmware-vm-audit-dod-stig

# Install dependencies
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Install-Module -Name Pester -Scope CurrentUser -MinimumVersion 5.0

# Run tests
.\tests\Run-Tests.ps1
```

## 📝 Code Style Guidelines

### PowerShell Style
- Use **PascalCase** for functions and parameters
- Use **camelCase** for variables
- Include comment-based help for functions
- Use approved PowerShell verbs
- Follow [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines)

### Example Function
```powershell
<#
.SYNOPSIS
    Gets advanced setting value from VM
.DESCRIPTION
    Retrieves the value of a specified advanced setting from a virtual machine
.PARAMETER VM
    The VM object to query
.PARAMETER Name
    The name of the advanced setting
.EXAMPLE
    Get-AdvValue -VM $vm -Name "isolation.tools.copy.disable"
#>
function Get-AdvValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [VMware.VimAutomation.ViCore.Types.V1.Inventory.VirtualMachine]$VM,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    try {
        $setting = $VM | Get-AdvancedSetting -Name $Name -ErrorAction Stop
        return $setting.Value
    }
    catch {
        Write-Verbose "Advanced setting '$Name' not found on VM '$($VM.Name)'"
        return $null
    }
}
```

## 🧪 Testing

### Running Tests
```powershell
# Run all tests
.\tests\Run-Tests.ps1

# Run specific test types
.\tests\Run-Tests.ps1 -TestType Unit
.\tests\Run-Tests.ps1 -TestType Integration
```

### Writing Tests
- Use Pester 5+ syntax
- Include unit tests for all functions
- Mock external dependencies
- Test both success and failure scenarios

### Test Example
```powershell
Describe "Get-AdvValue" {
    BeforeAll {
        # Setup mocks
        Mock Get-AdvancedSetting { return [PSCustomObject]@{ Value = "true" } }
    }

    It "Should return setting value when found" {
        $result = Get-AdvValue -VM $mockVM -Name "test.setting"
        $result | Should -Be "true"
    }

    It "Should return null when setting not found" {
        Mock Get-AdvancedSetting { throw "Not found" }
        $result = Get-AdvValue -VM $mockVM -Name "missing.setting"
        $result | Should -BeNullOrEmpty
    }
}
```

## 📋 Pull Request Process

### Before Submitting
1. **Fork** the repository
2. **Create** a feature branch from `main`
3. **Make** your changes
4. **Test** thoroughly
5. **Update** documentation if needed
6. **Commit** with clear messages

### PR Requirements
- [ ] All tests pass
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
- [ ] Commit messages are descriptive

### PR Template
Use our [pull request template](.github/pull_request_template.md) and include:
- Description of changes
- Type of change (bug fix, feature, etc.)
- Testing performed
- Screenshots (if applicable)

## 📚 Documentation

### Wiki Updates
- Keep documentation current with code changes
- Use clear, concise language
- Include examples and use cases
- Test all code examples

### README Updates
- Update version numbers
- Add new features to feature list
- Update requirements if changed

## 🏷️ Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## 🎯 Coding Standards

### Security
- Never include credentials in code
- Use placeholder values in examples
- Validate all user inputs
- Follow principle of least privilege

### Performance
- Minimize API calls to vCenter
- Use efficient PowerShell constructs
- Cache results when appropriate
- Provide progress indicators for long operations

### Error Handling
- Use try/catch blocks appropriately
- Provide meaningful error messages
- Log errors for debugging
- Fail gracefully

## 📞 Getting Help

- **Questions**: Use [GitHub Discussions](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/discussions)
- **Issues**: Check existing issues before creating new ones
- **Documentation**: Browse the wiki for detailed guides

## 🏆 Recognition

Contributors will be:
- Listed in the project README
- Mentioned in release notes
- Invited to join the maintainer team (for significant contributions)

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the VMware DoD STIG Audit Tool! 🙏