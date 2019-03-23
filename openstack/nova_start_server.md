```
[root@controller ~(keystone)]# openstack server create SERVER1\
--user-data userdata.yaml \
--security-group bd6224ce-46fa-400e-9298-8c0c8d36d791 \
--image centos7 \
--flavor m1.small \
--nic net-id=net-provider1,v4-fixed-ip=10.55.195.37
```
