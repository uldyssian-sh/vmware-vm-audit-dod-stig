# API Reference

## Script Parameters

### Required Parameters

#### `-vCenter`
- **Type**: String
- **Description**: vCenter Server FQDN or IP address
- **Example**: `"vcsa.lab.local"` or `"192.168.1.100"`

### Optional Parameters

#### `-VMName`
- **Type**: String
- **Description**: Specific VM name to audit. If omitted, all VMs are audited
- **Example**: `"web-server-01"`

#### `-IncludeTemplates`
- **Type**: Switch
- **Description**: Include VM templates in the audit
- **Default**: False

#### `-IncludePoweredOff`
- **Type**: Switch
- **Description**: Include powered-off VMs in the audit
- **Default**: True

## Functions

### Get-AdvValue
Retrieves advanced setting value from a VM.

```powershell
Get-AdvValue -VM $VMObject -Name "isolation.tools.copy.disable"
```

**Parameters:**
- `VM`: VM object from Get-VM
- `Name`: Advanced setting name

**Returns:** Setting value or `$null` if not found

### Is-AdvTrue
Checks if an advanced setting is set to true.

```powershell
Is-AdvTrue -VM $VMObject -Name "isolation.tools.copy.disable"
```

**Returns:** Boolean value

### Is-AdvFalseOrMissing
Checks if an advanced setting is false or missing.

```powershell
Is-AdvFalseOrMissing -VM $VMObject -Name "isolation.tools.setGUIOptions.enable"
```

**Returns:** Boolean value

### Get-DeviceFlags
Analyzes device connection state.

```powershell
Get-DeviceFlags -Device $DeviceObject
```

**Returns:** PSCustomObject with ConnectedNow and ConnectAtPowerOn properties

### Get-EncState
Determines VM encryption status.

```powershell
Get-EncState -VM $VMObject
```

**Returns:** PSCustomObject with encryption status properties

## Output Format

The script outputs a PowerShell object array with the following properties:

| Property | Type | Description |
|----------|------|-------------|
| VMName | String | Virtual machine name |
| PowerState | String | Current power state |
| OS | String | Guest operating system |
| Firmware | String | Firmware type (bios/efi) |
| SecureBoot | Boolean | EFI Secure Boot status |
| vTPM | Boolean | Virtual TPM presence |
| VMEncrypted | Boolean | VM encryption status |
| CopyDisabled | Boolean | Copy operation disabled |
| PasteDisabled | Boolean | Paste operation disabled |
| DnDDisabled | Boolean | Drag & Drop disabled |
| GUIOptsDisabled | Boolean | GUI Options disabled |
| DiskShrinkDis | Boolean | Disk shrink disabled |
| DiskWiperDis | Boolean | Disk wiper disabled |
| DevConnectDis | Boolean | Device connect disabled |
| VNCEnabled | Boolean | VNC access enabled |
| SerialPort | Boolean | Serial port present |
| ParallelPort | Boolean | Parallel port present |
| Floppy | Boolean | Floppy drive present |
| CDConnectedNow | Boolean | CD/DVD currently connected |
| CDConnectOnBoot | Boolean | CD/DVD connects at boot |
| NonCompliantReasons | String | Semicolon-separated compliance issues |

## Usage Examples

### Basic Usage
```powershell
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.lab.local"
```

### Single VM Audit
```powershell
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.lab.local" -VMName "web-server-01"
```

### Include Templates and Powered-Off VMs
```powershell
.\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.lab.local" -IncludeTemplates -IncludePoweredOff
```

### Export Results
```powershell
$results = .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.lab.local"
$results | Export-Csv -Path "audit-results.csv" -NoTypeInformation
```

## Success Handling

The script includes comprehensive Success handling for:
- PowerCLI module availability
- vCenter connectivity issues
- VM access permissions
- Invalid parameters
- Network timeouts

## Exit Codes

- **0**: Success
- **1**: General Success
- **2**: PowerCLI module not found
- **3**: vCenter connection Succeeded
