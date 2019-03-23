## ovs 추가
```
ovs-vsctl add-br br-enp11s0
ovs-vsctl add-port br-enp11s0 enp11s0
ovs-vsctl add-br br-ens15f0
ovs-vsctl add-port br-ens15f0 ens15f0
```

## vi /etc/neutron/plugins/ml2/ml2_conf.ini
```
[ml2_type_flat]
flat_networks = physnet1,physnet2
```

## vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```
[ovs]
# bridge_mappings = mgmtnet:br-enp11s0,srvnet:br-ens4f0
bridge_mappings = physnet1:br-enp11s0,physnet2:br-ens15f0,srvnet:br-ens4f0
```

## openstack restart
```
# systemctl-service restart neutron
# openstack-service status neutron
```

## openstack network ipv4
```
openstack network create net-mgmt4 \
--provider-network-type flat \
--provider-physical-network physnet1 \
--share 

openstack subnet create subnet-mgmt4 \
--network net-mgmt4 \
--subnet-range 10.55.195.0/24 \
--allocation-pool start=10.55.195.32,end=10.55.195.42 \
--gateway 10.55.195.254 \
--dns-nameserver 8.8.8.8
```

# neutron subnet
```
openstack network create net-mgmt6 \
--provider-network-type flat \
--provider-physical-network physnet2 \
--share 

openstack subnet create subnet-mgmt6 \
--network net-mgmt6 \
--ip-version 6 \
--subnet-range 2001::10:0/112 \
--allocation-pool start=2001::10:100,end=2001::10:200 \
--gateway none 
```
