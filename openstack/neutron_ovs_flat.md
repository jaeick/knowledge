```
--------------------- Service
     |         |
     |eth1     |eth2
  +==================+
  |  controller      |
  +==================+
     |eth0
     |
--------------------- Management
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
bridge_mappings = physnet1:br-enp11s0,physnet2:br-ens4f0
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
