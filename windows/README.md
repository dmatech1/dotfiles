# Overview

| Item | Notes |
| :-- | :--- |
| [AllowPings.ps1](AllowPings.ps1) | Modifies the Windows Firewall rules to allow ICMP4. |
| [AltTabViewHost.reg](AltTabViewHost.reg) | Makes the Alt+Tab thumbnails much smaller (allowing more on the screen). |
| [ChromeUpdates.reg](ChromeUpdates.reg) | Alerts within one hour of Chrome updates being available. |
| [ConfigureEventLogs.ps1](ConfigureEventLogs.ps1) | Enables significantly more logging in Windows for troubleshooting. |
| [DisableFastStartup.reg](DisableFastStartup.reg) | Disables Windows "Fast Startup" so that Wake-on-LAN works. |
| [EnableRDP.reg](EnableRDP.reg) | Enables RDP support on port 3389. |
| [ExplorerW10.reg](ExplorerW10.reg) | Windows 10 Explorer settings. |
| [KeyboardAccessibility.reg](KeyboardAccessibility.reg) | Disable some keyboard shortcuts and enable underlines. |
| [PatchWinREScript_2004plus.ps1](PatchWinREScript_2004plus.ps1) | Original version can be found at [KB5034957](https://support.microsoft.com/en-us/topic/kb5034957-updating-the-winre-partition-on-deployed-devices-to-address-security-vulnerabilities-in-cve-2024-20666-0190331b-1ca3-42d8-8a55-7fc406910c10) or [KB5025175](https://support.microsoft.com/en-us/topic/kb5025175-updating-the-winre-partition-on-deployed-devices-to-address-security-vulnerabilities-in-cve-2022-41099-ba6621fa-5a9f-48f1-9ca3-e13eb56fb589).  It patches WinRE in Windows 10 or 11 to fix security issues and requires the CAB file appropriate for the architecture and version of Windows at the [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=Safe%20OS). |
| [ScreenSaver300.reg](ScreenSaver300.reg) | Enables an auto-locking screen saver after 5 minutes. |

# Notes

* Before you can run any `.ps1` script, you'll need to [change the execution policy](<https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4>):
  
  ```ps1
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
  ```

# TO-DO

In addition to what's here, I typically need to do the following when setting up a new machine.

* Change the Time Zone.  I can do this with the following PowerShell command:
  
  ```ps1
  Set-TimeZone -Id "Eastern Standard Time"
  ```
* Disable (or otherwise extend) automatic sleep when plugged in.  This can be done with [POWERCFG.EXE](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options) automatically or `control /name Microsoft.PowerOptions` to open the GUI.
* See the following for more info:
  * https://news.ycombinator.com/item?id=43889093
  * https://ss64.com/nt/syntax-reghacks.html
