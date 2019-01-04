## Check
<pre><code>
# nova-status upgrade check
+---------------------------------------------------------------------+
| Upgrade Check Results                                               |
+---------------------------------------------------------------------+
| Check: Cells v2                                                     |
| Result: Success                                                     |
| Details: None                                                       |
+---------------------------------------------------------------------+
| Check: Placement API                                                |
| Result: Success                                                     |
| Details: None                                                       |
+---------------------------------------------------------------------+
| Check: Resource Providers                                           |
| Result: Warning                                                     |
| Details: There are 2 compute resource providers and 3 compute nodes |
|   in the deployment. Ideally the number of compute resource         |
|   providers should equal the number of enabled compute nodes        |
|   otherwise the cloud may be underutilized. See                     |
|   http://docs.openstack.org/developer/nova/placement.html           |
|   for more details.                                                 |
+---------------------------------------------------------------------+
</pre></code>

## delete database
<pre><code>
# mysql -u root -p
MariaDB [(none)]> use nova;
MariaDB [nova]> select hypervisor_hostname from compute_nodes;
+------------------------------+
| hypervisor_hostname          |
+------------------------------+
| compute1                     |
| controller                   |
+------------------------------+
MariaDB [nova]> DELETE FROM compute_nodes where hypervisor_hostname='compute1';
MariaDB [nova]> use nova_api;
MariaDB [nova_api]> select host from host_mappings;
+------------+
| host       |
+------------+
| compute1   |
| controller |
+------------+
MariaDB [nova_api]> DELETE FROM host_mappings WHERE host='compute1';
</pre></code>

## Check
<pre><code>
# nova-status upgrade check
+---------------------------+
| Upgrade Check Results     |
+---------------------------+
| Check: Cells v2           |
| Result: Success           |
| Details: None             |
+---------------------------+
| Check: Placement API      |
| Result: Success           |
| Details: None             |
+---------------------------+
| Check: Resource Providers |
| Result: Success           |
| Details: None             |
+---------------------------+
</pre></code>
