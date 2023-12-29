# General Settings

This can be [done automatically](https://www.raspberrypi.com/documentation/computers/configuration.html#the-raspi-config-command-line-interface)
or [interactively](https://www.raspberrypi.com/documentation/computers/configuration.html#the-raspi-config-tool) with `raspi-config`.

```bash
# 3 Interface Options       Configure connections to peripherals
# P2 SSH                    Enable/disable remote command line access using SSH

# 1 System Options          Configure system settings
# S1 Wireless LAN           Enter SSID and passphrase

# 1 System Options          Configure system settings
# S7 Splash Screen          Choose graphical splash screen or text boot
sudo raspi-config nonint do_boot_splash 1
```

## Log Rotation

`/etc/logrotate.conf`

```
rotate 400
create
compress
```

## Disabling "CUPS"

I can't imagine ever needing to print from one of these devices, so I disabled the
[CUPS](https://www.cups.org/) services.  I have plenty of storage, so I don't need
to completely remove them.

```bash
sudo systemctl stop cups.service cups-browsed.service cups.path cups.socket
sudo systemctl disable cups.service cups-browsed.service cups.path cups.socket
```

## Useful Packages

Raspbian doesn't include a lot of useful stuff as part of the default installation, so
I typically get a bunch of extra packages.

### Networking

| Package           | Description |
| :---------------- | :---------- |
| hping3            | Active Network Smashing Tool |
| iputils-arping    | Tool to send ICMP echo requteests to an ARP address |
| iputils-tracepath | Tools to trace the network path to a remote host |
| mtr               | Full screen ncurses and X11 traceroute tool |
| ncat              | NMAP netcat reimplementation |
| netcat-openbsd    | TCP/IP swiss army knife |
| nmap              | The Network Mapper |
| socat             | multipurpose relay for bidirectional data transfer |
| tcpdump           | command-line network traffic analyzer |
| traceroute        | Traces the route taken by packets over an IPv4/IPv6 network |
| wakeonlan         | Sends 'magic packets' to wake-on-LAN enabled ethernet adapters |

| Package           | Description |
| :---------------- | :---------- |
| pv                | Shell pipeline element to meter data passing through |
| vim               | Vi IMproved - enhanced vi editor |

```bash
sudo apt install hping3 iputils-arping iputils-tracepath mtr ncat netcat-openbsd nmap socat tcpdump traceroute wakeonlan pv vim
```

Also make sure that everything is up to date.

```bash
sudo apt update -y
sudo apt list --upgradable
sudo apt full-upgrade -y
```

# Device-Specific Configuration

## Raspberry Pi Zero W Customizations

These devices are fairly old and underpowered, so I stripped down the configuration
to free memory and speed up the bootup process.

### Disabling the GUI

It's possible to use these things with X, but they boot faster if they stay in text mode.

```bash
# 1 System Options          Configure system settings
# S5 Boot / Auto Login      Select boot into desktop or to command line
# B1 Console                Text console, requiring user to login
sudo raspi-config nonint do_boot_behaviour B1

# 4 Performance Options     Configure performance settings
# P2 GPU Memory             Change the amount of memory made available to the GPU
sudo ...
```

## Raspberry Pi 4

This device has enough memory to use X without issues.  But I still disable CUPS because I don't need it.

# Upgrading

Before doing anything, do something like the following to back up the most important stuff.

```bash
ssh pi@192.168.1.22 sudo tar cJv /root /etc /home/pi /var/lib/dpkg/ > rpi-zero-w-1.tar.xz
```

Write the newest image to a new Micro SD card and set things up as usual.  Before
stepping away, be sure to enable SSH and run this command to get the host key fingerprint.

```
pi@rpi-zero-w-1:~ $ ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:o3yf+VIptOyDsEHBoZ7drmMTZcQDkDr2gh9KN6EBfZc root@(none) (ED25519)
```

Until the old keys are restored, use an alternate `known_hosts` file.  Make sure the fingerprint matches what's above.

```
dma@vestibule:~$ ssh -o UserKnownHostsFile=~/.ssh/RPI_SETUP_KH pi@192.168.1.22
The authenticity of host '192.168.1.22 (192.168.1.22)' can't be established.
ED25519 key fingerprint is SHA256:o3yf+VIptOyDsEHBoZ7drmMTZcQDkDr2gh9KN6EBfZc.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
