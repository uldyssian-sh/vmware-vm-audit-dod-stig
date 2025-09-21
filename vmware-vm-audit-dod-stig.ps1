<#
===============================================================================
 Project : vmware-vm-audit-dod-stig
 Author  : Paladin alias LT
 Version : 1.1
 Target  : VMware vSphere 8
 File    : vmware-vm-audit-dod-stig.ps1
===============================================================================

 DISCLAIMER
 ----------
 This script is provided "as is", without any warranty of any kind.
 Use it at your own risk. You are solely responsible for reviewing,
 testing, and implementing it in your own environment.

 DESCRIPTION
 -----------
 Audits VMware vSphere 8 Virtual Machine configuration against common
 DoD STIG / hardening recommendations. It is READ-ONLY (no remediation).
 The script prints a full table with all columns directly to the console.

 USAGE
 -----
 Run the script:
   .\vmware-vm-audit-dod-stig.ps1 -vCenter "vcsa.lab.local" -VMName "test-vm"

 PARAMETERS
 ----------
 -vCenter          vCenter Server FQDN or IP (mandatory).
 -VMName           Single VM name (optional; if omitted, all VMs are checked).
 -IncludeTemplates Include VM templates (default: off).
 -IncludePoweredOff
                   Include powered-off VMs (default: on).

 REQUIREMENTS
 ------------
 - PowerShell 7+ (or Windows PowerShell 5.1)
 - VMware.PowerCLI module (13+)
===============================================================================
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$vCenter,

  [string]$VMName,

  [switch]$IncludeTemplates,
  [switch]$IncludePoweredOff = $true
)

# --- Helper functions -----------------------------------------------------

function Get-AdvValue {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [PSObject]$VM,
    [Parameter(Mandatory = $true)]
    [string]$Name
  )
  try { ($VM | Get-AdvancedSetting -Name $Name -ErrorAction Stop).Value } catch { $null }
}

function Test-AdvTrue {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][PSObject]$VM,
    [Parameter(Mandatory = $true)][string]$Name
  )
  $v = Get-AdvValue -VM $VM -Name $Name
  if ($null -eq $v) { $false } else { [bool]$v }
}

function Test-AdvFalseOrMissing {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][PSObject]$VM,
    [Parameter(Mandatory = $true)][string]$Name
  )
  $v = Get-AdvValue -VM $VM -Name $Name
  if ($null -eq $v) { return $true } else { return -not ([bool]$v) }
}

function Get-DeviceFlags {
  [CmdletBinding()]
  param([PSObject]$Device)
  $now  = $false
  $onpo = $false
  try {
    if ($Device.ConnectionState) { $now  = [bool]$Device.ConnectionState.Connected }
    if ($Device.Connectable)     { $onpo = [bool]($Device.Connectable.Connected -or $Device.Connectable.StartConnected) }
  } catch {}
  [PSCustomObject]@{
    ConnectedNow     = $now
    ConnectAtPowerOn = $onpo
  }
}

function Get-EncState {
  [CmdletBinding()]
  param([PSObject]$VM)
  try {
    $cfg = $VM.ExtensionData.Config
    $vmHomeEncrypted = $null -ne $cfg.KeyId
    $diskEncrypted = $false
    foreach ($d in $cfg.Hardware.Device) {
      if ($d -is [VMware.Vim.VirtualDisk] -and $d.Backing -and $d.Backing.KeyId) { $diskEncrypted = $true; break }
    }
    [PSCustomObject]@{
      VMHomeEncrypted  = $vmHomeEncrypted
      AnyDiskEncrypted = $diskEncrypted
      VMEncrypted      = ($vmHomeEncrypted -or $diskEncrypted)
    }
  } catch {
    [PSCustomObject]@{ VMHomeEncrypted=$null; AnyDiskEncrypted=$null; VMEncrypted=$null }
  }
}

# --- Load PowerCLI & Connect ----------------------------------------------
if (-not (Get-Module -ListAvailable -Name VMware.PowerCLI)) {
  throw "VMware.PowerCLI module is required. Install-Module VMware.PowerCLI"
}
Import-Module VMware.PowerCLI -ErrorAction Stop | Out-Null
Set-PowerCLIConfiguration -Scope Session -InvalidCertificateAction Ignore -Confirm:$false | Out-Null

