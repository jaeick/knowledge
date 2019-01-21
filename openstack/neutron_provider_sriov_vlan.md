[root@controller ~(keystone)]# cat /etc/sysconfig/network-scripts/ifcfg-ens4f1
```
TYPE=Ethernet
BOOTPROTO=none
NAME=ens4f1
DEVICE=ens4f1
ONBOOT=yes
```

[root@controller ~(keystone)]# vi /etc/default/grub
```
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap console=ttyS0,115200n8, intel_iommu=on"
```

[root@controller ~(keystone)]#  grub2-mkconfig -o /boot/grub2/grub.cfg

[root@controller ~(keystone)]#  reboot

[root@controller ~(keystone)]# cat /proc/cmdline
```
BOOT_IMAGE=/vmlinuz-3.10.0-957.1.3.el7.x86_64 root=/dev/mapper/centos-root ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap console=ttyS0,115200n8, intel_iommu=on
```

[root@controller ~(keystone)]# cat /sys/class/net/ens15f0/device/sriov_totalvfs
```
7
```

[root@controller ~(keystone)]# echo '7' > /sys/class/net/ens4f1/device/sriov_numvfs

[root@controller ~(keystone)]#  lspci | grep Ethernet | grep Virtual
```
04:10.0 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
04:10.4 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
04:11.0 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
04:11.4 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
04:12.0 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
04:12.4 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
04:13.0 Ethernet controller: Intel Corporation I350 Ethernet Controller Virtual Function (rev 01)
```

[root@controller ~(keystone)]# ip link show ens4f1
```
12: ens4f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:90:0b:6e:4d:61 brd ff:ff:ff:ff:ff:ff
    vf 0 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
    vf 1 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
    vf 2 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
    vf 3 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
    vf 4 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
    vf 5 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
    vf 6 MAC 00:00:00:00:00:00, spoof checking on, link-state auto, trust off
```

[root@controller ~(keystone)]# echo "echo '7' > /sys/class/net/ens4f1/device/sriov_numvfs" >> /etc/rc.local

[root@controller ~(keystone)]# chmod +x /etc/rc.d/rc.local

[root@controller ~(keystone)]# vi /etc/nova/nova.conf
```
[pci]
passthrough_whitelist = { "devname": "ens4f1", "physical_network": "physnet3"}

[filter_scheduler]
enabled_filters=RetryFilter,AvailabilityZoneFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,ServerGroupAntiAffinityFilter,ServerGroupAffinityFilter,P
ciPassthroughFilter
```

[root@controller ~(keystone)]# openstack-service restart nova

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/ml2_conf.ini
```
[ml2]
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = openvswitch,l2population,sriovnicswitch

[ml2_type_flat]
flat_networks = physnet1,physnet2

[ml2_type_vlan]
network_vlan_ranges = physnet3

```

[root@controller ~(keystone)]# openstack-service restart neutron

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/sriov_agent.ini
```
[sriov_nic]
physical_device_mappings = physnet3:ens4f1
```

[root@controller ~(keystone)]# yum install -y openstack-neutron-sriov-nic-agent

[root@controller ~(keystone)]# systemctl start neutron-sriov-nic-agent.service

[root@controller ~(keystone)]# systemctl enable neutron-sriov-nic-agent.service

[root@controller ~(keystone)]# openstack network create \\ \
--provider-network-type vlan \\ \
--provider-physical-network physnet3 \\ \
--provider-segment 20 \\ \
--share \\ \
net-provider3

[root@controller ~(keystone)]# openstack subnet create \\ \
--network net-provider3 \\ \
--subnet-range 20.1.1.0/24 \\ \
--no-dhcp \\ \
subnet-provider3-v4-20

[root@controller ~(keystone)]# openstack port create \\ \
--network net-provider3 \\ \
--fixed-ip ip-address=20.1.1.3 \\ \
--vnic-type direct \\ \
--no-security-group \\ \
--disable-port-security \\ \
port-provider3-20
