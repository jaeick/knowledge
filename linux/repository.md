## CentOS Local repository 만들기
### Copy Package
<pre><code>
# mkdir /tmp/usb
# fdisk -l
# mount /dev/sdb1 /tmp/usb
# mkdir /localrepo
# cp -rv /tmp/usb /localrepo
</pre></code>

### Set repository
<pre><code>
# rm -rf /etc/yum.repos.d/*
# vi /etc/yum.repos.d/local.repo
[local]
name=local
baseurl=file:///localrepo/
enabled=1
gpgcheck=0
</pre></code>

### Update repository
<pre><code>
# createrepo /localrepo/
# yum clean all
</pre></code>
