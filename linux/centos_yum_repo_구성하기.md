
## centos ios 에서 packages 복사
```
# mkdir -p /mnt/centos
# mount -o loop ./CentOS-7.6-x86_64-DVD-1810.iso /mnt/centos
# mkdir -p /srv/centos/7
# rsync -avzH /mnt/centos/Packages /srv/centos/7/
# chmod 777 /srv/centos/7
```

## ubuntu에서 yum createrepo 설치
```
# apt install -y createrepo python-urlgrabber apache2
# createrepo /srv/centos/7/
```

## httpd 설정
```
# vi /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost

        DocumentRoot /srv/centos/7
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /srv/centos/7/>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
```
```
root@ems-m:~# vi /etc/apache2/apache2.conf
<Directory /srv/centos/7/>
	Options Indexes FollowSymLinks MultiViews
	AllowOverride None
	Require all granted
</Directory>
```

## apache 재실행
```
root@ems-m:~# systemctl restart apache2
```

## repo db 생성
```
createrepo -v /srv/centos/7/
```

## Client에서 repo 지정
```
# vi /etc/yum.repos.d/ems.repo 
[ems]
name = ems centos7 repo
baseurl = http://[2001:0:0:10::35]
enabled = 1
gpgcheck = 0

[pgdg10]
name = PostgreSQL 10 7 - x86_64
baseurl = http://[2001:0:0:10::35]/yum.postgresql.org/10/redhat/rhel-7-x86_64
enabled = 1
gpgcheck = 0
```

## client에서 repo 확인
```
# yum repolist
```
