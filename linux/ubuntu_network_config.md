## IPv4 static
```
auto ens33
iface ens33 inet static
  address 192.168.1.100
  netmask 255.255.255.0
  gateway 192.168.1.1
  dns-nameservers 8.8.8.8 8.8.4.4
```

## IPv6 Static
```
auto ens4
iface ens4 inet6 static
  pre-up modprobe ipv6
  address 2001:0:0:10::33
  netmask 64
  gateway 2001:0:0:10::1
```

## restart
```
# systemctl restart networking
```
