
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
