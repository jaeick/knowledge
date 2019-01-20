## image 등록

[root@controller ~(keystone)]#  wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2

[root@controller ~(keystone)]# openstack image create \\ \
--file CentOS-7-x86_64-GenericCloud.qcow2 \\ \
--disk-format qcow2 --container-format bare  \\ \
--public \\ \
centos7

[root@controller ~(keystone)]# openstack image list
```
+--------------------------------------+-------------+--------+
| ID                                   | Name        | Status |
+--------------------------------------+-------------+--------+
| 296ed643-3977-49e3-8641-57d98ae8e2db | centos7     | active |
+--------------------------------------+-------------+--------+
```

## Flavor 생성

[root@controller ~(keystone)]# openstack flavor create \\ \
--id 0 --ram 2048 --disk 20 --vcpus 1 --public \\ \
m1.small 

[root@controller ~(keystone)]# openstack flavor list
```
+----+----------+------+------+-----------+-------+-----------+
| ID | Name     |  RAM | Disk | Ephemeral | VCPUs | Is Public |
+----+----------+------+------+-----------+-------+-----------+
| 0  | m1.small | 2048 |   10 |         0 |     1 | True      |
+----+----------+------+------+-----------+-------+-----------+
```

## Security-group rule 등록

[root@controller ~(keystone)]# openstack project list

```
+----------------------------------+---------+
| ID                               | Name    |
+----------------------------------+---------+
| 08e5a1eeb81d40d4aebda61e1c38eb01 | admin   |
| 13aeeaaa21da47d99eea158a4bc6dc5e | service |
+----------------------------------+---------+
```

[root@controller ~(keystone)]# openstack security group list
```
+--------------------------------------+---------+------------------------+----------------------------------+
| ID                                   | Name    | Description            | Project                          |
+--------------------------------------+---------+------------------------+----------------------------------+
| 3b1ad8d1-52a7-4716-b53d-fa9e91ede660 | default | Default security group | 13aeeaaa21da47d99eea158a4bc6dc5e |
| ac6d4c2e-3a20-4203-9847-7c7fc4c639e7 | default | Default security group |                                  |
| bd6224ce-46fa-400e-9298-8c0c8d36d791 | default | Default security group | 08e5a1eeb81d40d4aebda61e1c38eb01 |
+--------------------------------------+---------+------------------------+----------------------------------+
```

[root@controller ~(keystone)]# openstack security group rule create --protocol icmp --ingress bd6224ce-46fa-400e-9298-8c0c8d36d791

[root@controller ~(keystone)]# openstack security group rule create --protocol tcp --ingress bd6224ce-46fa-400e-9298-8c0c8d36d791

[root@controller ~(keystone)]# openstack security group rule create --protocol udp --ingress bd6224ce-46fa-400e-9298-8c0c8d36d791t

## userdata 생성

[root@controller ~(keystone)]# vi userdata.yaml
```
#cloud-config

password: openstack
chpasswd:
  expire: False

ssh_pwauth: True

timezone: Asia/Seoul
```

## Start instance

[root@controller ~(keystone)]# openstack server create \\ \
--flavor m1.small \\ \
--image centos7 \\ \
--security-group bd6224ce-46fa-400e-9298-8c0c8d36d791 \\ \
--nic net-id=net-provider1,v4-fixed-ip=10.55.195.37 \\ \
--user-data userdata.ymal \\ \
vm-fixed-v4
