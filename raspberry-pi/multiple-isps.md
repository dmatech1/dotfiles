# Multiple ISPs

In addition to my primary ISP, I'm using a Verizon Hotspot device.  The plan supposedly doesn't
have a hard cap or overage charges (only throttling) and costs $10/month.  The device is an
[Orbic Speed](https://www.verizon.com/internet-devices/verizon-orbic-speed-mobile-hotspot/)
that supports networking and charging over USB as well as 2.4GHz or 5GHz wireless.
For now, I'm using USB as I'm already using the wireless radio.  This has the added benefit
of keeping it charged, although it might wear out the battery faster.

## Networking Background

This Raspberry Pi runs a variant of Debian.  At the moment, I have the choice between
[dhcpcd](https://roy.marples.name/projects/dhcpcd) (the default) and [NetworkManager](https://wiki.debian.org/NetworkManager)
(a more complex solution mostly developed by Red Hat).  I'm just using dhcpcd as it works well enough.

## Metric

Unless we want to use the 4G connection as the primary outbound route, we must give it a
sufficiently high metric value.  Note that if IPv6 not disabled with `net.ipv6.conf.all.disable_ipv6`,
the 4G connection will be the *only* IPv6 gateway.  By default, `/etc/gai.conf` [prioritizes](https://askubuntu.com/a/38468)
IPv6 addresses in DNS lookups, so this might result in a lot of traffic over that slower link.

I'd like to fully support IPv6 here, but for the moment, I'll keep things IPv4-only until I know
I can do it securely.  For that, I'd need predictable IPv6 addresses for many of my devices, and
I'd also probably need to keep these consistent with a DNS zone.

**Added to `/etc/dhcpcd.conf`:**
```
interface usb0
metric 3000
```

## Adding a Routing Table

Actually *using* the secondary interface is still a bit of a problem.  A close look at the output
of `ip rule list` and `ip route list table all` will show that by default, the source IP address
won't actually affect what interface is used, so [`bind`](https://man7.org/linux/man-pages/man2/bind.2.html)
is not sufficient.  You can use [`SO_BINDTODEVICE`](https://man7.org/linux/man-pages/man7/socket.7.html#:~:text=since%20Linux%204.6.-,SO_BINDTODEVICE,-Bind%20this%20socket)
with [`setsockopt`](https://man7.org/linux/man-pages/man2/setsockopt.2.html) to force traffic
over an interface, but `curl` is the only software I know [that does this](https://github.com/curl/curl/blob/2683de3078eadc86d9b182e7417f4ee75a247e2c/lib/cf-socket.c#L448-L469).

The solution is to maintain [multiple routing tables](https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.rpdb.multiple-links.html)
with `ip rule`, and it's not terribly difficult to integrate this into scripts that handle
network events.

**Contents of `/etc/iproute2/rt_tables.d/vzw.conf`:**
```
252     vzw
```

## Automating Rule and Route Creation

**Contents of `/lib/dhcpcd/dhcpcd-hooks/80-usb0-route`:**
```bash
# Allow the alternate interface to work a bit more easily.
# If we wanted to, we could check "/sys/class/net/${interface}/device"
# to make sure it's the correct piece of hardware.  Additionally,
# IPv6 would need similar work to route correctly.

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

# NetworkManager Setup

In addition to configuring `/etc/iproute2/rt_tables.d/vzw.conf` as shown
above, do the following:

```bash
# Rename it to something more descriptive.
nmcli connection modify "Wired connection 1" connection.id verizon_4g

# Give it a very high metric so that it won't normally be used.
nmcli connection modify verizon_4g ipv4.route-metric 3000

# Disable IPv6.
nmcli connection modify verizon_4g ipv6.method disabled
```

**Contents of `/etc/NetworkManager/dispatcher.d/80-usb0-route`:**
```bash
#!/bin/bash
# Allow the alternate interface to work a bit more easily.
#
# See: https://networkmanager.dev/docs/api/latest/NetworkManager-dispatcher.html

table=vzw
priority=32700

if [ "${CONNECTION_ID}" = "verizon_4g" ]
then
    case $2 in
        up|dhcp4-change)
            # Parse out the metric from IP4_ROUTE_0.  We're not currently
            # using it.
            if [[ ${IP4_ROUTE_0} =~ (.*)\ (.*)\ (.*) ]]
            then
                ifmetric=${BASH_REMATCH[3]}
            fi

            # Delete any old records for the table and rule pointing to it.
            ip route flush table ${table}
            ip rule del priority ${priority} 2>/dev/null

            # Add the new ones.  We don't actually need the metric as this is a separate table.
            ip route add default via ${DHCP4_ROUTERS} dev ${DEVICE_IP_IFACE} mtu ${DHCP4_INTERFACE_MTU} table ${table}
            ip rule add priority ${priority} from ${DHCP4_IP_ADDRESS} lookup ${table}
            ;;
        
        down)
            # Delete the table and the rule pointing to it.
            ip route flush table ${table}
            ip rule del priority ${priority} 2>/dev/null
            ;;
    esac
fi
```
