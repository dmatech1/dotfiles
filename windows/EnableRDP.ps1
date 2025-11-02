
# Enable the following firewall rules that should already exist in Windows 10/11:
# "Remote Desktop - Shadow (TCP-In)" (Profile: Domain, Private, Public)
# "Remote Desktop - User Mode (TCP-In)" (Profile: Domain, Private, Public)
# "Remote Desktop - User Mode (UDP-In)" (Profile: Domain, Private, Public)
#
# Note that I probably shouldn't do that, as this shouldn't be enabled on the "Public" profile.
# Perhaps I should use "Get-NetConnectionProfile" and "Set-NetConnectionProfile" instead.

Enable-NetFirewallRule -Name RemoteDesktop-Shadow-In-TCP,RemoteDesktop-UserMode-In-TCP,RemoteDesktop-UserMode-In-UDP

# Stop denying RDP connections.
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
