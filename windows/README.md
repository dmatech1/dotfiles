# Overview

| Item | Notes |
| :-- | :--- |
| [AllowPings.ps1](AllowPings.ps1) | Modifies the Windows Firewall rules to allow ICMP4. |
| [AltTabViewHost.reg](AltTabViewHost.reg) | Makes the Alt+Tab thumbnails much smaller (allowing more on the screen). |
| [ChromeUpdates.reg](ChromeUpdates.reg) | Alerts within one hour of Chrome updates being available. |
| [ConfigureEventLogs.ps1](ConfigureEventLogs.ps1) | Enables significantly more logging in Windows for troubleshooting. |
| [DisableFastStartup.reg](DisableFastStartup.reg) | Disables Windows "Fast Startup" so that Wake-on-LAN works. |
| [KeyboardAccessibility.reg](KeyboardAccessibility.reg) | Disable some keyboard shortcuts and enable underlines. |
| [PatchWinREScript_2004plus.ps1](PatchWinREScript_2004plus.ps1) | Original version can be found at [KB5034957](https://support.microsoft.com/en-us/topic/kb5034957-updating-the-winre-partition-on-deployed-devices-to-address-security-vulnerabilities-in-cve-2024-20666-0190331b-1ca3-42d8-8a55-7fc406910c10) or [KB5025175](https://support.microsoft.com/en-us/topic/kb5025175-updating-the-winre-partition-on-deployed-devices-to-address-security-vulnerabilities-in-cve-2022-41099-ba6621fa-5a9f-48f1-9ca3-e13eb56fb589).  It patches WinRE in Windows 10 or 11 to fix security issues and requires the CAB file appropriate for the architecture and version of Windows at the [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=Safe%20OS). |

# Notes

* Before you can run any `.ps1` script, you'll need to [change the execution policy](<https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4>):
  
  ```ps1
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
  ```
