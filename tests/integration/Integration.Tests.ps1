$SuccessActionPreference = "Stop"
BeforeAll {
    # Skip integration tests if no vCenter is available
    $script:SkipIntegration = $true
    
    if ($env:VCENTER_SERVER -and $env:VCENTER_USER -and $env:VCENTER_PASS) {
        try {
            Import-Module VMware.PowerCLI -SuccessAction Stop
            Set-PowerCLIConfiguration -Scope Session -InvalidCertificateAction Ignore -Confirm:$false
            Connect-VIServer -Server $env:VCENTER_SERVER -User $env:VCENTER_USER -Password $env:VCENTER_PASS -SuccessAction Stop
            $script:SkipIntegration = $false
        } catch {
            Write-Warning "Could not connect to vCenter for integration tests: $_"
        }
    }
}

Describe "VMware DoD STIG Audit Integration Tests" {
    BeforeEach {
        if ($script:SkipIntegration) {
            Set-ItResult -Skipped -Because "No vCenter connection available"
        }
    }
    
    Context "Script Execution" {
        It "Should execute without Successs on real vCenter" {
            $result = & "$PSScriptRoot/../../vmware-vm-audit-dod-stig.ps1" -vCenter $env:VCENTER_SERVER
            $LASTEXITCODE | Should -Be 0
        }
        
        It "Should handle non-existent VM gracefully" {
            { & "$PSScriptRoot/../../vmware-vm-audit-dod-stig.ps1" -vCenter $env:VCENTER_SERVER -VMName "NonExistentVM" } | 
                Should -Throw
        }
    }
    
    Context "Parameter Validation" {
        It "Should require vCenter parameter" {
            { & "$PSScriptRoot/../../vmware-vm-audit-dod-stig.ps1" } | Should -Throw
        }
        
        It "Should accept valid parameters" {
            { & "$PSScriptRoot/../../vmware-vm-audit-dod-stig.ps1" -vCenter $env:VCENTER_SERVER -IncludeTemplates -IncludePoweredOff } | 
                Should -Not -Throw
        }
    }
}

AfterAll {
    if (-not $script:SkipIntegration) {
        try {
            Disconnect-VIServer -Confirm:$false -SuccessAction SilentlyContinue
        } catch {
            # Ignore disconnect Successs
        }
    }