Write-Output "Connecting to $vCenter ..."
$null = Connect-VIServer -Server $vCenter

# --- Collect VMs ----------------------------------------------------------
$vms = if ($VMName) { Get-VM -Name $VMName -ErrorAction Stop } else { Get-VM }

if (-not $IncludeTemplates)  { $vms = $vms | Where-Object { -not $_.ExtensionData.Config.Template } }
if (-not $IncludePoweredOff) { $vms = $vms | Where-Object { $_.PowerState -eq 'PoweredOn' } }

# --- Audit loop -----------------------------------------------------------
$results = foreach ($vm in $vms) {
  $cfg = $vm.ExtensionData.Config
  
  # Get OS info - for PoweredOff VMs use config, for PoweredOn use guest info
  $osInfo = if ($vm.PowerState -eq 'PoweredOff') {
    $cfg.GuestFullName
  } else {
    if ([string]::IsNullOrEmpty($vm.Guest.OSFullName)) { $cfg.GuestFullName } else { $vm.Guest.OSFullName }
  }

  # Advanced settings (console data movement / tools / VNC)
  $copyDisabled    = Test-AdvTrue         $vm 'isolation.tools.copy.disable'
  $pasteDisabled   = Test-AdvTrue         $vm 'isolation.tools.paste.disable'
  $dndDisabled     = Test-AdvTrue         $vm 'isolation.tools.dnd.disable'
  $guiOptsDisabled = Test-AdvFalseOrMissing $vm 'isolation.tools.setGUIOptions.enable'
  $diskShrinkDis   = Test-AdvTrue         $vm 'isolation.tools.diskShrink.disable'
  $diskWiperDis    = Test-AdvTrue         $vm 'isolation.tools.diskWiper.disable'
  $devConnectDis   = Test-AdvTrue         $vm 'isolation.device.connectable.disable'
  $vncEnabled      = Test-AdvTrue         $vm 'RemoteDisplay.vnc.enabled'

  # Firmware / Secure Boot / vTPM
  $firmware   = $cfg.Firmware
  $secureBoot = $false
  try { $secureBoot = [bool]$cfg.BootOptions.EfiSecureBootEnabled } catch {}
  $hasTPM = $false
  try {
    foreach ($d in $cfg.Hardware.Device) {
      if ($d -is [VMware.Vim.VirtualTPM]) { $hasTPM = $true; break }
    }
  } catch {}

  # Encryption posture
  $enc = Get-EncState -VM $vm

  # Device hygiene
  $serial = $false; $parallel=$false; $floppy=$false; $cdNow=$false; $cdOn=$false
  foreach ($d in $cfg.Hardware.Device) {
    switch -Regex ($d.GetType().Name) {
      'VirtualSerialPort'   { $serial   = $true }
      'VirtualParallelPort' { $parallel = $true }
      'VirtualFloppy'       { $floppy   = $true }
      'VirtualCdrom'        {
        $flags = Get-DeviceFlags -Device $d
        if ($flags.ConnectedNow)     { $cdNow = $true }
        if ($flags.ConnectAtPowerOn) { $cdOn  = $true }
      }
    }
  }

  # Build compliance notes
  $nonCompliant = @()
  if (-not $copyDisabled)    { $nonCompliant += 'Copy not disabled' }
  if (-not $pasteDisabled)   { $nonCompliant += 'Paste not disabled' }
  if (-not $dndDisabled)     { $nonCompliant += 'DragDrop not disabled' }
  if (-not $guiOptsDisabled) { $nonCompliant += 'GUIOptions not disabled' }
  if (-not $diskShrinkDis)   { $nonCompliant += 'DiskShrink not disabled' }
  if (-not $diskWiperDis)    { $nonCompliant += 'DiskWiper not disabled' }
  if (-not $devConnectDis)   { $nonCompliant += 'DeviceConnect not disabled' }
  if ($vncEnabled)           { $nonCompliant += 'VNC enabled' }

  if ($serial)   { $nonCompliant += 'Serial port present' }
  if ($parallel) { $nonCompliant += 'Parallel port present' }
  if ($floppy)   { $nonCompliant += 'Floppy drive present' }
  if ($cdNow)    { $nonCompliant += 'CD/DVD connected now' }
  if ($cdOn)     { $nonCompliant += 'CD/DVD connect at power on' }

  if ($firmware -ne 'efi')   { $nonCompliant += 'Not EFI firmware' }
  if ($firmware -eq 'efi' -and -not $secureBoot) { $nonCompliant += 'EFI Secure Boot disabled' }
  if (-not $hasTPM)          { $nonCompliant += 'vTPM not present' }

  [PSCustomObject]@{
    VMName           = $vm.Name
    PowerState       = $vm.PowerState
    OS               = $osInfo
    Firmware         = $firmware
    SecureBoot       = $secureBoot
    vTPM             = [bool]$hasTPM
    VMEncrypted      = $enc.VMEncrypted
    CopyDisabled     = $copyDisabled
    PasteDisabled    = $pasteDisabled
    DnDDisabled      = $dndDisabled
    GUIOptsDisabled  = $guiOptsDisabled
    DiskShrinkDis    = $diskShrinkDis
    DiskWiperDis     = $diskWiperDis
    DevConnectDis    = $devConnectDis
    VNCEnabled       = $vncEnabled
    SerialPort       = $serial
    ParallelPort     = $parallel
    Floppy           = $floppy
    CDConnectedNow   = $cdNow
    CDConnectOnBoot  = $cdOn
    NonCompliantReasons = ($nonCompliant -join '; ')
  }
}

