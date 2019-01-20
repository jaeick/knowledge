```
Service2 -----------------------
                           |
Service1 ----------        |
             |             |
             |eth1         |eth2
          +======================+
          |                      |
          +======================+
                 |eth0
                 |
Management -------------------------- 
```

[root@controller ~(keystone)]# ovs-vsctl add-br br-eth1

[root@controller ~(keystone)]# ovs-vsctl add-port br-eth1 eth1

[root@controller ~(keystone)]# ovs-vsctl add-br br-eth2

[root@controller ~(keystone)]# ovs-vsctl add-port br-eth1 eth2

```
[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/ml2_conf.ini

[ml2_type_flat]
flat_networks = physnet1,physnet2
```

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```
[ovs]
bridge_mappings = physnet1:br-eth1,physnet2:br-eth2
```

[root@controller ~(keystone)]# systemctl restart neutron-openvswitch-agent

[root@controller ~(keystone)]# openstack network create \\ \
--provider-network-type flat \\ \
--provider-physical-network physnet1 \\ \
--share \\ \
net-provider1

[root@controller ~(keystone)]# openstack subnet create \\ \
--network net-provider1 \\ \
--subnet-range 10.55.195.0/24 \\ \
--allocation-pool start=10.55.195.32,end=10.55.195.39 \\ \
--gateway 10.55.195.254 --dns-nameserver 8.8.8.8 \\ \
subnet-provider1-v4

[root@controller ~(keystone)]# openstack network list
```
+--------------------------------------+---------------+--------------------------------------+
| ID                                   | Name          | Subnets                              |
+--------------------------------------+---------------+--------------------------------------+
| 646e41f2-7a4f-4fc2-b1f2-7625f276957d | net-provider1 | 881d1827-8d5b-4faf-9ade-dbec5c10ef91 |
+--------------------------------------+---------------+--------------------------------------+
```

[root@controller ~(keystone)]# openstack subnet list
```
+--------------------------------------+---------------------+--------------------------------------+----------------+
| ID                                   | Name                | Network                              | Subnet         |
+--------------------------------------+---------------------+--------------------------------------+----------------+
| 881d1827-8d5b-4faf-9ade-dbec5c10ef91 | subnet-provider1-v4 | 646e41f2-7a4f-4fc2-b1f2-7625f276957d | 10.55.195.0/24 |
+--------------------------------------+---------------------+--------------------------------------+----------------+
```