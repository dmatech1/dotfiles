# Raspberry Pi Zero W Customizations

These devices are fairly old and underpowered, so I stripped down the configuration
to free memory and speed up the bootup process.

## Disabling the GUI

It's possible to use these things with X, but they boot faster if they stay in text
mode.  This can be [done automatically](https://www.raspberrypi.com/documentation/computers/configuration.html#the-raspi-config-command-line-interface)
or [interactively](https://www.raspberrypi.com/documentation/computers/configuration.html#the-raspi-config-tool) with `raspi-config`.

```bash
# 1 System Options          Configure system settings
# S5 Boot / Auto Login      Select boot into desktop or to command line
# B1 Console                Text console, requiring user to login
sudo raspi-config nonint do_boot_behaviour B1
```

```bash
# 3 Interface Options       Configure connections to peripherals
# P2 SSH                    Enable/disable remote command line access using SSH

# 1 System Options          Configure system settings
# S1 Wireless LAN           Enter SSID and passphrase

# 1 System Options          Configure system settings
# S7 Splash Screen          Choose graphical splash screen or text boot

# 4 Performance Options     Configure performance settings
# P2 GPU Memory             Change the amount of memory made available to the GPU
```

## Disabling "CUPS"

I can't imagine ever needing to print from one of these devices, so I disabled the
[CUPS](https://www.cups.org/) services.  I have plenty of storage, so I don't need
to completely remove them.

```bash
sudo systemctl stop cups.service cups-browsed.service cups.path cups.socket
sudo systemctl disable cups.service cups-browsed.service cups.path cups.socket
```

# Raspberry Pi 4

This device has enough memory to use X without issues.  But I still disable CUPS because I don't need it.

## Dual ISPs

**Contents of `/lib/dhcpcd/dhcpcd-hooks/80-usb0-route`:**
```bash
# Allow the alternate interface to work a bit more easily.

table=vzw
priority=32700

if [ "$interface" = "usb0" ]
then
    if [ "$reason" = "BOUND" ]
    then
        # Delete any old records.
        ip route flush table ${table}
        ip rule del priority ${priority} 2>/dev/null

        # Add the new ones.
        ip route add default via ${new_routers} dev ${interface} metric ${ifmetric} mtu ${new_interface_mtu} table ${table}
        ip rule add priority ${priority} from ${new_ip_address} lookup ${table}
    fi
fi
```

**Contents of `/etc/iproute2/rt_tables.d/vzw.conf`:**
```
252     vzw
```

**Added to `/etc/dhcpcd.conf`:**
```
interface usb0
metric 3000
```

# Useful Packages

Raspbian doesn't include a lot of useful stuff as part of the default installation, so
I typically get a bunch of extra packages.

## Networking

| Package           | Description |
| :---------------- | :---------- |
| hping3            | Active Network Smashing Tool |
| iputils-arping    | Tool to send ICMP echo requteests to an ARP address |
| iputils-tracepath | Tools to trace the network path to a remote host |
| mtr               | Full screen ncurses and X11 traceroute tool |
| ncat              | NMAP netcat reimplementation |
| netcat            | TCP/IP swiss army knife -- transitional package |
| nmap              | The Network Mapper |
| socat             | multipurpose relay for bidirectional data transfer |
| tcpdump           | command-line network traffic analyzer |
| traceroute        | Traces the route taken by packets over an IPv4/IPv6 network |
| wakeonlan         |  Sends 'magic packets' to wake-on-LAN enabled ethernet adapters |
