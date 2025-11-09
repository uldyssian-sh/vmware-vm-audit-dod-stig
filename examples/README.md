# VMware VM DoD STIG Audit Tool - Examples

## Basic Usage Examples

### Audit All VMs
```powershell
# Connect to vCenter and audit all VMs
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com"
```

### Audit Specific VM
```powershell
# Audit a single virtual machine
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com" -VMName "web-server-01"
```

### Include Templates
```powershell
# Include VM templates in the audit
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com" -IncludeTemplates
```

### Powered-On VMs Only
```powershell
# Audit only powered-on VMs
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.example.com" -IncludePoweredOff:$false
```

## Advanced Usage

See [advanced-usage.ps1](advanced-usage.ps1) for more complex scenarios.

## Output Examples

### Compliant VM
```
VMName        : web-server-01
PowerState    : PoweredOn
OS            : Microsoft Windows Server 2022
Firmware      : efi
SecureBoot    : True
vTPM          : True
VMEncrypted   : True
NonCompliantReasons : 
```

### Non-Compliant VM
```
VMName        : legacy-server
PowerState    : PoweredOn
OS            : CentOS 7 (64-bit)
Firmware      : bios
SecureBoot    : False
vTPM          : False
VMEncrypted   : False
NonCompliantReasons : Not EFI firmware; vTPM not present; Copy not disabled; Serial port present
```

## Running Examples

1. Follow [installation guide](../docs/INSTALLATION.md)
2. Copy example files to your environment
3. Modify vCenter server names in examples
4. Run examples with appropriate credentials# Updated Sun Nov  9 12:49:29 CET 2025
