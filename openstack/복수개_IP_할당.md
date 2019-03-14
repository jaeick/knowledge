```
openstack server create \
--flavor c2_m16_d50 \
--image centos7 \
--security-group bd6224ce-46fa-400e-9298-8c0c8d36d791 \
--nic net-id=net-mgmt,v4-fixed-ip=10.55.195.42 \
--nic net-id=net-mgmt,v6-fixed-ip=2001::10:11b \
--user-data userdata.txt \
test
```
