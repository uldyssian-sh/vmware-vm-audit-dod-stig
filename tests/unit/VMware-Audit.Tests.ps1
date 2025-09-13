BeforeAll {
    # Import the main script for testing
    . "$PSScriptRoot/../../vmware-vm-audit-dod-stig.ps1"
}

Describe "VMware DoD STIG Audit Functions" {
    Context "Helper Functions" {
        It "Get-AdvValue should handle null values" {
            # Mock VM object
            $mockVM = [PSCustomObject]@{
                Name = "TestVM"
            }
            
            # Mock Get-AdvancedSetting to return null
            Mock Get-AdvancedSetting { return $null }
            
            $result = Get-AdvValue -VM $mockVM -Name "test.setting"
            $result | Should -BeNullOrEmpty
        }
        
        It "Is-AdvTrue should return false for null values" {
            $mockVM = [PSCustomObject]@{ Name = "TestVM" }
            Mock Get-AdvancedSetting { return $null }
            
            $result = Is-AdvTrue -VM $mockVM -Name "test.setting"
            $result | Should -Be $false
        }
        
        It "Is-AdvFalseOrMissing should return true for null values" {
            $mockVM = [PSCustomObject]@{ Name = "TestVM" }
            Mock Get-AdvancedSetting { return $null }
            
            $result = Is-AdvFalseOrMissing -VM $mockVM -Name "test.setting"
            $result | Should -Be $true
        }
    }
    
    Context "Device Flag Processing" {
        It "Get-DeviceFlags should handle null device" {
            $result = Get-DeviceFlags -Device $null
            $result.ConnectedNow | Should -Be $false
            $result.ConnectAtPowerOn | Should -Be $false
        }
        
        It "Get-DeviceFlags should process device correctly" {
            $mockDevice = [PSCustomObject]@{
                ConnectionState = [PSCustomObject]@{ Connected = $true }
                Connectable = [PSCustomObject]@{ 
                    Connected = $false
                    StartConnected = $true 
                }
            }
            
            $result = Get-DeviceFlags -Device $mockDevice
            $result.ConnectedNow | Should -Be $true
            $result.ConnectAtPowerOn | Should -Be $true
        }
    }
    
    Context "Encryption State" {
        It "Get-EncState should handle VM without encryption" {
            $mockVM = [PSCustomObject]@{
                ExtensionData = [PSCustomObject]@{
                    Config = [PSCustomObject]@{
                        KeyId = $null
                        Hardware = [PSCustomObject]@{
                            Device = @()
                        }
                    }
                }
            }
            
            $result = Get-EncState -VM $mockVM
            $result.VMHomeEncrypted | Should -Be $false
            $result.AnyDiskEncrypted | Should -Be $false
            $result.VMEncrypted | Should -Be $false
        }
    }
}