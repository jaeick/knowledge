centos를 default로 설치하면 /root가 50GB, /home 이 나머지를 갖는다.

/home 이 필요없을 때, /root를 늘리는 방법

## umount /home
<pre><code>
[root@localhost ~]# df -Th
Filesystem              Type      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs        50G 1008M   49G   2% /
devtmpfs                devtmpfs   63G     0   63G   0% /dev
tmpfs                   tmpfs      63G     0   63G   0% /dev/shm
tmpfs                   tmpfs      63G   10M   63G   1% /run
tmpfs                   tmpfs      63G     0   63G   0% /sys/fs/cgroup
/dev/sda1               xfs      1014M  145M  870M  15% /boot
/dev/mapper/centos-home xfs       422G   33M  422G   1% /home
tmpfs                   tmpfs      13G     0   13G   0% /run/user/0

[root@localhost ~]# umount /home

[root@localhost ~]# vi /etc/fstab
# /etc/fstab
# Created by anaconda on Thu Jan 10 10:21:44 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root /                       xfs     defaults        0 0
UUID=7c42a2a3-3e00-4677-87c6-9a050f4fdb5a /boot                   xfs     defaults        0 0
/dev/mapper/centos-home /home                   xfs     defaults        0 0             <<< 삭제
/dev/mapper/centos-swap swap                    swap    defaults        0 0
</pre></code>

## 확인
<pre><code>
[root@localhost ~]# lvdisplay
  --- Logical volume ---
  LV Path                /dev/centos/swap
  LV Name                swap
  VG Name                centos
  LV UUID                QFo0Y1-TDoe-ERt2-CK0Q-a0eK-wDNI-1gw7up
  LV Write Access        read/write
  LV Creation host, time localhost, 2019-01-10 19:21:33 +0900
  LV Status              available
  # open                 2
  LV Size                4.00 GiB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
   
  --- Logical volume ---
  LV Path                /dev/centos/home
  LV Name                home
  VG Name                centos
  LV UUID                JvvT6R-hdY2-JWeP-C174-6vEW-STlh-N1aenh
  LV Write Access        read/write
  LV Creation host, time localhost, 2019-01-10 19:21:34 +0900
  LV Status              available
  # open                 0
  LV Size                <421.94 GiB
  Current LE             108016
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos
  LV UUID                oRkp32-UV6n-OAha-PLHu-23Le-2xPJ-LBv70M
  LV Write Access        read/write
  LV Creation host, time localhost, 2019-01-10 19:21:42 +0900
  LV Status              available
  # open                 1
  LV Size                50.00 GiB
  Current LE             12800
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
</pre></code>
  
## /home lv 삭제
<pre><code>
[root@localhost ~]# lvremove /dev/centos/home
Do you really want to remove active logical volume centos/home? [y/n]: y
  Logical volume "home" successfully removed
</pre></code>

## /root lv 확장
<pre><code>
[root@localhost ~]# lvextend -L +12GB /dev/centos/swap
  Size of logical volume centos/swap changed from 4.00 GiB (1024 extents) to 16.00 GiB (4096 extents).
  Logical volume centos/swap successfully resized.
[root@localhost ~]# 
[root@localhost ~]# lvextend -l 100%FREE /dev/centos/root
  Size of logical volume centos/root changed from 50.00 GiB (12800 extents) to <409.94 GiB (104944 extents).
  Logical volume centos/root successfully resized.
</pre></code>

## 확인
<pre><code>
[root@localhost ~]# lvdisplay
  --- Logical volume ---
  LV Path                /dev/centos/swap
  LV Name                swap
  VG Name                centos
  LV UUID                QFo0Y1-TDoe-ERt2-CK0Q-a0eK-wDNI-1gw7up
  LV Write Access        read/write
  LV Creation host, time localhost, 2019-01-10 19:21:33 +0900
  LV Status              available
  # open                 2
  LV Size                16.00 GiB
  Current LE             4096
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
   
  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos
  LV UUID                oRkp32-UV6n-OAha-PLHu-23Le-2xPJ-LBv70M
  LV Write Access        read/write
  LV Creation host, time localhost, 2019-01-10 19:21:42 +0900
  LV Status              available
  # open                 1
  LV Size                <409.94 GiB
  Current LE             104944
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
</pre></code>

## 적용
<pre><code>
[root@localhost ~]# xfs_growfs /dev/centos/root
meta-data=/dev/mapper/centos-root isize=512    agcount=4, agsize=3276800 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=13107200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=6400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 13107200 to 107462656
</pre></code>
