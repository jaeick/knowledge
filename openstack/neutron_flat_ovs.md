## ovs 추가
```
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

