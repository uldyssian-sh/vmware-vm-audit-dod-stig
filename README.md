# vmware-vm-audit-dod-stig

Author: **uldys­sian-sh**  
Target: **VMware vSphere 8**  
Version: **1.1**

---

## Overview

This project provides a PowerShell/PowerCLI script `vmware-vm-audit-dod-stig.ps1` that audits **Virtual Machine configuration settings** against common **DoD STIG / VMware vSphere 8 hardening recommendations**.

- Read-only: it does **not** modify VM configuration.
- Produces a **full table** directly in the PowerShell console.
- Checks include console data movement restrictions, VNC access, removable devices, firmware/Secure Boot/vTPM, and encryption posture.

---

## Requirements

- PowerShell 7+ (or Windows PowerShell 5.1)  
- [VMware.PowerCLI](https://developer.vmware.com/powercli) 13 or higher  

Install PowerCLI if not already installed:

```powershell
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
