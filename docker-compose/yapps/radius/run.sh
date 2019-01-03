#!/bin/bash

echo -e "client ${RADIUS_NETWORK} {" >> /etc/raddb/clients.conf
echo -e "\tsecret = ${RADIUS_SECRET}" >> /etc/raddb/clients.conf
echo -e "\tnastype = other" >> /etc/raddb/clients.conf
echo -e "}" >> /etc/raddb/clients.conf
echo -e "${RADIUS_AAA_USER} Cleartext-Password := \"${RADIUS_AAA_PASS}\"" >> /etc/raddb/users
echo -e "\t\tService-Type = Login-User" >> /etc/raddb/users

/usr/sbin/radiusd
tail -f /dev/null
