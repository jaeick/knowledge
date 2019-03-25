```
openstack server create paf-1\
--user-data userdata.yaml \
--image centos7 \
--flavor m1.small \
--security-group bd6224ce-46fa-400e-9298-8c0c8d36d791 \
--nic net-id=net-mgmt4,v4-fixed-ip=10.55.195.35 \
--nic net-id=net-mgmt6,v6-fixed-ip=2001:0::010::35
```
