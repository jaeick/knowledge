```
[root@controller ~(keystone)]# openstack project list
+----------------------------------+---------+
| ID                               | Name    |
+----------------------------------+---------+
| 08e5a1eeb81d40d4aebda61e1c38eb01 | admin   |
| 13aeeaaa21da47d99eea158a4bc6dc5e | service |
+----------------------------------+---------+
```

```
[root@controller ~(keystone)]# openstack security group list
+--------------------------------------+---------+------------------------+----------------------------------+
| ID                                   | Name    | Description            | Project                          |
+--------------------------------------+---------+------------------------+----------------------------------+
| 3b1ad8d1-52a7-4716-b53d-fa9e91ede660 | default | Default security group | 13aeeaaa21da47d99eea158a4bc6dc5e |
| ac6d4c2e-3a20-4203-9847-7c7fc4c639e7 | default | Default security group |                                  |
| bd6224ce-46fa-400e-9298-8c0c8d36d791 | default | Default security group | 08e5a1eeb81d40d4aebda61e1c38eb01 |
+--------------------------------------+---------+------------------------+----------------------------------+
```

```
[root@controller ~(keystone)]# openstack security group rule create --protocol icmp --ingress bd6224ce-46fa-400e-9298-8c0c8d36d791
[root@controller ~(keystone)]# openstack security group rule create --protocol tcp --ingress bd6224ce-46fa-400e-9298-8c0c8d36d791
[root@controller ~(keystone)]# openstack security group rule create --protocol udp --ingress bd6224ce-46fa-400e-9298-8c0c8d36d791t
```


