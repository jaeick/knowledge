#!/bin/bash

echo "server ${NTP_SERVER} iburst" >> /etc/ntp.conf

/usr/sbin/ntpd
tail -f /dev/null

