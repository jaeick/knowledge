## ovs
```
[root@controller ~(keystone)]# ovs-vsctl add-br br-ens4f0
[root@controller ~(keystone)]# ovs-vsctl add-port br-ens4f0 ens4f0
```

## vi /etc/neutron/plugins/ml2/ml2_conf.ini
```
[ml2_type_vlan]
network_vlan_ranges = srvnet
```

## vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```
[ovs]
bridge_mappings = srvnet:br-ens4f0
```

## openstack network
```
[root@controller ~(keystone)]# openstack network create net-service-ovs-20\
--provider-network-type vlan \
--provider-physical-network srvnet \
--provider-segment 20 


[root@controller ~(keystone)]# openstack subnet create subnet-service-ovs-20-v6 \
--network net-service-ovs-20 \
--ip-version 6 \
--subnet-range 2001::20:0/112 \
--allocation-pool start=2001::20:100,end=2001::20:200 \
--gateway none 
```
