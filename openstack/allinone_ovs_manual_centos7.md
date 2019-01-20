
## Configure hostname

[root@controller ~]# cat /etc/hosts
```
10.55.195.7 controller
```

## Configure network interface

[root@controller ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
```
TYPE=Ethernet
BOOTPROTO=static
IPADDR=10.55.195.7
NETMASK=255.255.255.0
GATEWAY=10.55.195.254
DNS1=8.8.8.8
NAME=enp10s0
DEVICE=enp10s0
ONBOOT=yes
```

## Configure service

[root@controller ~]# systemctl stop NetworkManager firewalld postfix

[root@controller ~]# systemctl disable NetworkManager firewalld postfix

[root@controller ~]# setenforce 0

[root@controller ~]# vi /etc/sysconfig/selinux
```
SELINUX=permissive
```

## Configure NTP

[root@controller ~]# vi /etc/chrony.conf
```
server time.ewha.or.kr iburst
allow 10.55.195.0/24
```

[root@controller ~]# systemctl start chronyd.service

[root@controller ~]# systemctl enable chronyd.service

## Configure openstack package

[root@controller ~]# yum install -y centos-release-openstack-queens

[root@controller ~]# yum upgrade -y

[root@controller ~]# yum install -y python-openstackclient openstack-selinux openstack-utils

## Configure database

[root@controller ~]# yum install -y mariadb mariadb-server python2-PyMySQL

[root@controller ~]# vi /etc/my.cnf.d/openstack.cnf
```
[mysqld]
bind-address = 10.55.195.7
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```

[root@controller ~]# systemctl start mariadb.service

[root@controller ~]# systemctl enable mariadb.service

max-connections 설정 적용 확인 
```
[root@controller ~(keystone)]# mysql -u root -p
MariaDB [(none)]> show variables like 'max_connections';
MariaDB [(none)]> SET GLOBAL max_connections=4096;
```

## Configure message queue

[root@controller ~]# yum install -y rabbitmq-server

[root@controller ~]# systemctl start rabbitmq-server.service

[root@controller ~]# systemctl enable rabbitmq-server.service

[root@controller ~]# rabbitmqctl add_user openstack RABBIT_PASS

[root@controller ~]# rabbitmqctl set_permissions openstack ".*" ".*" ".*"

## Configure memcached

[root@controller ~]# yum install -y memcached python-memcached

[root@controller ~]# vi /etc/sysconfig/memcached
```
OPTIONS="-l 127.0.0.1,::1,controller"
```

[root@controller ~]# systemctl start memcached.service

[root@controller ~]# systemctl enable memcached.service

## Configure Keystone

[root@controller ~]# mysql -u root -p
```
MariaDB [(none)]> CREATE DATABASE keystone;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';
MariaDB [(none)]> EXIT;
```

[root@controller ~]# yum install -y openstack-keystone httpd mod_wsgi

[root@controller ~]# vi /etc/keystone/keystone.conf
```
[database]
connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone

[token]
provider = fernet
```

[root@controller ~]# su -s /bin/sh -c "keystone-manage db_sync" keystone

[root@controller ~]# keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

[root@controller ~]# keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

[root@controller ~]# keystone-manage bootstrap --bootstrap-password ADMIN_PASS \\ \
--bootstrap-admin-url http://controller:5000/v3/ \\ \
--bootstrap-internal-url http://controller:5000/v3/ \\ \
--bootstrap-public-url http://controller:5000/v3/ \\ \
--bootstrap-region-id RegionOne

[root@controller ~]# vi /etc/httpd/conf/httpd.conf
```
ServerName controller
```

[root@controller ~]# ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

[root@controller ~]# systemctl start httpd.service

[root@controller ~]# systemctl enable httpd.service

[root@controller ~]# vi keystone-admin
```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export PS1='[\u@\h \W(keystone)]\$ '
```

[root@controller ~]# source keystone-amin

[root@controller ~(keystone)]# openstack token issue
```
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2019-01-13T03:33:39+0000                                                                                                                                                                |
| id         | gAAAAABcOqODWPrf1kJOn5x5anITsUrKncsxRX4TBQfD02gL8LdoV16a-wECZS0kvP9_LhrcgMmF59DhsQz_3xDee14IzbMsTCDjyPfkX3JsZkMDk9f-u41ckVqlaaLkckQmLN-wrFjJ9s7tCJxwUM_2_AujpjfNd-Egb3jf0HYnissCQ3VJuE0 |
| project_id | 0e98eda71bee4fc78a64819e46fbe13d                                                                                                                                                        |
| user_id    | 0a6e433380b840e28862e443dab7dbd7                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

## Configure Glance

[root@controller ~(keystone)]# mysql -u root -p
```
MariaDB [(none)]> CREATE DATABASE glance;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
```

[root@controller ~(keystone)]# openstack user create --domain default --password GLANCE_PASS glance

[root@controller ~(keystone)]# openstack role add --project service --user glance admin

[root@controller ~(keystone)]# openstack service create --name glance --description "OpenStack Image" image

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne image public http://controller:9292

[root@controller ~(keystone)]## openstack endpoint create --region RegionOne image internal http://controller:9292

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne image admin http://controller:9292

[root@controller ~(keystone)]# yum install -y openstack-glance

[root@controller ~(keystone)]# vi /etc/glance/glance-api.conf
```
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
flavor = keystone
```

[root@vems ~]# vi /etc/glance/glance-registry.conf
```
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
flavor = keystone
```

[root@controller ~(keystone)]# su -s /bin/sh -c "glance-manage db_sync" glance

[root@controller ~(keystone)]# systemctl start openstack-glance-api.service openstack-glance-registry.service

[root@controller ~(keystone)]#  systemctl enable openstack-glance-api.service openstack-glance-registry.service

## Configure Nova

[root@controller ~(keystone)]# mysql -u root -p
```
MariaDB [(none)]> CREATE DATABASE nova_api;
MariaDB [(none)]> CREATE DATABASE nova;
MariaDB [(none)]> CREATE DATABASE nova_cell0;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%'   IDENTIFIED BY 'NOVA_DBPASS';
MariaDB [(none)]> EXIT;
```

[root@controller ~(keystone)]# openstack user create --domain default --password NOVA_PASS nova

[root@controller ~(keystone)]# openstack role add --project service --user nova admin

[root@controller ~(keystone)]# openstack service create --name nova --description "OpenStack Compute" compute

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

[root@controller ~(keystone)]# openstack user create --domain default --password PLACEMENT_PASS placement

[root@controller ~(keystone)]# openstack role add --project service --user placement admin

[root@controller ~(keystone)]# openstack service create --name placement --description "Placement API" placement

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne placement public http://controller:8778

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne placement internal http://controller:8778

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne placement admin http://controller:8778

[root@controller ~(keystone)]# yum install -y openstack-nova-api openstack-nova-conductor \\ \
openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler \\ \
openstack-nova-placement-api openstack-nova-compute

[root@controller ~(keystone)]# vi /etc/nova/nova.conf
```
[DEFAULT]
use_neutron=true
firewall_driver=nova.virt.firewall.NoopFirewallDriver
enabled_apis=osapi_compute,metadata
transport_url = rabbit://openstack:RABBIT_PASS@controller

[api]
auth_strategy=keystone

[api_database]
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api

[database]
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova

[glance]
api_servers = http://controller:9292

[keystone_authtoken]
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = NOVA_PASS

[oslo_concurrency]
lock_path=/var/lib/nova/tmp

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = PLACEMENT_PASS

[scheduler]
discover_hosts_in_cells_interval=300

[vnc]
enabled=true
server_listen=0.0.0.0
server_proxyclient_address=controller
novncproxy_base_url=http://10.55.195.7:6080/vnc_auto.html
```

[root@controller ~(keystone)]# vi /etc/httpd/conf.d/00-nova-placement-api.conf
```
<Directory /usr/bin>
   <IfVersion >= 2.4>
      Require all granted
   </IfVersion>
   <IfVersion < 2.4>
      Order allow,deny
      Allow from all
   </IfVersion>
</Directory>
```
[root@controller ~(keystone)]# systemctl restart httpd

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage api_db sync" nova Ignore any deprecation messages in this output.

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage db sync" nova

[root@controller ~(keystone)]# nova-manage cell_v2 list_cells

[root@controller ~(keystone)]# systemctl start openstack-nova-api.service \\ \
openstack-nova-scheduler.service openstack-nova-conductor.service \\ \
openstack-nova-novncproxy.service openstack-nova-compute.service

[root@controller ~(keystone)]# systemctl enable openstack-nova-api.service \\ \
openstack-nova-scheduler.service openstack-nova-conductor.service \\ \
openstack-nova-novncproxy.service openstack-nova-compute.service

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

[root@controller ~(keystone)]# openstack compute service list
```
+----+------------------+------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
+----+------------------+------------+----------+---------+-------+----------------------------+
|  1 | nova-consoleauth | controller | internal | enabled | up    | 2019-01-14T04:48:32.000000 |
|  2 | nova-scheduler   | controller | internal | enabled | up    | 2019-01-14T04:48:32.000000 |
|  3 | nova-conductor   | controller | internal | enabled | up    | 2019-01-14T04:48:32.000000 |
| 19 | nova-compute     | controller | nova     | enabled | up    | None                       |
+----+------------------+------------+----------+---------+-------+----------------------------+
```

## Configure Neutron

[root@controller ~(keystone)]# mysql -u root -p
```
MariaDB [(none)]> CREATE DATABASE neutron;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'NEUTRON_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'NEUTRON_DBPASS';
MariaDB [(none)]> EXIT;
```

[root@controller ~(keystone)]# openstack user create --domain default --password NEUTRON_PASS neutron

[root@controller ~(keystone)]# openstack role add --project service --user neutron admin

[root@controller ~(keystone)]# openstack service create --name neutron --description "OpenStack Networking" network

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne network public http://controller:9696

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne network internal http://controller:9696

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne network admin http://controller:9696

[root@controller ~(keystone)]#  yum install -y openstack-neutron openstack-neutron-ml2 \\ \
openstack-neutron-openvswitch ebtables

[root@controller ~(keystone)]# vi /etc/neutron/neutron.conf
```
[DEFAULT]
auth_strategy = keystone
core_plugin = ml2
service_plugins = router
dhcp_agent_notification = true
allow_overlapping_ips = True
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
dhcp_agents_per_network = 2
transport_url = rabbit://openstack:RABBIT_PASS@controller

[database]
connection = mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = NEUTRON_PASS

[nova]
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = NOVA_PASS

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```

[root@controller ~(keystone)]# vi /etc/neutron/l3_agent.ini
```
[DEFAULT]
interface_driver = openvswitch
```

[root@controller ~(keystone)]# vi /etc/neutron/dhcp_agent.ini
```
[DEFAULT]
interface_driver = openvswitch
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True
```

[root@controller ~(keystone)]# vi /etc/neutron/metadata_agent.ini
```
[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret = METADATA_SECRET
```

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/ml2_conf.ini
```
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types =  
mechanism_drivers = openvswitch,l2population
extension_drivers = port_security
```

[root@controller ~(keystone)]# vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```
[securitygroup]
firewall_driver = iptables_hybrid
enable_security_group = true
enable_ipset = true
```

[root@controller ~(keystone)]# vi /etc/nova/nova.conf
```
[DEFAULT]
linuxnet_interface_driver=nova.network.linux_net.LinuxBridgeInterfaceDriver
use_neutron=true

[neutron]
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS
service_metadata_proxy = true
metadata_proxy_shared_secret = METADATA_SECRET
```

[root@controller ~(keystone)]# systemctl start openvswitch

[root@controller ~(keystone)]# systemctl enable openvswitch

[root@controller ~(keystone)]# ovs-vsctl add-br br-int

[root@controller ~(keystone)]# ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

[root@controller ~(keystone)]# su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \\ \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

[root@controller ~(keystone)]# systemctl start neutron-server.service neutron-dhcp-agent.service \\ \
neutron-l3-agent.service neutron-metadata-agent.service neutron-openvswitch-agent

[root@controller ~(keystone)]# systemctl enable neutron-server.service neutron-dhcp-agent.service \\ \
neutron-l3-agent.service neutron-metadata-agent.service neutron-openvswitch-agent

[root@controller ~(keystone)]# systemctl restart openstack-nova-api openstack-nova-compute

[root@controller ~(keystone)]# openstack network agent list
```
+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host       | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
| 360a0e64-8911-4d7e-8b4d-21e886e1d34a | L3 agent           | controller | nova              | :-)   | UP    | neutron-l3-agent          |
| 7a816347-f329-434f-89e5-a4eab596091d | Metadata agent     | controller | None              | :-)   | UP    | neutron-metadata-agent    |
| af3df282-b3ad-4ef4-a0c1-0696fb080f29 | DHCP agent         | controller | nova              | :-)   | UP    | neutron-dhcp-agent        |
| fd66e468-e98a-441a-a9b6-a914526c4323 | Open vSwitch agent | controller | None              | :-)   | UP    | neutron-openvswitch-agent |
+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
```

## Configure Horizon

[root@controller ~(keystone)]# yum install -y openstack-dashboard

[root@controller ~(keystone)]# vi /etc/openstack-dashboard/local_settings 
```
ALLOWED_HOSTS = ['*']

OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}

OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True

OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': 'controller:11211',
    },
}

OPENSTACK_HOST = "controller"
OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_DEFAULT_ROLE = “user"

TIME_ZONE = "Asia/Seoul"
```

[root@controller ~(keystone)]#  vi /etc/httpd/conf.d/openstack-dashboard.conf
```
WSGIDaemonProcess dashboard
WSGIProcessGroup dashboard
WSGISocketPrefix run/wsgi
WSGIApplicationGroup %{GLOBAL}  <- 추가
```
[root@vems ~]# systemctl restart httpd.service memcached.service
