## Static IP address of **ubuntu**
<pre><code>
# vi /etc/network/interfaces
auto enp0s3
iface enp0s3 inet static
address 10.0.2.15
netmask 255.255.255.0
network 10.0.2.0
gateway 10.0.2.2
dns-nameserver 8.8.8.8
</pre></code>

## Static IP address of **CentOS**
<pre><code>
# vi  /etc/sysconfig/network-scripts/ifcfg-enp0s29u1u2
TYPE=Ethernet
DEVICE=enp0s29u1u2
ONBOOT=yes
BOOTPROTO=static
IPADDR=10.55.195.5
NETMASK=255.255.255.0
GATEWAY=10.55.195.254
DNS1=8.8.8.8
</pre></code>

## restart network service
<pre><code>
# service network restart
</pre></code>

## Add static route
<pre><code>
# route add default gw 192.168.1.254
# ip route add default via 192.168.1.25
</pre></code>
