
## Configure Keystone

[root@controller ~]# mysql -u root -p
<pre><code>
MariaDB [(none)]> CREATE DATABASE keystone;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';
MariaDB [(none)]> EXIT;
</pre></code>

[root@controller ~]# yum install -y openstack-keystone httpd mod_wsgi

[root@controller ~]# vi /etc/keystone/keystone.conf
<pre><code>
[database]
connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone

[token]
provider = fernet
</pre></code>

[root@controller ~]# su -s /bin/sh -c "keystone-manage db_sync" keystone

[root@controller ~]# keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

[root@controller ~]# keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

[root@controller ~]# keystone-manage bootstrap --bootstrap-password ADMIN_PASS \\ \
--bootstrap-admin-url http://controller:5000/v3/ \\ \
--bootstrap-internal-url http://controller:5000/v3/ \\ \
--bootstrap-public-url http://controller:5000/v3/ \\ \
--bootstrap-region-id RegionOne

[root@controller ~]# vi /etc/httpd/conf/httpd.conf
<pre><code>
ServerName controller
</pre></code>

[root@controller ~]# ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

[root@controller ~]# systemctl start httpd.service

[root@controller ~]# systemctl enable httpd.service

[root@controller ~]# vi keystone-admin
<pre><code>
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export PS1='[\u@\h \W(keystone)]\$ '
</pre></code>

[root@controller ~]# source keystone-amin

[root@controller ~(keystone)]# openstack token issue
<pre><code>
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2019-01-13T03:33:39+0000                                                                                                                                                                |
| id         | gAAAAABcOqODWPrf1kJOn5x5anITsUrKncsxRX4TBQfD02gL8LdoV16a-wECZS0kvP9_LhrcgMmF59DhsQz_3xDee14IzbMsTCDjyPfkX3JsZkMDk9f-u41ckVqlaaLkckQmLN-wrFjJ9s7tCJxwUM_2_AujpjfNd-Egb3jf0HYnissCQ3VJuE0 |
| project_id | 0e98eda71bee4fc78a64819e46fbe13d                                                                                                                                                        |
| user_id    | 0a6e433380b840e28862e443dab7dbd7                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
</pre></code>

## Configure Glance

[root@controller ~(keystone)]# mysql -u root -p
<pre><code>
MariaDB [(none)]> CREATE DATABASE glance;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
</pre></code>

[root@controller ~(keystone)]# openstack user create --domain default --password GLANCE_PASS glance

[root@controller ~(keystone)]# openstack role add --project service --user glance admin

[root@controller ~(keystone)]# openstack service create --name glance --description "OpenStack Image" image

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne image public http://controller:9292

[root@controller ~(keystone)]## openstack endpoint create --region RegionOne image internal http://controller:9292

[root@controller ~(keystone)]# openstack endpoint create --region RegionOne image admin http://controller:9292

[root@controller ~(keystone)]# yum install -y openstack-glance

[root@controller ~(keystone)]# vi /etc/glance/glance-api.conf
<pre><code>
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
</pre></code>

[root@vems ~]# vi /etc/glance/glance-registry.conf
<pre><code>
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
</pre></code>

[root@controller ~(keystone)]# su -s /bin/sh -c "glance-manage db_sync" glance

[root@controller ~(keystone)]# systemctl start openstack-glance-api.service openstack-glance-registry.service

[root@controller ~(keystone)]#  systemctl enable openstack-glance-api.service openstack-glance-registry.service

## Configure Nova

[root@controller ~(keystone)]# mysql -u root -p
<pre><code>
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
</pre></code>

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

[root@controller ~(keystone)]# yum install -y openstack-nova-api openstack-nova-conductor \\ 
openstack-nova-console openstack-nova-novncproxy \\ \
openstack-nova-scheduler openstack-nova-placement-api \\ \
openstack-nova-compute

[root@controller ~(keystone)]# vi /etc/nova/nova.conf
<pre><code>
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
</pre></code>

[root@controller ~(keystone)]# vi /etc/httpd/conf.d/00-nova-placement-api.conf
<pre><code>
<Directory /usr/bin>
   <IfVersion >= 2.4>
      Require all granted
   </IfVersion>
   <IfVersion < 2.4>
      Order allow,deny
      Allow from all
   </IfVersion>
</Directory>
</pre></code>
[root@controller ~(keystone)]# systemctl restart httpd

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage api_db sync" nova Ignore any deprecation messages in this output.

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage db sync" nova

[root@controller ~(keystone)]# nova-manage cell_v2 list_cells

[root@controller ~(keystone)]# systemctl start openstack-nova-api.service \\ \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \\ \
openstack-nova-conductor.service openstack-nova-novncproxy.service \\ \
libvirtd.service openstack-nova-compute.service

[root@controller ~(keystone)]# systemctl enable openstack-nova-api.service \\ \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \\ \
openstack-nova-conductor.service openstack-nova-novncproxy.service \\ \
libvirtd.service openstack-nova-compute.service

[root@controller ~(keystone)]# su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

[root@controller ~(keystone)]# openstack compute service list
<pre><code>
+----+------------------+------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
+----+------------------+------------+----------+---------+-------+----------------------------+
|  1 | nova-consoleauth | controller | internal | enabled | up    | 2019-01-14T04:48:32.000000 |
|  2 | nova-scheduler   | controller | internal | enabled | up    | 2019-01-14T04:48:32.000000 |
|  3 | nova-conductor   | controller | internal | enabled | up    | 2019-01-14T04:48:32.000000 |
| 19 | nova-compute     | controller | nova     | enabled | up    | None                       |
+----+------------------+------------+----------+---------+-------+----------------------------+
</pre></code>
