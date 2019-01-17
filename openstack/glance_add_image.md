## Ubuntu 16.04 image download

<pre><code>
$ wget http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
</pre></code>

## glance에 image 등록하기

<pre><code>
$ openstack image create \
--file xenial-server-cloudimg-amd64-disk1.img \
--disk-format qcow2 \
--container-format bare \
--public
ubuntu16.04
</pre></code>
