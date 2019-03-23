## vi /etc/nova/nova.conf
```
allow_resize_to_same_host=true
```

## restart
```
# openstack-service restart nova
# openstack-service status nova
```
