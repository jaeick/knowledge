centos를 default로 설치하면 /root가 50GB, /home 이 나머지를 갖는다.

/home 이 필요없을 때, /root를 늘리는 방법

## /home 삭제
[root@controller ~]# df -Th
[root@controller ~]# umount /home
[root@controller ~]# vi /etc/fstab
/home mount

## /home lv 삭제
[root@controller ~]# lvremove /dev/centos/home

## /root lv 확장
[root@controller ~]# lvextend -l 100%FREE /dev/centos/root

## 확인
[root@controller ~]# lvdispaly

## 적용
[root@controller ~]# xfs_growfs /dev/centos/root
