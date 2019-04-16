## launch server with ipv6

config-drive 설정 필요

```
# openstack server create FLSW-EMS-U \
  --image centos \
  --flavor m1.small \
  --config-drive True \
  --user-data userdata.txt \
  --security-group FLSW-EMS \
  --nic net-id=net-int,v6-fixed-ip=240b:c0e0:101:5545::1:0
 ```