
# Enable the "File and Printer Sharing (Echo Request - ICMPv4-In)" rule for both
# the "Domain" and "Private, Public" profiles.  This will allow the workstation
# to be pinged.

Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In-NoScope,FPS-ICMP4-ERQ-In
