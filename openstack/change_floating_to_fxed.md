## change nat floating ip to flat fixed ip

```
openstack server remove floating ip <server> <ip-address>
openstack server remove port <server> <port>
openstack server add fixed ip --fixed-ip-address <ip-address> <server> <network>
openstack server reboot [--soft] <server>
openstack floating ip list
openstack floating delete <ip-address>
```

```
[root@controller ~(keystone)]# openstack server remove floating ip test 10.55.195.13
[root@controller ~(keystone)]# openstack floating ip delete 10.55.195.13
[root@controller ~(keystone)]# openstack floating ip list
[root@controller ~(keystone)]# openstack server remove port test 60034d24-bd77-47ae-9241-5d225404b494
[root@controller ~(keystone)]# openstack server add fixed ip --fixed-ip-address 10.55.195.13 test net-ext
[root@controller ~(keystone)]# openstack server reboot --soft test
```
