```
Service -------------
            |
        eth1|
       +===========+
       |           |
       +===========+
         eth0|
             |
Management ----------

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/ml2_conf.ini

```
[ml2]
tenant_network_types = vxlan

[ml2_type_flat]
flat_networks = physnet1

[ml2_type_vxlan]
vni_ranges = 10:100
```

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```
[agent]
tunnel_types = vxlan
l2_population = True

[ovs]
local_ip = 10.55.195.7
bridge_mappings = physnet1:br-eth1
```

[root@controller ~(keystone)]# openstack-service restart neutron

[root@controller ~(keystone)]# openstack network create \\ \  
--provider-network-type flat \\ \
--provider-physical-network physnet1 \\ \
--share --external\\ \
net-provider1

[root@controller ~(keystone)]# openstack subnet create \\ \ 
--network net-provider1 \\ \ 
--subnet-range 10.55.195.0/24 \\ \ 
--allocation-pool start=10.55.195.32,end=10.55.195.39 \\ \
--gateway 10.55.195.254 --dns-nameserver 8.8.8.8 \\ \ 
subnet-provider1-v4

[root@controller ~(keystone)]#  openstack network create net-selfservice1

[root@controller ~(keystone)]#  openstack subnet create \\ \
--project admin \\ \
--network net-selfservice1 \\ \
--subnet-range 172.16.1.0/24 \\ \
--gateway 172.16.1.1 \\ \
--dns-nameserver 8.8.8.8 \\ \
subnet-selfservice1 

[root@controller ~(keystone)]# openstack router create router1

[root@controller ~(keystone)]# openstack router set router1 --external-gateway net-provider1

[root@controller ~(keystone)]# openstack router add subnet router1 subnet-selfservice1

[root@controller ~(keystone)]# openstack port list --router router1
