```
[root@controller ~(keystone)]# openstack server create SERVER1\
--user-data userdata.yaml \
--security-group bd6224ce-46fa-400e-9298-8c0c8d36d791 \
--image centos7 \
--flavor m1.small \
--nic net-id=net-provider1,v4-fixed-ip=10.55.195.37
```

## careate instance to speicifc host
```
$ openstack server create SERVER \
--image IMAGE \
--flavor m1.tiny \
--availability-zone ZONE:HOST:NODE \
--nic net-id=UUID 

use the ZONE::NODE, ZONE:HOST or ZONE
```

```
$ openstack availability zone list
+-----------+-------------+
| Zone Name | Zone Status |
+-----------+-------------+
| zone1     | available   |
| zone2     | available   |
+-----------+-------------+

$ openstack host list
+----------------+-------------+----------+
| Host Name      | Service     | Zone     |
+----------------+-------------+----------+
| compute01      | compute     | nova     |
| compute02      | compute     | nova     |
+----------------+-------------+----------+

$ openstack hypervisor list
+----+---------------------+
| ID | Hypervisor Hostname |
+----+---------------------+
|  1 | server2             |
|  2 | server3             |
|  3 | server4             |
+----+---------------------+
```
