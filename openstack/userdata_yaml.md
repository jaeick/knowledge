<pre><code>
#cloud-config
password: openstack
chpasswd:
  expire: False
  root: openstack
ssh_pwauth: True
disable_root: False
timezone: Asia/Seoul
network:
  version: 1
  config:
    - type: physical
      name: eth0
      subnet:
        - type: dhcp6
    - type: physical
      name: eth1
      subnet:
        - type: dhcp6
</pre></code>
