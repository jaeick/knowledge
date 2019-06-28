## network
```
# cat /etc/sysconfig/network-scripts/ifcfg-ens4f1
DEVICE=ens4f1
NAME=ens4f1
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=none
```

## ovs
```
# ovs-vsctl add-br br-ens4f1
# ovs-vsctl add-port br-ens4f1 ens4f1
```

## vi /etc/neutron/plugins/ml2/ml2_conf.ini
```
[ml2_type_vlan]
network_vlan_ranges = physnet2
```

## vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```
[ovs]
bridge_mappings = physnet2:br-ens4f1
```

## restart service
```
# systemctl restart neutron-server.service neutron-dhcp-agent.service \
  neutron-l3-agent.service neutron-metadata-agent.service neutron-openvswitch-agent
```


## openstack network
```
[root@controller ~(keystone)]# openstack network create net-service-ovs-20\
--provider-network-type vlan \
--provider-physical-network physnet2 \
--provider-segment 20 


[root@controller ~(keystone)]# openstack subnet create subnet-service-ovs-20-v6 \
--network net-service-ovs-20 \
--ip-version 6 \
--subnet-range 2001::20:0/112 \
--allocation-pool start=2001::20:100,end=2001::20:200 \
--gateway none 
```
