# VMware VM DoD STIG Audit Tool - Testing

## Test Structure

```
tests/
├── README.md              # This file
├── Run-Tests.ps1          # Main test runner
├── unit/                  # Unit tests
│   └── VMware-Audit.Tests.ps1
└── integration/           # Integration tests
    └── Integration.Tests.ps1
```

## Running Tests

### All Tests
```powershell
.\tests\Run-Tests.ps1
```

### Unit Tests Only
```powershell
.\tests\Run-Tests.ps1 -TestType Unit
```

### Integration Tests Only
```powershell
.\tests\Run-Tests.ps1 -TestType Integration
```

### With Verbose Output
```powershell
.\tests\Run-Tests.ps1 -Verbose
```

## Test Requirements

- **Pester 5.0+** - PowerShell testing framework
- **PSScriptAnalyzer** - PowerShell code analysis
- **VMware PowerCLI** - For integration tests

## Writing Tests

### Unit Test Example
```powershell
Describe "Get-AdvValue Function" {
    BeforeAll {
        # Mock VMware cmdlets
        Mock Get-AdvancedSetting { return @{ Value = "true" } }
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

### Integration Test Guidelines
- Use test vCenter environment
- Mock external dependencies
- Clean up test resources
- Test both success and failure scenarios

## Continuous Integration

Tests run automatically on:
- Push to main branch
- Pull requests
- Weekly schedule (security scans)

See [GitHub Actions workflows](../.github/workflows/) for CI/CD configuration.# Updated Sun Nov  9 12:49:29 CET 2025
