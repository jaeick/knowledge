#!/bin/bash

useradd -d /tmp -s /bin/bash ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

sed -i "s/listen=NO/listen=yes/" /etc/vsftpd/vsftpd.conf
sed -i "s/listen_ipv6=YES/listen_ipv6=NO/" /etc/vsftpd/vsftpd.conf

echo "pasv_enable=${FTP_PASV_ENABLE}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=50001" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=50010" >> /etc/vsftpd/vsftpd.conf
echo "pasv_address=${FTP_PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
tail -f /dev/null
