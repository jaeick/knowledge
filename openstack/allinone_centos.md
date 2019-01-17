
# Configure Keystone

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
