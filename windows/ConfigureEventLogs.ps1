# This script is intended to enable additional event logging as well as enable automatic archiving
# of logs that get too large.
#
# Windows event logs are stored at "C:\Windows\System32\Winevt\Logs" by default.
#
# An overview of all logs can be generated using the following:
# Get-WinEvent -ListLog * | Format-Table LogMode, MaximumSizeInBytes, RecordCount, IsEnabled, LogName
# Get-WinEvent -ListLog * | Sort-Object -Property LogName | Format-Table LogMode, IsEnabled, LogName

# =============================================================
# Configure a specific event log.
# =============================================================
function Enable-Log {
    param (
        [Parameter(Mandatory)]
        [string]$LogName,

        [Nullable[long]]$SizeKB,
        [switch]$DoNotRetain
    )

    # Output the name of the log to enable diagnosis of any failures.
    Write-Host $LogName

    # Get the log object.
    $log = New-Object System.Diagnostics.Eventing.Reader.EventLogConfiguration $LogName

    if (!$log.IsEnabled) {
        $log.IsEnabled = $true                      # Enable the log.  More logging is better, right?
    }

    if (! $DoNotRetain ) {
        $log.LogMode = 1                            # Enable automatic archiving.
    }

    if ($SizeKB -ne $null) {
        $log.MaximumSizeInBytes = $SizeKB * 1024    # Set the maximum size.
    }

    # Save all the changes.
    $log.SaveChanges()
}

# =============================================================
# Log configuration
# =============================================================

# Make sure the standard event logs are backed up.
Enable-Log "Application"    -SizeKB 10240
Enable-Log "Security"       -SizeKB 20480       # This one seemingly can't be shrunk below this size.
Enable-Log "System"         -SizeKB 10240
Enable-Log "Setup"          -SizeKB 10240

# For some silly reason, Windows doesn't log task manager stuff by default.  Fix that here.
Enable-Log "Microsoft-Windows-TaskScheduler/Maintenance" -SizeKB 4096
Enable-Log "Microsoft-Windows-TaskScheduler/Operational" -SizeKB 4096

Enable-Log "Microsoft-Windows-Kernel-PnP/Configuration"                 -SizeKB 2048    # Contains hardware event information.
Enable-Log "Microsoft-Windows-DriverFrameworks-UserMode/Operational"    -SizeKB 4096    # Contains some hardware events.
Enable-Log "Microsoft-Windows-Storage-Disk/Admin"                       -SizeKB 2048    # ...
Enable-Log "Microsoft-Windows-Storage-Disk/Operational"                 -SizeKB 2048    # ...
Enable-Log "Microsoft-Windows-VerifyHardwareSecurity/Operational"       -SizeKB 2048    # ...
Enable-Log "Microsoft-Windows-BitLocker/BitLocker Management"           -SizeKB 2048    # Contains things like unlocking drives.
Enable-Log "Microsoft-Windows-BitLocker/BitLocker Operational"          -SizeKB 2048    # Unsure.
Enable-Log "Microsoft-Windows-StorageSpaces-Driver/Operational"         -SizeKB 2048    # Contains some information about attached devices.
Enable-Log "Microsoft-Windows-LSA/Operational"                          -SizeKB 4096    # Contains some authentication stuff.
Enable-Log "Microsoft-Windows-Dhcp-Client/Admin"                        -SizeKB 2048    # Contains DHCP events.
Enable-Log "Microsoft-Windows-Dhcp-Client/Operational"                  -SizeKB 2048    # Contains DHCP events.
Enable-Log "Microsoft-Windows-Windows Defender/Operational"             -SizeKB 4096    # Contains malware scan events.
Enable-Log "Microsoft-Windows-Windows Defender/WHC"                     -SizeKB 4096    # Contains malware scan events.
