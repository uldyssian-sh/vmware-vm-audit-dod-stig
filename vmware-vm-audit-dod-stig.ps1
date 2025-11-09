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
    OS               = $vm.Guest.OSFullName
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

# --- Console output only ---------------------------------------------------
# Print a full table with all columns. No CSV is produced.
$results | Format-Table -AutoSize

