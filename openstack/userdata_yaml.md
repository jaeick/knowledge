```
#cloud-config

password: openstack
chpasswd: {expire: False}
ssh_pwauth: True
timezone: Asia/Tokyo
fqdn: ems-c
hostname: ems-c

write_files:  
  - path: /etc/hosts
    permissions: '0644'
    content: |
      127.0.0.1   localhost localhost.localdomain
      ::1         localhost localhost.localdomain
      # internal
      240b:c0e0:101:5545::1:0 ems-u-int
      240b:c0e0:101:5545::1:1 ems-m-int
      240b:c0e0:101:5545::1:2 ems-c-m-int 
      240b:c0e0:101:5545::1:3 ems-c-s-int
      # external
      240b:c0e0:101:5546::1:1 ems-m
      240b:c0e0:101:5546::1:2 ems-c-m
      240b:c0e0:101:5546::1:3 ems-c-s
      240b:c0e0:101:5546::1:4 ems-c-vip
  - path: /etc/sysconfig/network
    permissions: '0644'
    content: |
      NETWORKING=yes
      NOZEROCONF=yes
      NETWORKING_IPV6=yes

yum_repos:
  ems:
    name: ems centos7 repo
    baseurl: http://ems-u-int/repo/centos/7
    enabled: True
    gpgcheck: False
  pgdg10:
    name: PostgreSQL 10 7 - x86_64
    baseurl: http://ems-u-int/repo/postgresql/10/redhat/rhel-7-x86_64
    enabled: True
    gpgcheck: False
```