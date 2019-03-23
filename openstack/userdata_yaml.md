```
#cloud-config
password: openstack
chpasswd:
  expire: False
ssh_pwauth: True
timezone: Asia/Seoul
```

```
network:
  version: 1
  config:
    - type: physical
      name: eth0
      subnet:
        - type: dhcp6
    - type: physical
      name: eth1
      subnet:
        - type: dhcp6
```