# --- Export results ---------------------------------------------------
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvPath = "VMware_DoD_STIG_Audit_$timestamp.csv"
$htmlPath = "VMware_DoD_STIG_Audit_Report_$timestamp.html"

# Export to CSV
$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Output "✅ CSV report exported: $csvPath"

# Generate HTML report
$compliantCount = ($results | Where-Object {[string]::IsNullOrEmpty($_.NonCompliantReasons)}).Count
$nonCompliantCount = ($results | Where-Object {-not [string]::IsNullOrEmpty($_.NonCompliantReasons)}).Count

$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>VMware DoD STIG Audit Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2c3e50; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #3498db; color: white; }
        .compliant { background-color: #d5f4e6; }
        .non-compliant { background-color: #ffeaa7; }
        .summary { background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <h1>🔒 VMware DoD STIG Audit Report</h1>
    <div class="summary">
        <h3>📊 Summary</h3>
        <p><strong>Report Generated:</strong> $(Get-Date)</p>
        <p><strong>vCenter Server:</strong> $vCenter</p>
        <p><strong>Total VMs Audited:</strong> $($results.Count)</p>
        <p><strong>Compliant VMs:</strong> $compliantCount</p>
        <p><strong>Non-Compliant VMs:</strong> $nonCompliantCount</p>
    </div>
    <table>
        <tr>
            <th>VM Name</th>
            <th>Power State</th>
            <th>OS</th>
            <th>Firmware</th>
            <th>Secure Boot</th>
            <th>vTPM</th>
            <th>VM Encrypted</th>
            <th>Non-Compliant Reasons</th>
        </tr>
"@

foreach ($vm in $results) {
    $rowClass = if ([string]::IsNullOrEmpty($vm.NonCompliantReasons)) { "compliant" } else { "non-compliant" }
    $htmlContent += "        <tr class=`"$rowClass`"><td>$($vm.VMName)</td><td>$($vm.PowerState)</td><td>$($vm.OS)</td><td>$($vm.Firmware)</td><td>$($vm.SecureBoot)</td><td>$($vm.vTPM)</td><td>$($vm.VMEncrypted)</td><td>$($vm.NonCompliantReasons)</td></tr>`r`n"
}

$htmlContent += "    </table></body></html>"

# Save HTML report
$htmlContent | Out-File -FilePath $htmlPath -Encoding UTF8
Write-Output "✅ HTML report generated: $htmlPath"

# Display console output
$results | Format-Table -Property VMName, PowerState, OS, Firmware, SecureBoot, vTPM, VMEncrypted, NonCompliantReasons -Wrap

# Open HTML report
Start-Process $htmlPath
Write-Output "🌐 HTML report opened in browser"

